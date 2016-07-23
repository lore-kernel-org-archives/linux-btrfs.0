Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:34206 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcGWNUU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 09:20:20 -0400
Received: by mail-yw0-f178.google.com with SMTP id z8so104137074ywa.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 06:20:19 -0700 (PDT)
MIME-Version: 1.0
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Sat, 23 Jul 2016 15:20:18 +0200
Message-ID: <CANznX5F6aL_c3nJuEvBa0e-q_XD2p72YfsU7uzVkRn_BzVVeSw@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems like I accidentally managed to break my Btrfs/RAID5
filesystem, yet again, in a similar fashion.
This time around, I ran into some random libata driver issue (?)
instead of a faulty hardware part but the end result is quiet similar.

I issued the command (replacing X with valid letters for every
hard-drives in the system):
# echo 1 > /sys/block/sdX/device/queue_depth
and I ended up with read-only filesystems.
I checked dmesg and saw write errors on every disks (not just those in RAID-5).

I tried to reboot immediately without success. My root filesystem with
a single-disk Btrfs (which is an SSD, so it has "single" profile for
both data and metadata) was unmountable, thus the kernel was stuck in
a panic-reboot cycle.
I managed to fix this one by booting from an USB stick and trying
various recovery methods (like mounting it with "-o
clear_cache,nospace_cache,recovery" and running "btrfs rescue
chunk-recovery") until everything seemed to be fine (it can now be
mounted read-write without error messages in the kernel-log, can be
fully scrubbed without errors reported, it passes in "btrfs check",
files can be actually written and read, etc).

Once my system was up and running (well, sort of), I realized my /data
is also un-mountable. I tried the same recovery methods on this RAID-5
filesystem but nothing seemed to help (there is an exception with the
recovery attempts: the system drive was a small and fast SSD so
"chunk-recovery" was a viable option to try but this one consists of
huge slow HDDs - so, I tried to run it as a last-resort over-night but
I found an unresponsive machine on the morning with the process stuck
relatively early in the process).

I can always mount it read-only and access files on it, seemingly
without errors (I compared some of the contents with backups and it
looks good) but as soon as I mount it read-write, all hell breaks
loose and it falls into read-only state in no time (with some files
seemingly disappearing from the filesystem) and the kernel log is
starting to get spammed with various kind of error messages (including
missing csums, etc).


After mounting it like this:
# mount /dev/sdb /data -o rw,noatime,nospace_cache
and doing:
# btrfs scrub start /data
the result is:

scrub status for 7d4769d6-2473-4c94-b476-4facce24b425
        scrub started at Sat Jul 23 13:50:55 2016 and was aborted after 00:05:30
        total bytes scrubbed: 18.99GiB with 16 errors
        error details: read=16
        corrected errors: 0, uncorrectable errors: 16, unverified errors: 0

The relevant dmesg output is:

 [ 1047.709830] BTRFS info (device sdc): disabling disk space caching
[ 1047.709846] BTRFS: has skinny extents
[ 1047.895818] BTRFS info (device sdc): bdev /dev/sdc errs: wr 4, rd
0, flush 0, corrupt 0, gen 0
[ 1047.895835] BTRFS info (device sdc): bdev /dev/sdb errs: wr 4, rd
0, flush 0, corrupt 0, gen 0
[ 1065.764352] BTRFS: checking UUID tree
[ 1386.423973] BTRFS error (device sdc): parent transid verify failed
on 24431936729088 wanted 585936 found 586145
[ 1386.430922] BTRFS error (device sdc): parent transid verify failed
on 24431936729088 wanted 585936 found 586145
[ 1411.738955] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[ 1411.948040] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[ 1412.040964] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[ 1412.040980] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[ 1412.041134] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[ 1412.042628] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[ 1412.042748] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[ 1499.222245] BTRFS error (device sdc): parent transid verify failed
on 24432312270848 wanted 585779 found 586143
[ 1499.230264] BTRFS error (device sdc): parent transid verify failed
on 24432312270848 wanted 585779 found 586143
[ 1525.865143] BTRFS error (device sdc): parent transid verify failed
on 24432367730688 wanted 585779 found 586144
[ 1525.880537] BTRFS error (device sdc): parent transid verify failed
on 24432367730688 wanted 585779 found 586144
[ 1552.434209] BTRFS error (device sdc): parent transid verify failed
on 24432415821824 wanted 585781 found 586144
[ 1552.437325] BTRFS error (device sdc): parent transid verify failed
on 24432415821824 wanted 585781 found 586144


btrfs check /dev/sdc results in:

Checking filesystem on /dev/sdc
UUID: 7d4769d6-2473-4c94-b476-4facce24b425
checking extents
parent transid verify failed on 24431859855360 wanted 585941 found 586144
parent transid verify failed on 24431859855360 wanted 585941 found 586144
checksum verify failed on 24431859855360 found 3F0C0853 wanted 165308D5
parent transid verify failed on 24431859855360 wanted 585941 found 586144
Ignoring transid failure
parent transid verify failed on 24432402878464 wanted 585947 found 586144
parent transid verify failed on 24432402878464 wanted 585947 found 586144
checksum verify failed on 24432402878464 found 2018608B wanted 0947600D
parent transid verify failed on 24432402878464 wanted 585947 found 586144
Ignoring transid failure
leaf parent key incorrect 24432402878464
parent transid verify failed on 24431936729088 wanted 585936 found 586145
parent transid verify failed on 24431936729088 wanted 585936 found 586145
checksum verify failed on 24431936729088 found E464923E wanted CD3B92B8
parent transid verify failed on 24431936729088 wanted 585936 found 586145
Ignoring transid failure
leaf parent key incorrect 24431936729088
parent transid verify failed on 24432268873728 wanted 585946 found 586143
parent transid verify failed on 24432268873728 wanted 585946 found 586143
checksum verify failed on 24432268873728 found 7748C8E4 wanted 5E17C862
parent transid verify failed on 24432268873728 wanted 585946 found 586143
Ignoring transid failure
leaf parent key incorrect 24432268873728
parent transid verify failed on 24432268873728 wanted 585946 found 586143
Ignoring transid failure
leaf parent key incorrect 24432268873728
parent transid verify failed on 24432268873728 wanted 585946 found 586143
Ignoring transid failure
leaf parent key incorrect 24432268873728
parent transid verify failed on 24432268873728 wanted 585946 found 586143
Ignoring transid failure
leaf parent key incorrect 24432268873728
parent transid verify failed on 24432112070656 wanted 585944 found 586142
parent transid verify failed on 24432112070656 wanted 585944 found 586142
checksum verify failed on 24432112070656 found 0482AA77 wanted 2DDDAAF1
parent transid verify failed on 24432112070656 wanted 585944 found 586142
Ignoring transid failure
parent transid verify failed on 24432112070656 wanted 585944 found 586142
Ignoring transid failure
parent transid verify failed on 24432112070656 wanted 585944 found 586142
Ignoring transid failure
parent transid verify failed on 24431790055424 wanted 585936 found 586144
parent transid verify failed on 24431790055424 wanted 585936 found 586144
checksum verify failed on 24431790055424 found 3B2164E6 wanted 127E6460
parent transid verify failed on 24431790055424 wanted 585936 found 586144
Ignoring transid failure
leaf parent key incorrect 24431790055424
parent transid verify failed on 24432038637568 wanted 585941 found 586145
parent transid verify failed on 24432038637568 wanted 585941 found 586145
checksum verify failed on 24432038637568 found 7A070E86 wanted 53580E00
parent transid verify failed on 24432038637568 wanted 585941 found 586145
Ignoring transid failure
leaf parent key incorrect 24432038637568
parent transid verify failed on 24432038637568 wanted 585941 found 586145
Ignoring transid failure
leaf parent key incorrect 24432038637568
parent transid verify failed on 24431790055424 wanted 585936 found 586144
Ignoring transid failure
leaf parent key incorrect 24431790055424
bad block 24431790055424
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 24432322764800 wanted 585779 found 586145
parent transid verify failed on 24432322764800 wanted 585779 found 586145
checksum verify failed on 24432322764800 found 2B2DE1E6 wanted 0272E160
parent transid verify failed on 24432322764800 wanted 585779 found 586145
Ignoring transid failure
Segmentation fault


So, it seems like there is no way of recovering from this.
Thus, so far, my experience with Btrfs RAID-5 is that it's everything
but resilient. Something sneezes in the system and it's gone. The only
fix is recreating the filesystem from scratch and restoring the
backups (if any) or may be recovering some of the content (with
read-only mount or the "btrfs recovery" tool). But it seems to be much
more prone to become unrecoverable than Btrfs filesystems with
"single" data and/or metadata profiles.


This one accident could possibly be related to the new space_cache=v2,
since I had that enabled when the corruption occurred and now I am
unable to mount it with that option (mounting with "-o
clear_cache,space_cache=v2" fails completely). So, may be that
experimental feature played some role in this:

[  906.664963] BTRFS info (device sdc): disabling disk space caching
[  906.664974] BTRFS: has skinny extents
[  907.032573] BTRFS info (device sdc): bdev /dev/sdc errs: wr 4, rd
0, flush 0, corrupt 0, gen 0
[  907.032589] BTRFS info (device sdc): bdev /dev/sdb errs: wr 4, rd
0, flush 0, corrupt 0, gen 0
[  951.948672] BTRFS info (device sdc): enabling free space tree
[  951.948682] BTRFS info (device sdc): force clearing of disk cache
[  951.948694] BTRFS info (device sdc): using free space tree
[  951.948696] BTRFS: has skinny extents
[  952.125700] BTRFS info (device sdc): bdev /dev/sdc errs: wr 4, rd
0, flush 0, corrupt 0, gen 0
[  952.125717] BTRFS info (device sdc): bdev /dev/sdb errs: wr 4, rd
0, flush 0, corrupt 0, gen 0
[  970.019994] BTRFS: creating free space tree
[  970.308042] BTRFS error (device sdc): parent transid verify failed
on 24431936729088 wanted 585936 found 586145
[  970.316104] BTRFS error (device sdc): parent transid verify failed
on 24431936729088 wanted 585936 found 586145
[  988.288037] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[  988.311250] BTRFS error (device sdc): parent transid verify failed
on 24432322764800 wanted 585779 found 586145
[  988.311265] ------------[ cut here ]------------
[  988.311276] WARNING: CPU: 0 PID: 1930 at
fs/btrfs/free-space-tree.c:1196
btrfs_create_free_space_tree+0x160/0x498
[  988.311280] BTRFS: Transaction aborted (error -5)
[  988.311285] CPU: 0 PID: 1930 Comm: mount Not tainted 4.6.4-gentoo #6
[  988.311288] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./FM2A75 Pro4, BIOS P2.40 07/11/2013
[  988.311291]  0000000000000286 000000008bf8f073 ffffffff812bdd7d
ffff8800d31af9b8
[  988.311297]  0000000000000000 ffffffff8106919f ffff8800da8652a0
ffff8800d31afa10
[  988.311302]  ffff8800d478e000 ffff880000000000 ffff8800da8652a0
ffff8800da865150
[  988.311307] Call Trace:
[  988.311314]  [<ffffffff812bdd7d>] ? dump_stack+0x46/0x59
[  988.311320]  [<ffffffff8106919f>] ? __warn+0xaf/0xd0
[  988.311324]  [<ffffffff8106921a>] ? warn_slowpath_fmt+0x5a/0x78
[  988.311330]  [<ffffffff8126d898>] ? btrfs_create_free_space_tree+0x160/0x498
[  988.311334]  [<ffffffff811f4fe2>] ? open_ctree+0x1d82/0x26b0
[  988.311340]  [<ffffffff811cb497>] ? btrfs_mount+0xca7/0xde0
[  988.311346]  [<ffffffff810fa289>] ? pcpu_alloc_area+0x219/0x3e0
[  988.311350]  [<ffffffff810fadcc>] ? pcpu_alloc+0x38c/0x690
[  988.311356]  [<ffffffff8112e4da>] ? mount_fs+0xa/0x88
[  988.311362]  [<ffffffff81147e86>] ? vfs_kern_mount+0x56/0x100
[  988.311367]  [<ffffffff811cab38>] ? btrfs_mount+0x348/0xde0
[  988.311371]  [<ffffffff811337ca>] ? terminate_walk+0x8a/0xf0
[  988.311375]  [<ffffffff810fa289>] ? pcpu_alloc_area+0x219/0x3e0
[  988.311379]  [<ffffffff810fa065>] ? pcpu_next_unpop+0x35/0x40
[  988.311383]  [<ffffffff810fadcc>] ? pcpu_alloc+0x38c/0x690
[  988.311388]  [<ffffffff8112e4da>] ? mount_fs+0xa/0x88
[  988.311393]  [<ffffffff81147e86>] ? vfs_kern_mount+0x56/0x100
[  988.311397]  [<ffffffff811491ed>] ? do_mount+0x1fd/0xce0
[  988.311400]  [<ffffffff8113f8fb>] ? dput+0xd3/0x248
[  988.311405]  [<ffffffff81120d38>] ? __kmalloc_track_caller+0x20/0xe8
[  988.311408]  [<ffffffff810f7318>] ? memdup_user+0x38/0x60
[  988.311412]  [<ffffffff81149fe0>] ? SyS_mount+0x80/0xc8
[  988.311417]  [<ffffffff816f379b>] ? entry_SYSCALL_64_fastpath+0x13/0x8f
[  988.311420] ---[ end trace a3cc21d9a0eba35e ]---
[  988.311425] BTRFS: error (device sdc) in
btrfs_create_free_space_tree:1196: errno=-5 IO failure
[  988.311463] BTRFS: failed to create free space tree -5
[  988.311475] BTRFS error (device sdc): commit super ret -30
[  988.311561] BTRFS error (device sdc): cleaner transaction attach returned -30
[  988.350206] BTRFS: open_ctree failed


Any ideas before I wipe the filesystem?
