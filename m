Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041FE23BCEE;
	Sat, 29 Aug 2026 05:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787982978; cv=none; b=Jo0/defSIlwSCJfOLgTb+/2SvCqrQchTitB5kwsNajJ8KohgntkOb0ss2r1pknwRx4J4fDo0bJSRyjLiY2A+D7FzV9r9nkdp7E3Aovtxxx+Ffnoyv4CNhRvA3u5br9Ri5KSkNPLECAX3LWHNG5jIV/1v18xCT6v4Zs8j/4XbRoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787982978; c=relaxed/simple;
	bh=2FOUWMlsR+RkhsyUYBfHnH37vrxo71hxEejjjfPLUuA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ggidxcd1vERInS8c55tuko6b3je1qbRZ3Zu23pi1BiArbCLjHOiyiKd9xiBCSYfhC5NHr22RHI2XjBU3lHI2f07bnxr+UocBmIQh9HUvmYM7sCEN57kdPcg0Z5nRkkbUWfv6CcV90qIepQr/jhRNRH/x+AhpFPssnJTSxknEUG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67T5tYcN010762;
	Sat, 29 Aug 2026 14:55:34 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67T5tYl1010759
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 29 Aug 2026 14:55:34 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <6a770a9c-2642-4392-9b9c-609836693f36@I-love.SAKURA.ne.jp>
Date: Sat, 29 Aug 2026 14:55:33 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] loop: Fix NULL pointer dereference in lo_rw_aio()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
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
 <903a22a2-432c-4e72-bc09-7898becf2f3e@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <903a22a2-432c-4e72-bc09-7898becf2f3e@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav415.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/08/29 14:17, Tetsuo Handa wrote:
>                                                                 Also, this
> synchronize_rcu() => drain_workqueue() => blk_mq_freeze_queue() ordering
> guarantees that q_usage_counter won't be incremented again after it once
> reached 0, due to the lo->lo_state != Lo_bound check in loop_queue_rq().

Well, this part was inaccurate. Since q_usage_counter is incremented before
loop_queue_rq() is called, it is possible that q_usage_counter itself can be
incremented even after synchronize_rcu() => drain_workqueue() => blk_mq_freeze_queue()
sequence.

But what makes this ordering safe are

  (1) since we are in lo_release() with disk_openers(disk) == 0, the activity of
      incrementing/decrementing q_usage_counter (incremented before loop_queue_rq()
      is called, and decremented after loop_queue_rq() returned BLK_STS_IOERR)) will
      cease shortly

  (2) since there is no pending work in lo->workqueue, no I/O will be made to
      backing file

.
