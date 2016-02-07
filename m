Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60255 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbcBGN4Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Feb 2016 08:56:24 -0500
Subject: Re: Fi corruption on RAID1, generation doesn't match
To: a.t.hild@gmail.com, linux-btrfs@vger.kernel.org
References: <CAEm4ggmjK8oH7PcN_-Jf3M-j=8Yewh6j3G2F+zUviaajY1wgow@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56B74D01.9000008@gmx.com>
Date: Sun, 7 Feb 2016 21:56:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAEm4ggmjK8oH7PcN_-Jf3M-j=8Yewh6j3G2F+zUviaajY1wgow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/07/2016 09:15 PM, Andreas Hild wrote:
> Dear All,
>
> The file system on a RAID1 Debian server seems corrupted in a major
> way, with 99% of the files not found. This was the result of a
> precarious shutdown after a crash that was preceded by an accidental
> misconfiguration in /etc/fstab; it pointed "/" and "/tmp" to one and
> the same UUID by omitting a subvol entry.

So the data of the subvolume is just erased, in a proper manner.
>
> Is there any way to repair or recover a substantial part of this RAID?

As already mentioned by Lionel, the filesystem is not damaged, but just 
emptied.

There is still some chance to recovery to at most 4 transaction back, 
but I assume only the previous trans is possible.

First thing first, don't ever do *ANY* write to the filesystem.

Any write will just lead to at least new transaction, which will make 
the chance to recovery even smaller.

>
> The following output was obtained via a live disk boot.
>
>
> Many thanks!
>
> Best wishes,
> Andreas
>
>
> --- --- ---
> uname -a
> Linux debian 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u3
> (2016-01-17) x86_64 GNU/Linux
> --
>
> sudo btrfs fi show
> Label: none  uuid: fc429e82-f46e-4018-a9fa-ded688cef161
>          Total devices 2 FS bytes used 42.36MiB
>          devid    1 size 455.76GiB used 169.03GiB path /dev/sdb4
>          devid    2 size 455.76GiB used 169.03GiB path /dev/sda4
>
> Btrfs v3.17
>
> --
> sudo btrfs fi df /mnt
> Data, RAID1: total=168.00GiB, used=42.00MiB

You are wondering why data is still 168G, but that's the allocated data 
chunk size.

It means 168G space is allocated to store data, but only 42M is used.
Matches with your vanilla df output.

So it doesn't mean you data are still here.

> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=1.00GiB, used=320.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> --
>
> sudo btrfs subvol list /mnt/
> ID 257 gen 192248 top level 5 path home
> ID 258 gen 192228 top level 5 path usr
> ID 259 gen 192226 top level 5 path tmp
> ID 260 gen 192238 top level 5 path var
> --
>
> sudo btrfs-find-root /dev/sdb4
> Super think's the tree root is at 647630274560, chunk root 647596376064
> Well block 647629897728 seems great, but generation doesn't match,
> have=192251, want=192253 level 1
> Well block 647630012416 seems great, but generation doesn't match,
> have=192251, want=192253 level 0
> Well block 647630028800 seems great, but generation doesn't match,
> have=192252, want=192253 level 1
> Well block 647630110720 seems great, but generation doesn't match,
> have=192249, want=192253 level 0
> Well block 647630143488 seems great, but generation doesn't match,
> have=192252, want=192253 level 0
> Well block 647630159872 seems great, but generation doesn't match,
> have=192252, want=192253 level 0
> Well block 647630176256 seems great, but generation doesn't match,
> have=192252, want=192253 level 0
> Well block 647630192640 seems great, but generation doesn't match,
> have=192252, want=192253 level 0
> Well block 647630258176 seems great, but generation doesn't match,
> have=192252, want=192253 level 0
> Found tree root at 647630274560 gen 192253 level 1

Remember the generation 192253, which will be used later, if you didn't 
increased it by do any write into the filesystem.

> --
>
> sudo btrfs check /dev/sdb4
> Checking filesystem on /dev/sdb4
> UUID: fc429e82-f46e-4018-a9fa-ded688cef161
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 12173435 bytes used err is 0
> total csum bytes: 0
> total tree bytes: 376832
> total fs tree bytes: 98304
> total extent tree bytes: 49152
> btree space waste bytes: 229409
> file data blocks allocated: 44040192
>   referenced 44040192
> --
>
> sudo btrfs-debug-tree -R /dev/sdb4
> root tree: 647630274560 level 1
> chunk tree: 647596376064 level 1
> extent tree key (EXTENT_TREE ROOT_ITEM 0) 647630307328 level 1
> device tree key (DEV_TREE ROOT_ITEM 0) 647630094336 level 1
> fs tree key (FS_TREE ROOT_ITEM 0) 647730692096 level 0
> checksum tree key (CSUM_TREE ROOT_ITEM 0) 647630422016 level 0
> uuid tree key (UUID_TREE ROOT_ITEM 0) 647641219072 level 0
> file tree key (257 ROOT_ITEM 0) 647629996032 level 0
> file tree key (258 ROOT_ITEM 0) 647730413568 level 0
> file tree key (259 ROOT_ITEM 0) 648013332480 level 0
> file tree key (260 ROOT_ITEM 0) 647731609600 level 0
> data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 648438398976 level 0
> btrfs root backup slot 0
>          tree root gen 192252 block 647630028800
>                  extent root gen 192252 block 647630045184
>                  chunk root gen 191843 block 647596376064
>                  device root gen 192252 block 647630094336
>                  csum root gen 192252 block 647630225408
>                  fs root gen 192233 block 647730692096
>                  44417024 used 978736644096 total 2 devices

That's the previous transaction's tree root.
If you are in good luck, previous trans may has all your data.
But if you are in bad luck, it may already after the remove.

Normally, at least something should still be in previous trans.

Now use btrfsck to check if previous trans is in good shape.

# btrfsck --tree-root 647630028800

If btrfsck only reports minor problems, like space cache tree mismatch, 
then it means previous trans are almost OK.

Then let btrfsck to revert to previous trans:

# btrfsck --tree-root 647630028800 --repair

If you're really in good luck, then you can mount the fs and found 
something in it.

Thanks,
Qu

> btrfs root backup slot 1
>          tree root gen 192253 block 647630274560
>                  extent root gen 192253 block 647630307328
>                  chunk root gen 191843 block 647596376064
>                  device root gen 192252 block 647630094336
>                  csum root gen 192253 block 647630422016
>                  fs root gen 192233 block 647730692096
>                  44417024 used 978736644096 total 2 devices
> btrfs root backup slot 2
>          tree root gen 192244 block 647731642368
>                  extent root gen 192244 block 647731691520
>                  chunk root gen 191843 block 647596376064
>                  device root gen 192244 block 647731724288
>                  csum root gen 192244 block 647731789824
>                  fs root gen 192233 block 647730692096
>                  44695552 used 978736644096 total 2 devices
> btrfs root backup slot 3
>          tree root gen 192245 block 647737933824
>                  extent root gen 192245 block 647737950208
>                  chunk root gen 191843 block 647596376064
>                  device root gen 192244 block 647731724288
>                  csum root gen 192245 block 647738081280
>                  fs root gen 192233 block 647730692096
>                  44695552 used 978736644096 total 2 devices
> total bytes 978736644096
> bytes used 44417024
> uuid fc429e82-f46e-4018-a9fa-ded688cef161
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
