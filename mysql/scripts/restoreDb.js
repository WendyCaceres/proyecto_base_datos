const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');

const CONTAINER = 'mysql_pokemon';
const DB_USER = 'root';
const DB_PASSWORD = 'wendy0511';
const DB_NAME = 'pokemon_db';
const BACKUP_FILE_HOST = path.join(__dirname, '../', 'backups', 'backup_pokemon_db_2025-06-25.sql');

console.log('\n▶ Iniciando restauración de MySQL');

if (!fs.existsSync(BACKUP_FILE_HOST)) {
  console.error(`🔴 ERROR: No se encontró el archivo de backup en el host:\n   ${BACKUP_FILE_HOST}`);
  process.exit(1);
}

const BASENAME = path.basename(BACKUP_FILE_HOST);
const CONTAINER_TMP_PATH = `/tmp/${BASENAME}`;

console.log(`  • Contenedor:       ${CONTAINER}`);
console.log(`  • Usuario MySQL:    ${DB_USER}`);
console.log(`  • Base a restaurar: ${DB_NAME}`);
console.log(`  • Archivo backup:   ${BACKUP_FILE_HOST}`);
console.log(`  • Dentro del contenedor: ${CONTAINER_TMP_PATH}\n`);

const copyCmd = `docker cp "${BACKUP_FILE_HOST}" ${CONTAINER}:${CONTAINER_TMP_PATH}`;
const restoreCmd = `docker exec -i ${CONTAINER} sh -c "mysql -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < ${CONTAINER_TMP_PATH}"`;
const cleanupCmd = `docker exec ${CONTAINER} rm -f ${CONTAINER_TMP_PATH}`;

console.log(`▶︎ Copiando backup al contenedor...`);
exec(copyCmd, (errCopy) => {
  if (errCopy) {
    console.error(`🔴 Error al copiar el archivo:\n${errCopy.message}`);
    return;
  }
  console.log(`✅ Archivo copiado a ${CONTAINER}:${CONTAINER_TMP_PATH}`);

  console.log(`▶︎ Restaurando la base de datos...`);
  exec(restoreCmd, (errRestore, _stdoutRestore, stderrRestore) => {
    if (errRestore) {
      console.error(`🔴 Error durante restauración:\n${stderrRestore || errRestore.message}`);
      return;
    }
    console.log(`✅ Restauración completada.`);

    console.log(`▶︎ Eliminando archivo temporal...`);
    exec(cleanupCmd, () => {
      console.log(`✅ Archivo temporal eliminado.\n🎉 Restauración MySQL finalizada con éxito.`);
    });
  });
});
