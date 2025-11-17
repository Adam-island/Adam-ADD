#!/bin/bash

# Script: backup_diferencial.sh
# Descripción: Realiza copia de seguridad diferencial semanal de /home
# Autor: Adam
# Tarea: 7.1 - Backup diferencial semanal con CRON

BACKUP_DIR="/bacadam"
SOURCE_DIR="/home"
WEEK_NUM=$(date +%V)
YEAR=$(date +%Y)
BACKUP_NAME="CopDifSem-${WEEK_NUM}"
SNAPSHOT_FILE="$BACKUP_DIR/.snapshot_diferencial"
LOG_FILE="$BACKUP_DIR/backup_diferencial.log"

# Función de log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Verificar que existe el directorio de destino
if [ ! -d "$BACKUP_DIR" ]; then
    log "ERROR: El directorio $BACKUP_DIR no existe"
    exit 1
fi

log "==========================================="
log "Iniciando backup diferencial semanal"
log "Semana: $WEEK_NUM del año $YEAR"
log "Origen: $SOURCE_DIR"
log "Destino: $BACKUP_DIR/$BACKUP_NAME.tar.gz"

# Crear archivo de respaldo diferencial
if [ ! -f "$SNAPSHOT_FILE" ]; then
    log "Creando backup diferencial (desde último snapshot)"
    tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" \
        --listed-incremental="$SNAPSHOT_FILE" \
        -C / home 2> "$LOG_FILE"
else
    log "Primer backup - creando snapshot inicial"
    tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" \
        --listed-incremental="$SNAPSHOT_FILE" \
        -C / home 2> "$LOG_FILE"
fi

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME.tar.gz" | cut -f1)
    log "✓ Backup completado exitosamente - Tamaño: $SIZE"
else
    log "✗ Error al crear el backup"
    exit 1
fi

log "==========================================="
