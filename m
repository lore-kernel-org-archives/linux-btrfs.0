From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] can not allocate space for caching data
Date: Mon, 20 Dec 2010 07:44:06 -0500
Message-ID: <1292848998-sup-5155@think>
References: <4D0F4B26.7030406@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D0F4B26.7030406@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2010-12-20 07:25:10 -0500:
> Hi, Chris
> 
> There is something wrong with this patch:
> 
> commit 83a50de97fe96aca82389e061862ed760ece2283
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Mon Dec 13 15:06:46 2010 -0500
> 
>     Btrfs: prevent RAID level downgrades when space is low
>     
>     The extent allocator has code that allows us to fill
>     allocations from any available block group, even if it doesn't
>     match the raid level we've requested.
>     
>     This was put in because adding a new drive to a filesystem
>     made with the default mkfs options actually upgrades the metadata from
>     single spindle dup to full RAID1.
>     
>     But, the code also allows us to allocate from a raid0 chunk when we
>     really want a raid1 or raid10 chunk.  This can cause big trouble because
>     mkfs creates a small (4MB) raid0 chunk for data and metadata which then
>     goes unused for raid1/raid10 installs.
>     
>     The allocator will happily wander in and allocate from that chunk when
>     things get tight, which is not correct.
>     
>     The fix here is to make sure that we provide duplication when the
>     caller has asked for it.  It does all the dups to be any raid level,
>     which preserves the dup->raid1 upgrade abilities.
>     
>     Signed-off-by: Chris Mason <chris.mason@oracle.com>
> 
> Btrfs has added the space of single chunks and raid0 chunks into the space
> information, so when we use btrfs_check_data_free_space() to check if there
> is some space for storing file data, this function may return true. So we
> write the data into the cache successfully. But, the extent allocator can
> not allocate any space to store that cached data, and then the file system
> panic.
> 
> I think we subtract that space from the space information, or split the space
> information into two types, one is used to manage the chunks with duplication,
> the other manages the other chunks.

Ok, do you have a test case that triggers this?  I'll work out a patch.
Yan Zheng's original idea of 'the chunks should be readonly' should help
us deduct them from the total.

-chris
