Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487113B5301;
	Mon, 23 Mar 2026 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278671; cv=none; b=s8yrG5eotwbZW1r1WP3s8sTxXZq1D/axQ9t1vdcSyNaBhyxsfdRsyDI1sK65fG9NFCn0aeTVE8pH65UxoepMNK8WEU5X0COOsFfmgiyrI8moLRR/FpJwzonFAIUzK0yKJ7GxGuuyRpftuQqQd0Xb2qBkzn+aW7496MzxZqKkzd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278671; c=relaxed/simple;
	bh=mD//i5XRZJZ3kG19Mr3ncYKm5fT+bbjvQHIx6flbo9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WzhK/cq/Mb1QWybxe7ZV7hrUdtl/9CLKYQu6jywUDTfZ+eob5kbvddpNpcBt2e8oD0+xb1rLp4QcAfnge2w06aUHh+taItoqSh3GDLlS+Wbw/cjJHkkzyLKM+E+Pq3+7oQNh8EqryuLYVJMNQGXgIze/VJL/4IiOdADRq8neIbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=pcxjVpCA; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="pcxjVpCA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=BOT1joVeBvRJNf048C/pia2Ig6BTdwxHvSGJf+KwT8A=; b=pcxjVpCAEzQJjMWXqIUUflRuRW
	IaKQMKXOQaWPREOVL4QftsUUDADpff/r1QoXD1QOo9KACGm3p1LhHnEqlIY6XadW0eS41WtRY+S3k
	szzHV9FlInE7pEQJRtacLvRG2d120+okrBHZlljgWhJgAMQ19P5GcUq2HfoQ01B4o/RpRvKqnXK/D
	Z1qchjODVi100Ws206MkC43Y2BzM8bPA5GJ6PHBDCYTaHe+1TPyRJ+zO56rx1mEjQ3fVOcME2lk+4
	/GC5P5cT31sCeATh/zJT2VwFOrKHwFnuFRqqmPs26KdExhDbBxod6fgdEcQNl6jyuUvM9M5DcpfSl
	p0IsefkQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w4gvn-007cJ7-M8; Mon, 23 Mar 2026 15:11:02 +0000
Date: Mon, 23 Mar 2026 08:10:57 -0700
From: Breno Leitao <leitao@debian.org>
To: Chuck Lever <cel@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, puranjay@kernel.org, 
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH v2 0/5] workqueue: Introduce a sharded cache affinity
 scope
Message-ID: <acFVEr7iVnU_70yh@gmail.com>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
 <04af531d-d8a3-4fbb-993d-e1da2df62a03@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04af531d-d8a3-4fbb-993d-e1da2df62a03@app.fastmail.com>
X-Debian-User: leitao

Hello Chuck,

On Mon, Mar 23, 2026 at 10:11:07AM -0400, Chuck Lever wrote:
> On Fri, Mar 20, 2026, at 1:56 PM, Breno Leitao wrote:
> > TL;DR: Some modern processors have many CPUs per LLC (L3 cache), and
> > unbound workqueues using the default affinity (WQ_AFFN_CACHE) collapse
> > to a single worker pool, causing heavy spinlock (pool->lock) contention.
> > Create a new affinity (WQ_AFFN_CACHE_SHARD) that caps each pool at
> > wq_cache_shard_size CPUs (default 8).
> >
> > Changes from RFC:
> >
> > * wq_cache_shard_size is in terms of cores (not vCPU). So,
> >   wq_cache_shard_size=8 means the pool will have 8 cores and their siblings,
> >   like 16 threads/CPUs if SMT=1
>
> My concern about the "cores per shard" approach is that it
> improves the default situation for moderately-sized machines
> little or not at all.
>
> A machine with one L3 and 10 cores will go from 1 UNBOUND
> pool to only 2. For virtual machines commonly deployed as
> cloud instances, which are 2, 4, or 8 core systems (up to
> 16 threads) there will still be significant contention for
> UNBOUND workers.

Could you clarify your concern? Are you suggesting the default value of
wq_cache_shard_size=8 is too high, or that the cores-per-shard approach
fundamentally doesn't scale well for moderately-sized systems?

Any approach—whether sharding by cores or by LLC—ultimately relies on
heuristics that may need tuning for specific workloads. The key difference
is where we draw the line. The current default of 8 cores prevents the
worst-case scenario: severe lock contention on large systems with 16+ CPUs
all hammering a single unbound workqueue.

For smaller systems (2-4 CPUs), contention is usually negligible
regardless of the approach. My perf lock contention measurements
consistently show minimal contention in that range.

> IOW, if you want good scaling, human intervention (via a
> boot command-line option) is still needed.

I am not convinced. The wq_cache_shard_size approach creates multiple
pools on large systems while leaving small systems (<8 cores) unchanged.
This eliminates the pathological lock contention we're observing on
high-core-count machines without impacting smaller deployments.

In contrast, splitting pools per LLC would force fragmentation even on
systems that aren't experiencing contention, increasing the need for
manual tuning across a wider range of configurations.

Thanks for the review,
--breno
