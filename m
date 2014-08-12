Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11425 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045AbaHLO6S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 10:58:18 -0400
Message-ID: <53EA2B71.6060701@fb.com>
Date: Tue, 12 Aug 2014 10:57:53 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: <miaox@cn.fujitsu.com>, Martin Steigerwald <Martin@lichtvoll.de>,
        Marc MERLIN <marc@merlins.org>,
        =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
Subject: Re: [PATCH] Btrfs: fix task hang under heavy compressed write
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/12/2014 03:44 AM, Liu Bo wrote:
> This has been reported and discussed for a long time, and this hang occurs in
> both 3.15 and 3.16.
> 
> Btrfs now migrates to use kernel workqueue, but it introduces this hang problem.
> 
> Btrfs has a kind of work queued as an ordered way, which means that its
> ordered_func() must be processed in the way of FIFO, so it usually looks like --

This definitely explains some problems, and I overlooked the part where
all of our workers use the same normal_work()

But I think it's actually goes beyond just the ordered work queues.

Process A:
	btrfs_bio_wq_end_io() -> kmalloc a end_io_wq struct at address P
	submit bio
	end bio
	btrfs_queue_work(endio_write_workers)
	worker thread jumps in
	end_workqueue_fn()
		-> kfree(end_io_wq)
		^^^^^ right here end_io_wq can be reused,
		but the worker thread is still processing this work item

Process B:
	btrfs_bio_wq_end() -> kmalloc an end_io_wq struct, reuse P
	submit bio
	end bio ... sometimes this is really fast
	btrfs_queue_work(endio_workers) // lets do a read
		->process_one_work()
		    -> find_worker_executing_work()
		    ^^^^^ now we get in trouble.  our struct P is still
		    active and so find_worker_executing_work() is going
		    to queue up this read completion on the end of the
		    scheduled list for this worker in the generic code.

		    The end result is we can have read IO completions
		    queued up behind write IO completions.

This example uses the bio end io code, but we probably have others.  The
real solution is to have each btrfs workqueue provide its own worker
function, or each caller to btrfs_queue_work to send a unique worker
function down to the generic code.

Thanks Liu, great job finding this.

-chris
