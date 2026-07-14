Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C380444C654
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 19:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784058108; cv=none; b=bLIpVFfkXtPuFIJbcCr98UlVyWjgkw458yzvxdsEUYJfeuaPYKNsZtzqVrZ9k3vwTHQ4Ash1j9MlyqZ9cvvxR939d64K7+juT9VHH3YMbhtgQHap4w0ULMnUkgjPHW6HBkcd4/mR5R3xd9o7f7eVZb8aWiJQTq/YMwYqeDcLGRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784058108; c=relaxed/simple;
	bh=MJOPfZgWoOuY9WoaTSgn/QRExxhrG9WiL/2+OlLbqn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7HL0rdrT7wVGw9QGwPMzXWskf4Ha2Eg3JKM7hxWTAPb3aE9JQ9v/Tr+Ci53sSB91wpQ2C5ThVSEtzdPu98eb8NoPjC6nknUw1WjlpZTBmxb6MSPro1erw7M7jgrfpumEsfv2dqI0C6ACNf5/gFvUr2Fqbn4g1+W781wuM+ziFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zl8Y98I6; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zl8Y98I6"
Date: Tue, 14 Jul 2026 12:41:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784058103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kYcYCSULV/hfG7U7cWmlPQ/oHtSU1VEtwNwKSB8CpEM=;
	b=Zl8Y98I6TSwbZ6r8suDxniwyylFwFl2e1Uau1HCcE8ii377yG/8MagwcljzpEk0YOb8REZ
	qHJAuCBiRirQETZGb7LWtF5StJUHNQdqGjh3TlG5a6CDN6PbPEj9NBsA88g0TA5LrGRNq2
	e6ARkIOGoJ2oH9RrVX684FV/RY5Ob9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, qi.zheng@linux.dev, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
Message-ID: <alaQ0VgxOuLVoYbU@linux.dev>
References: <20260714101454.1202449-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714101454.1202449-1-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 14, 2026 at 03:14:54AM -0700, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skips the
> ->nr_cached_objects() hook whenever the shrinker is invoked for a
> non-root memcg, because none of the current implementations (btrfs,
> xfs, shmem huge) honour sc->memcg.
> 
> That policy is really a filesystem-owned property: fs/super.c should
> not encode the assumption that these hooks are never memcg-aware,
> since a future implementation might legitimately filter by sc->memcg.
> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
> and shmem_unused_huge_count() so each filesystem can lift the
> restriction independently once its underlying counters/scans become
> memcg-aware, without needing a coordinated change to fs/super.c.
> 
> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
> still early-return 0 for non-root memcg contexts, keeping the shrinker
> bit clearable in each memcg's bitmap; the global (kswapd or root
> direct reclaim) path still drives them as before.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
