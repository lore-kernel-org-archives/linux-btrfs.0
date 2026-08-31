Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459254CCDED;
	Mon, 31 Aug 2026 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192893; cv=none; b=CdljANNH+DKTWqPqum6LZ3XME9zYjSwCNEni7ltT2YE2/tGPZBq8BGwo8oh3xVDdzZnJVrzjy97qdjVrRPIQ3/YHkqKsI1k+C3UfrDKMs+1UgcRkTRRdqiLf3Idr5DigazHlqaYFfLMix77G6WiFQXVkImyZlqH4kWyenJETQ30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192893; c=relaxed/simple;
	bh=QNwcsZjJFVrXdEUCCIjgAGniheS835dXsn4vUs5xqng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V+gNqCnXtJQcPHPbA2ZqbFwki+CVRi2ZsRpU8MZoDCeBV/IZb4ShPq3AVFUuf8MPxy+2q3fiC21M96kWFDk1OmnZ7QNFCxyhKgBososgzqSwzvzjOD++3K1SDTbEZZvQcc4AJ1nvnHOJBJLkYYAcqNXCI3I7RbijBuUOTRlsyKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4q1GZ52I; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4q1GZ52I"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hYYwp5WLdzlfvps;
	Mon, 31 Aug 2026 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788192882; x=1790784883; bh=QNwcsZjJFVrXdEUCCIjgAGni
	heS835dXsn4vUs5xqng=; b=4q1GZ52IPMwMCZTI7qns+0qxTqPa80tDzWBakZW8
	vh5ZTwqi9nR6cFCFQxzRhGLhzHTAGSmKZYUJ27rk+QkNb+kem+fKCm7oG8htVyuj
	/5Nj8OjyRZdz4P3B5H5CJgjzlwYcZykNZADke1kIyNKJSU+j363eV+SOEVpteawK
	rXk5QZmcPj/UwMMI3GgccRJij3GCu2qbUw1o5Z5fTRHJYtdhY2dWQyfsRx2s6M+6
	YmqO2AhIU3kol6ENGjFj7Yn4+25H8wDqRHElcRy1aHdotJhsS/xnN06IwOnimkuM
	pFE7/QbJT3IWe0FqRsDnz/goozangZuvn++9npvefaCzJQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mixfySwKtzaB; Mon, 31 Aug 2026 16:14:42 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:a104:ffdc:9983:687c] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hYYwX6WNtzlfvpM;
	Mon, 31 Aug 2026 16:14:36 +0000 (UTC)
Message-ID: <d7e26d4b-d9b9-47c0-9658-c241499209b5@acm.org>
Date: Mon, 31 Aug 2026 09:14:35 -0700
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
 <d0471919-9b71-4d24-9fb8-5f1d7f3792ca@acm.org>
 <903a22a2-432c-4e72-bc09-7898becf2f3e@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <903a22a2-432c-4e72-bc09-7898becf2f3e@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/26 10:17 PM, Tetsuo Handa wrote:
> Calling synchronize_rcu() makes sure that no more queue_work() calls are
> made from loop_queue_work() from loop_queue_rq(). Since loop_queue_rq() is
> called with RCU read lock, subsequent loop_queue_rq() calls which are made
> after synchronize_rcu() returned shall see lo->lo_state != Lo_bound and
> return with BLK_STS_IOERR.

Please add a comment above the synchronize_rcu() call that explains the
purpose of that call.

> That is OK. But after you agreed that my patch works as expected.
I appreciate your work and agree that this patch takes the right
direction. But I would appreciate it if you would take another look at
my review comments.

Thanks,

Bart.
