Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26796 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751078AbaIAGzG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Sep 2014 02:55:06 -0400
Message-ID: <5404188F.1040309@cn.fujitsu.com>
Date: Mon, 1 Sep 2014 14:56:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 11/12] Btrfs: implement repair function when direct
 read fails
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com> <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com> <1406625850-32168-12-git-send-email-miaox@cn.fujitsu.com> <5400C714.9030107@fb.com>
In-Reply-To: <5400C714.9030107@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 29 Aug 2014 14:31:48 -0400, Chris Mason wrote:
> On 07/29/2014 05:24 AM, Miao Xie wrote:
>> This patch implement data repair function when direct read fails.
>>
>> The detail of the implementation is:
>> - When we find the data is not right, we try to read the data from the other
>>   mirror.
>> - After we get right data, we write it back to the corrupted mirror.
>> - And if the data on the new mirror is still corrupted, we will try next
>>   mirror until we read right data or all the mirrors are traversed.
>> - After the above work, we set the uptodate flag according to the result.
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 08e65e9..56b1546 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -698,7 +719,12 @@ static void end_workqueue_bio(struct bio *bio, int err)
>>  
>>  	fs_info = end_io_wq->info;
>>  	end_io_wq->error = err;
>> -	btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL, NULL);
>> +
>> +	if (likely(end_io_wq->metadata != BTRFS_WQ_ENDIO_DIO_REPAIR))
>> +		btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL,
>> +				NULL);
>> +	else
>> +		INIT_WORK(&end_io_wq->work.normal_work, dio_end_workqueue_fn);
> 
> It's not clear why this one is using INIT_WORK instead of
> btrfs_init_work, or why we're calling directly into queue_work instead
> of btrfs_queue_work.  What am I missing?

I'm sorry that I forgot writing the explanation in this patch's changlog,
I wrote it in Patch 0.

"2.When the io on the mirror ends, we will insert the endio work into the
   system workqueue, not btrfs own endio workqueue, because the original
   endio work is still blocked in the btrfs endio workqueue, if we insert
   the endio work of the io on the mirror into that workqueue, deadlock
   would happen."

Could you add it into the changelog of this patch when you apply this patch?

Thanks
Miao
