Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2645A3D47A3;
	Tue, 25 Aug 2026 23:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699785; cv=none; b=mjI5Au8skcMkquPG7q9pLSbiYXy893PHmg7suYo3eGZJvMzehvsgWcpSPVXTVYjJh/QPCSZ6dPeHsdYxFWYUBw5hvuc6Pf/tw5zQzxKulA1h8f2V3QdUtTJ+HFOEgsvKW3pqvkX/rH4IESpeFECBhdqjQXvvW0ZhfjDjKgud5iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699785; c=relaxed/simple;
	bh=4BH5qBp7d/apfGjVRN79/37yh2NrIAndniiSVDXcDms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=utfTiFao4cX73yV7h6xy5IXmtnLUnHc6qD78UXB7BUhL/WqsraUAGCBunKv8n0ME/yn98gf9fDC7M9h4i0WCW2kKXB0CLVPycakFNftbzR+05dRooDw1A6h+7p/C4Ru7rDsqlb5fo8KvQKZUYrjc9KHxhgPmP4BglsDHqxaYgh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Gf6aL0B4; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Gf6aL0B4"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hV3Yz4X2kz1XM4Tn;
	Tue, 25 Aug 2026 23:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787699774; x=1790291775; bh=cvX+ylpk9b8LiWwOaRJY0kOH
	k31lGuhmVps8jATT9IM=; b=Gf6aL0B4id7CXLF6GFEiHcY0bbnfV7P1Fte9Uy+4
	IFU2SldGTJ+TeU6J2AEXKbzoEe2H6mPRFaNdc2apgBJ6JN1DDg0p5C+7m1n83mnR
	ATbESQt32/y4mnbNVAZjGWXXelWpjGx3fNPAkHJ4Ytt1TCZ9rJ9BcvD3l+4tJ4M6
	v0oqqUwZ3X0+EjG3s32odCQdchuasITFh+MKL91pSj4NjtLxffKnJnQXOO+fTLgQ
	ufYOuBpZb9ZHKJu5EjpCwXnTqFGv5VcvWQtMdjbaWoGYMTmi4kMEYrhtjCMH8bjx
	eYG5vcrzKPa2WyhvTVrfFhlx3QDtbHOe8a8z60T3StKaLQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WZN1Ogep4yCr; Tue, 25 Aug 2026 23:16:14 +0000 (UTC)
Received: from [100.80.227.50] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hV3Yj4bJtz1XM4TB;
	Tue, 25 Aug 2026 23:16:08 +0000 (UTC)
Message-ID: <7e51bca8-218a-40b8-8ff8-fc59671f5add@acm.org>
Date: Tue, 25 Aug 2026 16:16:07 -0700
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c41e9198-86a8-4bcd-a608-6f457b24f345@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 8:13 AM, Tetsuo Handa wrote:
> On 2026/08/25 7:53, Bart Van Assche wrote:
>> A correction: it is not safe to call drain_workqueue() nor to freeze the
>> request queue in __loop_clr_fd(). I'm considering to modify the comment
>> in that function as follows:
> 
> you also recognized that we can't call drain_workqueue() or flush_workqueue().
> 
> Therefore, I chose to temporarily drop lo->lo_disk->open_mutex in order to
> make it possible to safely perform drain_workqueue().

My sentence was incomplete: I should have written that it is not safe to
call drain_workqueue() nor flush_workqueue() from __loop_clr_fd() while
the request queue is frozen. It is not clear to me how draining or
flushing the workqueue from inside __loop_clr_fd() could cause trouble
if this happens with the queue unfrozen since disk->open_mutex is not
acquired by the memory reclaim code?

Thanks,

Bart.
