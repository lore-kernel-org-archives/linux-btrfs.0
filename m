Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47890 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732592AbeGJSot (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 14:44:49 -0400
Date: Tue, 10 Jul 2018 11:09:15 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: Su Yue <Damenly_Su@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <20180710180915.onnxuak7vb7uywyn@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: btrfs check lowmem, take 2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks to Su and Qu, I was able to get my filesystem to a point that
it's mountable.
I then deleted loads of snapshots and I'm down to 26.

IT now looks like this:
gargamel:~# btrfs fi show /mnt/mnt
Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
	Total devices 1 FS bytes used 12.30TiB
	devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2

gargamel:~# btrfs fi df /mnt/mnt
Data, single: total=13.57TiB, used=12.19TiB
System, DUP: total=32.00MiB, used=1.55MiB
Metadata, DUP: total=124.50GiB, used=115.62GiB
Metadata, single: total=216.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B


Problems
1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
server, despite my deleting lots of snapshots.
Is it because I have too many files then?

2) I tried Su's master git branch for btrfs-progs to try and see how a
normal check would go, and I'm stuck on this:
gargamel:/var/local/src/btrfs-progs.sy# time ./btrfsck --mode=lowmem --repair /dev/mapper/dshelf2
enabling repair mode
WARNING: low-memory mode repair support is only partial
Checking filesystem on /dev/mapper/dshelf2
UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
root 18446744073709551607 has a root item with a more recent gen (143376) compared to the found root node (139061)
ERROR: failed to repair root items: Invalid argument

real	75m8.046s
user	0m14.591s
sys	0m52.431s

I understand what the message means, I just need to switch to the newer root
but honestly I'm not quite sure how to do this from the btrfs-check man page.

This didn't work:
time ./btrfsck --mode=lowmem --repair --chunk-root=18446744073709551607  /dev/mapper/dshelf2
enabling repair mode
WARNING: low-memory mode repair support is only partial
WARNING: chunk_root_bytenr 18446744073709551607 is unaligned to 4096, ignore it

How do I address the error above?

Thanks
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
