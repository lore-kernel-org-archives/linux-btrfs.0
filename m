Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.sr71.net ([198.145.64.142]:38193 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbcCQQgs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 12:36:48 -0400
Subject: Re: qgroup code slowing down rebalance
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
References: <56E9C7BB.7060509@sr71.net> <56EA0A0F.8070008@cn.fujitsu.com>
From: Dave Hansen <dave@sr71.net>
Message-ID: <56EADD1E.3040202@sr71.net>
Date: Thu, 17 Mar 2016 09:36:46 -0700
MIME-Version: 1.0
In-Reply-To: <56EA0A0F.8070008@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/16/2016 06:36 PM, Qu Wenruo wrote:
> Dave Hansen wrote on 2016/03/16 13:53 -0700:
>> I have a medium-sized multi-device btrfs filesystem (4 disks, 16TB
>> total) running under 4.5.0-rc5.  I recently added a disk and needed to
>> rebalance.  I started a rebalance operation three days ago.  It was on
>> the order of 20% done after those three days. :)
...
> Perf record profile will help a lot.
> Please upload it if it's OK for you.

I'll send it privately.

But, I do see basically the same behavior when balancing data and
metadata.  I profiled both.

> Also, the following data would help a lot:
> 1) btrfs fi df output
>    To determine the metadata/data ratio
>    Balancing metadata should be quite slow.

Data, RAID1: total=4.53TiB, used=4.53TiB
System, RAID1: total=32.00MiB, used=720.00KiB
Metadata, RAID1: total=17.00GiB, used=15.77GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


> 2) btrfs subvolume list output
>    To determine how many tree blocks are shared against each other
>    More shared tree blocks, slower quota routing is.
> 
>    Feel free to mask the output to avoid information leaking.

Here you go (pasted at the end).  You can pretty clearly see that I'm
using this volume for incremental backups.  My plan was to keep the old
snapshots around until the filesystem fills up.

> 3) perf record for balancing metadata and data respectively
>    Although this is optional. Just to prove some assumption.
> 
> btrfs_find_all_roots() is quite a slow operation, and in its worst case
> (tree blocks are shared by a lot of trees) it may be near O(2^n).

Yikes! But, that does look to be consistent with what I'm seeing.

>> ID 15183 gen 207620 top level 5 path blackbird_backups.enc
>> ID 15547 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455779116
>> ID 15548 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455779185
>> ID 15559 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455814382
>> ID 15560 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455814540
>> ID 15561 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455814739
>> ID 15562 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455814783
>> ID 15563 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455815180
>> ID 15564 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455815259
>> ID 15565 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455815314
>> ID 15566 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455815948
>> ID 15567 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816104
>> ID 15568 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816127
>> ID 15569 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816213
>> ID 15570 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816305
>> ID 15571 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816591
>> ID 15572 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816622
>> ID 15573 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816632
>> ID 15574 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816638
>> ID 15575 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1455816837
>> ID 15576 gen 207620 top level 5 path home-backup-on-btrfs.enc
>> ID 16634 gen 207620 top level 5 path homes-backup-nimitz-o2.enc
>> ID 17389 gen 207620 top level 5 path snapshots/root/1456271568
>> ID 17390 gen 207620 top level 5 path snapshots/root/1456272221
>> ID 17391 gen 207620 top level 5 path snapshots/root/1456416369
>> ID 17392 gen 207620 top level 5 path snapshots/root/1456435609
>> ID 17393 gen 207620 top level 5 path snapshots/root/1456539873
>> ID 17394 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1456553298
>> ID 17395 gen 207620 top level 5 path snapshots/root/1456553448
>> ID 17396 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456553460
>> ID 17397 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456553461
>> ID 17398 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456602362
>> ID 17399 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456602405
>> ID 17400 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1456602405
>> ID 17401 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456628682
>> ID 17402 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1456628682
>> ID 17403 gen 207620 top level 5 path snapshots/root/1456628682
>> ID 17404 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456675846
>> ID 17405 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1456675846
>> ID 17406 gen 207620 top level 5 path snapshots/root/1456675846
>> ID 17407 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456713915
>> ID 17408 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456720748
>> ID 17409 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456722793
>> ID 17410 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456722812
>> ID 17411 gen 207620 top level 5 path snapshots/root/1456722812
>> ID 17412 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1456722812
>> ID 17413 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456731271
>> ID 17414 gen 207620 top level 5 path snapshots/root/1456731271
>> ID 17415 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1456731271
>> ID 17416 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1456838946
>> ID 17417 gen 207620 top level 5 path snapshots/root/1456838946
>> ID 17418 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1456838946
>> ID 17419 gen 207620 top level 5 path snapshots/root/1457127404
>> ID 17420 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1457127404
>> ID 17421 gen 207620 top level 5 path snapshots/home-backup-on-btrfs.enc/1457127404
>> ID 17422 gen 207620 top level 5 path snapshots/root/1457138948
>> ID 17423 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1457138948
>> ID 17425 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1457451483
>> ID 17426 gen 207620 top level 5 path snapshots/blackbird_backups.enc/1457808380



