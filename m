Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C522C47F782;
	Thu, 27 Aug 2026 15:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787844756; cv=none; b=MFj0qidFlCsXhe0nG54o2+O/megt4oEkG4qhoTzFFyK5QC3xw0gNZOO9grahEhy2jud0J51jQsgpC1EPWzBD8G6xrqkXz2lhjrf07qH8/1fXe0wddP+xAtLjClmaYzlj7cwViM1cNAD00f+jSlJH4hCUYssH8vVEObDRjSaPyuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787844756; c=relaxed/simple;
	bh=5fULEVdiLNaeaGPmNGVav3cRmsOv0HEjjh0adnjLFWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jb/0jWqUlp+UiC+QTOFw0K16cj4d8imHUmHTc46z6MWhtYxzlfufhI0Ho+onbeX2KaU7areMKo4Dg/uhHuj9gAssLtsqAK8CostpwBkJDrV0JqAy5dVcrAB6/T7SPfJOJwzcL41rFlpBCvABkfSoExlYOHOuZjZOUaEOKUPROM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67RFUkJh066871;
	Fri, 28 Aug 2026 00:30:46 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67RFUdpm066842
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 28 Aug 2026 00:30:45 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <e5518546-701e-4d3c-a077-18e34aa8c188@I-love.SAKURA.ne.jp>
Date: Fri, 28 Aug 2026 00:30:39 +0900
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
 <3bb080d0-4421-4012-8a62-6a2bf165cbd9@I-love.SAKURA.ne.jp>
 <d2f387b9-031a-4306-9323-56f98a8241b7@acm.org>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <d2f387b9-031a-4306-9323-56f98a8241b7@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav415.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/08/27 2:44, Bart Van Assche wrote:
> Releasing and reacquiring disk->open_mutex from __loop_clr_fd() seems
> risky to me. There is plenty of code in block/bdev.c that assumes that
> disk->open_mutex is not released by lo_release().

sashiko's review did not find problems
( https://sashiko.dev/#/patchset/8dedfc40-9cae-44ff-9960-e0eb1825e963%40I-love.SAKURA.ne.jp ).
This callback is the last code which is performed immediately before releasing disk->open_mutex.

> 
> I think there is another solution: instead of draining the workqueue
> from inside __loop_clr_fd(), postpone it until the next time the loop
> device is bound. See also the patch below.

That is too late to avoid NULL pointer dereference problem.
We need to flush before setting lo->lo_backing_file to NULL.

> 
> Regarding your earlier request for a Sashiko review: I will look into
> configuring Sashiko such that I can run "sashiko review ${commit_id}"
> locally. The only part I'm missing right now is a Sashiko API key.
While Sashiko considers a static blk_mq_freeze_queue() sufficient to avoid
the NULL pointer dereference, relying on freezing the queue inside __loop_clr_fd()
while holding `disk->open_mutex` is a dangerous decision.

It is true that blk_mq_freeze_queue() alone is equivalent to
synchronize_rcu() + drain_workqueue() + blk_mq_freeze_queue().

Although omitting drain_workqueue() causes lockdep to stop complaining, not
using drain_workqueue() does not avoid the runtime deadlock situation shown below.
As long as there is a possibility of an in-flight I/O holding or waiting on a
lock that subsequently tries to acquire `disk->open_mutex`, the deadlock
risk remains. Lockdep will remain silent here simply because it cannot inspect
the wake-up conditions inside wait_event() during a queue freeze.

Here is the exact execution timeline that leads to the silent deadlock:

Thread 1:                         Thread 2:                         Thread 3:
========================================================================================
                                                                    Holds a global lock 
                                                                    (e.g., system_transition_mutex).

                                  Block core increments 
                                  `q_usage_counter`.

Block core holds `disk->open_mutex`.

lo_release() tries to wait for 
`q_usage_counter` to reach 0 
via blk_mq_freeze_queue() 
  => BLOCKED by Thread 2.
                                  loop_handle_cmd() tries 
                                  to hold the global lock 
                                    => BLOCKED by Thread 3.
                                                                    Tries to hold 
                                                                    `disk->open_mutex` 
                                                                      => BLOCKED by Thread 1.
========================================================================================

Since Thread 1 will never release `disk->open_mutex`, Thread 3 can never release
the global lock, and Thread 2 can never reach blk_mq_end_request() to unblock Thread 1.

I've tried offloading __loop_clr_fd() entirely to task_work context in v3 patch, but
it did not work due to module lifecycle restrictions
( https://sashiko.dev/#/patchset/fda8abc8-6aa2-463b-bf72-865f6b838034@I-love.SAKURA.ne.jp ).

Therefore, I consider that temporarily releasing `disk->open_mutex` within the process
context to safely perform flushing/draining before clearing the backing file pointer
is the most robust architectural solution to break this deadlock chain.

