Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24674 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbaIBNFW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 09:05:22 -0400
Message-ID: <5405C08B.9020009@fb.com>
Date: Tue, 2 Sep 2014 09:05:15 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 11/12] Btrfs: implement repair function when direct
 read fails
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com> <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com> <1406625850-32168-12-git-send-email-miaox@cn.fujitsu.com> <5400C714.9030107@fb.com> <5404188F.1040309@cn.fujitsu.com> <20140902123319.GA14438@localhost.localdomain>
In-Reply-To: <20140902123319.GA14438@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/02/2014 08:33 AM, Liu Bo wrote:
> On Mon, Sep 01, 2014 at 02:56:15PM +0800, Miao Xie wrote:
>> On Fri, 29 Aug 2014 14:31:48 -0400, Chris Mason wrote:
>>> On 07/29/2014 05:24 AM, Miao Xie wrote:
>>>> This patch implement data repair function when direct read fails.
>>>>
>>>> The detail of the implementation is:
>>>> - When we find the data is not right, we try to read the data from the other
>>>>   mirror.
>>>> - After we get right data, we write it back to the corrupted mirror.
>>>> - And if the data on the new mirror is still corrupted, we will try next
>>>>   mirror until we read right data or all the mirrors are traversed.
>>>> - After the above work, we set the uptodate flag according to the result.
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 08e65e9..56b1546 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -698,7 +719,12 @@ static void end_workqueue_bio(struct bio *bio, int err)
>>>>  
>>>>  	fs_info = end_io_wq->info;
>>>>  	end_io_wq->error = err;
>>>> -	btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL, NULL);
>>>> +
>>>> +	if (likely(end_io_wq->metadata != BTRFS_WQ_ENDIO_DIO_REPAIR))
>>>> +		btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL,
>>>> +				NULL);
>>>> +	else
>>>> +		INIT_WORK(&end_io_wq->work.normal_work, dio_end_workqueue_fn);
>>>
>>> It's not clear why this one is using INIT_WORK instead of
>>> btrfs_init_work, or why we're calling directly into queue_work instead
>>> of btrfs_queue_work.  What am I missing?
>>
>> I'm sorry that I forgot writing the explanation in this patch's changlog,
>> I wrote it in Patch 0.
>>
>> "2.When the io on the mirror ends, we will insert the endio work into the
>>    system workqueue, not btrfs own endio workqueue, because the original
>>    endio work is still blocked in the btrfs endio workqueue, if we insert
>>    the endio work of the io on the mirror into that workqueue, deadlock
>>    would happen."
> 
> Can you elaborate the deadlock?
> 
> Now that buffer read can insert a subsequent read-mirror bio into btrfs endio
> workqueue without problems, what's the difference?

We do have problems if we're inserting dependent items in the same
workqueue.

Miao, please make a repair workqueue.  I'll also have a use for it in
the raid56 parity work I think.

-chris
