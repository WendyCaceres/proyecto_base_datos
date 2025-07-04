const { CronJob } = require('cron');
const { exec } = require('child_process');
const path = require('path');

// DATOS DEL MASTER
const DOCKER_USER    = 'postgres';
const CONTAINER_NAME = 'pokemon_master';
const DB_USER        = 'postgres';
const DB_NAME        = 'pokemon_db';
const DB_PASSWORD    = 'masterpass';

const BACKUP_FOLDER  = path.join(__dirname, '../', 'backups');
const CRON_SCHEDULE = '*/1 * * * *'; 

const job = new CronJob(
  CRON_SCHEDULE,
  function () {
    const now    = new Date();
    const date   = now.toISOString().slice(0, 10);
    const fileName = `backup_${DB_NAME}_${date}.dump`;
    const containerPath = `/bitnami/postgresql/${fileName}`;
    const hostPath      = path.join(BACKUP_FOLDER, fileName);

    const dumpCmd = [
      'docker exec',
      `-u ${DOCKER_USER}`,
      CONTAINER_NAME,
      `bash -c "PGPASSWORD=${DB_PASSWORD} pg_dump -U ${DB_USER} -F c -d ${DB_NAME} -f '${containerPath}'"`
    ].join(' ');

    const copyCmd = `docker cp ${CONTAINER_NAME}:${containerPath} "${hostPath}"`;
    const rmCmd   = `docker exec ${CONTAINER_NAME} rm -f ${containerPath}`;

    console.log(`\n[Postgres Backup] Iniciando backup de '${DB_NAME}' (${date}):`);
    console.log(`  > ${dumpCmd}`);

    exec(dumpCmd, (errDump, stdoutDump, stderrDump) => {
      if (errDump) {
        console.error(`🔴 Error pg_dump: ${stderrDump || errDump.message}`);
        return;
      }

      console.log(`✅ Dump generado en contenedor: ${containerPath}`);
      console.log(`  > ${copyCmd}`);

      exec(copyCmd, (errCopy, _, stderrCopy) => {
        if (errCopy) {
          console.error(`🔴 Error al copiar archivo:\n${stderrCopy || errCopy.message}`);
          return;
        }

        console.log(`✅ Archivo copiado a host: ${hostPath}`);
        console.log(`  > ${rmCmd}`);

        exec(rmCmd, (errRm, _, stderrRm) => {
          if (errRm) {
            console.warn(`⚠️ No se pudo eliminar dump dentro del contenedor: ${stderrRm || errRm.message}`);
            return;
          }
          console.log(`✅ Limpieza en contenedor completada.`);
          console.log(`🎉 Backup de PostgreSQL completado para ${date}.`);
        });
      });
    });
  },
  null,
  true,
  'UTC'
);

console.log('✅ Cron job para BACKUP de postgres_master iniciado.');
