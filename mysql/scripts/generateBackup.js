const { CronJob } = require('cron');
const { exec } = require('child_process');
const path = require('path');

const CONTAINER_NAME = 'mysql_pokemon'; 
const DB_USER        = 'root';
const DB_PASSWORD    = 'wendy0511';
const DB_NAME        = 'pokemon_db';
const BACKUP_FOLDER  = path.join(__dirname, '../', 'backups');

const CRON_SCHEDULE  = '*/1 * * * *'; 

const job = new CronJob(
  CRON_SCHEDULE,
  function () {
    const now = new Date();
    const date = now.toISOString().slice(0, 10);
    const fileName = `backup_${DB_NAME}_${date}.sql`;
    const containerPath = `/tmp/${fileName}`;
    const hostPath = path.join(BACKUP_FOLDER, fileName);

    const dumpCmd = `docker exec ${CONTAINER_NAME} sh -c "mysqldump -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} > ${containerPath}"`;
    const copyCmd = `docker cp ${CONTAINER_NAME}:${containerPath} "${hostPath}"`;
    const rmCmd = `docker exec ${CONTAINER_NAME} rm -f ${containerPath}`;

    console.log(`\n[MySQL Backup] Iniciando backup de '${DB_NAME}' (${date}):`);
    console.log(`  > ${dumpCmd}`);

    exec(dumpCmd, (errDump, _stdout, stderr) => {
      if (errDump) {
        console.error(`🔴 Error durante mysqldump:\n${stderr || errDump.message}`);
        return;
      }
      console.log(`✅ Dump generado en contenedor: ${containerPath}`);
      console.log(`  > ${copyCmd}`);

      exec(copyCmd, (errCopy) => {
        if (errCopy) {
          console.error(`🔴 Error durante docker cp`);
          return;
        }
        console.log(`✅ Archivo copiado a host: ${hostPath}`);
        console.log(`  > ${rmCmd}`);

        exec(rmCmd, (errRm) => {
          if (errRm) {
            console.warn(`⚠️ No se pudo eliminar el dump en contenedor`);
            return;
          }
          console.log(`✅ Limpieza en contenedor exitosa.`);
          console.log(`🎉 Backup de MySQL completado para ${date}.`);
        });
      });
    });
  },
  null,
  true,
  'UTC'
);

console.log('✅ Cron job para MySQL iniciado.');
