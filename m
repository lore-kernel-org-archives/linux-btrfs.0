Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36160 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751278AbeEVScQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 14:32:16 -0400
From: Chris Mason <clm@fb.com>
To: Christoph Hellwig <hch@infradead.org>
CC: robbieko <robbieko@synology.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: implement unlocked buffered write
Date: Tue, 22 May 2018 14:31:36 -0400
Message-ID: <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
In-Reply-To: <20180522180828.GA8340@infradead.org>
References: <1526442757-7167-1-git-send-email-robbieko@synology.com>
 <20180522180828.GA8340@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22 May 2018, at 14:08, Christoph Hellwig wrote:

> On Wed, May 16, 2018 at 11:52:37AM +0800, robbieko wrote:
>> From: Robbie Ko <robbieko@synology.com>
>>
>> This idea is from direct io. By this patch, we can make the buffered
>> write parallel, and improve the performance and latency. But because 
>> we
>> can not update isize without i_mutex, the unlocked buffered write 
>> just
>> can be done in front of the EOF.
>>
>> We needn't worry about the race between buffered write and truncate,
>> because the truncate need wait until all the buffered write end.
>>
>> And we also needn't worry about the race between dio write and punch 
>> hole,
>> because we have extent lock to protect our operation.
>>
>> I ran fio to test the performance of this feature.
>
> And what protects two writes from interleaving their results now?

page locks...ish, we at least won't have results interleaved in a single 
page.  For btrfs it'll actually be multiple pages since we try to do 
more than one at a time.

I haven't verified all the assumptions around truncate and fallocate and 
friends expecting the dio special locking to be inside i_size.  In 
general this makes me a little uncomfortable.

But we're not avoiding the inode lock completely, we're just dropping it 
for the expensive parts of writing to the file.  A quick guess about 
what the expensive parts are:

1) balance_dirty_pages()
2) btrfs_btree_balance_dirty()
3) metadata reservations/enospc waiting.

Can I bribe you to benchmark how much each of those things is impacting 
the iops/latency benefits?

-chris
