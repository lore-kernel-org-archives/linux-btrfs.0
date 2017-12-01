Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:44260 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdLARGZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 12:06:25 -0500
Subject: Re: btrfs-transacti hammering the system
To: Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
Date: Fri, 1 Dec 2017 18:06:23 +0100
MIME-Version: 1.0
In-Reply-To: <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2017 05:31 PM, Matt McKinnon wrote:
> Sorry, I missed your in-line reply:
> 
> 
>> 1) The one right above, btrfs_write_out_cache, is the write-out of the
>> free space cache v1. Do you see this for multiple seconds going on, and
>> does it match the time when it's writing X MB/s to disk?
>>
> 
> It seems to only last until the next watch update.
> 
> [<ffffffffaa0a8406>] io_schedule+0x16/0x40
> [<ffffffffaa3b3cde>] get_request+0x23e/0x720
> [<ffffffffaa3b6861>] blk_queue_bio+0xc1/0x3a0
> [<ffffffffaa3b4a88>] generic_make_request+0xf8/0x2a0
> [<ffffffffaa3b4ca5>] submit_bio+0x75/0x150
> [<ffffffffc087fac5>] btrfs_map_bio+0xe5/0x2f0 [btrfs]
> [<ffffffffc084834c>] btree_submit_bio_hook+0x8c/0xe0 [btrfs]
> [<ffffffffc086f1e3>] submit_one_bio+0x63/0xa0 [btrfs]
> [<ffffffffc086f39b>] flush_epd_write_bio+0x3b/0x50 [btrfs]
> [<ffffffffc086f3be>] flush_write_bio+0xe/0x10 [btrfs]
> [<ffffffffc08777a9>] btree_write_cache_pages+0x379/0x450 [btrfs]
> [<ffffffffc08478ed>] btree_writepages+0x5d/0x70 [btrfs]
> [<ffffffffaa1a326c>] do_writepages+0x1c/0x70
> [<ffffffffaa196f2a>] __filemap_fdatawrite_range+0xaa/0xe0
> [<ffffffffaa197023>] filemap_fdatawrite_range+0x13/0x20
> [<ffffffffc084fba9>] btrfs_write_marked_extents+0xe9/0x110 [btrfs]
> [<ffffffffc084fc4d>] btrfs_write_and_wait_transaction.isra.22+0x3d/0x80
> [btrfs]
> [<ffffffffc0851645>] btrfs_commit_transaction+0x665/0x900 [btrfs]
> [<ffffffffc084baca>] transaction_kthread+0x18a/0x1c0 [btrfs]
> [<ffffffffaa09b839>] kthread+0x109/0x140
> [<ffffffffaa8459f5>] ret_from_fork+0x25/0x30
> 
> The last three lines will stick around for a while.  Is switching to
> space cache v2 something that everyone should be doing?  Something that
> would be a good test at least?

Yes. Read on.

>> 2) How big is this filesystem? What does your `btrfs fi df
>> /mountpoint` say?
>>
> 
> # btrfs fi df /export/
> Data, single: total=30.45TiB, used=30.25TiB
> System, DUP: total=32.00MiB, used=3.62MiB
> Metadata, DUP: total=66.50GiB, used=65.08GiB
> GlobalReserve, single: total=512.00MiB, used=53.69MiB

Multi-TiB filesystem, check. total/used ratio looks healthy.

>> 3) What kind of workload are you running? E.g. how can you describe it
>> within a range from "big files which just sit there" to "small writes
>> and deletes all over the place all the time"?
> 
> It's a pretty light workload most of the time.  It's a file system that
> exports two NFS shares to a small lab group.  I believe it is more small
> reads all over a large file (MRI imaging) rather than small writes.

Ok.

>> 4) What kernel version is this? `uname -a` output?
> 
> # uname -a
> Linux machine_name 4.12.8-custom #1 SMP Tue Aug 22 10:15:01 EDT 2017
> x86_64 x86_64 x86_64 GNU/Linux
> 

Yes, I'd recommend switching to space_cache v2, which stores the free
space information in a tree instead of separate blobs, and does not
block the transaction while writing out all info of all touched parts of
the filesystem again.

Here's of course the famous presentation with all kinds of info why:

http://events.linuxfoundation.org/sites/events/files/slides/vault2016_0.pdf

How:

* umount the filesystem
* btrfsck --clear-space-cache v1 /block/device
* do a rw mount with the space_cache=v2 option added (only needed
explicitly once)

During that mount, it will generate the free space tree by reading the
extent tree and writing the inverse of it. This will take some time,
depending on how fast your storage can do random reads with a cold disk
cache.

For x86_64, using the free space cache v2 is fine since linux 4.5. Up to
4.9, there was a bug for big-endian systems. So, with your kernel it's
absolutely fine.

Why isn't this the default yet? It's because btrfs-progs don't have
support to update the free space tree when doing offline modifications
(like check --repair or btrfstune, which you hopefully don't need often
anyway). So, until that's fully added, you need to do an `btrfsck
--clear-space-cache v2`, then do the offline r/w action and then
generate the tree again on next mount.

Additional tips (forgot to ask for your /proc/mounts before):
* Use the noatime mount option, so that only accessing files does not
lead to changes in metadata, which lead to writes, which lead to cowing
and writes in a new place, which lead to updates of the free space
administration etc...

-- 
Hans van Kranenburg
