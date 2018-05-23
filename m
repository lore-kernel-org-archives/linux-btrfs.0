Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54968 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750880AbeEWP5w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 11:57:52 -0400
From: Chris Mason <clm@fb.com>
To: robbieko <robbieko@synology.com>
CC: Christoph Hellwig <hch@infradead.org>, <linux-btrfs@vger.kernel.org>,
        <linux-btrfs-owner@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: implement unlocked buffered write
Date: Wed, 23 May 2018 11:56:06 -0400
Message-ID: <B0E81709-76C1-45C1-AC3E-C52072A9FE15@fb.com>
In-Reply-To: <7ceaa6253162b32bf23e57e1763647de@synology.com>
References: <1526442757-7167-1-git-send-email-robbieko@synology.com>
 <20180522180828.GA8340@infradead.org>
 <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
 <7ceaa6253162b32bf23e57e1763647de@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23 May 2018, at 3:26, robbieko wrote:

> Chris Mason 於 2018-05-23 02:31 寫到:
>> On 22 May 2018, at 14:08, Christoph Hellwig wrote:
>>
>>> On Wed, May 16, 2018 at 11:52:37AM +0800, robbieko wrote:
>>>> From: Robbie Ko <robbieko@synology.com>
>>>>
>>>> This idea is from direct io. By this patch, we can make the 
>>>> buffered
>>>> write parallel, and improve the performance and latency. But 
>>>> because we
>>>> can not update isize without i_mutex, the unlocked buffered write 
>>>> just
>>>> can be done in front of the EOF.
>>>>
>>>> We needn't worry about the race between buffered write and 
>>>> truncate,
>>>> because the truncate need wait until all the buffered write end.
>>>>
>>>> And we also needn't worry about the race between dio write and 
>>>> punch hole,
>>>> because we have extent lock to protect our operation.
>>>>
>>>> I ran fio to test the performance of this feature.
>>>
>>> And what protects two writes from interleaving their results now?
>>
>> page locks...ish, we at least won't have results interleaved in a
>> single page.  For btrfs it'll actually be multiple pages since we try
>> to do more than one at a time.
>>
>> I haven't verified all the assumptions around truncate and fallocate
>> and friends expecting the dio special locking to be inside i_size.  
>> In
>> general this makes me a little uncomfortable.
>>
>> But we're not avoiding the inode lock completely, we're just dropping
>> it for the expensive parts of writing to the file.  A quick guess
>> about what the expensive parts are:
>>
>> 1) balance_dirty_pages()
>> 2) btrfs_btree_balance_dirty()
>> 3) metadata reservations/enospc waiting.
>>
>
> The expensive part of buffered_write are:
> 1. prepare_pages()
>     --wait_on_page_writeback()
>     Because writeback submit page to PG_writeback.
>     We must wait until the page writeback IO ends.

Is this based on timing the fio job or something else?  We can trigger a 
stable page prep run before we take the mutex, but stable pages 
shouldn't be part of random IO workloads unless we're doing random IO 
inside a file that mostly fits in ram.

balance_dirty_pages() is a much more common waiting point, and doing 
that with the inode lock held definitely adds contention.

>
> 2. lock_and_cleanup_extent_if_need
>     --btrfs_start_ordered_extent
>     When a large number of ordered_extent queue is in 
> endio_write_workers workqueue.
>     Buffered_write assumes that ordered_extent is the last one in the 
> endio_write_workers workqueue,
>     and waits for all ordered_extents to be processed before because 
> the workqueue is a FIFO.
>

This isn't completely accurate, but it falls into the stable pages 
bucket as well.  We can push a lighter version of the stable page wait 
before the inode lock when the IO is inside of i_size.  It won't 
completely remove the possibility that someone else dirties those pages 
again, but if the workload is random or really splitting up the file, 
it'll make the work done with the lock held much less.

-chris
