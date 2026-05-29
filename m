Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649713A63F2
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 22:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780092723; cv=none; b=oMP2fB2LSGofLGH46NuQ8trE4+4E2dM2sV6RjvAemv9AoZv28wf0CtNcSoCUk4PwWxE3LtUFUjO02RyRhcntIYosKA+YJqrKPXnA8XAYjkleEzDHQmD73Nf1LSUyp6F6pHlyCU2I78j63d3gYZ85F0bLWaCa7YujKjqfS3WkPXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780092723; c=relaxed/simple;
	bh=rTtWXRkGmOFHKkWMX67e65K7shDZcm3K7uYKMYItW+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1UX432W2ganmQ6dQcPb9WNa5CXotpbBwDI7pppgmm7VhL21djL1dUvxhGvNO5oPawNJ/NwJ84b0OnOu2S324mZvnhS1jVyb0ltKi296qcjmHNOA5rxiQnEOwlBB3Nuskl4E2DyNNgF6jqJ9ABLUqnScs+lQHRsbRdnZRTdrElA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1iZAYZd; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1iZAYZd"
Date: Fri, 29 May 2026 15:11:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780092719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UlOW+hFTxnTyPuwfT8t/meDWA/F956nGdipFeFxxKjQ=;
	b=v1iZAYZd0kgFFSjcicm7CjrlLzc8HDtah4rCwgGlHnzVxRhEr3Ejf7XO4jqNFAWRzai8d6
	3XX4KnarknevZcgW2v4l/10d/g7X1DTLmO/US6m+OcsiPdqXOKTWSKeUPE4QZNB8041AWs
	wbGNTXMYhwMBo/5YJTJvn+h32LWfQWg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: use lockless read in nr_cached_objects shrinker
 callback
Message-ID: <ahoPCcC_2RZROBcq@linux.dev>
References: <4c64ed769cbb827b8c55de8f89372fc27290feea.1780089816.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c64ed769cbb827b8c55de8f89372fc27290feea.1780089816.git.boris@bur.io>
X-Migadu-Flow: FLOW_OUT

On Fri, May 29, 2026 at 02:23:46PM -0700, Boris Burkov wrote:
> From: Ben Maurer <bmaurer@meta.com>
> 
> Under heavy memcg-driven slab reclaim with many memcgs and CPUs,
> shrink_slab_memcg() invokes the per-superblock count callback once
> per (memcg, NUMA node) tuple. For btrfs that callback reaches
> percpu_counter_sum_positive() on fs_info->evictable_extent_maps,
> which takes the percpu_counter's raw spinlock with IRQs disabled and
> walks every online CPU. With hundreds of memcgs driving reclaim on a
> host with dozens of CPUs, this counter lock becomes a global
> serialization point: profiles show CPU pinned in the spin_lock_irqsave
> acquire under __percpu_counter_sum, with cross-CPU IPIs hitting
> csd_lock_wait_toolong while waiting for spinning vCPUs.
> 
> The shrinker count is advisory -- super_cache_count() already notes
> "counts can change between super_cache_count and super_cache_scan, so
> we really don't need locks here." Use percpu_counter_read_positive(),
> which is lockless. Worst-case skew is bounded by batch * num_online_cpus
> (a few thousand), negligible compared to the millions of extent maps a
> busy filesystem accumulates and well within the noise that the shrinker
> already tolerates.
> 
> Tested-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Ben Maurer <bmaurer@meta.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
