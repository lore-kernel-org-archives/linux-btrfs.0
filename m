Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C9938655E;
	Fri, 28 Aug 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787934614; cv=none; b=ipDIZ432eb1dlzeUQqygMl2dxsVcXg1yq6MwEcoCrGJA85RX1nRTDfTKuIgh/vs0AcRWodnYTnw2AUvl0/gdMln6j/BMlemVoZrruChBXqDFyR71xaYZuNzWuDgPKNHPBSQ+KZ50lRBFinI4S3iysHRK6E2uqcrAM3hyOmxsxws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787934614; c=relaxed/simple;
	bh=xLS8MlBReWfhJPvmiXzWFDK52YcN7W6n6+Xd3NC5lOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tknQX/UKIZ48x/ujr/RIly1MMf/D0vVc0lK3/+Nzxl92dkkZEoSUetGQYaOIHZDOajO95gEHNkb4udIcOUGA9gQTkxIf1PCKhtywrnzpJ22kWcqI2BQK74xW6uYjR4K/DD/Y/9Vu1l4aDQH8QqgcSDobGv33jqNT9CXcktF1ZCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uiF+N/NN; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uiF+N/NN"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hWkPv11D2z1XM30n;
	Fri, 28 Aug 2026 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787934596; x=1790526597; bh=clkga+mglnXML2bMv9Ds4jVJ
	dAKQ9kHPcaeJNPAIRNE=; b=uiF+N/NNe3hNuRtGlayCbmdTexnjGeir7i0DfY63
	NcxdPwIdDkn1LnrOdKh97V6Uqn/xlOPkGPMknkWliUucvfUhRnT32j9s1ciScIkF
	i/auawk9H/4wfjJOhBDxuspEGcznn7GI50tcNy4/X6Op7DEFgITpd4LsC6I9P9UV
	qEEVMlpIY9kBfxPK6zr2LzSuux3ghDJehT8fP/5SNNXxnNLH/xUsnmu+bLZ446hw
	iI607i+1X6Ym70sg+5l04Tm+cNGFiPXRWv7EzXWAKq8PEorQXXS4i/3AkntyC2Fc
	cZG2Pl7EK6MOTmmwJ3CHiEtN2wEDLblP45KdjetWZK8s+w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sCa7tTwi1n-N; Fri, 28 Aug 2026 16:29:56 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:af43:61da:b9fc:bc3e] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hWkPP6FHrz1XM5kW;
	Fri, 28 Aug 2026 16:29:45 +0000 (UTC)
Message-ID: <d0471919-9b71-4d24-9fb8-5f1d7f3792ca@acm.org>
Date: Fri, 28 Aug 2026 09:29:44 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] loop: Fix NULL pointer dereference in lo_rw_aio()
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
 <c0df5f39-d103-4e36-9807-df0ae0247772@acm.org>
 <c2ab2547-63b3-48cf-87c1-fc53219e360a@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c2ab2547-63b3-48cf-87c1-fc53219e360a@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/26 8:53 AM, Tetsuo Handa wrote:
> +	 * wait for already started loop_queue_rq() to complete.
> +	 */
> +	synchronize_rcu();

Calling synchronize_rcu() to wait for ongoing loop_queue_rq() calls to
complete won't work if anyone would set BLK_MQ_F_BLOCKING for the
request queues created by the loop driver. Please use the block-layer
APIs instead of open-coding these. I'm referring to
blk_mq_quiesce_queue() and blk_mq_wait_quiesce_done().

Freezing the request queue must happen before waiting for ongoing
loop_queue_rq() calls to finish.

Calling synchronize_rcu() does not prevent new I/O to be submitted. What
prevents io_uring to submit more I/O asynchronously, e.g. if a file
descriptor that refers to a loop device instance has been registered in
the fixed-file table?

> +	/*
> +	 * Now that no more works are scheduled by loop_queue_rq(),
> +	 * wait for already scheduled works to complete.
> +	 */
> +	drain_workqueue(lo->workqueue);
> +	/*
> +	 * Now that no more AIO requests are scheduled by lo_rw_aio(),
> +	 * wait for already started AIO to complete.
> +	 */
> +	blk_mq_unfreeze_queue(lo->lo_queue, blk_mq_freeze_queue(lo->lo_queue));

Freezing the request queue must happen before lo->workqueue is drained.

> +	/* Step 2: Perform remaining cleanup, with open_mutex held. */
> +	mutex_lock(&disk->open_mutex);

After having obtained disk->open_mutex, lease add something like the
following: WARN_ON_ONCE(lo->lo_state == Lo_bound). Even if this
condition can't be triggered today, this may help with detecting bugs in
future loop driver changes.

> @@ -1168,8 +1186,6 @@ static void __loop_clr_fd(struct loop_device *lo)
>   	/* let user-space know about this change */
>   	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
>   	mapping_set_gfp_mask(filp->f_mapping, gfp);
> -	/* This is safe: open() is still holding a reference. */
> -	module_put(THIS_MODULE);
>   
>   	disk_force_media_change(lo->lo_disk); 

I don't think that it's acceptable to invoke __loop_clr_fd()
asynchronously in its entirety. I think at least the following code
should be executed synchronously from lo_release():

	loop_sysfs_exit(lo);

	mutex_lock(&lo->lo_mutex);
	WRITE_ONCE(lo->lo_state, Lo_unbound);
	mutex_unlock(&lo->lo_mutex);

> @@ -1769,8 +1797,20 @@ static void lo_release(struct gendisk *disk)
>   	need_clear = (lo->lo_state == Lo_rundown);
>   	mutex_unlock(&lo->lo_mutex);
>   
> -	if (need_clear)
> -		__loop_clr_fd(lo);
> +	/*
> +	 * In order to flush pending I/O requests before clearing the backing
> +	 * device, defer __loop_clr_fd() to WQ context. The Lo_rundown state
> +	 * guarantees that lo_open() will fail with -ENXIO.
> +	 */
> +	if (need_clear) {
> +		/*
> +		 * Grab all references that will be dropped as soon as
> +		 * returning from lo_release() and releasing disk->open_mutex.
> +		 */
> +		get_device(disk_to_dev(disk));
> +		__module_get(disk->fops->owner);
> +		queue_work(system_long_wq, &lo->lo_clr_work);
> +	}
>   }

Please convert the above code to the "early return" style that is used
elsewhere in the kernel.

Why system_long_wq instead of lo->workqueue?

Thanks,

Bart.
