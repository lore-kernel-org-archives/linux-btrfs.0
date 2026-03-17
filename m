Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C2534F486;
	Tue, 17 Mar 2026 11:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747141; cv=none; b=s3wIi+RQJOQujWKa49xdHvuEzhJJ05vf7GZGu9FesNrm/43998OyvrN2aBMtOQkamX+IsrlKM3PJxA4Z3n3zG7BvDgeX6NPKtkRAGKo0or8ZKNUN+P3iWuV0jRq0V6NI5OWc84Z60e5eN4odmwj25O/87TmFSAhUCOISKLnq244=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747141; c=relaxed/simple;
	bh=UWTSvxAlGGuyS5z7VDcNiiCEiejhuiDa72AmOtpQApU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1oD7D2ovSysKrgcEe3R95MsWyTAyDnYr7D7Ld/1BytkkbBAhol8KMqRoiqo66JeqQI1B3JB0mKs7vmrcfn0j5aDmHlgcJOcopDE/pxlP6N2WCfwMeJT0neHkUR6rMrpkh5ilUqdWLXMMcIZ+xPyXsl+Dicpe+0iLLyaxo34UzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=p/FpDRti; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="p/FpDRti"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=G31hXcPOimlJCCwoNzpI+vMSEg4NhwVwk7ZC9FRItGU=; b=p/FpDRti6QDbdeGLC8WP1aLSA9
	8mGebtDKU6c9PWFsrVDBAKvOhg482Y3wK/hbjGD7wmvHgDctqvMoYjf8n6FChNr+iPcfPbekLcyDK
	/scCPKuq2jzUUswxUAft7i8JBQB/ZHOMwB99qrmN4G2bdgJrKpSE6AO0wAphXOLkNgo8Hn40BuiD1
	PNq6EutYi/SYAn2oTSieXqYTb2ramKgaT4sHgYM+zwSp+8kY4WTkCk9/XZ7Pow3NPKJC5ylYvra18
	HJon4uLXOK53n9d4LBPyk6sjT0FeiqiaqxKmnOW4oojqKQ7Ss74slyD1z5CofinYH922a7OydlVEx
	SoBY2lQg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2Sem-002qz6-CT; Tue, 17 Mar 2026 11:32:15 +0000
Date: Tue, 17 Mar 2026 04:32:09 -0700
From: Breno Leitao <leitao@debian.org>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, puranjay@kernel.org, 
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH RFC 0/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Message-ID: <abk6PMrSDcb-yXZ9@gmail.com>
References: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
 <6b952e7087c5fd8f040b692a92374871@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b952e7087c5fd8f040b692a92374871@kernel.org>
X-Debian-User: leitao

Hello Tejun,

On Fri, Mar 13, 2026 at 07:57:20AM -1000, Tejun Heo wrote:
> Hello,
>
> Applied 1/5. Some comments on the rest:
>
> - The sharding currently splits on CPU boundary, which can split SMT
>   siblings across different pods. The worse performance on Intel compared
>   to SMT scope may be indicating exactly this - HT siblings ending up in
>   different pods. It'd be better to shard on core boundary so that SMT
>   siblings always stay together.

Thank you for the insight. I'll modify the sharding to operate at the
core boundary rather than at the SMT/thread level to ensure sibling CPUs
remain in the same pod.

> - How was the default shard size of 8 picked? There's a tradeoff
> between the number of kworkers created and locality. Can you also
> report the number of kworkers for each configuration? And is there
> data on different shard sizes? It'd be useful to see how the numbers
> change across e.g. 4, 8, 16, 32.

The choice of 8 as the default shard size was somewhat arbitrary – it was
selected primarily to generate initial data points.

I'll run tests with different shard sizes and report the results.

I'm currently working on finding a suitable workload with minimal noise.
Testing on real NVMe devices shows significant jitter that makes analysis
difficult. I've also been experimenting with nullblk, but haven't had much
success yet.

If you have any suggestions for a reliable workload or benchmark, I'd
appreciate your input.

> - Can you also test on AMD machines? Their CCD topology (16 or 32
> threads per LLC) would be a good data point.

Absolutely, I'll test on AMD machines as well.

Thanks,
--breno
