Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42316 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967396AbeEXPH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 11:07:57 -0400
From: Chris Mason <clm@fb.com>
To: robbieko <robbieko@synology.com>
CC: Christoph Hellwig <hch@infradead.org>, <linux-btrfs@vger.kernel.org>,
        <linux-btrfs-owner@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: implement unlocked buffered write
Date: Thu, 24 May 2018 11:05:55 -0400
Message-ID: <3DB5CC2A-415A-43E1-B339-2AD6FD7420F7@fb.com>
In-Reply-To: <7b0a74b32bb7d0e5ea0f9dbf0b764101@synology.com>
References: <1526442757-7167-1-git-send-email-robbieko@synology.com>
 <20180522180828.GA8340@infradead.org>
 <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
 <7ceaa6253162b32bf23e57e1763647de@synology.com>
 <B0E81709-76C1-45C1-AC3E-C52072A9FE15@fb.com>
 <7b0a74b32bb7d0e5ea0f9dbf0b764101@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 May 2018, at 4:46, robbieko wrote:

> Chris Mason 於 2018-05-23 23:56 寫到:
>> On 23 May 2018, at 3:26, robbieko wrote:
>>>>
>>>> But we're not avoiding the inode lock completely, we're just 
>>>> dropping
>>>> it for the expensive parts of writing to the file.  A quick guess
>>>> about what the expensive parts are:
>>>>
>>>> 1) balance_dirty_pages()
>>>> 2) btrfs_btree_balance_dirty()
>>>> 3) metadata reservations/enospc waiting.
>>>>
>>>
>>> The expensive part of buffered_write are:
>>> 1. prepare_pages()
>>>     --wait_on_page_writeback()
>>>     Because writeback submit page to PG_writeback.
>>>     We must wait until the page writeback IO ends.
>>
>> Is this based on timing the fio job or something else?  We can 
>> trigger
>> a stable page prep run before we take the mutex, but stable pages
>> shouldn't be part of random IO workloads unless we're doing random IO
>> inside a file that mostly fits in ram.
>>
>
> This problem is easily encountered in the context of VMs and 
> File-based iSCSI LUNs.
> Most of them are random write pattern.
> Fio can quickly simulate the problem.

With really random IO, to a device bigger than memory, the chances of us 
writing to the same block twice with it still in flight are pretty 
small.  With VMs and other virtual block devices backed by btrfs, it's 
easier to hit stable pages because filesystems try pretty hard to be 
less than completely random.

>
> So which is the best way?
> 1. unlocked buffered write (like direct-io)
> 2. stable page prep
> 3. Or is there any way to completely avoid stable pages?
>
>> balance_dirty_pages() is a much more common waiting point, and doing
>> that with the inode lock held definitely adds contention.
>
> Yes. I agree.
> But for latency, balance_dirty_pages is usually a relatively smooth 
> latency,
> lock_and_cleanup_extent_if_need and prepare_pages are dependent on IO,
> so the latency is a multiple of growth.

I think the best way is to peel out a stable page write wait before the 
inode lock is taken, and only when the write is inside i_size.  We'll 
need to keep the existing stable page wait as well, but waiting before 
the inode lock is taken should handle the vast majority of IO in flight.

I'd also push the balance_dirty_pages() outside the inode lock, as long 
as the write is relatively small.

For really getting rid of stable pages, that's a bigger project ;)

-chris
