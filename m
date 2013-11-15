Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46368 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758464Ab3KOLbk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 06:31:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhHcg-00089z-E1
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 12:31:38 +0100
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 12:31:38 +0100
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 12:31:38 +0100
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: "btrfs: 1 enospc errors during balance" when balancing after formerly
 failed raid1 device re-appeared
Date: Fri, 15 Nov 2013 12:31:24 +0100
Message-ID: <l650m2$njg$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,

I just did another test on resilience with btrfs/raid1, this time I tested
the following scenario: One out of two raid1 devices disappears. The filesystem
is written to in degraded mode. The missing device re-appears (think of e.g.
a storage device that temporarily became unavailable due to a cable or controller
issue that is later fixed). User issues "btrfs filesystem balance".

Alas, this scenario ends in an effor "btrfs: 1 enospc errors during balance",
with the raid1 staying degraded.

Here's the test procedure in detail:

Testing was done using vanilla linux-3.12 (x86_64)
plus btrfs-progs at commit 9f0c53f574b242b0d5988db2972c8aac77ef35a9
plus "[PATCH] btrfs-progs: for mixed group check opt before default raid profile is enforced"

Preparing two 100 MB image files:
 > # dd if=/dev/zero of=/tmp/img1 bs=1024k count=100
 > 100+0 records in
 > 100+0 records out
 > 104857600 bytes (105 MB) copied, 0.201003 s, 522 MB/s
 >
 > # dd if=/dev/zero of=/tmp/img2 bs=1024k count=100
 > 100+0 records in
 > 100+0 records out
 > 104857600 bytes (105 MB) copied, 0.185486 s, 565 MB/s

Preparing two loop devices on those images to act as the underlying
block devices for btrfs:
 > # losetup /dev/loop1 /tmp/img1
 > # losetup /dev/loop2 /tmp/img2

Mounting / writing to the fs:
 > # mount -t btrfs /dev/loop1 /mnt/tmp
 > # echo asdfasdfasdfasdf >/mnt/tmp/testfile1
 > # md5sum /mnt/tmp/testfile1
 > f1264d450b9feda62fec5a1e11faba1a  /mnt/tmp/testfile1
 > # umount /mnt/tmp

First storage device "disappears":
 > # losetup -d /dev/loop1

Mounting degraded btrfs:
 > # mount -t btrfs -o degraded /dev/loop2 /mnt/tmp

Testing that testfile1 is still readable:
 > # md5sum /mnt/tmp/testfile1
f1264d450b9feda62fec5a1e11faba1a  /mnt/tmp/testfile1

Creating "testfile2" on the degraded filesystem:
 > # echo qwerqwerqwerqwer >/mnt/tmp/testfile2
 > # md5sum /mnt/tmp/testfile2
 > 9df26d2f2657462c435d58274cc5bdf0  /mnt/tmp/testfile2
 > # umount /mnt/tmp

Now we assume the issue causing the first storage device
to be unavailable to be fixed:

 > # losetup /dev/loop1 /tmp/img1
 > # mount -t btrfs /dev/loop1 /mnt/tmp

Notice that at this point, I would have expected some kind of warning
in the syslog that the mounted filesystem is not balanced and
thus not redundant.
But there was no such warning.
This may easily lead operators into a situation where they do
not realize that a btrfs is not redundant and losing one storage
device will lose data.

Testing that the two testfiles (one of which is not yet
stored on both devices) are still readable:
 > # md5sum /mnt/tmp/testfile1
f1264d450b9feda62fec5a1e11faba1a  /mnt/tmp/testfile1
 > # md5sum /mnt/tmp/testfile2
9df26d2f2657462c435d58274cc5bdf0  /mnt/tmp/testfile2

So far, so good.
Now since we know the filesystem is not really redundant,
we start a "balance":

 > # btrfs filesystem balance /mnt/tmp
 > ERROR: error during balancing '/mnt/tmp' - No space left on device
 > There may be more info in syslog - try dmesg | tail

Syslog shows:
 > kernel: btrfs: relocating block group 20971520 flags 21
 > kernel: btrfs: found 3 extents
 > kernel: btrfs: relocating block group 4194304 flags 5
 > kernel: btrfs: relocating block group 0 flags 2
 > kernel: btrfs: 1 enospc errors during balance

So the raid1 remains "degraded".

BTW: I wonder why "btrfs balance" seems to require additional space
for writing data to the re-appeared disk.

I also wonder: Would btrfs try to write _two_ copies of
everything to _one_ remaining device of a degraded two-disk raid1?
(If yes, then this means a raid1 would have to be planned with
twice the capacity just to be sure that one failing disk will
not lead to an out-of-diskspace situation. Not good.)

Regards,

Lutz Vieweg

