Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D69B3B8959;
	Mon, 23 Mar 2026 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283201; cv=none; b=nG9IUb8AdfQSfOOaHShreyk2kyREetKRFonlXWEp5M2uAfh/ouuuG3/24zqEywr4lnqOx5VZgK+fttayYJc1DyG/AaATd5YGsvKHwJd92A+wPZWmBbHmrV1FqAOlT2ZrCHef0NNwyqZpubmRo0QI6/yXIqOKJKeH6ycU9//cJGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283201; c=relaxed/simple;
	bh=VR8utIjDTW7aSYJEFiut7g5ORWSt0EO2oE+gyiMEMiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+Fu1BtsufM8s1FzkAdqjV95OH5/x76pHbdAXUZ6D5uQR5jQTfHriyeg5OLYJ3b7neDSADnk3Ng71Fqr91pehjcQa2fowx3lqy6vv8gsomLm+ehrIXqdMVOa2Up3lyMtSqiT2ohSuLIopGO0wiK4vij6Z5+5Q1ayv5JtFjalCNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=uuVGHED5; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="uuVGHED5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VR8utIjDTW7aSYJEFiut7g5ORWSt0EO2oE+gyiMEMiQ=; b=uuVGHED5JOPP1xXa4K+lXUe3yH
	Dyy6FK1jDXtQYK2gOP7rkQ1j10SbtKV4xSEc0Yf5oCGBGl72PLm4tp+FTwoGMp5A5/90AJiaF6HQ0
	f75YrmQ+4If9oIjDOvNgwoCPI6/+J0Pm+MCOfTdzrG9M2xj6Ob5+mGeArrBa8rJkf53FLHU9FEWCS
	40bDqFrcmsRAgnjlRH7rBaSKsxnZ5/xLxa0Ri50tYgiVL3CbXbMoAT8bG39t6KQasy9cC+inLB76P
	tpWxfRD7s1OVCmLh4fqgOPBSYSulpDCAukhSEmiu9FJtF4S549qS45vGSJOEWPAWDRcmO0aDAUlB7
	F196ZpYA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w4i6t-007exf-A0; Mon, 23 Mar 2026 16:26:34 +0000
Date: Mon, 23 Mar 2026 09:26:28 -0700
From: Breno Leitao <leitao@debian.org>
To: Chuck Lever <cel@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, puranjay@kernel.org, 
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH v2 0/5] workqueue: Introduce a sharded cache affinity
 scope
Message-ID: <acFmcCcbPfznH_it@gmail.com>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
 <04af531d-d8a3-4fbb-993d-e1da2df62a03@app.fastmail.com>
 <acFVEr7iVnU_70yh@gmail.com>
 <f2f7fff3-2f6a-4ebb-aa5e-33188be4dd9a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2f7fff3-2f6a-4ebb-aa5e-33188be4dd9a@kernel.org>
X-Debian-User: leitao

Hello Chuck,

On Mon, Mar 23, 2026 at 11:28:49AM -0400, Chuck Lever wrote:
> On 3/23/26 11:10 AM, Breno Leitao wrote:
> >
> > I am not convinced. The wq_cache_shard_size approach creates multiple
> > pools on large systems while leaving small systems (<8 cores) unchanged.
>
> This is exactly my concern. Smaller systems /do/ experience measurable
> contention in this area. I don't object to your series at all, it's
> clean and well-motivated; but the cores-per-shard approach doesn't scale
> down to very commonly deployed machine sizes.

I don't see why the cores-per-shard approach wouldn't scale down
effectively.

The sharding mechanism itself is independent of whether we use
cores-per-shard or shards-per-LLC as the allocation strategy, correct?

Regardless of the approach, we retain full control over the granularity
of the shards.

> We might also argue that the NFS client and other subsystems that make
> significant use of UNBOUND workqueues in their I/O paths might be well
> advised to modify their approach. (net/sunrpc/sched.c, hint hint)
>
>
> > This eliminates the pathological lock contention we're observing on
> > high-core-count machines without impacting smaller deployments.
>
> > In contrast, splitting pools per LLC would force fragmentation even on
> > systems that aren't experiencing contention, increasing the need for
> > manual tuning across a wider range of configurations.
>
> I claim that smaller deployments also need help. Further, I don't see
> how UNBOUND pool fragmentation is a problem on such systems that needs
> to be addressed (IMHO).

Are you suggesting we should reduce the default value to something like
wq_cache_shard_size=2 instead of wq_cache_shard_size=8?

Thanks for the feedback,
--breno
