Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:45655 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3DEXnj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 19:43:39 -0400
Received: by mail-la0-f43.google.com with SMTP id ek20so3905454lab.2
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Apr 2013 16:43:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 5 Apr 2013 19:43:35 -0400
Message-ID: <CAPL5yKf=Lw7qPLrkVOhKC=B1Ap+Y=JxMzJ0SUdtG=QyjfBWKEg@mail.gmail.com>
Subject: filesystem stuck RO after losing a device
From: Dan Merillat <dan.merillat@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

first off: this was just junk data, and is all readable in degraded
mode anyway.

Label: 'ROOT'  uuid: cc80d150-af98-4af4-bc68-c8df352bda4f
	Total devices 2 FS bytes used 138.00GB
	devid    1 size 232.79GB used 189.04GB path /dev/sdc2
	devid    3 size 232.89GB used 14.06GB path /dev/sdb

The filesystem was created in 3.6 or so, and abandoned when I moved to
a SSD as my main root.  Playing around with it, I added a raw disk to
it and did some IO but wanted that disk back.  Due to the automatic
upgrade to 'dup' when adding a second device, I couldn't do a btrfs
dev delete so I ended up just unmounting it and reformatting /dev/sdb
as a backup for my SSD.

Given the 'dup' profile, I should be able to just blow away the stub
of sdb and continue using sdc, but I can't figure out any way to get
it to allow that.

$ uname -a
$ uname -a
Linux wolf 3.8.0-rc5-dan #3 SMP PREEMPT Tue Jan 29 00:55:14 EST 2013
x86_64 GNU/Linux
(I forgot to remove extraversion, git is clean 3.8-rc5)

$ sudo mount -o degraded /dev/sdc2 /mnt/t2
mount: wrong fs type, bad option, bad superblock on /dev/sdc2,
$ dmesg | tail
[1648243.075565] device label ROOT devid 1 transid 15051 /dev/sdc2
[1648243.076531] btrfs: allowing degraded mounts
[1648243.076539] btrfs: disk space caching is enabled
[1648243.891735] Btrfs: too many missing devices, writeable mount is not allowed
[1648243.898122] btrfs: open_ctree failed

$ sudo mount -o degraded,ro /dev/sdc2 /mnt/t2
$ dmesg | tail

[1648331.898660] device label ROOT devid 1 transid 15051 /dev/sdc2
[1648331.900371] btrfs: allowing degraded mounts
[1648331.900380] btrfs: disk space caching is enabled

$ sudo btrfs dev del missing /mnt/t2
ERROR: error removing the device 'missing' - Read-only file system
$ sudo btrfs dev add /dev/loop0 /mnt/t2
ERROR: error adding the device '/dev/loop0' - Read-only file system

$ sudo umount /mnt/t2
$ sudo ./btrfsck --repair /dev/sdc2
[sudo] password for harik:
enabling repair mode
ERROR: device scan failed '/dev/sdb' - Device or resource busy
ERROR: device scan failed '/dev/sdb' - Device or resource busy
Check tree block failed, want=211559927808, have=0
Check tree block failed, want=211559927808, have=0
Check tree block failed, want=211644346368, have=3611932269563901032
Check tree block failed, want=211644346368, have=3611932269563901032
Check tree block failed, want=211559563264, have=70368744177680
Check tree block failed, want=211559563264, have=70368744177680
Check tree block failed, want=211641229312, have=2308722807962755443
Check tree block failed, want=211641229312, have=2308722807962755443
Check tree block failed, want=211640909824, have=651398145056990559
Check tree block failed, want=211640909824, have=651398145056990559
Checking filesystem on /dev/sdc2
UUID: cc80d150-af98-4af4-bc68-c8df352bda4f
checking extents
Check tree block failed, want=212375867392, have=3431074926722403215
<thousands of these>
Check tree block failed, want=211559571456, have=15880152022637367237
checking root refs
btrfsck: extent-tree.c:2553: btrfs_reserve_extent: Assertion `!(ret)' failed.

btrfsck is from btrfs-progs master, g7854c8b66

So I can't mount RW because I only have one active disk, I can't add a
new one, and I can't remove the missing disk.  This seems somewhat
awkward, if using 2-disk BTRFS and a drive dies, how do you replace &
recover?
