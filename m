Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61670 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932862AbcIUH2f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 03:28:35 -0400
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
Date: Wed, 21 Sep 2016 15:28:25 +0800
MIME-Version: 1.0
In-Reply-To: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

For this well-known bug, is there any one fixing it?

It can't be more frustrating finding some one has already worked on it 
after spending days digging.

BTW, since kernel scrub is somewhat scrap for raid5/6, I'd like to 
implement btrfsck scrub support, at least we can use btrfsck to fix bad 
stripes before kernel fix.

Thanks,
Qu

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
>
> 5) I check the disks at the offsets above, to verify that the data/parity is correct
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


