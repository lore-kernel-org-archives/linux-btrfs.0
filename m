Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2693CAA49;
	Wed, 26 Aug 2026 10:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740741; cv=none; b=Iw3x3e76XGQzAIC56sZZfqcltIILdJFMcX4A3kN4KOnm7DPszUDJwWLA+yX2q1mLRc2WRtjzlAdWaRL7DznuRWXxgWbNaIPspZf3AOTF5apyVQVXkh9Ex0Pk3wrheZqHLm27lYoqjGGuJCagol++LmLnkF0SaYDHh1gyuAZkdsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740741; c=relaxed/simple;
	bh=aNqnHUAaUhTGvvVwE9ECDTRoDx01i/L5nzyGJk3/rHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tPuY4aQjGQtNffDrRzGCwd3nGA0YgC0B/w1PGOEC4ngY/VuTHV7vS/iyLZ6EKTwF1CmrWmaQVszIr5CdJOB8wNK08qtr9aiNzMoimItYocDJ0a+QmUqV0sdPe3yXoTDzj08dpIsUbUspa1lCJjq3bdr7VKFukjwkh2CwaduKhxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67QAbvDZ079437;
	Wed, 26 Aug 2026 19:37:57 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67QAbusX079434
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 26 Aug 2026 19:37:57 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <3bb080d0-4421-4012-8a62-6a2bf165cbd9@I-love.SAKURA.ne.jp>
Date: Wed, 26 Aug 2026 19:37:54 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] loop: Fix NULL pointer dereference in lo_rw_aio()
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
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <7e51bca8-218a-40b8-8ff8-fc59671f5add@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav211.rs.sakura.ne.jp

On 2026/08/26 8:16, Bart Van Assche wrote:
> On 8/25/26 8:13 AM, Tetsuo Handa wrote:
>> On 2026/08/25 7:53, Bart Van Assche wrote:
>>> A correction: it is not safe to call drain_workqueue() nor to freeze the
>>> request queue in __loop_clr_fd(). I'm considering to modify the comment
>>> in that function as follows:
>>
>> you also recognized that we can't call drain_workqueue() or flush_workqueue().
>>
>> Therefore, I chose to temporarily drop lo->lo_disk->open_mutex in order to
>> make it possible to safely perform drain_workqueue().
> 
> My sentence was incomplete: I should have written that it is not safe to
> call drain_workqueue() nor flush_workqueue() from __loop_clr_fd() while
> the request queue is frozen. It is not clear to me how draining or
> flushing the workqueue from inside __loop_clr_fd() could cause trouble
> if this happens with the queue unfrozen since disk->open_mutex is not
> acquired by the memory reclaim code?

I don't know how "since disk->open_mutex is not acquired by the memory reclaim
code" is relevant...

Current situation is a result of what we had considered 4 years ago; we don't need
to destroy workqueue (note that destroy_workqueue() implies drain_workqueue()) from
__loop_clr_fd() ( https://lkml.kernel.org/r/20220330052917.2566582-16-hch@lst.de ).

Since there is a

  Chain exists of:
    (wq_completion)loop0 --> system_transition_mutex/1 --> &disk->open_mutex
  
   Possible unsafe locking scenario:
  
         CPU0                    CPU1
         ----                    ----
    lock(&disk->open_mutex);
                                 lock(system_transition_mutex/1);
                                 lock(&disk->open_mutex);
    lock((wq_completion)loop0);

dependency, but my proposal to forbid binding loop device to pseudo files
( https://lkml.kernel.org/r/148efba2-a0b6-47d7-ac76-b19d2f4b696c@I-love.SAKURA.ne.jp )
was rejected by Christoph, we are stuck in a

  Draining workqueue with open_mutex held causes creating a complex lock dependency
  chain involving the global system_transition_mutex. (Maybe there are other paths
  that create similar dependency chain if we drain workqueue with open_mutex held.)

versus

  Not draining workqueue causes NULL pointer dereference in lo_rw_aio().

collision. Therefore,

  Draining workqueue *without open_mutex held* can avoid creating a complex lock
  dependency chain involving the global system_transition_mutex and can also avoid
  NULL pointer dereference in lo_rw_aio().

is my solution.

Can you agree with my solution?
