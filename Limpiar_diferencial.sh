#!/bin/bash

# Script: limpiar_diferenciales.sh
# Descripción: Elimina SOLO los backups diferenciales mensuales
# Autor: Adam
# Tarea: 7.2 - Limpieza mensual con ANACRON

BACKUP_DIR="/bacadam"
LOG_FILE="$BACKUP_DIR/limpieza.log"

# Función de log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Verificar que existe el directorio
if [ ! -d "$BACKUP_DIR" ]; then
    log "ERROR: El directorio $BACKUP_DIR no existe"
    exit 1
fi

log "=========================================="
log "Iniciando limpieza de backups diferenciales"

# Contar backups diferenciales (solo los CopDifSem)
COUNT=$(find "$BACKUP_DIR" -name "CopDifSem-*.tar.gz" -type f 2>/dev/null | wc -l)
log "Backups diferenciales encontrados: $COUNT"

if [ $COUNT -eq 0 ]; then
    log "No hay backups diferenciales para eliminar"
else
    # Listar archivos que se van a eliminar
    log "Archivos a eliminar:"
    find "$BACKUP_DIR" -name "CopDifSem-*.tar.gz" -type f 2>/dev/null | while read file; do
        log "  - $(basename $file)"
    done
    
    # Eliminar SOLO backups diferenciales
    find "$BACKUP_DIR" -name "CopDifSem-*.tar.gz" -type f -delete 2>> "$LOG_FILE"
    log "✓ Eliminados $COUNT backups diferenciales"
    
    # Resetear snapshot para el próximo ciclo
    if [ -f "$BACKUP_DIR/.snapshot_diferencial" ]; then
        rm -f "$BACKUP_DIR/.snapshot_diferencial"
        log "✓ Snapshot diferencial reseteado"
    fi
fi

log "Limpieza completada"
log "=========================================="
