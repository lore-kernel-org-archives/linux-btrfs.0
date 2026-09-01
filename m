Received: from mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC3237C93F
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 13:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788268155; cv=none; b=akOT6Tz3DBexh1eTO4zyUf2Lz6vGga6A1Wwx6cSsivMIjaPZsGts3uy4HK3pDUDRiALzmCsEUVarghW2P5YTXor5CG1kEVIN37nF7p1h6FOrCJzGWs+muPWvjvbZkv2fevYS9ror9XyyYyUl4WG1vbJqtVpOkmvnhBW1nsBeP5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788268155; c=relaxed/simple;
	bh=I9p86zfEc0rxJVFc8bGyzgpJ2NfBzjwUd1RaEkL/cGk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fJ7q2ha9Nte77+0Jq6qSg+QD0XYFvK0ePiuaX/scgfEwbKtCvDlyru1+eje5GDWaqUpECzHkbG2LuVNINoJiXfllUALdyzuln8WRrzKIYEQ+QLlyfZoE3NpST4UawDW0eQ8Eude8+AwvAq5J9+9rvZCLtNKDPn+dqO3kx3qZia4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dCg2zxwu; arc=none smtp.client-ip=95.215.58.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dCg2zxwu"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=I9p86zfEc0rxJVFc8bGyzgpJ2NfBzjwUd1RaEkL/cGk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788268152; v=1; x=1788872952;
 b=dCg2zxwuFLBx2Quos/98lWz2JGJ+CE4Jyd8p/38FdhLFAbbEC9NagDFQxbxKUXaWW229xeqI
 B5i/6cu2iiXyr0M4lQ7ZdXa72blffoFwTH99yBkSbC6QmxSj4/C7rvjGKi3I4AojvgJrxPzEhAt
 qTPkPmYqkSqemffq3WEqyJNI=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7ec9b92416be4d2e;
	Tue, 01 Sep 2026 13:09:01 +0000
X-Mizu-Trace-ID: 7ec9b92416be4d2e
X-Migadu-Flow: FLOW_OUT
Message-ID: <d1209b70-7e76-4415-92c9-6ddc192a3347@linux.dev>
Date: Tue, 1 Sep 2026 21:08:49 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Markus.Elfring@web.de, axboe@kernel.dk,
 broonie@kernel.org, bvanassche@acm.org, dlemoal@kernel.org,
 hch@infradead.org, hch@lst.de, hdanton@sina.com,
 linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-next@vger.kernel.org, lkp@intel.com, oe-lkp@lists.linux.dev,
 oliver.sang@intel.com, torvalds@linux-foundation.org,
 viro@zeniv.linux.org.uk, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v7] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, brauner@kernel.org
References: <6a770a9c-2642-4392-9b9c-609836693f36@I-love.SAKURA.ne.jp>
 <20260831141143.704821-1-cui.tao@linux.dev>
 <30528b67-6ff9-4512-892b-f48d819e100f@I-love.SAKURA.ne.jp>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <30528b67-6ff9-4512-892b-f48d819e100f@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Bart, Tetsuo,

Thanks for the detailed replies, and to Tetsuo for the sashiko
log.

在 2026/8/31 23:49, Tetsuo Handa 写道:
> Thank you for joining to this thread, Tao.
> 
> On 2026/08/31 23:11, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> Hi Tetsuo, Bart,
>>
>>> +	/* Step 1: Flush all outstanding I/O, without open_mutex held. */
>>> +	/*
>>> +	 * Now that loop_queue_rq() sees lo->lo_state != Lo_bound,
>>> +	 * wait for already started loop_queue_rq() to complete.
>>> +	 */
>>> +	synchronize_rcu();
>>
>> Your reply to Bart says loop_queue_rq() is called with RCU read
>> lock, but I don't see one.  The two call sites of ->queue_rq() are
>> blk_mq_dispatch_rq_list() and __blk_mq_issue_directly(), and
>> neither is wrapped in rcu_read_lock().  Direct issue from
>> blk_mq_submit_bio() runs in process context with no RCU read-side
>> critical section, so synchronize_rcu() does not wait for a
>> loop_queue_rq() that is already running there.  Only the softirq
>> dispatch path is an implicit RCU reader.
> 
> You can read sashiko's raw logs at https://sashiko.dev/#/log/49552 .
> 
>   Okay, let's break this down. My initial thought is to examine how the `blk_mq_run_dispatch_ops`
>   macro is implemented. Specifically, how does it handle RCU read locks? It wraps the provided
>   `dispatch_ops` in either `rcu_read_lock()` or `srcu_read_lock()`, depending on the `BLK_MQ_F_BLOCKING`
>   flag. The loop device, however, is set up *without* this `BLK_MQ_F_BLOCKING` flag. Therefore,
>   `loop_queue_rq` executes under the protection of `rcu_read_lock()`.
> 
>   Now, the critical question: Does the `synchronize_rcu()` call in `__loop_clr_fd` effectively address
>   the potential race conditions? Since `loop_queue_rq()` is indeed RCU-protected, `synchronize_rcu()` will
>   correctly wait for all currently executing instances of `loop_queue_rq()` to complete. Furthermore,
>   the `lo_state` transition to `Lo_rundown` before calling `__loop_clr_fd` ensures that any *new* calls to
>   `loop_queue_rq()` will see this state and return an error. This perfectly fences the execution of
>   `loop_queue_rq()`. Moreover, `drain_workqueue()` then makes sure all queued works are completed, and
>   these are scheduled by `loop_queue_rq()`. This is great; all scheduled works are completed before
>   clearing `lo->lo_backing_file`.
> 

Bart, on 8/31 you wrote:
> This is the code that protects .queue_rq() implementations like
> loop_queue_rq() with an rcu_read_lock() / rcu_read_unlock() pair:
>
> /* run the code block in @dispatch_ops with rcu/srcu read lock held */
> #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
> ...
> 	} else {						\
> 		rcu_read_lock();				\
> 		(dispatch_ops);					\
> 		rcu_read_unlock();				\
> 	}							\
> } while (0)

You are both right and I was wrong.  I stopped at
__blk_mq_issue_directly() and blk_mq_dispatch_rq_list() and missed
that every caller goes through this macro.  So synchronize_rcu()
does wait for a running loop_queue_rq() with the current loop
setup.  I withdraw that comment.

>>
>> The window is still closed by the steps below, so this is not a
>> correctness bug, but the synchronize_rcu() is not doing what the
>> comment claims.  blk_mq_quiesce_queue() +
>> blk_mq_wait_quiesce_done(), as Bart suggested, would express the
>> intent directly.
> 
> synchronize_rcu() + drain_workqueue() can be implied by blk_mq_freeze_queue() + blk_mq_unfreeze_queue().
> But why are you talking about blk_mq_quiesce_queue() + blk_mq_wait_quiesce_done() ?
> 

That was Bart's suggestion from his earlier review, and I passed
it on while assuming the synchronize_rcu() was unfounded.  With
the RCU pairing confirmed, there is nothing left to replace and
the quiesce suggestion is moot.

>>
>>> +	/*
>>> +	 * Now that no more AIO requests are scheduled by lo_rw_aio(),
>>> +	 * wait for already started AIO to complete.
>>> +	 */
>>> +	blk_mq_unfreeze_queue(lo->lo_queue, blk_mq_freeze_queue(lo->lo_queue));
>>
>> About this step, in your follow-up you wrote:
>>
>>>   (1) since we are in lo_release() with disk_openers(disk) == 0, the activity of
>>>       incrementing/decrementing q_usage_counter (incremented before loop_queue_rq()
>>>       is called, and decremented after loop_queue_rq() returned BLK_STS_IOERR)) will
>>>       cease shortly
>>
>> The decrement timing here is only true for the error path.  For
>> BLK_STS_OK the reference is held until the request is freed, which
>> is what makes blk_mq_freeze_queue() wait for requests that already
>> passed the state check, including the loop workqueue worker that
>> completes them.  That is the property step 1 relies on, and it is
>> worth stating in the comment.
>>
>> What is still open is Bart's question about io_uring fixed files:
>> if submissions can continue after the last close, "cease shortly"
>> does not hold, and it is the freeze wait that actually drains them.
> 

The decrement part I would still reword: for BLK_STS_OK the
reference is held until the request is freed, and that is the
property blk_mq_freeze_queue() relies on.  But you are right that
the activity ceases, and for a simpler reason than the freeze:

> If submissions can continue _forever_ despite disk_openers(disk) == 0, what
> mechanism was preventing this problem from occurring until Linux 7.0 ?
> 

An io_uring fixed file holds a reference to the struct file, so
bd_openers never reaches zero and lo_release() does not start
while such a submission path exists.  Any submission needs an
open block device file (or a mount holding it), so "openers == 0
but submissions continue" needs no additional mechanism.  I'll
drop the io_uring part.

>>
>>> +	if (need_clear) {
>>> +		/*
>>> +		 * Grab all references that will be dropped as soon as
>>> +		 * returning from lo_release() and releasing disk->open_mutex.
>>> +		 */
>>> +		get_device(disk_to_dev(disk));
>>> +		__module_get(disk->fops->owner);
>>> +		queue_work(system_long_wq, &lo->lo_clr_work);
>>> +	}
>>
>> With teardown now asynchronous, between the last close()
>> returning and the work item finishing, lo_open() and
>> LOOP_CONFIGURE return -ENXIO.  That is the same behavior change
>> that led to the revert of the earlier attempt (bf23747ee053,
>> xfs/259).  Moving the xfstests side to the tests is one thing, but
>> userspace that closes a loop device and immediately reconfigures
>> it now needs to handle a transient -ENXIO.  Is that acceptable, or
>> should the retry happen in the kernel?
> 
> Does whether the teardown being synchronous or asynchronous matter so much?
> 
> I don't think we can control when e.g. udev-worker becomes the thread
> who actually calls __loop_clr_fd()
> ( https://lkml.kernel.org/r/9f8b5ab0-efbc-4cf3-a1f8-b43377416946@I-love.SAKURA.ne.jp ).
> Even if an existing user app calls close() immediately followed by open(),
> we can't prove that __loop_clr_fd() is synchronously called by that user app
> because udev-worker can jump in and udev-worker becomes the thread who actually
> calls __loop_clr_fd().
> 
>    An user app     udev-worker
>    -----------     -----------
>                     open()
>     close()
>     open() // => succeeds due to Lo_bound state
>     ioctl(LOOP_CONFIGURE) // => fails with -EBUSY due to Lo_bound state
>     close() // <= gives up due to ioctl() failure
>                     close() // => becomes  Lo_rundown and __loop_clr_fd() is called
> 
> A claim that mentions that the kernel is unable to release forever due to a refcount
> leak bug is valid. But a claim that mentions that the kernel cannot prove that
> this -ENXIO or -EBUSY problem never happens is invalid. Programs that use the loop
> device have to be prepared for transient errors.

Your udev-worker sequence shows that synchronous completion was
never guaranteed and -EBUSY or -ENXIO transients were already
possible.  I accept that.  The remaining difference is only that
the window now exists after every close instead of requiring an
interleaving close from another opener, and if programs must
tolerate transient errors anyway, that is not a blocker.

Tao

