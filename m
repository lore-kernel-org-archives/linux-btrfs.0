Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35870 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbbIXNhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 09:37:02 -0400
Received: by qkcf65 with SMTP id f65so29531619qkc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 06:37:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOE4rSwY0ZFAzRkRg-maU474FWaHo+TFb8JTG+a66rjVfOSmhg@mail.gmail.com>
References: <CAOE4rSwiQxR16fSNtnaX5D5MaTcG3q+v__=qP4-m3So3fu_ksQ@mail.gmail.com>
	<CAOE4rSwY0ZFAzRkRg-maU474FWaHo+TFb8JTG+a66rjVfOSmhg@mail.gmail.com>
Date: Thu, 24 Sep 2015 16:37:01 +0300
Message-ID: <CAOE4rSyg1dyuoo-T90=Y-iSSk5Xzz-Bb4e-dTvr=N04+QgHXWw@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2062 (v4.2.0-rc8)
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-09-01 3:08 GMT+03:00 Dāvis Mosāns <davispuh@gmail.com>:
>
> Here's a btrfs-image from that filesystems /dev/sdb
> https://drive.google.com/file/d/0B82_Tz1_6URAQmV5LTZHUmR4YXM/view?usp=sharing
> sha256sum
> 88fb561b4a581319ae18c1f27b6ac108e9c08ff80954e192cb3201cc5d4c19ff raid1_sdb.img
> size 142M
>
> only difference for btrfs-image between disks
> image from /dev/sdb  => image from /dev/sdf
> 0x00000400 2fc3d988 => 8c421133
> 0x000004c9 02 => 01
> 0x0000050b 7ed7472cd5d44f5e842ede789208dfd9 => 3ceab04840a3412da65cab36dba5c17e
>

When I tried to restore that image in VM

$  btrfs-image -r raid1_sdb.img /dev/sdb1
warning devid 1 not found already
disk-io.c:1437: write_dev_supers: Assertion `ret !=
BTRFS_SUPER_INFO_SIZE` failed.
btrfs-image[0x40e128]
btrfs-image(write_all_supers+0x1b6)[0x40f5c6]
btrfs-image(write_ctree_super+0xd3)[0x40f733]
btrfs-image(btrfs_commit_transaction+0xb3)[0x40fb73]
btrfs-image[0x433fa9]
btrfs-image(main+0x33d)[0x4080cd]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f75657a8610]
btrfs-image(_start+0x29)[0x408489]

$ btrfs-image -r raid1_sdf.img /dev/sdb2
warning devid 2 not found already
disk-io.c:1437: write_dev_supers: Assertion `ret !=
BTRFS_SUPER_INFO_SIZE` failed.
btrfs-image[0x40e128]
btrfs-image(write_all_supers+0x1b6)[0x40f5c6]
btrfs-image(write_ctree_super+0xd3)[0x40f733]
btrfs-image(btrfs_commit_transaction+0xb3)[0x40fb73]
btrfs-image[0x433fa9]
btrfs-image(main+0x33d)[0x4080cd]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7fa502f58610]
btrfs-image(_start+0x29)[0x408489]


Seems can't restore with just one image, but even with both it gave errors

$  btrfs-image -r -m raid1_sdb.img /dev/sdb1 raid1_sdf.img /dev/sdb2
Error writing to device 28
Error writing to device 28
Error writing to device 28
Error writing to device 28
Error writing to device 28
[...]
Error writing to device 28
Error writing to device 28
Error writing to device 28
Error writing to device 28
Error writing to device 28
Error writing to device 28
Error writing to device 28
restore failed (Success)


Also I think it should prevent from restoring on mounted device because
I accidentally restored on my / root partition...

$ btrfs-image -r raid1_sdf.img /dev/sda1
$
it finished and didn't show any message, whoops...

that was inside a VM so no big deal, but still...


Now when I tried to mount disk with written image it doesn't work with
subvol even if they show up with

$ btrfs subvolume list
ID 261 gen 2838 top level 258 path var

$ mount -o subvol=var /dev/sdb1 /mnt/raid1img
mount: mount(2) failed: No such file or directory

but it mounted fine with subvolid, only folders are inaccessible
and can't see anything more than root folder
$ ls -l /mnt/raid1img

d????????? ? ? ? ?            ? 1%
l????????? ? ? ? ?            ? 2Y{m
d????????? ? ? ? ?            ? %42
d????????? ? ? ? ?            ? $|&K
-????????? ? ? ? ?            ? :k}LT}Eh
d????????? ? ? ? ?            ? mB7

$ cd /mnt/raid1img/mB7
cd: /mnt/raid1img/mB7: No such file or directory


so seems that image is useless for bug reproduction.

I created a new image without sanitized names and when restoring single device
it doesn't crash and shows different message

$ btrfs-image -r raid1_sdb_new.img /dev/sdb1
Error writing to device 28
Error writing to device 28
Error writing to device 28
[...]
Error writing to device 28
Error writing to device 28
Couldn't find a chunk, using logical
Error writing to device 28
restore failed (Success)


but it doesn't mount at all
$ mount /dev/sdb1 /mnt/raid1img
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error
BTRFS: open_ctree failed

ah, looks like I need device that's atleast size of original device so now with
bigger disk

$ btrfs-image -r -m raid1_sdb_new.img /dev/sdb raid1_sdf_new.img /dev/sdc
warning, device 1 is missing
bytenr mismatch, want=588272107520, have=0
Couldn't read chunk root
unable to open /dev/sdb error = Illegal seek

$ btrfs-image -r raid1_sdb_new.img /dev/sdb
warning devid 1 not found already
checksum verify failed on 623598993408 found E4E3BDB6 wanted 00000000
checksum verify failed on 623598993408 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=623598993408, have=0
Couldn't setup log root tree

still doesn't mount

$ mount /dev/sdb /mnt/raid1img
mount: /dev/sdb: can't read superblock

kernel: BTRFS info (device sdc): disk space caching is enabled
kernel: BTRFS: has skinny extents
kernel: BTRFS (device sdc): bad tree block start 0 623648882688
kernel: BTRFS: failed to read log tree
kernel: BTRFS: open_ctree failed

after
$ btrfs check --repair /dev/sdb

enabling repair mode
checksum verify failed on 623204597760 found E4E3BDB6 wanted 00000000
checksum verify failed on 623204597760 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=623204597760, have=0
Couldn't setup log root tree
repair mode will force to clear out log tree, Are you sure? [y/N]: y
Checking filesystem on /dev/sdb
UUID: 247e6249-6de1-45cb-9dd0-fa8a654234bf
checking extents
Chunk[256, 228, 99350478848]: length(1073741824), offset(99350478848),
type(1) mismatch with block group[99350478848, 192, 1073741824]:
offset(1073741824), objectid(99350478848), flags(17)
[...]
Chunk[256, 228, 643066494976]: length(1073741824),
offset(643066494976), type(1) mismatch with block group[643066494976,
192, 1073741824]: offset(1073741824), objectid(643066494976),
flags(17)
Block group[163774988288, 1073741824] (flags = 17) didn't find the
relative chunk.
[...]
Block group[624812883968, 1073741824] (flags = 17) didn't find the
relative chunk.
Device extent[1, 1048576, 33554432] didn't find the relative chunk.
[...]
Device extent[1, 375844241408, 1073741824] didn't find its device.
Errors found in extent allocation tree or chunk allocation
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
reset nbytes for ino 229313 root 266
checking csums
checking root refs
found 369461424388 bytes used err is 0
total csum bytes: 357534528
total tree bytes: 1705639936
total fs tree bytes: 1152352256
total extent tree bytes: 116981760
btree space waste bytes: 285539280
file data blocks allocated: 369964752896
 referenced 390885834752

now it mounted, but accessing that file doesn't cause crash, probably
need data too.


So then on original filesystem I tried btrfs send, but

$ btrfs send /mnt/raid1/var -f /mnt/raid1.img
ERROR: /mnt/raid1/var is not read-only.

why... it is mounted with ro
oh, it wasn't really clear that it expects read-only snapshot rather than just
subvolume mounted as ready-only.
Ok, created read-only snapshot and then tried btrfs send again and got
*kernel crash*

nice, so I can't even copy it to other device.

Any idea how to analyze this filesystem without using btrfs kernel
module because
as soon as it accesses that file it causes crash?
