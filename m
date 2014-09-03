Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49929 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755472AbaICJAU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 05:00:20 -0400
Message-ID: <5406D90C.60707@cn.fujitsu.com>
Date: Wed, 3 Sep 2014 17:02:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 11/12] Btrfs: implement repair function when direct
 read fails
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com> <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com> <1406625850-32168-12-git-send-email-miaox@cn.fujitsu.com> <5400C714.9030107@fb.com> <5404188F.1040309@cn.fujitsu.com> <20140902123319.GA14438@localhost.localdomain> <5405C08B.9020009@fb.com>
In-Reply-To: <5405C08B.9020009@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2 Sep 2014 09:05:15 -0400, Chris Mason wrote:
>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>> index 08e65e9..56b1546 100644
>>>>> --- a/fs/btrfs/disk-io.c
>>>>> +++ b/fs/btrfs/disk-io.c
>>>>> @@ -698,7 +719,12 @@ static void end_workqueue_bio(struct bio *bio, int err)
>>>>>  
>>>>>  	fs_info = end_io_wq->info;
>>>>>  	end_io_wq->error = err;
>>>>> -	btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL, NULL);
>>>>> +
>>>>> +	if (likely(end_io_wq->metadata != BTRFS_WQ_ENDIO_DIO_REPAIR))
>>>>> +		btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL,
>>>>> +				NULL);
>>>>> +	else
>>>>> +		INIT_WORK(&end_io_wq->work.normal_work, dio_end_workqueue_fn);
>>>>
>>>> It's not clear why this one is using INIT_WORK instead of
>>>> btrfs_init_work, or why we're calling directly into queue_work instead
>>>> of btrfs_queue_work.  What am I missing?
>>>
>>> I'm sorry that I forgot writing the explanation in this patch's changlog,
>>> I wrote it in Patch 0.
>>>
>>> "2.When the io on the mirror ends, we will insert the endio work into the
>>>    system workqueue, not btrfs own endio workqueue, because the original
>>>    endio work is still blocked in the btrfs endio workqueue, if we insert
>>>    the endio work of the io on the mirror into that workqueue, deadlock
>>>    would happen."
>>
>> Can you elaborate the deadlock?
>>
>> Now that buffer read can insert a subsequent read-mirror bio into btrfs endio
>> workqueue without problems, what's the difference?
> 
> We do have problems if we're inserting dependent items in the same
> workqueue.
> 
> Miao, please make a repair workqueue.  I'll also have a use for it in
> the raid56 parity work I think.

OK, I'll update the patch soon.

Thanks
Miao

