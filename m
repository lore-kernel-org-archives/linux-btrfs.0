From: Andi Drebes <lists-receive@programmierforen.de>
Subject: Unable to mount loopback devices in RAID mode
Date: Thu, 19 Nov 2009 20:26:04 +0100
Message-ID: <200911192026.04694.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
I recently tried to mount a filesystem in RAID1 mode using loopback devices. I followed the instructions at [1]. Here's exactly what I've done:

$ dd if=/dev/zero of=raid1_0.img bs=1M count=500
$ dd if=/dev/zero of=raid1_1.img bs=1M count=500
$ mkfs.btrfs -m raid1 -d raid1 raid1_0.img raid1_1.img
$ losetup /dev/loop0 raid1_0.img
$ losetup /dev/loop1 raid1_1.img
$ mount -t btrfs /dev/loop0 /mnt/btrfs
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

$ dmesg
...
[  301.429030] Btrfs loaded
[  301.439361] device fsid 7347e7099a1ddaab-c4f037e2686afdbf devid 1 transid 7 /dev/loop0
[  301.444425] btrfs: failed to read the system array on loop0
[  301.444480] btrfs: open_ctree failed

Am I missing something? Or is the documentation outdated? The error is perfectly reproducible, no matter what RAID type I specify (raid0, raid1 or raid10). I used the latest version from the btrfs-unstable and btrfs-progs-unstable git repositories. When using real block devices, however, everything works fine.

	Cheers,
		Andi

[1] http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
