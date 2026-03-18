Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B366356A37;
	Wed, 18 Mar 2026 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856290; cv=none; b=s9Mmv3+KoLLzTnc4/J8kj1OfmEJsehHFwtHV5TwJKWWR87Y6UXBCibpj++OogIx6pflwV2Kg9oVcotLuPasDRC8tV0l02HouyDNPtOa2t1aHRvgxs1oM9JbJb/uIphniiRMZswBpnPp09a3DuRS6BYxIVPUPZvUnEF+I4pjfsIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856290; c=relaxed/simple;
	bh=EDBlyoiXkGjVuAtMcXzb2GV3zjSDR/jqOI6A7Tor6XU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ChWiA3rf2QcbkZLCNJ0lN1BNDQq4FAXlAED1nE7mx61umRWFBKcI1B2x5R5RNGYX8sjAKShVSdS9vwK6yifxz4JbFKlSrUNgLSwH5LHtXZzk5i8jAl/KCLBE7rCaEH1EBsZSrCnB8qdcfR+Z5uv5x0ICsxhnFX9B/WjOJl6mGs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=QcFw9CJV; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="QcFw9CJV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=EDBlyoiXkGjVuAtMcXzb2GV3zjSDR/jqOI6A7Tor6XU=; b=QcFw9CJVBL6yssnKmxjONDY8GT
	TnExAMBio7BoAKwzlOeeFZT5m0ky9C001Nz83bRqK+srspqtao9/Y+i8mMIl8FMjsxkwPru9HL4jz
	wR+pTmvS8KrhpqvJEBvvhGWtESUQnvxi/EJTg7Rtr+eH989lwNvJRSEOBF+cB/8T76q/YyDwMYL2k
	+agw7FtPxcy2Air2RTt1LD7ydjwkDxmRU31hfPoZhKLDpl7ovK/oXx0RSTyQq5+L9+SAH2tfOj6b9
	U6oL4ZFPssGJgPIFA/TlM23AW3+jzslv64z0PgyQB5vWJoGOLx5Bfh1+SPvD4KGcPg/T9eahPig/c
	uVtdMhuA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2v3B-003pWI-JT; Wed, 18 Mar 2026 17:51:20 +0000
Date: Wed, 18 Mar 2026 10:51:15 -0700
From: Breno Leitao <leitao@debian.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, puranjay@kernel.org, 
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com
Subject: Re: [PATCH RFC 0/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Message-ID: <abrkrZc52h0vcTTj@gmail.com>
References: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
 <6b952e7087c5fd8f040b692a92374871@kernel.org>
 <abk6PMrSDcb-yXZ9@gmail.com>
 <30adaf6c-657c-41f1-9234-79d807d74f02@oracle.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30adaf6c-657c-41f1-9234-79d807d74f02@oracle.com>
X-Debian-User: leitao

On Tue, Mar 17, 2026 at 09:58:54AM -0400, Chuck Lever wrote:
> On 3/17/26 7:32 AM, Breno Leitao wrote:
> >> - How was the default shard size of 8 picked? There's a tradeoff
> >> between the number of kworkers created and locality. Can you also
> >> report the number of kworkers for each configuration? And is there
> >> data on different shard sizes? It'd be useful to see how the numbers
> >> change across e.g. 4, 8, 16, 32.
> >
> > The choice of 8 as the default shard size was somewhat arbitrary – it was
> > selected primarily to generate initial data points.
>
> Perhaps instead of basing the sharding on a particular number of CPUs
> per shard, why not cap the total number of shards? IIUC that is the main
> concern about ballooning the number of kworker threads.

That's a great suggestion. I'll send a v2 that implements this approach,
where the parameter specifies the number of shards rather than the number
of CPUs per shard.

Thanks for the feedback,
--breno
