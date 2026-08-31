Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68B2473C8D;
	Mon, 31 Aug 2026 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788191509; cv=none; b=BE2e6IVqUy/psO0tqjeaR7AUmHE2+LbaQm7Ecf1WAr5Owws9fnfdd8EVlnYPOhQTddXEjp7sjsBYasZJqJbaCg8COXbQviCs7E4/ew8DZT3TYzSo1se2UUYyxpNG13cwnzvCMUYR2VWUFNwXgq+JLB75eNQBPEtck6K5frTHcAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788191509; c=relaxed/simple;
	bh=bBVowiB5dS8JjB/FFWssLYEWYbCErytHxenCEPiDcoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PkV5hnBLX7/JzF6Vdf2fzwbrsOsODNoIaEYXFGHYPuDds1IFdIuB3KYyv9yKe0MW6yizvL0S8TC0a6KpbVFjoQ5gU+RuDykh56A8lPqRjNBgwH/vnFqkJHu2qY7VpA/h8R0ZIA8b21YReCoSPKadlXcHikJRoccaTWYplCivrSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67VFnte6047028;
	Tue, 1 Sep 2026 00:49:55 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67VFntWh047025
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 1 Sep 2026 00:49:55 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <30528b67-6ff9-4512-892b-f48d819e100f@I-love.SAKURA.ne.jp>
Date: Tue, 1 Sep 2026 00:49:51 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Tao Cui <cui.tao@linux.dev>, brauner@kernel.org
Cc: Markus.Elfring@web.de, axboe@kernel.dk, broonie@kernel.org,
        bvanassche@acm.org, dlemoal@kernel.org, hch@infradead.org, hch@lst.de,
        hdanton@sina.com, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        lkp@intel.com, oe-lkp@lists.linux.dev, oliver.sang@intel.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Tao Cui <cuitao@kylinos.cn>
References: <6a770a9c-2642-4392-9b9c-609836693f36@I-love.SAKURA.ne.jp>
 <20260831141143.704821-1-cui.tao@linux.dev>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260831141143.704821-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav211.rs.sakura.ne.jp

Thank you for joining to this thread, Tao.

On 2026/08/31 23:11, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Hi Tetsuo, Bart,
> 
>> +	/* Step 1: Flush all outstanding I/O, without open_mutex held. */
>> +	/*
>> +	 * Now that loop_queue_rq() sees lo->lo_state != Lo_bound,
>> +	 * wait for already started loop_queue_rq() to complete.
>> +	 */
>> +	synchronize_rcu();
> 
> Your reply to Bart says loop_queue_rq() is called with RCU read
> lock, but I don't see one.  The two call sites of ->queue_rq() are
> blk_mq_dispatch_rq_list() and __blk_mq_issue_directly(), and
> neither is wrapped in rcu_read_lock().  Direct issue from
> blk_mq_submit_bio() runs in process context with no RCU read-side
> critical section, so synchronize_rcu() does not wait for a
> loop_queue_rq() that is already running there.  Only the softirq
> dispatch path is an implicit RCU reader.

You can read sashiko's raw logs at https://sashiko.dev/#/log/49552 .

  Okay, let's break this down. My initial thought is to examine how the `blk_mq_run_dispatch_ops`
  macro is implemented. Specifically, how does it handle RCU read locks? It wraps the provided
  `dispatch_ops` in either `rcu_read_lock()` or `srcu_read_lock()`, depending on the `BLK_MQ_F_BLOCKING`
  flag. The loop device, however, is set up *without* this `BLK_MQ_F_BLOCKING` flag. Therefore,
  `loop_queue_rq` executes under the protection of `rcu_read_lock()`.

  Now, the critical question: Does the `synchronize_rcu()` call in `__loop_clr_fd` effectively address
  the potential race conditions? Since `loop_queue_rq()` is indeed RCU-protected, `synchronize_rcu()` will
  correctly wait for all currently executing instances of `loop_queue_rq()` to complete. Furthermore,
  the `lo_state` transition to `Lo_rundown` before calling `__loop_clr_fd` ensures that any *new* calls to
  `loop_queue_rq()` will see this state and return an error. This perfectly fences the execution of
  `loop_queue_rq()`. Moreover, `drain_workqueue()` then makes sure all queued works are completed, and
  these are scheduled by `loop_queue_rq()`. This is great; all scheduled works are completed before
  clearing `lo->lo_backing_file`.

> 
> The window is still closed by the steps below, so this is not a
> correctness bug, but the synchronize_rcu() is not doing what the
> comment claims.  blk_mq_quiesce_queue() +
> blk_mq_wait_quiesce_done(), as Bart suggested, would express the
> intent directly.

synchronize_rcu() + drain_workqueue() can be implied by blk_mq_freeze_queue() + blk_mq_unfreeze_queue().
But why are you talking about blk_mq_quiesce_queue() + blk_mq_wait_quiesce_done() ?

> 
>> +	/*
>> +	 * Now that no more AIO requests are scheduled by lo_rw_aio(),
>> +	 * wait for already started AIO to complete.
>> +	 */
>> +	blk_mq_unfreeze_queue(lo->lo_queue, blk_mq_freeze_queue(lo->lo_queue));
> 
> About this step, in your follow-up you wrote:
> 
>>   (1) since we are in lo_release() with disk_openers(disk) == 0, the activity of
>>       incrementing/decrementing q_usage_counter (incremented before loop_queue_rq()
>>       is called, and decremented after loop_queue_rq() returned BLK_STS_IOERR)) will
>>       cease shortly
> 
> The decrement timing here is only true for the error path.  For
> BLK_STS_OK the reference is held until the request is freed, which
> is what makes blk_mq_freeze_queue() wait for requests that already
> passed the state check, including the loop workqueue worker that
> completes them.  That is the property step 1 relies on, and it is
> worth stating in the comment.
> 
> What is still open is Bart's question about io_uring fixed files:
> if submissions can continue after the last close, "cease shortly"
> does not hold, and it is the freeze wait that actually drains them.

If submissions can continue _forever_ despite disk_openers(disk) == 0, what
mechanism was preventing this problem from occurring until Linux 7.0 ?

> 
>> +	if (need_clear) {
>> +		/*
>> +		 * Grab all references that will be dropped as soon as
>> +		 * returning from lo_release() and releasing disk->open_mutex.
>> +		 */
>> +		get_device(disk_to_dev(disk));
>> +		__module_get(disk->fops->owner);
>> +		queue_work(system_long_wq, &lo->lo_clr_work);
>> +	}
> 
> With teardown now asynchronous, between the last close()
> returning and the work item finishing, lo_open() and
> LOOP_CONFIGURE return -ENXIO.  That is the same behavior change
> that led to the revert of the earlier attempt (bf23747ee053,
> xfs/259).  Moving the xfstests side to the tests is one thing, but
> userspace that closes a loop device and immediately reconfigures
> it now needs to handle a transient -ENXIO.  Is that acceptable, or
> should the retry happen in the kernel?

Does whether the teardown being synchronous or asynchronous matter so much?

I don't think we can control when e.g. udev-worker becomes the thread
who actually calls __loop_clr_fd()
( https://lkml.kernel.org/r/9f8b5ab0-efbc-4cf3-a1f8-b43377416946@I-love.SAKURA.ne.jp ).
Even if an existing user app calls close() immediately followed by open(),
we can't prove that __loop_clr_fd() is synchronously called by that user app
because udev-worker can jump in and udev-worker becomes the thread who actually
calls __loop_clr_fd().

   An user app     udev-worker
   -----------     -----------
                    open()
    close()
    open() // => succeeds due to Lo_bound state
    ioctl(LOOP_CONFIGURE) // => fails with -EBUSY due to Lo_bound state
    close() // <= gives up due to ioctl() failure
                    close() // => becomes  Lo_rundown and __loop_clr_fd() is called

A claim that mentions that the kernel is unable to release forever due to a refcount
leak bug is valid. But a claim that mentions that the kernel cannot prove that
this -ENXIO or -EBUSY problem never happens is invalid. Programs that use the loop
device have to be prepared for transient errors.
