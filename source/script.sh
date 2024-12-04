#!/bin/bash

OUTPUT_FILE="Output.log"

if [[ $EUID -ne 0 ]]; then
    echo "Скрипт має бути запущений з правами суперкористувача (sudo)." >&2
    exit 1
fi


> "$OUTPUT_FILE"

function scan_with_nmap {
    echo "=== NMAP Scan Results ===" >> "$OUTPUT_FILE"
    nmap -Pn 192.168.1.105 >> "$OUTPUT_FILE" 2>&1
    echo "NMAP scan завершено." 
}

function capture_with_tcpdump {
    echo "=== TCPDUMP Results ===" >> "$OUTPUT_FILE"
    echo "Захоплення пакетів на інтерфейсі eth0 протягом 10 секунд..." 
    timeout 10 tcpdump -i eth0 -nn -c 50 >> "$OUTPUT_FILE" 2>&1
    echo "TCPDUMP завершено."
}

scan_with_nmap
capture_with_tcpdump


echo "Результати збережено у файл $OUTPUT_FILE"