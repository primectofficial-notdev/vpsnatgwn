FROM ubuntu:24.04

# Install SSH, tmate, dan tools sistem
RUN apt update && apt install -y \
    openssh-server \
    curl \
    wget \
    git \
    sudo \
    tmate \
    net-tools \
    procps \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Hilangkan banner bawaan Ubuntu
RUN rm -f /etc/legal /etc/update-motd.d/*

# Buat banner kustom GWN di /etc/profile agar otomatis muncul saat SSH login
RUN echo 'clear' >> /etc/profile && \
    echo 'echo -e "\033[1;31m ██████╗ ██╗    ██╗███╗   ██╗\033[0m"' >> /etc/profile && \
    echo 'echo -e "\033[1;31m██╔════╝ ██║    ██║████╗  ██║\033[0m"' >> /etc/profile && \
    echo 'echo -e "\033[1;33m██║  ███╗██║ █╗ ██║██╔██╗ ██║\033[0m"' >> /etc/profile && \
    echo 'echo -e "\033[1;33m██║   ██║██║███╗██║██║╚██╗██║\033[0m"' >> /etc/profile && \
    echo 'echo -e "\033[1;32m╚██████╔╝╚███╔███╔╝██║ ╚████║\033[0m"' >> /etc/profile && \
    echo 'echo -e "\033[1;32m ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝\033[0m"' >> /etc/profile && \
    echo 'echo "═══════════════════════════════════════════════════════════"' >> /etc/profile && \
    echo 'echo "  VPS ini dibuat oleh: @primeCTofficial"' >> /etc/profile && \
    echo 'echo "═══════════════════════════════════════════════════════════"' >> /etc/profile && \
    echo 'echo "  📢 GWEN STORE - PROVIDER DIGITAL TRUSTED!"' >> /etc/profile && \
    echo 'echo "  ORDER VIA TELEGRAM : @primeCTofficial"' >> /etc/profile && \
    echo 'echo "  WHATSAPP OFFICIAL  : 6281325507265"' >> /etc/profile && \
    echo 'echo "  WEBSITE STORE      : gwenshop.biz.id"' >> /etc/profile && \
    echo 'echo "═══════════════════════════════════════════════════════════"' >> /etc/profile && \
    echo 'echo "  Hostname     : $(hostname)"' >> /etc/profile && \
    echo 'echo "  OS           : Ubuntu 24.04 LTS"' >> /etc/profile && \
    echo 'echo "  IP Address   : $(hostname -I | awk \"{print \$1}\")"' >> /etc/profile && \
    echo 'echo "  CPU Model    : $(lscpu | grep \"Model name\" | sed \"s/Model name:[ ]*//g\" | head -n 1)"' >> /etc/profile && \
    echo 'echo "  CPU Cores    : $(nproc) cores"' >> /etc/profile && \
    echo 'echo "  RAM Total    : $(free -h | awk \"/Mem:/ {print \$2}\")"' >> /etc/profile && \
    echo 'echo "  RAM Used     : $(free -h | awk \"/Mem:/ {print \$3}\")"' >> /etc/profile && \
    echo 'echo "  Disk Total   : $(df -h / | awk \"END {print \$2}\")"' >> /etc/profile && \
    echo 'echo "  Disk Used    : $(df -h / | awk \"END {print \$3}\")"' >> /etc/profile && \
    echo 'echo "  Uptime       : $(uptime -p)"' >> /etc/profile && \
    echo 'echo "═══════════════════════════════════════════════════════════"' >> /etc/profile && \
    echo 'echo ""' >> /etc/profile

# Entrypoint Script
RUN echo '#!/bin/bash\n\
if [ -n "$ROOT_PASSWORD" ]; then\n\
  echo "root:$ROOT_PASSWORD" | chpasswd\n\
fi\n\
service ssh start\n\
tmate -S /tmp/tmate.sock new-session -d\n\
tmate -S /tmp/tmate.sock wait tmate-ready\n\
tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}" > /tmp/tmate_ssh.txt\n\
tail -f /dev/null\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 22

CMD ["/entrypoint.sh"]
