#!/bin/sh

PROCESS_MAP="syslogd:0 cron:0 sshd:0 nginx:1"

# В Linux вывод ps идентичен, используем ту же логику
ps ax -o pid,ucomm | while read _pid _ucomm; do
    for map in ${PROCESS_MAP}; do
        ucomm_target="${map%:*}"
        cpu_target="${map#*:}"
        
        if [ "${ucomm_target}" = "${_ucomm}" ]; then
            # taskset -p [маска_или_список] [pid]
            # Флаг -c позволяет указывать номера ядер через запятую (0,1) или тире (0-2)
            taskset -cp "${cpu_target}" "${_pid}" > /dev/null 2>&1
            
            if [ $? -eq 0 ]; then
                echo "${_ucomm}[${_pid}] -> CPU ${cpu_target}"
            fi
        fi
    done
done

