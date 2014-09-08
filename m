Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48908 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaIHBve (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Sep 2014 21:51:34 -0400
Date: Sun, 7 Sep 2014 18:51:24 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, fdmanana@suse.com
Message-ID: <20140908015124.GA21441@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: btrfs differential receive has become excrutiatingly slow on one
 machine
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe and others,

TL;DR:
- btrfs send of a 1.5GB filesystem takes 4mn to replicate that
  filesystem on the target machine.
- btrfs send -p between 2 snapshots happens in 1 second
- copying that diff to the other machine takes 8 seconds
- applying that diff with btrfs receive takes 82mn (again
  when resyncing the entire filesystem from scratch only takes 4mn)

Details:
Kernel 3.16.2 on both sides, although the problem started earlier, maybe
after 3.14.

btrfs send/receive works great on my laptop from one drive to another,
but it's unbearable when I run it to my disk server (which was on 3.14
up to today due to the bugs in 3.15 and 3.16.x<2).

Sending an entire snapshot (non differential mode) is fast too:
> legolas:/mnt/btrfs_pool1# time btrfs send root_ggm_daily_ro.20140907_13* | ssh gargamel "time btrfs receive /mnt/btrfs_pool2"
> At subvol root_ggm_daily_ro.20140907_13:16:58
> At subvol root_ggm_daily_ro.20140907_13:16:58
> 
> real	4m41.392s
> user	0m1.380s
> sys	0m9.504s
> 
> real	4m41.685s
> user	0m4.580s
> sys	0m16.844s

Sending an incremental 154MB diff takes almost 82mn for btrfs receive to process.


btrfs send differential is fast:
legolas:/mnt/btrfs_pool1# time btrfs send -p /mnt/btrfs_pool1/root_ggm_daily_ro.20140906_10:25:25 root_ggm_daily_ro.20140907_14:55:40 > /mnt/btrfs_pool2/diff
At subvol root_ggm_daily_ro.20140907_14:55:40

real	0m1.464s
user	0m0.004s
sys	0m1.172s

However, btrfs receive of that diff is slow as molasses.

The diff is smallish:
legolas:/mnt/btrfs_pool1# du -sh /mnt/btrfs_pool2/diff
154M	/mnt/btrfs_pool2/diff

The subvolume is small too:
legolas:/mnt/btrfs_pool1# du -sh root
1.5G	root

Copying that diff file over ssh takes 8 seconds, and then doing the
receive manually is where wait is going on

gargamel:/mnt/btrfs_pool2/backup/debian64/legolas# time btrfs receive -f /tmp/diff .  
At snapshot root_ggm_daily_ro.20140907_14:55:40


Strace shows that it hangs for portion of or multiple seconds on read from FH 3
btrfs   4467 root    3r   REG   0,27 160962420 13136056 /tmp/diff

/tmp/diff is on a different filesystem and different drives than the
btrfs FS the restore is happening on.

Here is a snapshot of strace showing how it hangs for multiple seconds at the read
step that reads from the diff file:
     0.000114 read(3, "h\0\0\0\21\0\305\341\244\266", 10) = 10
     0.000059 read(3, "\17\0X\0lib/modules/3.16.2-amd64-i91"..., 104) = 104
     0.000061 truncate("/mnt/btrfs_pool2/backup/debian64/legolas/root_ggm_daily_ro.20140907_14:55:40/lib/modules/3.16.2-amd64-i915-preempt-20140714/kernel/arch/x86/crypto/blowfish-x86_64.ko", 20304) = 0
>>>  91.915793 read(3, "t\0\0\0\23\0\v\370\222\244", 10) = 10
     0.000066 read(3, "\17\0X\0lib/modules/3.16.2-amd64-i91"..., 116) = 116
     0.000061 lchown("/mnt/btrfs_pool2/backup/debian64/legolas/root_ggm_daily_ro.20140907_14:55:40/lib/modules/3.16.2-amd64-i915-preempt-20140714/kernel/arch/x86/crypto/blowfish-x86_64.ko", 0, 0) = 0
     0.000125 read(3, "h\0\0\0\22\0Xa\r\271", 10) = 10
     0.000050 read(3, "\17\0X\0lib/modules/3.16.2-amd64-i91"..., 104) = 104
     0.000055 chmod("/mnt/btrfs_pool2/backup/debian64/legolas/root_ggm_daily_ro.20140907_14:55:40/lib/modules/3.16.2-amd64-i915-preempt-20140714/kernel/arch/x86/crypto/blowfish-x86_64.ko", 0644) = 0

See how that was 91 seconds up there, it's thankfully usually less.

While strace shows me the wait is on read, I'm going to assume that really the hang is 
when btrfs receive is sending the bytes to the kernel to write on disk.

The target filesystem looks like this:
Label: 'dshelf2'  uuid: d4a51178-c1e6-4219-95ab-5c5864695bfd 
        Total devices 1 FS bytes used 3.53TiB 
        devid    1 size 7.28TiB used 3.66TiB path /dev/mapper/dshelf2 

Data, single: total=3.50TiB, used=3.47TiB
System, DUP: total=8.00MiB, used=416.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=77.50GiB, used=62.31GiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=512.00MiB, used=8.64MiB

So it's not critically misbalanced since it's only 50% used, correct?

For good measure, I ran:
btrfs balance start -dusage=10 /mnt/btrfs_pool2 
ran and exited with:
Done, had to relocate 5 out of 3746 chunks
but that did not help the restore speed at all.


btrfs restore -v -v -v shows it's doing work, but slow enough that I can easily read the text going by:
truncate sbin/swaplabel size=14568
chown sbin/swaplabel - uid=0, gid=0
chmod sbin/swaplabel - mode=0755
utimes sbin/swaplabel
mkfile o85871-279575-0
rename o85871-279575-0 -> sbin/raw
utimes sbin
truncate sbin/raw size=10336
chown sbin/raw - uid=0, gid=0
chmod sbin/raw - mode=0755
utimes sbin/raw
mkfile o85872-279575-0
rename o85872-279575-0 -> sbin/fsck.cramfs  
utimes sbin
truncate sbin/fsck.cramfs size=14544
chown sbin/fsck.cramfs - uid=0, gid=0
chmod sbin/fsck.cramfs - mode=0755
utimes sbin/fsck.cramfs
mkfile o85873-279575-0
rename o85873-279575-0 -> sbin/mkfs.cramfs
utimes sbin
truncate sbin/mkfs.cramfs size=31120
chown sbin/mkfs.cramfs - uid=0, gid=0
chmod sbin/mkfs.cramfs - mode=0755
utimes sbin/mkfs.cramfs
mkfile o85874-279575-0
rename o85874-279575-0 -> sbin/findfs
utimes sbin
truncate sbin/findfs size=6208
chown sbin/findfs - uid=0, gid=0
chmod sbin/findfs - mode=0755
utimes sbin/findfs
mkfile o85875-279575-0
rename o85875-279575-0 -> sbin/wipefs
utimes sbin

Here is a full run:
gargamel:/mnt/btrfs_pool2/backup/debian64/legolas# time btrfs receive -v -v -v -f /tmp/diff .
At snapshot root_ggm_daily_ro.20140907_14:55:40
receiving snapshot root_ggm_daily_ro.20140907_14:55:40 uuid=8bfc0ac8-6436-614d-8a56-7f7894f743b8, ctransid=281821 parent_uuid=075e6ff5-9b87-874f-991c-b453a0f5d4c0, parent_ctransid=278891
utimes tmp
utimes bin
unlink bin/dmesg
utimes bin
unlink bin/lsblk
utimes bin
unlink bin/more
utimes bin
unlink bin/tailf
(...)
BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=8bfc0ac8-6436-614d-8a56-7f7894f743b8, stransid=281821

real    82m55.222s
user    0m0.236s
sys     0m1.816s


Any idea what's going on?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
