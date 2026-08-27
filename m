Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F9B3451CC;
	Thu, 27 Aug 2026 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787851715; cv=none; b=Jna51FTH4lH6bJFRKSmtUDja261/jlLWovMjb9wNjjjCemQCr+q4rbgb3chsEK+Thl9Y2dkZcQ32lulYlTO1wUS3zqoF5/HGo1jY8Mp/SRkRfzOxGH303Hu6pxPR0SD1c4Q8UpWhTr8ZFXN+PfG8qCDyOfznX6NLJmqoRw5bv/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787851715; c=relaxed/simple;
	bh=+bVSqeETuoDw1BqSpntt2L1pf1LIQ9cwzg+2T8/W+SI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MtL6S17WbYkgEGp4PamKrbcR8D3xPAEnmKdShiaqzuFhIGTKmGKyxjlNMZcW6jSt3TAEaH1PS34ISHjbi8TnsZO6Sd7D3Md50dpw4oW8zWl6x23OxFWywfJTbBh3/VSewj4IhAaKYq/OtvR8PM9Let0HE+E7TPv6JVxuAdDE8Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=l8MZr2zg; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="l8MZr2zg"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hW7lj4Q59z1XM0p7;
	Thu, 27 Aug 2026 17:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787851701; x=1790443702; bh=uCX4aVXwG7lP1Y2cPRH5ADHi
	/a1CbPD/0uCVhN6bZJs=; b=l8MZr2zgBnfuV3VV3T3fA7yVO+6R/3zmvNlC8ef7
	nvKlHA2cAduk1+ivotVcwM9Tz78WylwH/lZ28K13GZQn+pH4wdfAWxEuuIHd7nkx
	z0GwO+8XXTJQSAX1/MTmQhRHiTCGHczkncOF2AC57jGs//yZp31fF+jyvS/4L6KY
	RtDDuEqRSxL/vJzp+Zcq5LxKLkoj7g69Mzkwen50H/tqxO5J8YCF0y7ii/aZBwdT
	IWmJ8XMVF8Cfw3K9GU7nUKgVUZKsgLRJClcsWKpxdqRNBY/TMzeM3DoP6WfqBXIb
	BN+jpDwvzgWakt/fxHDdy2raDKCQSW5dLZp02tQKXfPrkA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KR0o28xEvOmE; Thu, 27 Aug 2026 17:28:21 +0000 (UTC)
Received: from [100.80.227.50] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hW7lN0m3dz1XM0p2;
	Thu, 27 Aug 2026 17:28:15 +0000 (UTC)
Message-ID: <c0df5f39-d103-4e36-9807-df0ae0247772@acm.org>
Date: Thu, 27 Aug 2026 10:28:14 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Markus Elfring <Markus.Elfring@web.de>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e5518546-701e-4d3c-a077-18e34aa8c188@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/26 8:30 AM, Tetsuo Handa wrote:
> While Sashiko considers a static blk_mq_freeze_queue() sufficient to avoid
> the NULL pointer dereference, relying on freezing the queue inside __loop_clr_fd()
> while holding `disk->open_mutex` is a dangerous decision.
> 
> It is true that blk_mq_freeze_queue() alone is equivalent to
> synchronize_rcu() + drain_workqueue() + blk_mq_freeze_queue().
> 
> Although omitting drain_workqueue() causes lockdep to stop complaining, not
> using drain_workqueue() does not avoid the runtime deadlock situation shown below.
> As long as there is a possibility of an in-flight I/O holding or waiting on a
> lock that subsequently tries to acquire `disk->open_mutex`, the deadlock
> risk remains. Lockdep will remain silent here simply because it cannot inspect
> the wake-up conditions inside wait_event() during a queue freeze.
> 
> Here is the exact execution timeline that leads to the silent deadlock:
> 
> Thread 1:                         Thread 2:                         Thread 3:
> ========================================================================================
>                                                                      Holds a global lock
>                                                                      (e.g., system_transition_mutex).
> 
>                                    Block core increments
>                                    `q_usage_counter`.
> 
> Block core holds `disk->open_mutex`.
> 
> lo_release() tries to wait for
> `q_usage_counter` to reach 0
> via blk_mq_freeze_queue()
>    => BLOCKED by Thread 2.
>                                    loop_handle_cmd() tries
>                                    to hold the global lock
>                                      => BLOCKED by Thread 3.
>                                                                      Tries to hold
>                                                                      `disk->open_mutex`
>                                                                        => BLOCKED by Thread 1.
> ========================================================================================
> 
> Since Thread 1 will never release `disk->open_mutex`, Thread 3 can never release
> the global lock, and Thread 2 can never reach blk_mq_end_request() to unblock Thread 1.
> 
> I've tried offloading __loop_clr_fd() entirely to task_work context in v3 patch, but
> it did not work due to module lifecycle restrictions
> ( https://sashiko.dev/#/patchset/fda8abc8-6aa2-463b-bf72-865f6b838034@I-love.SAKURA.ne.jp ).
> 
> Therefore, I consider that temporarily releasing `disk->open_mutex` within the process
> context to safely perform flushing/draining before clearing the backing file pointer
> is the most robust architectural solution to break this deadlock chain.

I'm going to drop patch "loop: Serialize I/O and queue limits updates"
from my patch series and leave it to someone else to solve this issue
since none of the proposed fixes that have been discussed so far make me
enthusiast.

Thanks,

Bart.
