Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63357 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaHQMoh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 08:44:37 -0400
Received: from [10.0.0.2] ([193.154.244.253]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0LcT2M-1WcTjB2M9m-00jrS4 for
 <linux-btrfs@vger.kernel.org>; Sun, 17 Aug 2014 14:44:35 +0200
Message-ID: <53F0A3B2.80709@gmx.at>
Date: Sun, 17 Aug 2014 14:44:34 +0200
From: Klaus Holler <kho@gmx.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs receive problem on ARM kirkwood NAS with kernel 3.16.0 and
 btrfs-progs 3.14.2
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I want to use an ARM kirkwood based NSA325v2 NAS (dubbed "Receiver") for
receiving btrfs snapshots done on several hosts, e.g. a Core Duo laptop
running kubuntu 14.04 LTS (dubbed "Source"), storing them on a 3TB WD
red disk (having GPT label, partitions created with parted).

But all the btrfs receive commands on 'Receiver' fail soon with e.g.:
  ERROR: writing to initrd.img-3.13.0-24-generic.original failed. File
too large
... and that stops reception/snapshot creation.

In fact, the receive commands fails even earlier as the created files in
the partly-created snapshot copy have mismatched ownership, file
permissions and filesize (!); only file content is fine (see below 'More
Details').

First, I tried using the Linux version 3.13.0-33-generic kernel and
btrfs-progs from kubuntu 14.04 LTS; but to rule out any sender-side
(kernel or btrfs-progs) problems I changed to the official 3.16.0 linux
kernel and switched to btrfs-progs v3.14.2 [1], both compiled from GIT
(https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories).
With this combination I created a fresh snapshot from /boot at Source.
But error stayed the same on the 'Receiver'.

Initially, 'Receiver' used Linux version 3.14.0-kirkwood-tld-1, but also
switching to Linux version 3.16.0-kirkwood-tld-1 (root@tldDebian) (gcc
version 4.6.3 (Debian 4.6.3-14) ) #2 PREEMPT Sun Aug 10 01:22:41 PDT
2014 [2]
                                          and Btrfs v3.14.2 compiled
from GIT did not change anything.
kirkwood kernels (and rootfs) for NSA325v2 are from
http://forum.doozan.com/read.php?2,12096.

Receiving the identical snapshot, that was written to a file for
reproducability, on "OtherHost", a netbook running kubuntu 14.04 LTS,
works fine - the snapshot is complete and permissions/filesizes look
fine there.


More details:
=============
e.g. 'Source' has
/boot/.snapshot/20140816-1310-boot_kernel3.16.0$ ll grub
insgesamt 2376
drwxr-xr-x 1 root root     120 Aug 15 21:51 ./
drwxr-xr-x 1 root root     886 Aug 15 21:51 ../
drwxr-xr-x 1 root root      22 Mai  2 19:15 fonts/
-rw-r--r-- 1 root root     902 Mai  2 22:17 gfxblacklist.txt
-r--r--r-- 1 root root   10764 Aug 15 21:51 grub.cfg
-rw-r--r-- 1 root root    1024 Aug 16 13:04 grubenv
drwxr-xr-x 1 root root    6050 Jul 25 18:11 i386-pc/
drwxr-xr-x 1 root root      58 Jul 25 18:11 locale/
-rw-r--r-- 1 root root 2405285 Jul 25 18:11 unicode.pf2

This was created with
btrfs subvol snapshot -r /boot
/boot/.snapshot/20140816-1310-boot_kernel3.16.0, and written to a file with
btrfs send /boot/.snapshot/20140816-1310-boot_kernel3.16.0 >
/boot/.snapshot/20140816-1310-boot_kernel3.16.0.btrfs-send

The (partial) snapshot created on 'Receiver' is looking like this:
/vol/2/20140816-1310-boot_kernel3.16.0# ll grub
total 4
d-----x--- 1 mail mail       50 Aug 15 21:51 .
d-----x--- 1 mail mail      186 Aug 15 21:51 ..
drwxr-xr-x 1 root root       22 May  2 19:15 fonts
------x--- 1 mail mail 67108872 Aug 16 13:04 grubenv
d-----x--- 1 mail mail       20 Jul 25 18:11 i386-pc
dr-S--S--- 1 root root        0 Jul 25 18:11 locale


Increasing the verbosity with "-v -v" for btrfs receive shows the
following differences between receive operations on 'Receiver' and
'OtherHost', both of them using the identical inputfile
/boot/.snapshot/20140816-1310-boot_kernel3.16.0.btrfs-send

* the chown and chmod operations are different -> resulting in
weird/wrong permissions and sizes on 'Receiver' side.
* what's "stransid", this is the first line that differs

--- Receiver/dump2_fails.log      2014-08-16 20:28:57.553325832 +0200
+++ OtherHost/dump2_works.log       2014-08-16 20:36:03.739439175 +0200
@@ -1,13 +1,13 @@
 At subvol 20140816-1310-boot_kernel3.16.0
-receiving subvol 20140816-1310-boot_kernel3.16.0
uuid=2eb2588c-2c08-c946-83fb-e29387cb823e, stransid=91392
-chown  - uid=8, gid=8
-chmod  - mode=0173200010
+receiving subvol 20140816-1310-boot_kernel3.16.0
uuid=2eb2588c-2c08-c946-83fb-e29387cb823e, stransid=357
+chown  - uid=0, gid=0
+chmod  - mode=0755
 utimes
 mkdir o257-6-0
 rename o257-6-0 -> grub
 utimes
-chown grub - uid=8, gid=8
-chmod grub - mode=0173200010
+chown grub - uid=0, gid=0
+chmod grub - mode=0755
 utimes grub
 mkfile o261-6-0
 rename o261-6-0 -> memtest86+.bin
@@ -26,28 +26,28 @@
 mkfile o263-6-0
 rename o263-6-0 -> memtest86+_multiboot.bin
 utimes
-truncate memtest86+_multiboot.bin size=11709972488
-chown memtest86+_multiboot.bin - uid=8, gid=8
-chmod memtest86+_multiboot.bin - mode=0151000010
+truncate memtest86+_multiboot.bin size=178680
+chown memtest86+_multiboot.bin - uid=0, gid=0
+chmod memtest86+_multiboot.bin - mode=0644
 utimes memtest86+_multiboot.bin
 mkdir o267-10-0
 rename o267-10-0 -> grub/i386-pc
 utimes grub
-chown grub/i386-pc - uid=8, gid=8
-chmod grub/i386-pc - mode=0173200010
+chown grub/i386-pc - uid=0, gid=0
+chmod grub/i386-pc - mode=0755
 utimes grub/i386-pc
 mkdir o268-10-0
 rename o268-10-0 -> grub/locale
 utimes grub
 chown grub/locale - uid=0, gid=0
-chmod grub/locale - mode=0366400
+chmod grub/locale - mode=0755
 utimes grub/locale
 mkfile o537-10-0
 rename o537-10-0 -> grub/i386-pc/modinfo.sh
 utimes grub/i386-pc
-truncate grub/i386-pc/modinfo.sh size=588032
+truncate grub/i386-pc/modinfo.sh size=2297
 chown grub/i386-pc/modinfo.sh - uid=0, gid=0
-chmod grub/i386-pc/modinfo.sh - mode=0322000
+chmod grub/i386-pc/modinfo.sh - mode=0644
 utimes grub/i386-pc/modinfo.sh
 mkdir o541-10-0
 rename o541-10-0 -> grub/fonts

...

@@ -65,11 +65,2091 @@
 mkfile o543-10-0
 rename o543-10-0 -> grub/grubenv
 utimes grub
-truncate grub/grubenv size=67108872
-chown grub/grubenv - uid=8, gid=8
-chmod grub/grubenv - mode=0151000010
+truncate grub/grubenv size=1024
+chown grub/grubenv - uid=0, gid=0
+chmod grub/grubenv - mode=0644
 utimes grub/grubenv
 mkfile o548-13-0
 rename o548-13-0 -> initrd.img-3.13.0-24-generic.original
 utimes
-ERROR: writing to initrd.img-3.13.0-24-generic.original failed. File
too large
+truncate initrd.img-3.13.0-24-generic.original size=26419037
+chown initrd.img-3.13.0-24-generic.original - uid=0, gid=0
+chmod initrd.img-3.13.0-24-generic.original - mode=0644
+utimes initrd.img-3.13.0-24-generic.original

...


Any help on how to debug this problem further is _very_ appreciated.

Kind regards,
Klaus

P.S. Shall I create a bug report on https://bugzilla.kernel.org/ as well?

-- 
Klaus Holler <kho (at) gmx (punkt) at>
