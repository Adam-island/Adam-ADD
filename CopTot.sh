#!/bin/bash

# Script: backup_total.sh
# Descripción: Realiza copia de seguridad total mensual de /home
# Autor: Adam
# Tarea: 7.3 - Backup total mensual con ANACRON

BACKUP_DIR="/bacadam"
SOURCE_DIR="/home"
MONTH_NAME=$(date '+%B')  # Nombre completo del mes en inglés
YEAR=$(date +%Y)          # Año completo (2024)
BACKUP_NAME="CopTot-${MONTH_NAME}-${YEAR}"
LOG_FILE="$BACKUP_DIR/backup_total.log"

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
log "Iniciando backup total mensual"
log "Mes: $MONTH_NAME $YEAR"
log "Origen: $SOURCE_DIR"
log "Destino: $BACKUP_DIR/$BACKUP_NAME.tar.gz"

# Crear backup total (copia completa)
tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" \
    -C / home 2> "$LOG_FILE"

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME.tar.gz" | cut -f1)
    log "✓ Backup total completado exitosamente - Tamaño: $SIZE"
else
    log "✗ Error al crear el backup total"
    exit 1
fi

log "==========================================="
