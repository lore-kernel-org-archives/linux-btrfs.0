Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:59437 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab3JSStc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Oct 2013 14:49:32 -0400
Received: from mail-in-15-z2.arcor-online.net (mail-in-15-z2.arcor-online.net [151.189.8.32])
	by mx.arcor.de (Postfix) with ESMTP id 17A7110BA9C
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Oct 2013 20:49:31 +0200 (CEST)
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net [151.189.21.48])
	by mail-in-15-z2.arcor-online.net (Postfix) with ESMTP id 0E867112037
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Oct 2013 20:49:31 +0200 (CEST)
Received: from mail.arcor.de (dslb-092-073-087-239.pools.arcor-ip.net [92.73.87.239])
	(Authenticated sender: jk3064@arcor.de)
	by mail-in-08.arcor-online.net (Postfix) with ESMTPA id E51853AF16F
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Oct 2013 20:49:30 +0200 (CEST)
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
To: linux-btrfs@vger.kernel.org
Date: Sat, 19 Oct 2013 20:49:33 +0200
Subject: broken superblocks
MIME-Version: 1.0
From: "Christian Switaiski" <jk3064@arcor.de>
Message-ID: <op.w47s8v1od6z2ia@mail.arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During a system deadlock I was forced to hard shutdown my system while a  
`btrfs balance` was ongoing and ctrl+c & `btrfs balance cancel` failed
Since the restart the partition is broken, the kernel fails to mounts it  
and btrfs' repair tools exit cause of errors w/o doing anything. The  
partition is 20GB, and so got 2 superblocks: both are broken :/



kernel is 3.11.5, btrfs-progs are git ones & distro is gentoo
------------ btrfs output start ------------

# mount /dev/sda2 /mnt/repair
mount: wrong fs type, bad option, bad superblock on /dev/sda2,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail or so

# dmesg | tail
[279861.340796] device label root-x64 devid 1 transid 535462 /dev/sda2
[279861.341416] btrfs: disk space caching is enabled
[279861.342223] attempt to access beyond end of device     <------
[279861.342226] sda2: rw=32, want=44040448, limit=41943040 <------
[279861.342236] attempt to access beyond end of device
[279861.342237] sda2: rw=32, want=44302592, limit=41943040
[279861.347811] btrfs: open_ctree failed

# btrfs-show-super /dev/sda2
superblock: bytenr=65536, device=/dev/sda2
---------------------------------------------------------
csum                    0xbd53d63e [match]
bytenr                  65536
...
total_bytes             21474836480
bytes_used              18661335040
...
dev_item.total_bytes    21474836480
dev_item.bytes_used     22032678912 <--- beyond part size!
...

# btrfs fi show
Label: 'root-x64'  uuid: f87210e5-47a9-44af-9797-6afea2cdaae8
         Total devices 1 FS bytes used 17.38GB
         devid    1 size 20.00GB used 20.52GB path /dev/sda2   <--- again  
beyond partsize
Btrfs v0.20-rc1-358-g194aa4a

# btrfsck /dev/sda2
Check tree block failed, want=39317532672, have=0
read block failed check_tree_block
Couldn't setup extent tree
Checking filesystem on /dev/sda2
UUID: f87210e5-47a9-44af-9797-6afea2cdaae8
Critical roots corrupted, unable to fsck the FS

# btrfs restore /dev/sda2 /tmp/fix
Check tree block failed, want=39317532672, have=0
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=39317532672, have=0
read block failed check_tree_block
Couldn't read fs root: -5

# btrfs-find-root /dev/sda2
Super think's the tree root is at 29556736, chunk root 40659582976
Found tree root at 29556736 gen 535462 level 1

btrfs-debug-tree & `btrfs chunk-recover -v` output a lot stuff but at the  
end both fail:
# btrfs-debug-tree /dev/sda2
...
Check tree block failed, want=39317532672, have=0
read block failed check_tree_block
btrfs-debug-tree: btrfs-debug-tree.c:237: main: Assertion `!(ret < 0)'  
failed.
Aborted

# btrfs chunk-recover -v /dev/sda2
...
Total Chunks:   31
   Heathy:       29
   Bad:  2
Orphan Block Groups:
   Block Group: start = 37710987264, len = 268435456, flag = 1
   Block Group: start = 37979422720, len = 230686720, flag = 1
   Block Group: start = 38210109440, len = 33554432, flag = 1
Orphan Device Extents:
   Device extent: devid = 1, start = 3527409664, len = 268435456, chunk  
offset = 37710987264
Check tree block failed, want=39317532672, have=0
read block failed check_tree_block
Couldn't setup extent tree
open with broken chunk error
Fail to recover the chunk tree.

------------ btrfs output end ------------



Cause btrfs-debug-tree & `btrfs chunk-recover` say there are still chunks,  
I have the hope most data is still intact, only btrfs & tools stumble on  
some invalid data. Is there any hope to e.g. force btrfs to clamp all data?

Thanks,
Christian Switaiski


PS: I already tried to patch btrfsprogs to not exit after the errors  
occurred (it helped with a problem in the past I had) but it just causes  
segfaults :/
Also I am bit confused that none of the btrfs progs show a 'beyond  
anything' msg like the kernel.




