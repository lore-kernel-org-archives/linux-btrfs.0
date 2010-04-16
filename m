From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [RFC] btrfs, udev and btrfs
Date: Fri, 16 Apr 2010 20:48:14 +0200
Message-ID: <201004162048.14463.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

below a configuration for udev/initramfs which I propose to scan the block 
devices looking for a multi-volume btrfs filesystem.

Btrfs has the capability to span a file-system on multiple device. In order to 
do that, the involved devices have to be "registered" in the kernel. 

In order to do that there are two options:

  # btrfs device scan <device>         (or the old tool btrfsctl -A <device>)

or

  # btrfs device scan          (or the old tool btrfsctl -a)


The first one scan the device <device> in order to find a btrfs volume. If 
this exists, it is registered in the kernel.

The second options scan all the block devices (even floppy, cdrom...) looking 
for a btrfs volume. This option has two disadvantage:
1) this commands is slow because it access also slow device
2) every time it scans all the block devices, even the ones already scanned.

Instead the first option has the disadvantage to need to be used for every new 
device.
>From this observation I write a udev rule which scan the new block devices, 
excluding floppy and cdrom.

Below my udev rule

  $ cat /etc/udev/rules.d/60-btrfs.rules 

  # ghigo 15/04/2010

  ACTION!="add|change", GOTO="btrfs_scan_end"
  SUBSYSTEM!="block", GOTO="btrfs_scan_end"
  KERNEL!="sd[!0-9]*|hd[!0-9]*", GOTO="btrfs_scan_end"

  IMPORT{program}="/sbin/blkid -o udev -p $tempnode"

  # only disk scsi and ide
  ENV{ID_FS_TYPE}="btrfs", RUN+="/sbin/btrfsctl -A /dev/$name"

  LABEL="btrfs_scan_end"



Note #1) This rule is tested on a ubuntu 10.4
Note #2) ubuntu 10.4 has the old btrfctl tool

This work quite well for devices which appear *after* mounting the root file 
system. For a (very) common internal hard disk, it is needed to update the 
initramfs. So I wrote other two scripts: an initramfs hook and a initramfs 
init-top scripts.

The initramfs init-top scripts, is ran during the boot: it load the btrfs 
module after all the other module.

  $ cat /etc/initramfs-tools/scripts/init-top/btrfs 
  #!/bin/sh

  case $1 in
  # get pre-requisites
  prereqs)
        exit 0
        ;;
  esac

  modprobe btrfs

The initramfs hook scripts, load the btrfsctl command, the btrfs module and 
the udev rule in the initramfs image:

  $ cat /etc/initramfs-tools/hooks/btrfs
  #!/bin/sh

  case $1 in
  # get pre-requisites
  prereqs)
        echo "udev"
        exit 0
        ;;
  esac


  . /usr/share/initramfs-tools/hook-functions

  mkdir -p $DESTDIR/lib/udev/rules.d/
  cp /etc/udev/rules.d/60-btrfs-scan.rules \
        $DESTDIR/lib/udev/rules.d/

  copy_exec /sbin/btrfsctl 
  manual_add_modules btrfs
  manual_add_modules crc32c



Note #1) pay attention to the fact the btrfs (libcrc32c in reality) needs the 
module crc32c even though there no is explicit dependency.
Note #2) init-top/btrfs has to start before init-top/udev: udev starts 
"btrfsctl", which requires the btrfs module. In my test the sequence is 
correct but I think that this is due to the fact that the scripts are ran in 
alphabetic order.
Note #3) when the module btrfs is loaded it creates the device /dev/btrfs-
control; this device has to be created before the block devices. devtmpfs 
(which ubuntu 10.4 has) helps a lot in that.


CONCLUSION:
These scripts are a prototype for avoid to use explicitly the "btrfs device 
scan" command. To me it seems to work. I tested it with two usb disk which I 
inserted after the boot, and with two internal hard disks. Both contains a 
multi-device btrfs filesystem (but not a root filesystem).These scripts may be 
inserted in a package, thanks to the modularity of the debian initramfs tool.



NOTE: These scripts may eat your baby or drink your beer so used them 
carefully.
NOTE: I tested these scripts which an ubuntu 10.4 system. I don't know the 
changes which may be required to work for other distributions (like fedora), 
but I am very interested in knowing those.


Comments are welcome.

BR
Goffredo

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
