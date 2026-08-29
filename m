Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BF22CCB9;
	Sat, 29 Aug 2026 05:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787980701; cv=none; b=Jgb+edLcZvz5neiGoyln2qmDjpt+vLE/IOSswIerZ0T3WAH/HHOyXoE/9Fwjz5RBiaZ69Lu3ia6S5MVJ+CVPEYyQwpyE/j3o9ToZx2xWewnaSBaHhuHRZdmyCTQaYc9gnxu5rQLF0DWf6iS1fU0FEcJAlH8s+Rmm0/15Telygh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787980701; c=relaxed/simple;
	bh=qRwZ5NpNVPKe2b6/4sk8juFJHvLZLl114q8bZtIi3iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j0FAdIfomSR3cJRlJimvyVzpWhgB7+3XmR8d9YLQvWl01UBo3rfSYbwZm9SqzB2duVqwgASWvRVwKr4gGVZgsmBK3oXmBpt6f4LPnPyQeVtFoF9rpGxHGlXS0wXqYEMvwtncZX+HGSkY8J+qKnSsW4BON4/PYDzyx5Dh6xLyBxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67T5H1Rj003598;
	Sat, 29 Aug 2026 14:17:01 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67T5H01E003595
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 29 Aug 2026 14:17:00 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <903a22a2-432c-4e72-bc09-7898becf2f3e@I-love.SAKURA.ne.jp>
Date: Sat, 29 Aug 2026 14:17:00 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Bart Van Assche <bvanassche@acm.org>,
        Markus Elfring <Markus.Elfring@web.de>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, lkp@intel.com,
        oe-lkp@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>, Oliver Sang <oliver.sang@intel.com>,
        linux-btrfs@vger.kernel.org
References: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
 <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
 <38ad64c1-edc7-431d-8f52-fba572ebf3eb@I-love.SAKURA.ne.jp>
 <372ca5f6-81a0-4f6c-8f55-ebeeada9f955@acm.org>
 <27bcb147-bead-4432-8cd0-981489f36228@acm.org>
 <c41e9198-86a8-4bcd-a608-6f457b24f345@I-love.SAKURA.ne.jp>
 <7e51bca8-218a-40b8-8ff8-fc59671f5add@acm.org>
 <3bb080d0-4421-4012-8a62-6a2bf165cbd9@I-love.SAKURA.ne.jp>
 <d2f387b9-031a-4306-9323-56f98a8241b7@acm.org>
 <e5518546-701e-4d3c-a077-18e34aa8c188@I-love.SAKURA.ne.jp>
 <c0df5f39-d103-4e36-9807-df0ae0247772@acm.org>
 <c2ab2547-63b3-48cf-87c1-fc53219e360a@I-love.SAKURA.ne.jp>
 <d0471919-9b71-4d24-9fb8-5f1d7f3792ca@acm.org>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <d0471919-9b71-4d24-9fb8-5f1d7f3792ca@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav411.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/08/29 1:29, Bart Van Assche wrote:
> On 8/28/26 8:53 AM, Tetsuo Handa wrote:
>> +     * wait for already started loop_queue_rq() to complete.
>> +     */
>> +    synchronize_rcu();
> 
> Calling synchronize_rcu() to wait for ongoing loop_queue_rq() calls to
> complete won't work if anyone would set BLK_MQ_F_BLOCKING for the
> request queues created by the loop driver.

Excuse me, but this ordering is correct (reviewed by Gemini and sashiko).

>                                            Please use the block-layer
> APIs instead of open-coding these. I'm referring to
> blk_mq_quiesce_queue() and blk_mq_wait_quiesce_done().
> 
> Freezing the request queue must happen before waiting for ongoing
> loop_queue_rq() calls to finish.

I and Gemini cannot catch what you want to say here.

> Calling synchronize_rcu() does not prevent new I/O to be submitted. What
> prevents io_uring to submit more I/O asynchronously, e.g. if a file
> descriptor that refers to a loop device instance has been registered in
> the fixed-file table?

Calling synchronize_rcu() makes sure that no more queue_work() calls are
made from loop_queue_work() from loop_queue_rq(). Since loop_queue_rq() is
called with RCU read lock, subsequent loop_queue_rq() calls which are made
after synchronize_rcu() returned shall see lo->lo_state != Lo_bound and
return with BLK_STS_IOERR.

> 
>> +    /*
>> +     * Now that no more works are scheduled by loop_queue_rq(),
>> +     * wait for already scheduled works to complete.
>> +     */
>> +    drain_workqueue(lo->workqueue);
>> +    /*
>> +     * Now that no more AIO requests are scheduled by lo_rw_aio(),
>> +     * wait for already started AIO to complete.
>> +     */
>> +    blk_mq_unfreeze_queue(lo->lo_queue, blk_mq_freeze_queue(lo->lo_queue));
> 
> Freezing the request queue must happen before lo->workqueue is drained.

Again, I and Gemini cannot catch what you want to say here.

Calling drain_workqueue() after synchronize_rcu() makes sure that no more
loop_handle_cmd() calls are made from loop_process_work() from loop_workfn()
and loop_rootcg_workfn().

Calling blk_mq_freeze_queue() after drain_workqueue() after synchronize_rcu()
does wait for completion of all pending I/O requests which has been scheduled
via loop_queue_rq(), by waiting for q_usage_counter to reach 0. Also, this
synchronize_rcu() => drain_workqueue() => blk_mq_freeze_queue() ordering
guarantees that q_usage_counter won't be incremented again after it once
reached 0, due to the lo->lo_state != Lo_bound check in loop_queue_rq().
This makes it possible to call blk_mq_unfreeze_queue() immediately after
blk_mq_freeze_queue().

> 
>> +    /* Step 2: Perform remaining cleanup, with open_mutex held. */
>> +    mutex_lock(&disk->open_mutex);
> 
> After having obtained disk->open_mutex, lease add something like the
> following: WARN_ON_ONCE(lo->lo_state == Lo_bound). Even if this
> condition can't be triggered today, this may help with detecting bugs in
> future loop driver changes.

Did you mean WARN_ON_ONCE(lo->lo_state != Lo_rundown) ?

> 
>> @@ -1168,8 +1186,6 @@ static void __loop_clr_fd(struct loop_device *lo)
>>       /* let user-space know about this change */
>>       kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
>>       mapping_set_gfp_mask(filp->f_mapping, gfp);
>> -    /* This is safe: open() is still holding a reference. */
>> -    module_put(THIS_MODULE);
>>         disk_force_media_change(lo->lo_disk); 
> 
> I don't think that it's acceptable to invoke __loop_clr_fd()
> asynchronously in its entirety. I think at least the following code
> should be executed synchronously from lo_release():
> 
>     loop_sysfs_exit(lo);
> 
>     mutex_lock(&lo->lo_mutex);
>     WRITE_ONCE(lo->lo_state, Lo_unbound);
>     mutex_unlock(&lo->lo_mutex);
> 

Doing so breaks the whole protection provided by the Lo_rundown state. As soon
as lo->lo_state becomes Lo_unbound, lo_open() will succeed and loop_configure()
will start changing an lo object before WQ context cleans up that lo object.

>> @@ -1769,8 +1797,20 @@ static void lo_release(struct gendisk *disk)
>>       need_clear = (lo->lo_state == Lo_rundown);
>>       mutex_unlock(&lo->lo_mutex);
>>   -    if (need_clear)
>> -        __loop_clr_fd(lo);
>> +    /*
>> +     * In order to flush pending I/O requests before clearing the backing
>> +     * device, defer __loop_clr_fd() to WQ context. The Lo_rundown state
>> +     * guarantees that lo_open() will fail with -ENXIO.
>> +     */
>> +    if (need_clear) {
>> +        /*
>> +         * Grab all references that will be dropped as soon as
>> +         * returning from lo_release() and releasing disk->open_mutex.
>> +         */
>> +        get_device(disk_to_dev(disk));
>> +        __module_get(disk->fops->owner);
>> +        queue_work(system_long_wq, &lo->lo_clr_work);
>> +    }
>>   }
> 
> Please convert the above code to the "early return" style that is used
> elsewhere in the kernel.

That is OK. But after you agreed that my patch works as expected.

> 
> Why system_long_wq instead of lo->workqueue?

That is a deadlock. We can't flush a work in lo->workqueue from inside
WQ callback function where that work is associated with.
