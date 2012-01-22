From: Swapnil Pimpale <swapnil.pict@gmail.com>
Subject: Problem with 3.3.0-rc1+: Target filesystem cannot find /sbin/init
Date: Sun, 22 Jan 2012 17:51:38 +0530
Message-ID: <CAGZys+Q_A0H36+e45f6jTr7VQB=bn3pq1+pCvt=MHumiQP-=QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I can successfully boot into Ubuntu 11.10 (3.0.0-14-generic-pae) with
a btrfs root filesystem and an ext2 /boot partition.
But when I installed the latest vanilla (3.3.0-rc1+) and booted into
it, the first time the system froze.
Next time onwards, I get the following error every time:

[   0.427443] [drm:i915_init]  *ERROR* drm/i915 cannot work without
intel_agp module!
mount: mounting udev on /dev failed: No such device
W: devtmpfs not available, falling back to tmpfs for /dev
mount: mounting /dev/disk/by-uuid/f43fdd7a-8ad7-4e96-ab1c-14ba82a4324d
on /root failed: No such device
mount: mounting /dev on /root/dev failed: No such file or directory
mount: mounting /sys on /root/sys failed: No such file or directory
mount: mounting /proc on /root/proc failed: No such file or directory
Target filesystem doesn't have requested /sbin/init.
No init found. Try passing init= bootarg.

BusyBox v1.18.4 (Ubuntu 1:1.18.4-2ubuntu2) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs)

I compiled the kernel with default configuration.
The output of "mount -l" is:

/dev/sda8 on / type btrfs (rw,subvol=@)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
udev on /dev type devtmpfs (rw,mode=0755)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
none on /run/lock type tmpfs (rw,noexec,nosuid,nodev,size=5242880)
none on /run/shm type tmpfs (rw,nosuid,nodev)
/dev/sda8 on /home type btrfs (rw,subvol=@home)
/dev/sda9 on /boot type ext2 (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
(rw,noexec,nosuid,nodev)
gvfs-fuse-daemon on /home/swapnil/.gvfs type fuse.gvfs-fuse-daemon
(rw,nosuid,nodev,user=swapnil)

The output of "fdisk -l" is:

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x10000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *          63      433754      216846    6  FAT16
/dev/sda2          434176    21155839    10360832    7  HPFS/NTFS/exFAT
/dev/sda3        21155840   271378943   125111552    7  HPFS/NTFS/exFAT
/dev/sda4       271382526   976773119   352695297    f  W95 Ext'd (LBA)
/dev/sda5       271382528   481097727   104857600    7  HPFS/NTFS/exFAT
/dev/sda6       481099776   690814975   104857600    7  HPFS/NTFS/exFAT
/dev/sda7       690817024   898484223   103833600    7  HPFS/NTFS/exFAT
/dev/sda8       900534272   976773119    38119424   83  Linux
/dev/sda9       898486272   900532223     1022976   83  Linux

Partition table entries are not in disk order

I have the following entries in /boot/config-3.3.0-rc1+
#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y

CONFIG_DRM=y
CONFIG_DRM_I915=y

The ouput of "lspci" is:
00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 18)
00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16
Root Port (rev 18)
00:16.0 Communication controller: Intel Corporation 5 Series/3400
Series Chipset HECI Controller (rev 06)
00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
USB2 Enhanced Host Controller (rev 06)
00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
High Definition Audio (rev 06)
00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 1 (rev 06)
00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 2 (rev 06)
00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 4 (rev 06)
00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 5 (rev 06)
00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 6 (rev 06)
00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
USB2 Enhanced Host Controller (rev 06)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC
Interface Controller (rev 06)
00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series
Chipset 4 port SATA AHCI Controller (rev 06)
00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus
Controller (rev 06)
00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400
Series Chipset Thermal Subsystem (rev 06)
02:00.0 VGA compatible controller: ATI Technologies Inc M92 [Mobility
Radeon HD 4500/5100 Series]
02:00.1 Audio device: ATI Technologies Inc RV710/730
04:00.0 Network controller: Broadcom Corporation BCM43224 802.11a/b/g/n (rev 01)
07:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
07:00.1 System peripheral: Ricoh Co Ltd Memory Stick Host Controller (rev 01)
07:00.2 System peripheral: Ricoh Co Ltd Device e852 (rev 01)
07:00.3 FireWire (IEEE 1394): Ricoh Co Ltd FireWire Host Controller (rev 01)
09:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath
Architecture Generic Non-core Registers (rev 05)
ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath
Architecture System Address Decoder (rev 05)
ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 05)
ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)

--Swapnil
