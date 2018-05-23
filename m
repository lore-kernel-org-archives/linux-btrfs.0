Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:36117 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932172AbeEWJe7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 05:34:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 23 May 2018 17:34:57 +0800
From: ethanlien <ethanlien@synology.com>
To: dsterba@suse.cz, Ethan Lien <ethanlien@synology.com>,
        linux-btrfs@vger.kernel.org
Cc: linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
In-Reply-To: <20180522162810.GV6649@twin.jikos.cz>
References: <20180427070524.12188-1-ethanlien@synology.com>
 <20180522162810.GV6649@twin.jikos.cz>
Message-ID: <3ff2e778293544c99b25b562a77a1c68@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba 於 2018-05-23 00:28 寫到:
> On Fri, Apr 27, 2018 at 03:05:24PM +0800, Ethan Lien wrote:
>> We should balance dirty metadata pages at the end of
>> btrfs_finish_ordered_io, since a small, unmergeable random write can
>> potentially produce dirty metadata which is multiple times larger than
>> the data itself. For example, a small, unmergeable 4KiB write may
>> produce:
>> 
>>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume tree
>>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
>>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
>> 
>> Although we do call balance dirty pages in write side, but in the
>> buffered write path, most metadata are dirtied only after we reach the
>> dirty background limit (which by far onlys counts dirty data pages) 
>> and
>> wakeup the flusher thread. If there are many small, unmergeable random
>> writes spread in a large btree, we'll find a burst of dirty pages
>> exceeds the dirty_bytes limit after we wakeup the flusher thread - 
>> which
>> is not what we expect. In our machine, it caused out-of-memory problem
>> since a page cannot be dropped if it is marked dirty.
>> 
>> Someone may worry about we may sleep in btrfs_btree_balance_dirty(), 
>> but
>> since we do btrfs_finish_ordered_io in a separate worker, it will not
>> stop the flusher consuming dirty pages. Also, we use different worker 
>> for
>> metadata writeback endio, sleep in btrfs_finish_ordered_io help us
>> throttle the size of dirty metadata pages.
> 
> The described scenario sounds interesting. Do you have some scripted
> steps to reproduce it?

It needs some time to reproduce the problem. In our case,
1. Create 4 subvolumes.
2. Run fio on each subvolume:

[global]
direct=0
rw=randwrite
ioengine=libaio
bs=4k
iodepth=16
numjobs=1
group_reporting
size=128G
runtime=1800
norandommap
time_based
randrepeat=0

3. Take snapshot on each subvolume and repeat fio on existing files.
4. Repeat step 2&3 until we get really big btrees.
In our case, by observing btrfs_root_item->bytes_used, we have 2GiB of
metadata in each subvolume tree and 12GiB of metadata in extent tree.
5. Stop all fio, take snapshot again, and wait until all delayed work is 
completed.
6. Start all fio. Few seconds later we hit OOM when the flusher starts 
to work.

It can be reproduced even when using nocow write.

> btrfs_btree_balance_dirty detects congestion and can skip the balancing
> eventually, so the case when it actually does something and waits is 
> the
> point where things can go bad. From the last paragraph, it is clear 
> that
> you have considered that, that's good.
> 
> Have you also considered calling __btrfs_btree_balance_dirty with
> flush_delayed=0 ? This would avoid the waiting and I'm not sure if it's
> really required here to get out of the situation.

Yes, btrfs_btree_balance_dirty_nodelay seems to be a better choice, I'll 
add it to the v2 patch, thanks.

> Anyway, I'll add the patch to for-next for more testing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

