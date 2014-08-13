Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44482 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751471AbaHMAxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 20:53:41 -0400
Message-ID: <53EAB711.5010602@cn.fujitsu.com>
Date: Wed, 13 Aug 2014 08:53:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: <miaox@cn.fujitsu.com>, Martin Steigerwald <Martin@lichtvoll.de>,
        Marc MERLIN <marc@merlins.org>,
        =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
Subject: Re: [PATCH] Btrfs: fix task hang under heavy compressed write
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com> <53EA2B71.6060701@fb.com>
In-Reply-To: <53EA2B71.6060701@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] Btrfs: fix task hang under heavy compressed write
From: Chris Mason <clm@fb.com>
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Date: 2014年08月12日 22:57
>
> On 08/12/2014 03:44 AM, Liu Bo wrote:
>> This has been reported and discussed for a long time, and this hang occurs in
>> both 3.15 and 3.16.
>>
>> Btrfs now migrates to use kernel workqueue, but it introduces this hang problem.
>>
>> Btrfs has a kind of work queued as an ordered way, which means that its
>> ordered_func() must be processed in the way of FIFO, so it usually looks like --
> This definitely explains some problems, and I overlooked the part where
> all of our workers use the same normal_work()
Oh, all my faults, it didn't occur to me that it is possible that other 
process can alloc the same address of memory :(
And same normal_work() makes things much worse.
>
> But I think it's actually goes beyond just the ordered work queues.
>
> Process A:
> 	btrfs_bio_wq_end_io() -> kmalloc a end_io_wq struct at address P
> 	submit bio
> 	end bio
> 	btrfs_queue_work(endio_write_workers)
> 	worker thread jumps in
> 	end_workqueue_fn()
> 		-> kfree(end_io_wq)
> 		^^^^^ right here end_io_wq can be reused,
> 		but the worker thread is still processing this work item
>
> Process B:
> 	btrfs_bio_wq_end() -> kmalloc an end_io_wq struct, reuse P
> 	submit bio
> 	end bio ... sometimes this is really fast
> 	btrfs_queue_work(endio_workers) // lets do a read
> 		->process_one_work()
> 		    -> find_worker_executing_work()
> 		    ^^^^^ now we get in trouble.  our struct P is still
> 		    active and so find_worker_executing_work() is going
> 		    to queue up this read completion on the end of the
> 		    scheduled list for this worker in the generic code.
>
> 		    The end result is we can have read IO completions
> 		    queued up behind write IO completions.
>
> This example uses the bio end io code, but we probably have others.  The
> real solution is to have each btrfs workqueue provide its own worker
> function, or each caller to btrfs_queue_work to send a unique worker
> function down to the generic code.
That's true, personally I prefer the first one since it affects less 
callers, but it seems to need more macro
hacks or somthing like it to generate different functions but they all 
do the samething...

Thanks,
Qu
>
> Thanks Liu, great job finding this.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

