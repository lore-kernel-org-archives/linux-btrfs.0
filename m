Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52250 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaAMXPY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 18:15:24 -0500
Received: by mail-pb0-f51.google.com with SMTP id rp16so1655910pbb.38
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 15:15:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFP7zVthUK54N5-8+QRABBpz2R9-mAbJGjiOc6Ty3nVS4O-EDA@mail.gmail.com>
References: <CAFP7zVthUK54N5-8+QRABBpz2R9-mAbJGjiOc6Ty3nVS4O-EDA@mail.gmail.com>
Date: Tue, 14 Jan 2014 00:15:23 +0100
Message-ID: <CAFP7zVuzBRD17APtz=GgMX4rAnFw=fiPTb1Z3L=KC0EAx+qUHw@mail.gmail.com>
Subject: Re: btrfsck failes
From: Holger Brandsmeier <brandsmeier@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh and if I do
mount -o recovery /dev/sda5 /some/path/

then I get the following in dmesg:

[ 1449.171259] btrfs: device fsid f6907d81-f46f-4911-8600-858e8b6bd1a0
devid 1 transid 23462 /dev/sda5
[ 1449.171635] btrfs: enabling auto recovery
[ 1449.171638] btrfs: disk space caching is enabled
[ 1451.848339] btrfs: space cache generation (23463) does not match
inode (23461)
[ 1451.848360] BTRFS error (device sda5): failed to load free space
cache for block group 1103101952
[ 1451.959865] parent transid verify failed on 601710592 wanted 23460
found 23463
[ 1451.969678] parent transid verify failed on 601710592 wanted 23460
found 23463
[ 1452.461075] btrfs: space cache generation (23463) does not match
inode (23461)
[ 1452.461094] BTRFS error (device sda5): failed to load free space
cache for block group 2176843776
[ 1456.915205] parent transid verify failed on 603377664 wanted 23460
found 23463
[ 1456.925074] parent transid verify failed on 603377664 wanted 23460
found 23463
[ 1456.925827] BTRFS error (device sda5) in open_ctree:2847: errno=-5
IO failure (Failed to recover log tree)
[ 1456.971476] btrfs: open_ctree failed


On Mon, Jan 13, 2014 at 11:58 PM, Holger Brandsmeier
<brandsmeier@gmail.com> wrote:
> Dear BTRFS developers,
>
> thanks for providing a filesystem with which I am happy so far!
>
> Currently btrfsck failes to repair my partition, I get the output:
>
> [root@ho-think bholger]# btrfsck --repair /dev/sda5
> [...]
> leaf parent key incorrect 600846336
> parent transid verify failed on 600846336 wanted 23460 found 23463
> Ignoring transid failure
> leaf parent key incorrect 600846336
> bad block 600395776
> bad block 600518656
> bad block 600547328
> leaf parent key incorrect 600846336
> bad block 600846336
> bad block 601710592
> bad block 603197440
> Ignoring transid failure
> parent transid verify failed on 601710592 wanted 23460 found 23463
> Ignoring transid failure
> parent transid verify failed on 602529792 wanted 23460 found 23463
> Ignoring transid failure
> btrfsck: disk-io.c:155: readahead_tree_block: Assertion `!(ret)' failed.
> Aborted (core dumped)
>
>
> From dmesg I get the additional information:
>
> [  629.447677] btrfs: device fsid f6907d81-f46f-4911-8600-858e8b6bd1a0
> devid 1 transid 23462 /dev/sda5
> [  629.671835] systemd-journald[182]: Vacuuming done, freed 0 bytes
> [  629.843055] systemd-journald[182]: Failed to write entry (26 items,
> 416256620 bytes) despite vacuuming, ignoring: Argument list too long
>
> I am running Arch linux with btrfs-progs-3.12-1 and
> [root@ho-think bholger]# uname -r
> 3.12.7-2-ARCH
>
> The filesystem got some problems today while being mounted, it got
> mounted read-only due to an error, but I still had access to my data.
> I had to unmount it to run btrfsck, but because it fails to repair my
> disk, I cannot mount it any more.
>
> Any advice?
> Holger
