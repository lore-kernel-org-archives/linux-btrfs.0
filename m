Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7DB3F39D1;
	Tue, 25 Aug 2026 23:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787700550; cv=none; b=mXFLuY8T0nW6vkGNCjWUB4mH9xDrQH0TmcRbiellezbVuANCzHPpE3SQm+zuSAW6YeFLDToIWODlXBDsl/o87QFgsoByFZKaup+jFF7ZsmPuaVYrUYKSZYMQLf2u4VHId7d6bA2dJYkzR4A7itQ9qFux7dESuYfGMovJgki5XR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787700550; c=relaxed/simple;
	bh=F71Ivknk/fr/y3IOr8bjll/4HgnUcbsJFkUXK6ul6q4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ui4zmJcH22uhCtnTqsuMoK1QRng43RyzSgVsGKXOP9FlyxufYZfVsYnGIn5mLPUhYgjhjaUnej4M/jV/VsEpWLf7d9Q9jWRonF4StjBPK360HDP7ZVM8KKcviYw5Rsi+HFELHo1zsn4wbjdRHDQ6zmeiHs+9M08kwLuPt8eTYTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67PNS2L0041321;
	Wed, 26 Aug 2026 08:28:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67PNS2Xq041305
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 26 Aug 2026 08:28:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <f342e48a-1ce5-4bbe-aa6f-c8f31a5c98bb@I-love.SAKURA.ne.jp>
Date: Wed, 26 Aug 2026 08:28:01 +0900
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
 <845464ce-43c0-45b3-94ea-ccc830fbc76f@acm.org>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <845464ce-43c0-45b3-94ea-ccc830fbc76f@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav415.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/08/26 7:18, Bart Van Assche wrote:
>> you also recognized that we can't call drain_workqueue() or flush_workqueue().
>>
>> Therefore, I chose to temporarily drop lo->lo_disk->open_mutex in order to
>> make it possible to safely perform drain_workqueue().
> 
> There is another possibility: set QUEUE_FLAG_DYING in __loop_clr_fd() before modifying queue limits and clear it again after modifying queue
> limits has finished. Feedback on the patch below is welcome.
> 

See https://lkml.kernel.org/r/26717cb6-81b0-4d5d-a5db-669283f9bb9d@I-love.SAKURA.ne.jp .

> +    /* Wait until all I/O-related work has finished. */
> +    flush_workqueue(lo->workqueue);

I don't know about QUEUE_FLAG_DYING manipulation, but we know we can't call
flush_workqueue() while holding open_mutex.

Please post as a standalone patch (subject starting with "[PATCH" than "Re: [PATCH")
that can be applied on current linux.git tree, so that sashiko can review your patch.
