Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46790 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756594AbcKDCKs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Nov 2016 22:10:48 -0400
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f5a26f3c-2519-93b9-841f-4e16438bf458@cn.fujitsu.com>
Date: Fri, 4 Nov 2016 10:10:38 +0800
MIME-Version: 1.0
In-Reply-To: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/25/2016 08:21 PM, Goffredo Baroncelli wrote:
> Hi all,
>
> following the thread "Adventures in btrfs raid5 disk recovery", I investigated a bit the BTRFS capability to scrub a corrupted raid5 filesystem. To test it, I first find where a file was stored, and then I tried to corrupt the data disks (when unmounted) or the parity disk.
> The result showed that sometime the kernel recomputed the parity wrongly.
>
> I tested the following kernel
> - 4.6.1
> - 4.5.4
> and both showed the same behavior.
>
> The test was performed as described below:
>
> 1) create a filesystem in raid5 mode (for data and metadata) of 1500MB
>
> 	truncate -s 500M disk1.img; losetup -f disk1.img
> 	truncate -s 500M disk2.img; losetup -f disk2.img
> 	truncate -s 500M disk3.img; losetup -f disk3.img
> 	sudo mkfs.btrfs -d raid5 -m raid5 /dev/loop[0-2]
> 	sudo mount /dev/loop0 mnt/
>
> 2) I created a file with a length of 128kb:
>
> 	python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt
> 	sudo umount mnt/
>
> 3) I looked at the output of 'btrfs-debug-tree /dev/loop0' and I was able to find where the file stripe is located:
>
> /dev/loop0: offset=81788928+16*4096        (64k, second half of the file: 'bdbbbb.....)
> /dev/loop1: offset=61865984+16*4096        (64k, first half of the file: 'adaaaa.....)
> /dev/loop2: offset=61865984+16*4096        (64k, parity: '\x03\x00\x03\x03\x03.....)
>
> 4) I tried to corrupt each disk (one disk per test), and then run a scrub:
>
> for example for the disk /dev/loop2:
> 	sudo dd if=/dev/zero of=/dev/loop2 bs=1 \
>         	        seek=$((61865984+16*4096)) count=5
> 	sudo mount /dev/loop0 mnt
> 	sudo btrfs scrub start mnt/.

I reproduced your problem and find that seems to be a problem of race.

The problem I found is mostly the same as yours, but with some more details:

The script is like:
-------
#!/bin/bash

dev1=/dev/vdb6
dev2=/dev/vdb7
dev3=/dev/vdb8
mnt=/mnt/test

umount $mnt
# First full stripe layout is
# dev1: Parity, dev2: Data Stripe1 dev3: Data Stripe2
mkfs.btrfs $dev1 $dev2 $dev3 -f -m raid5 -d raid5
mount $dev1 $mnt -o nospace_cache
xfs_io -f -c "pwrite 0 128k" $mnt/file1
sync
umount $mnt

dmesg -C
# destory parity of data stripe 1
dd if=/dev/urandom of=$dev2 bs=1 count=64k seek=546308096


# btrfs-progs scrub
# Newly introduced function, offline scrub, quite handy here
btrfs check --scrub $dev1

# kernel scrub
mount $dev1 $mnt -o nospace_cache
btrfs scrub start -B $mnt

# Feel free to umount and call offline scrub
# umount $mnt
# btrfs check --scrub $dev1
-------

The result is divided into the following types:

1) Kernel scrub reports 16 recoverable csum error
    Same as offline scrub. All correct.

2) Kernel scrub reports 17 or more recoverable csum error
    Even we only corrupted 16 pages, the extra csum error comes out
    almost no where

3) Kernel scrub reports some unrecoverable csum error
    Totally insane. But quite low possibility.

I digged a little further into the case 2) and found:
a) Kernel is scrubbing correct range
    So the extra csum error is not caused by checking wrong logical
    bytenr range

b) Kernel is scrubbing some pages twice
    That's the cause of the problem.


And unlike most of us assume, in fact scrub full fs is a very racy thing.
Scrubbing full fs is split into N scrubbing ioctls for each device.

So for above script, kernel is doing *3* scrubbing work.
For other profile it may not be a problem, but for RAID5/6 race can 
happen easily like:

Scrub dev1(P)           |  Scrub dev2(D1)        | Scrub dev3(D2)
---------------------------------------------------------------
Read out full stripe    | Read out D1            | Read out D2
                         | Check Csum for D1      | Check Csum for D2
                         | Csum mismatch (err++)  | Csum matches
Cal parity              | Read out full stripe   |
Parity mismatch         | Do recovery            |
Check full stripe       |
D1 csum mismatch (err++)|

So csum mismatch can be counted twice.

And since scrubbing for corrupted data stripe can easily race with 
scrubbing for parity, if timing happens in a worse situation, it can 
lead to unrecoverable csum error.

On the other hand, if you only scrub the damaged device only, no race 
will happen so case 2) 3) will just disappear.

Would you please try to only scrub one device one time?

>
> 5) I check the disks at the offsets above, to verify that the data/parity is correct

You could try the new offline scrub, it can save you a lot of time to 
find data/parity corruption.
https://github.com/adam900710/btrfs-progs/tree/fsck_scrub

And of course, more reliable than kernel scrub (single thread, no extra 
IO no race) :)

Thanks,
Qu

>
> However I found that:
> 1) if I corrupt the parity disk (/dev/loop2), scrub don't find any corruption, but recomputed the parity (always correctly);
>
> 2) when I corrupted the other disks (/dev/loop[01]) btrfs was able to find the corruption. But I found two main behaviors:
>
> 2.a) the kernel repaired the damage, but compute the wrong parity. Where it was the parity, the kernel copied the data of the second disk on the parity disk
>
> 2.b) the kernel repaired the damage, and rebuild a correct parity
>
> I have to point out another strange thing: in dmesg I found two kinds of messages:
>
> msg1)
> 	[....]
> 	[ 1021.366944] BTRFS info (device loop2): disk space caching is enabled
> 	[ 1021.366949] BTRFS: has skinny extents
> 	[ 1021.399208] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872, root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
> 	[ 1021.399214] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> 	[ 1021.399291] BTRFS error (device loop2): fixed up error at logical 142802944 on dev /dev/loop0
>
> msg2)
> 	[ 1017.435068] BTRFS info (device loop2): disk space caching is enabled
> 	[ 1017.435074] BTRFS: has skinny extents
> 	[ 1017.436778] BTRFS info (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> 	[ 1017.463403] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872, 	root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
> 	[ 1017.463409] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
> 	[ 1017.463467] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872, root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
> 	[ 1017.463472] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
> 	[ 1017.463512] BTRFS error (device loop2): unable to fixup (regular) error at logical 142802944 on dev /dev/loop0
> 	[ 1017.463535] BTRFS error (device loop2): fixed up error at logical 142802944 on dev /dev/loop0
>
>
> but these seem to be UNrelated to the kernel behavior 2.a) or 2.b)
>
> Another strangeness is that SCRUB sometime reports
>  ERROR: there are uncorrectable errors
> and sometime reports
>  WARNING: errors detected during scrubbing, corrected
>
> but also these seems UNrelated to the behavior 2.a) or 2.b) or msg1 or msg2
>
>
> Enclosed you can find the script which I used to trigger the bug. I have to rerun it several times to show the problem because it doesn't happen every time. Pay attention that the offset and the loop device name are hard coded. You must run the script in the same directory where it is: eg "bash test.sh".
>
> Br
> G.Baroncelli
>
>
>
>


