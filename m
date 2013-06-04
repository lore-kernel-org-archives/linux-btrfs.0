Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53949 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FDCpv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 22:45:51 -0400
Received: by mail-pd0-f171.google.com with SMTP id z11so6548422pdj.30
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jun 2013 19:45:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMROUjkcZGC-OwkPdJvyx6KknpAeEA0jp3bkh=GF8zpS2mb9g@mail.gmail.com>
References: <CAOMROUjkcZGC-OwkPdJvyx6KknpAeEA0jp3bkh=GF8zpS2mb9g@mail.gmail.com>
Date: Mon, 3 Jun 2013 21:45:50 -0500
Message-ID: <CAOMROUhn0-B2nH-4TvqLiLE7vV4fzJFz3UV2VbHbfo+fHsQMaQ@mail.gmail.com>
Subject: Re: csum failed during rebalance
From: John Haller <john.h.haller@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 2, 2013 at 9:05 PM, John Haller <john.h.haller@gmail.com> wrote:
> Hi,
>
> I added a new drive to an existing RAID 0 array. Every
> attempt to rebalance the array fails:
> # btrfs filesystem balance /share/bd8

> btrfs csum failed ino 365 off 221745152 csum 3391451932 private 3121065028
> btrfs csum failed ino 365 off 221745152 csum 3391451932 private 3121065028
>
> An earlier rebalance attempt had the same csum error on a different inode:
> btrfs csum failed ino 312 off 221745152 csum 3391451932 private 3121065028
> btrfs csum failed ino 312 off 221745152 csum 3391451932 private 3121065028
>
> Every rebalance attempt fails the same way, but with a different inum.
>

Final scrub results:
btrfs: checksum error at logical 9524548104192 on dev /dev/sdc, sector
5252042552, root 5, inode 6754, offset 14188032000, length 4096, links
1 (path: bd6/...)
btrfs: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
btrfs: unable to fixup (regular) error at logical 9524548104192 on dev /dev/sdc
btrfs: checksum error at logical 9531724152832 on dev /dev/sdc, sector
5266058272, root 5, inode 6755, offset 1801699328, length 4096, links
1 (path: bd6/...)
btrfs: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
btrfs: unable to fixup (regular) error at logical 9531724152832 on dev /dev/sdc
btrfs: checksum error at logical 9628551053312 on dev /dev/sdc, sector
5455173312, root 5, inode 6757, offset 10686889984, length 4096, links
1 (path: bd6/...)
btrfs: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
btrfs: unable to fixup (regular) error at logical 9628551053312 on dev /dev/sdc
btrfs: checksum error at logical 9645596147712 on dev /dev/sdc, sector
5488464512, root 5, inode 6757, offset 22100770816, length 4096, links
1 (path: bd6/...)
btrfs: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
btrfs: unable to fixup (regular) error at logical 9645596147712 on dev /dev/sdc
btrfs: checksum error at logical 9662878707712 on dev /dev/sdc, sector
5522219512, root 5, inode 6758, offset 1697771520, length 4096, links
1 (path: bd6/...)
btrfs: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
btrfs: unable to fixup (regular) error at logical 9662878707712 on dev /dev/sdc
btrfs: checksum error at logical 9967720464384 on dev /dev/sdc, sector
6117613568, root 5, inode 6767, offset 19135102976, length 4096, links
1 (path: bd6/...)
btrfs: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
btrfs: unable to fixup (regular) error at logical 9967720464384 on dev /dev/sdc
btrfs: checksum error at logical 10048360648704 on dev /dev/sdc,
sector 6275113928, root 5, inode 6771, offset 4187852800, length 4096,
links 1 (path: bd6/...)
btrfs: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
btrfs: unable to fixup (regular) error at logical 10048360648704 on dev /dev/sdc
btrfs: checksum error at logical 6748601905152 on dev /dev/sdb, sector
6199388792, root 5, inode 6782, offset 7338291200, length 4096, links
1 (path: bd6/...)
btrfs: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 1, gen 0


reading one of the files yields the following in dmesg:
btrfs csum failed ino 6782 off 7338291200 csum 444044750 private 1783974550

But, none of these reflect the inodes of the original csum failure.

So, what's causing the problem at offset 221745152 that didn't show up
in the scrub, but's associated with multiple inodes?

John
