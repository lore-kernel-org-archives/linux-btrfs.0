Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A809E394462;
	Mon, 24 Aug 2026 22:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787612047; cv=none; b=SOZzIhNqWMGm5dUiXAS/gt2kt1yivBzEpweZHViCVeukjbwyyW23VZI5fhLLEgTaDkjbqQ/Jw853bddY2lADkqIomSLg26MIhS4lqBWDn0cl6puURr6aD3coCgZQ4Ea/NkEj91RDg1oJguxNqDaXMYCGcMm731CTasDHcSovh/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787612047; c=relaxed/simple;
	bh=fIEAMrSn9qVQ98whfUHmurKZ4stg2V53zJ0ACfdmkeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E2TvJ5125b8QEBgTxXt0l+T16f3ZWL3GH6Po5z7EL89sRxhz8bTaeex5hpHZzSi9IfPBBSH6i2ysy1UB7d8t9loYkCF3vJirnlPnkxMG6B50X3JaJIGk2fHJukHWgO2AaOkc7SG0zRPeqQ4DVxAvhM/KGwtW+XGQu1oKGTjZXxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kUqnjA6H; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kUqnjA6H"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hTR6h757LzlfwgD;
	Mon, 24 Aug 2026 22:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787612036; x=1790204037; bh=fIEAMrSn9qVQ98whfUHmurKZ
	4stg2V53zJ0ACfdmkeQ=; b=kUqnjA6H9nOu4wBYMHnD7nwetgrycZRz51bh5y/0
	zH+m1DmsVM5A0DCd7qxFTgXiLlLv+KUD9zt4qa5PBc770BaMXnZFbUxUqx4MW+sR
	6XcFqztDi1bYRJ4cf+N1SOlqOd8btwrlPsyU+vYGh++wTY7eLQ9ec7fvOTvmpcM/
	H5wV3P6DBUy1Fj4soCOKKPx6dxgrKf/pFJpXK73tCXLWDSkjmX9GdZeIMda3zjXa
	2JInEovsFqJupAZBtZUgFCkLCdZPx/OEe7QVgN1bsGGK7cLDUizDGFyi8wGRafFd
	TDE6tcjBYGVZWFR7wnnNBqWH5PjjOO4fTLJp0o9HH5fAPg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7GE_wI3mRROZ; Mon, 24 Aug 2026 22:53:56 +0000 (UTC)
Received: from [100.80.227.50] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hTR6Q6ZQbzlfvq9;
	Mon, 24 Aug 2026 22:53:50 +0000 (UTC)
Message-ID: <372ca5f6-81a0-4f6c-8f55-ebeeada9f955@acm.org>
Date: Mon, 24 Aug 2026 15:53:49 -0700
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
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Damien Le Moal
 <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, lkp@intel.com,
 oe-lkp@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
 Hillf Danton <hdanton@sina.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Brown <broonie@kernel.org>, Oliver Sang <oliver.sang@intel.com>
References: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
 <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
 <38ad64c1-edc7-431d-8f52-fba572ebf3eb@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <38ad64c1-edc7-431d-8f52-fba572ebf3eb@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/24/26 3:06 PM, Tetsuo Handa wrote:
> but sashiko found problems with Bart's series ( https://sashiko.dev/
> #/patchset/8330ca0e-b4d9-451a-bc0d-a50178194ea8@I-love.SAKURA.ne.jp
> and https://sashiko.dev/#/patchset/2efb1032-34b9-4c31-
> b6fc-4aa9b1d60895@I-love.SAKURA.ne.jp ).

Thanks, I had not yet seen this feedback from Sashiko. My conclusion is
that two of the three Sashiko findings are wrong. I will fix the third
one - the finding about the potential wait-die deadlock.

> I still cannot catch why Bart's approach can become safe without
> synchronize_rcu() and drain_workqueue().

Agreed that drain_workqueue() or flush_workqueue() is necessary. I do
not agree that an explicit synchronize_rcu() call is required. Waiting
until the request queue is frozen includes this call implicitly.
See also __percpu_ref_switch_to_atomic().

Thanks,

Bart.


