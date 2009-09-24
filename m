From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: [patch 0/2] grub-0.97: btrfs support
Date: Fri, 25 Sep 2009 00:06:23 +0200
Message-ID: <4ABBED5F.6000008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone.

The following patches are for Fedora 10(**).
The distro-independent package will be put to kernel.org a bit later.


           I. Loading kernels from btrfs volumes


Now you can load kernels and initrds from btrfs volumes composed of
many devices.

WARNING!!!
Make sure that all components of your loading btrfs volume(*) are
visible to grub. Otherwise, you'll end with unbootable system.
The list of available grub devices can be obtained, for example,
using tab completion in grub shell.

Number of components of a loading volume is not restricted, however
if it is larger then 128, then the boot process will be slowed down
because of expensive translations (btrfs-device-id -> grub-device-id)
which issue a large number of IOs. We cache only 128 such translations
in grub-0.97 because of high memory pressure.


           II. Installing grub from btrfs volumes


You can install grub from a btrfs image volume(*) composed of many
devices (see above about restrictions). Also you can setup any
component of a btrfs boot(*) volume as grub root device.

NOTE!!! Make sure that all components of image and boot volumes(*)
are visible to grub, otherwise grub installer will return error.

TECHNICAL NOTE (for grub developers):
The unpleasant surprise was that grub installer overwrites
(by default!) the file (stage2), bypassing the file system driver.
I can not understand this: it looks like stepping to the clean water
with dirty shoe. Hope that grub2 won't afford such things.

In order to install grub from a btrfs image volume use special
option (--stage2). This option makes grub installer to rewrite
the file with a help of the OS's file system (i.e, via write (2)).
Any attempts to install without this option will fail with an error
(wrong argument).

The example of possible installation scenario.

Suppose image volume = root volume = loading volume is composed
of devices (hd0,4), (hd0,5), (hd1,5), (hd1,7) and is not an OS's
root. We want to setup (hd0,4) as grub root device and install
grub to the mbr of (hd0).

. build and install grub with btrfs support;
. mount your the "3 in 1" btrfs volume to /mnt;
. create a directory /mnt/grub;
. put the built files stage1, stage2, btrfs_stage1_5, grub.conf,
 etc. to /mnt/grub;
. run grub shell;
. grub> root (hd0,4)
. grub> setup --stage2=/mnt/grub/stage2 (hd0)
. have a fun.

Use info(1) grub for more details.

(*) Glossary:
. loading volume:
 a btrfs volume that contains kernel image and initrd;

. image volume:
 a btrfs volume that contains stage1, stage2, btrfs_stage_1_5,
 and grub.conf files needed for grub installer;

. boot volume:
 a btrfs volume where grub will look for stage2 and grub.conf
 files in boot time.

(**) Link to the Fedora's grub package:
http://ucho.ignum.cz/fedora/linux/releases/10/Fedora/source/SRPMS/grub-0.97-38.fc10.src.rpm 


All comments, bugreports, etc. are welcome as usual.

Thanks,
Edward.

