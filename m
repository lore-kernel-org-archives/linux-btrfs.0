Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:41813 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754124AbeEWH0K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 03:26:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 23 May 2018 15:26:09 +0800
From: robbieko <robbieko@synology.com>
To: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] Btrfs: implement unlocked buffered write
In-Reply-To: <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
References: <1526442757-7167-1-git-send-email-robbieko@synology.com>
 <20180522180828.GA8340@infradead.org>
 <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
Message-ID: <7ceaa6253162b32bf23e57e1763647de@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason 於 2018-05-23 02:31 寫到:
> On 22 May 2018, at 14:08, Christoph Hellwig wrote:
> 
>> On Wed, May 16, 2018 at 11:52:37AM +0800, robbieko wrote:
>>> From: Robbie Ko <robbieko@synology.com>
>>> 
>>> This idea is from direct io. By this patch, we can make the buffered
>>> write parallel, and improve the performance and latency. But because 
>>> we
>>> can not update isize without i_mutex, the unlocked buffered write 
>>> just
>>> can be done in front of the EOF.
>>> 
>>> We needn't worry about the race between buffered write and truncate,
>>> because the truncate need wait until all the buffered write end.
>>> 
>>> And we also needn't worry about the race between dio write and punch 
>>> hole,
>>> because we have extent lock to protect our operation.
>>> 
>>> I ran fio to test the performance of this feature.
>> 
>> And what protects two writes from interleaving their results now?
> 
> page locks...ish, we at least won't have results interleaved in a
> single page.  For btrfs it'll actually be multiple pages since we try
> to do more than one at a time.
> 
> I haven't verified all the assumptions around truncate and fallocate
> and friends expecting the dio special locking to be inside i_size.  In
> general this makes me a little uncomfortable.
> 
> But we're not avoiding the inode lock completely, we're just dropping
> it for the expensive parts of writing to the file.  A quick guess
> about what the expensive parts are:
> 
> 1) balance_dirty_pages()
> 2) btrfs_btree_balance_dirty()
> 3) metadata reservations/enospc waiting.
> 

The expensive part of buffered_write are:
1. prepare_pages()
     --wait_on_page_writeback()
     Because writeback submit page to PG_writeback.
     We must wait until the page writeback IO ends.

2. lock_and_cleanup_extent_if_need
     --btrfs_start_ordered_extent
     When a large number of ordered_extent queue is in 
endio_write_workers workqueue.
     Buffered_write assumes that ordered_extent is the last one in the 
endio_write_workers workqueue,
     and waits for all ordered_extents to be processed before because the 
workqueue is a FIFO.

Thanks.
Robbie Ko

> Can I bribe you to benchmark how much each of those things is
> impacting the iops/latency benefits?
> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

