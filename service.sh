#!/system/bin/sh
# Magisk Service Script - Auto apply on boot

# Log start
log -p i -t device_boost "Ngo Tan Sang boost script..."

# ===== CPU TWEAKS =====
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 1200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

# Apply to all CPUs
for cpu in /sys/devices/system/cpu/cpu[1-9]*/; do
    echo performance > "$cpu/cpufreq/scaling_governor"
    echo 1200000 > "$cpu/cpufreq/scaling_min_freq"
done

# ===== GPU (nếu có path) =====
echo performance > /sys/class/kgsl/kgsl-3d0/devfreq/governor 2>/dev/null

# ===== ZRAM =====
swapoff /dev/block/zram0
echo 1073741824 > /sys/block/zram0/disksize # 1GB
mkswap /dev/block/zram0
swapon /dev/block/zram0

# ===== NETWORK SYSCTL =====
sysctl -w net.ipv4.tcp_congestion_control=bbr
sysctl -w net.ipv4.tcp_fastopen=3
sysctl -w net.core.rmem_max=31457280
sysctl -w net.core.wmem_max=31457280
sysctl -w net.ipv4.tcp_rmem="4096 87380 31457280"
sysctl -w net.ipv4.tcp_wmem="4096 65536 31457280"

# ===== POINTER SPEED =====
settings put system pointer_speed 7

# ===== DISPLAY: FORCE 120Hz (tuỳ thiết bị) =====
setprop debug.sf.lcd_density 420
setprop debug.sf.frame_rate_multiple 120

# ===== I/O =====
echo noop > /sys/block/mmcblk0/queue/scheduler
echo 512 > /sys/block/mmcblk0/queue/read_ahead_kb

# Done
log -p i -t device_boost "Script activated ngotansang."