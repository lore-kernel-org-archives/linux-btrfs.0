Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634780;
	b=PAfN5Ihn36zSODYqeaYnDB25CRL3kPqCzW1VySiHp6A9nJkwyCpUN1KSESB8Oow2FGbL
	 +KcoY3vJ9OHS5bqHBxJAqidza+avRfy3iFpFHKRteiAECNbX792zxBQmUL7TWdAXvkNiK
	 rdYt4fudwgGXfYGSXz1xX1nx7rSo4kPMT8UVLv/b9ac1PNK7lI/3+8dFzCA13uHioYz1i
	 P3LwBCSKC3dnvT7LKr7AB+quBuNfFqZrxEhFuVirZ/wMEw1ac2fEJdQWYB12kLcr8ohLX
	 vwS3C4bJ0X7K95hy9AsbPHRYRVqD4RjcVy88Vzp96c89UDdUTOEdEGn0tk0aR7poPEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634780;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=qJ9CDNyfi0b8bi4oc+B3vwfFf2lhdQn7U7nevKnjIhk=;
	b=kYsVG+2J2KjcM6Rc4v2SqM353CRKX+OHUcInZnYM1FonR91Aj04VYGce3soJG/Vuxx0s
	 W/nOKw8InyWEyfAEkcsByV+3mOqQNs4YAoMok977vMkS79/3Bp8JB4c7M7JRDAFlPPAtV
	 RMTckR5OslBD0KwcsJacVGMHGOfPCN37CfaAm0V0hlGKppqTX6aELVVQ4PPHKJI3kz3DR
	 zf43X73aZc/bckzl4KEv2b7V78bu8YTSMYVodRadrFVrqueBGbh15GshEWa4Fe8LrrXFR
	 dn1bgD0CbFceXt/XUKUSKKei4RQqwFrMRuTleqjNZ8cXZSRKy74gDyuVCPjRrANjoHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=sLffMh0B;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=V0mwhSgj;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854CB606A584;
	Mon,  2 Nov 2026 15:52:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 854CB606A584
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=sLffMh0B;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=V0mwhSgj
Date: Mon, 2 Nov 2026 16:52:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1793634775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qJ9CDNyfi0b8bi4oc+B3vwfFf2lhdQn7U7nevKnjIhk=;
	b=sLffMh0BUO9IemDLOjs2NyYeRf3SeBlmqDJBrgKsW9IQjwZZzCRZjTNz+JFi1uOQHs2JhO
	t8n6uXSvMZ+oEa0OKraydUhCf2hvFsnlGcy+2gCaZkxXoQH7BC/UNVde3v/fdHWtYlLMib
	gJBvkn3kY3U27G2+1txgjxx7eRmqCtaCxNEWIag/w8whkmGPX2eAZh1rAYRE439rC+UaRO
	GkTaHit3rbRpqs4EVS/9T6+DmLTFeJfnN1I5oBLDp0yGwEoos5HnY0QDDQ/CyQBDXE/zKJ
	eoU0Or7EzryAhwfrG4NmQLyehXZlkYaOSK2bZ1pLynT5JDjAgec2uKFbXgUKAg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1793634775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qJ9CDNyfi0b8bi4oc+B3vwfFf2lhdQn7U7nevKnjIhk=;
	b=V0mwhSgjH0D0MmkE+M1GdYLYtfHRZlsuGY/SEpKYqSfuqBsTdtcz9evLm985JJo9IRPPEE
	eLtdPYemoOCgQ6DQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org, "Naulls, Peter" <PeterNaulls@eaton.com>,
	linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a livelock in wait_for_commit() on PREEMPT_RT
Message-ID: <20261102155254.XxBU8-kd@linutronix.de>
References: <20261030153617.329733-1-neelx@suse.com>
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
In-Reply-To: <20261030153617.329733-1-neelx@suse.com>

On 2026-10-30 16:36:17 [+0100], Daniel Vacek wrote:
> Peter reported [1] that running multiple RR tasks doing sync()
> on fully preemptible kernel may starve other/normal sync() tasks
> due to fs_info::trans_lock turned into rt_mutex.

I don't want to nitpick here but 
/fully preemptible/PREEMPT_RT 
/RR/SCHED_FIFO or maybe better /RR/real-time priority

> This is caused by RR tasks contending over the mutex with priority over
> other tasks, which in turn lack progress and they are no longer able to
> remove TRANS_STATE_COMPLETED transactions from the fs_info::trans_list.

Yes, the important detail is that rt_mutex gives the lock to the task
with the highest priority even if it comes last and the long waiting
SCHED_OTHER will remain waiting. In contrast to raw_spinlock_t (the
spinlock_t on !PREEMPT_RT) will rotate over every waiter.

> The offenders start looping in wait_for_commit() expecting the completed
> transactions to get off the trans_list but since they're bouncing the
> trans_lock the tasks with other/normal priority which are about to delist
> such transactions never get a chance to do so due to lower priority.
> 
> A simple reproducer can be found in the mentioned email thread [1].
> 
> The situation can be resolved by boosting the priority of the starved
> tasks or dropping priority of the offenders. Thought this fix prevents
> the situation from happening in the first place. We simply delist the
> transactions before changing them to completed state. That breaks the
> loop condition.
> 
> [1] https://lore.kernel.org/linux-btrfs/SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com/
> 
> Reported-by: Naulls, Peter <PeterNaulls@eaton.com>
> Fixes: 5fd76bf31ccfe ("btrfs: fix relocation crash due to premature return from btrfs_commit_transaction()")
> CC: stable@vger.kernel.org # 5.15+
> Tested-by: Naulls, Peter <PeterNaulls@eaton.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>

Thank you for looking into this.

Sebastian
