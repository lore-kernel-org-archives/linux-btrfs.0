Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:44634 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbeBWBMP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 20:12:15 -0500
Subject: Re: [RFC] btrfs: Speedup btrfs_read_block_groups()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
References: <20180222045215.16426-1-wqu@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <a4ee5d23-93c5-bf12-cb24-dd903d6f77f9@applied-asynchrony.com>
Date: Fri, 23 Feb 2018 02:12:03 +0100
MIME-Version: 1.0
In-Reply-To: <20180222045215.16426-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/22/18 05:52, Qu Wenruo wrote:
> btrfs_read_block_groups() is used to build up the block group cache for
> all block groups, so it will iterate all block group items in extent
> tree.
> 
> For large filesystem (TB level), it will search for BLOCK_GROUP_ITEM
> thousands times, which is the most time consuming part of mounting
> btrfs.
> 
> So this patch will try to speed it up by:
> 
> 1) Avoid unnecessary readahead
>    We were using READA_FORWARD to search for block group item.
>    However block group items are in fact scattered across quite a lot of
>    leaves. Doing readahead will just waste our IO (especially important
>    for HDD).
> 
>    In real world case, for a filesystem with 3T used space, it would
>    have about 50K extent tree leaves, but only have 3K block group
>    items. Meaning we need to iterate 16 leaves to meet one block group
>    on average.
> 
>    So readahead won't help but waste slow HDD seeks.
> 
> 2) Use chunk mapping to locate block group items
>    Since one block group item always has one corresponding chunk item,
>    we could use chunk mapping to get the block group item size.
> 
>    With block group item size, we can do a pinpoint tree search, instead
>    of searching with some uncertain value and do forward search.
> 
>    In some case, like next BLOCK_GROUP_ITEM is in the next leaf of
>    current path, we could save such unnecessary tree block read.
> 
> Cc: Ellis H. Wilson III <ellisw@panasas.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Since all my TB level storage is all occupied by my NAS, any feedback
> (especially for the real world mount speed change) is welcome.

(sorry for the previous mail without results..finger salad)

Decided to give this a try & got some nice results!
Probably not on the same scale & nonlinear behaviour as Ellis will
provide since I just don't have that much storage, but interesting
nevertheless.

$btrfs filesystem df /mnt/backup 
Data, single: total=1.10TiB, used=1.09TiB
System, DUP: total=32.00MiB, used=144.00KiB
Metadata, DUP: total=4.00GiB, used=2.23GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

$btrfs-debug-tree -t chunk /dev/sdc1 | grep CHUNK_ITEM | wc -l
1137

current kernel (4.14++ with most of blk-mq+BFQ from 4.16):
mount /mnt/backup  0.00s user 0.02s system 1% cpu 1.211 total
mount /mnt/backup  0.00s user 0.02s system 2% cpu 1.122 total
mount /mnt/backup  0.00s user 0.02s system 2% cpu 1.236 total

patched:
mount /mnt/backup  0.00s user 0.02s system 1% cpu 1.070 total
mount /mnt/backup  0.00s user 0.02s system 1% cpu 1.056 total
mount /mnt/backup  0.00s user 0.02s system 1% cpu 1.058 total

That's not overwhelming, but still measurable and nice to have!

While I was at it I decided to fill up the drive to almost-max
~3.7TB and see how much slower it woulöd get...you won't believe
what happened next. :-)

$btrfs-debug-tree -t chunk /dev/sdc1 | grep CHUNK_ITEM | wc -l
3719

mount /mnt/backup  0.00s user 0.02s system 2% cpu 1.328 total
mount /mnt/backup  0.00s user 0.03s system 2% cpu 1.361 total
mount /mnt/backup  0.00s user 0.03s system 2% cpu 1.368 total

Over three times the data, almost the same mount time as before?
Yes please!

Overall this looks like a really nice improvement. Glad to see
that my suspicion about the (non)usefulness of the readhead turned
out to be true. :)

cheers,
Holger
