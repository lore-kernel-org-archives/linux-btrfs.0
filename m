Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597821;
	b=uytBZ10L3azBT4EW6OFmmalXvQtvlZUL8QHqXRe2Bhmma85Cxp76Y8nB6doLGFgaOkD3
	 k9dH1US4GGJOAlRAr9/ilNR7E/5fGA9PP0yPwkcdG7vKK8jLQLsrMjhihifyVyepGo3XP
	 CaLdYFRmFe+iVq5a0kQhhIrvo/ifHcusn0GMc2VGCBNwDDc5Y0IluvdDIkkb2gstN0WaW
	 /GmGq5KUxK41lT8Ixy0FipxjyGuFYnAcxjho8UHJi73Ro1GskiSnHn6TZAs3Syzi1K1gt
	 6toNWzLnEL8PYPf7usyQSryVNx2i8nS+pIrmCUqTHcao4KEOe3S3qra+BGSdlma3ZbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597821;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=WsY84P16KeimIz5gXF6FcGD1XJprhsKw4H+ygHCLq9s=;
	b=T9hObrV0NIr3s3EzndCrF+c8qsInKTM8Pw6Ub2/A4CNkhYcfeCcsYAzIg5TPTr0dS0m0
	 qN8KOovfGftSChKseXPAn18hEayx+Ai7UrgBDizatzahiaqBzy0rSUNnx+ohUJ30gHqKD
	 tvDCR11JpV/V7wJb/6LoC/J98QhLyA/vzwOh2mX2vP37raze7RElr+8gTYyY9lm7e8cRX
	 KYXdg+1Xz12+Itqt3jIjOjzUfq2bOkqgTLvSmox9q0Q3u0KQ9JhXbPBle/VPrQbUDgas2
	 R12X4cG01k7WglztT/oCcb2giViwjDVUgdW/c1rBYJoq3FV8yMxXGNH45nqMiPs5p+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=4MQxv9hU;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=w8m72e7c;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C543F606A31A;
	Wed, 21 Oct 2026 15:50:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C543F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=4MQxv9hU;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=w8m72e7c
Date: Wed, 21 Oct 2026 17:50:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792597818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsY84P16KeimIz5gXF6FcGD1XJprhsKw4H+ygHCLq9s=;
	b=4MQxv9hU0739vQ9rTwM+1H0w83Gr2oPT2V1FIAaYP+SV+z9u+xrVn1dZbXcwZ3jwPKgMo0
	fP35PZRFVhrel8IMbt/MJ9zyDq95JXzha4cwqHD98jmaStTN/zrukNWYlk2QchcoEMlq/f
	godHp4ldZdcUOHTqRBPuHEUbO98vGa10LbAtNSVOaB31lb2i2K7OoXf8EvglsnptBEdi2r
	NR4FOE+oByj49ChIm24krdCJbU56ETPQc+7W35jnIy0ago0L152MTmmUX+3aUhRE7+iuAY
	1IGvgM5mt6FNCngE7Q3BaVWTcbu7E5eDaMkjkxGwpsAbbDU0qv1nqsUmgXRGkQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792597818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsY84P16KeimIz5gXF6FcGD1XJprhsKw4H+ygHCLq9s=;
	b=w8m72e7cAVC5lH5Y8XTvnzm2KOXIF3xQKnbpXJbcCw6UT/QXBafqb5nZwU+DM2RHGjSu2z
	ki0CmJIrKJvUehBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Naulls, Peter" <PeterNaulls@eaton.com>
Cc: Daniel Vacek <neelx@suse.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
Message-ID: <20261021155016.1isOptPI@linutronix.de>
References: <PH0PR17MB4277167A37B20340B231443FBB922@PH0PR17MB4277.namprd17.prod.outlook.com>
 <SJ0PR17MB4288FC2E7FFB577F5D6C6D9EBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <CAPjX3Ff-zn2hda=deMvCGM1UMM6Zghh-ywabBMTqFUbzC69YEA@mail.gmail.com>
 <PH0PR17MB427723A82BCB2A6FCD37B329BB662@PH0PR17MB4277.namprd17.prod.outlook.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <PH0PR17MB427723A82BCB2A6FCD37B329BB662@PH0PR17MB4277.namprd17.prod.outlook.com>

nice to see that you have made progress.

On 2026-10-21 14:46:34 [+0000], Naulls, Peter wrote:
> As to why this needed an RT kernel, from copilot (so handfuls of salt):
> 
> "The RT kernel changes how trans_lock behaves. In btrfs it's an
> ordinary kernel spinlock, and PREEMPT_RT turns kernel spinlocks into
> priority-ordered sleeping locks. That change turns the loop into a
> starvation.
> 
> Without PREEMPT_RT, trans_lock is a real spinlock:
> 
> Tasks waiting for it are served in arrival order, regardless of
> priority. Once the committer asks for the lock, it gets it after the
> tasks already ahead of it.
> Taking the lock disables preemption, so the committer can't be
> preempted between getting the lock and removing the transaction from
> the list.
> The SCHED_RR waiters still loop, re-finding the finished transaction,
> until the committer removes it. But the committer gets through
> quickly, so the loop is short. The worst case is the contention and
> lost throughput the maintainer describes.
> 
> With PREEMPT_RT, spin_lock() uses an rtmutex. Three things change:
> 
> Waiters queue by priority, not arrival. Each looping SCHED_RR/25
> waiter goes ahead of the SCHED_OTHER committer.
This is correct.

> A higher-priority task can take the lock from a woken waiter. When the
> lock is released and the committer is woken to take it, an RT waiter
> that asks before the committer runs can grab it first. The RT waiters
> ask constantly, because their loop never sleeps: each finds the
> finished transaction still listed, sees it's complete, and goes back
> for the lock.
> Everything is preemptible. The committer, and anyone else holding the
> lock, can be preempted by RT tasks at any point.
> The RT waiters keep the lock in their own hands, while the one task
> that could end their loop waits behind them indefinitely. That's the
> livelock."

That sounds plausible. I did ask if RT tasks are involved and I think
the answer as no. With just SCHED_OTHER tasks it behaves as spinlock_t
on !PREEMPT_RT (except for the preemption which should have no impact).

Sebastian
