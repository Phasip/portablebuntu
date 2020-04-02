#!/bin/bash
set -e
DKRNAME="ubuntu:latest"
CTRFOLDER="ubuntu_container"

mkdir "$CTRFOLDER"
cd "$CTRFOLDER"
wget https://github.com/opencontainers/runc/releases/download/v1.0.0-rc10/runc.amd64
chmod +x runc.amd64
mkdir rootfs
CONT=$(sudo sudo docker run -d $DKRNAME sleep infinity)
declare -a commands=(
	"apt -y update"
	"apt -y --no-install-recommends dist-upgrade"
	"apt -y autoremove"
	"apt -y clean"
	"apt install -y --no-install-recommends tcpdump iptables iproute2 nmap python3 screen binwalk git vim net-tools iputils-ping"
	"apt -y clean"
	"rm -rf /var/lib/apt/lists"
)
set +e
for cmd in "${commands[@]}"; do
    docker exec -it -e "DEBIAN_FRONTEND=noninteractive" $CONT $cmd 
done
set -e

docker stop -t0 $CONT
echo "Exporting container"
docker export $CONT | sudo tar -C rootfs -xf -
docker container rm $CONT
cat > config.json << 'EOF'
{"ociVersion": 
	"1.0.1-dev",
	"process": {
		"terminal": true,
		"user": {"uid": 0,"gid": 0},
		"args": ["bash"],
		"env": ["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin","TERM=xterm"],
		"cwd": "/",
		"capabilities": {
			"bounding": ["CAP_CHOWN","CAP_DAC_OVERRIDE","CAP_DAC_READ_SEARCH","CAP_FOWNER","CAP_FSETID","CAP_KILL","CAP_SETGID","CAP_SETUID","CAP_SETPCAP","CAP_LINUX_IMMUTABLE","CAP_NET_BIND_SERVICE","CAP_NET_BROADCAST","CAP_NET_ADMIN","CAP_NET_RAW","CAP_IPC_LOCK","CAP_IPC_OWNER","CAP_SYS_MODULE","CAP_SYS_RAWIO","CAP_SYS_CHROOT","CAP_SYS_PTRACE","CAP_SYS_PACCT","CAP_SYS_ADMIN","CAP_SYS_BOOT","CAP_SYS_NICE","CAP_SYS_RESOURCE","CAP_SYS_TIME","CAP_SYS_TTY_CONFIG","CAP_MKNOD","CAP_LEASE","CAP_AUDIT_WRITE","CAP_AUDIT_CONTROL","CAP_SETFCAP","CAP_MAC_OVERRIDE","CAP_MAC_ADMIN","CAP_SYSLOG","CAP_WAKE_ALARM","CAP_BLOCK_SUSPEND"],
			"effective": ["CAP_CHOWN","CAP_DAC_OVERRIDE","CAP_DAC_READ_SEARCH","CAP_FOWNER","CAP_FSETID","CAP_KILL","CAP_SETGID","CAP_SETUID","CAP_SETPCAP","CAP_LINUX_IMMUTABLE","CAP_NET_BIND_SERVICE","CAP_NET_BROADCAST","CAP_NET_ADMIN","CAP_NET_RAW","CAP_IPC_LOCK","CAP_IPC_OWNER","CAP_SYS_MODULE","CAP_SYS_RAWIO","CAP_SYS_CHROOT","CAP_SYS_PTRACE","CAP_SYS_PACCT","CAP_SYS_ADMIN","CAP_SYS_BOOT","CAP_SYS_NICE","CAP_SYS_RESOURCE","CAP_SYS_TIME","CAP_SYS_TTY_CONFIG","CAP_MKNOD","CAP_LEASE","CAP_AUDIT_WRITE","CAP_AUDIT_CONTROL","CAP_SETFCAP","CAP_MAC_OVERRIDE","CAP_MAC_ADMIN","CAP_SYSLOG","CAP_WAKE_ALARM","CAP_BLOCK_SUSPEND"],
			"inheritable": ["CAP_CHOWN","CAP_DAC_OVERRIDE","CAP_DAC_READ_SEARCH","CAP_FOWNER","CAP_FSETID","CAP_KILL","CAP_SETGID","CAP_SETUID","CAP_SETPCAP","CAP_LINUX_IMMUTABLE","CAP_NET_BIND_SERVICE","CAP_NET_BROADCAST","CAP_NET_ADMIN","CAP_NET_RAW","CAP_IPC_LOCK","CAP_IPC_OWNER","CAP_SYS_MODULE","CAP_SYS_RAWIO","CAP_SYS_CHROOT","CAP_SYS_PTRACE","CAP_SYS_PACCT","CAP_SYS_ADMIN","CAP_SYS_BOOT","CAP_SYS_NICE","CAP_SYS_RESOURCE","CAP_SYS_TIME","CAP_SYS_TTY_CONFIG","CAP_MKNOD","CAP_LEASE","CAP_AUDIT_WRITE","CAP_AUDIT_CONTROL","CAP_SETFCAP","CAP_MAC_OVERRIDE","CAP_MAC_ADMIN","CAP_SYSLOG","CAP_WAKE_ALARM","CAP_BLOCK_SUSPEND"],
			"permitted": ["CAP_CHOWN","CAP_DAC_OVERRIDE","CAP_DAC_READ_SEARCH","CAP_FOWNER","CAP_FSETID","CAP_KILL","CAP_SETGID","CAP_SETUID","CAP_SETPCAP","CAP_LINUX_IMMUTABLE","CAP_NET_BIND_SERVICE","CAP_NET_BROADCAST","CAP_NET_ADMIN","CAP_NET_RAW","CAP_IPC_LOCK","CAP_IPC_OWNER","CAP_SYS_MODULE","CAP_SYS_RAWIO","CAP_SYS_CHROOT","CAP_SYS_PTRACE","CAP_SYS_PACCT","CAP_SYS_ADMIN","CAP_SYS_BOOT","CAP_SYS_NICE","CAP_SYS_RESOURCE","CAP_SYS_TIME","CAP_SYS_TTY_CONFIG","CAP_MKNOD","CAP_LEASE","CAP_AUDIT_WRITE","CAP_AUDIT_CONTROL","CAP_SETFCAP","CAP_MAC_OVERRIDE","CAP_MAC_ADMIN","CAP_SYSLOG","CAP_WAKE_ALARM","CAP_BLOCK_SUSPEND"],
			"ambient": ["CAP_CHOWN","CAP_DAC_OVERRIDE","CAP_DAC_READ_SEARCH","CAP_FOWNER","CAP_FSETID","CAP_KILL","CAP_SETGID","CAP_SETUID","CAP_SETPCAP","CAP_LINUX_IMMUTABLE","CAP_NET_BIND_SERVICE","CAP_NET_BROADCAST","CAP_NET_ADMIN","CAP_NET_RAW","CAP_IPC_LOCK","CAP_IPC_OWNER","CAP_SYS_MODULE","CAP_SYS_RAWIO","CAP_SYS_CHROOT","CAP_SYS_PTRACE","CAP_SYS_PACCT","CAP_SYS_ADMIN","CAP_SYS_BOOT","CAP_SYS_NICE","CAP_SYS_RESOURCE","CAP_SYS_TIME","CAP_SYS_TTY_CONFIG","CAP_MKNOD","CAP_LEASE","CAP_AUDIT_WRITE","CAP_AUDIT_CONTROL","CAP_SETFCAP","CAP_MAC_OVERRIDE","CAP_MAC_ADMIN","CAP_SYSLOG","CAP_WAKE_ALARM","CAP_BLOCK_SUSPEND"]},
			"noNewPrivileges": false
			},
		"root": {"path": "rootfs","readonly": false},
		"mounts": [
			{"destination": "/proc","type": "proc","source": "proc"},
			{"destination": "/dev","type": "tmpfs","source": "tmpfs","options": ["nosuid","strictatime","mode=755","size=65536k"]},
			{"destination": "/dev/pts","type": "devpts","source": "devpts","options": ["nosuid","noexec","newinstance","ptmxmode=0666","mode=0620","gid=5"]},
			{"destination": "/dev/shm","type": "tmpfs","source": "shm","options": ["nosuid","noexec","nodev","mode=1777","size=65536k"]},
			{"destination": "/dev/mqueue","type": "mqueue","source": "mqueue","options": ["nosuid","noexec","nodev"]},
			{"destination": "/sys","type": "sysfs","source": "sysfs","options": ["nosuid","noexec","nodev","ro"]},
			{"destination": "/sys/fs/cgroup","type": "cgroup","source": "cgroup","options": ["nosuid","noexec","nodev","relatime","ro"]},
			{"destination":"/mnt","source":"/","options":["rw","rbind"]}
			],
		"linux": {
			"resources": {"devices": [{ "allow": true, "access": "rwm" }]},
			"namespaces": [{"type": "mount"}]
		}
}
EOF
cd ..
echo "Compressing container"
tar czf "$CTRFOLDER.tar.gz" "$CTRFOLDER"
cat > container.sh << 'EOF'
#!/bin/bash
set -e
if [ ! -d "REPLACE_CTR_FOLDER" ]; then
  # Stolen from https://gist.github.com/ChrisCarini/d3e97c4bc7878524fa11
  SCRIPT_DIR="$(cd -P "$( dirname "${BASH_SOURCE[0]}" )" ; pwd)"
  SKIP=$(awk '/^__TARFILE_FOLLOWS__/ { print NR + 1; exit 0; }' $0)
  # Extract
  echo "Extracting container ... "
  tail -n +${SKIP} $0 | sudo tar -zpx
fi
cd "REPLACE_CTR_FOLDER"
echo "Done, entering container"
# xhost +si:localuser:root # TODO: Add $DISPLAY env somehow
sudo ./runc.amd64 run container
exit 0
# NOTE: Don't place any newline characters after the last line below.
__TARFILE_FOLLOWS__
EOF
sed -i "s/REPLACE_CTR_FOLDER/$CTRFOLDER/" container.sh
echo "Building shell script"
cat "$CTRFOLDER.tar.gz" >> container.sh
chmod +x container.sh
rm -rf "$CTRFOLDER" "$CTRFOLDER.tar.gz"
echo "Done"
