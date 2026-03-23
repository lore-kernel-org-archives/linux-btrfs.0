Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF5C2FE582;
	Mon, 23 Mar 2026 22:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774305813; cv=none; b=Fvazz4MNAtUCsB8RkG5sMlxI34w8eCUIFHWNbI4xLxid/QzbjH3Lcr/i74zGOwSthHJPqMBzrB7ZY1xArj+JYUvZ2G4pNBVi64wwgCglM9DrH8wkv4uD0P7HZQFJBxRYPw4abVtEaVimg9azyRNpjJBfS6dEWMLGZ1nBxz4xmRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774305813; c=relaxed/simple;
	bh=p7HO9XDY3c3UHOq/CP+xJ5mzqUGLPR+z711wGORLXB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EgGPnJJHGssCx5ifudbFL8Zl6LI20GjjJb3xpMTojaPax2gZ3hK9yWC7H5oqkQE0dPchMRYQh5iIpCi5b1wPVW8EdQn1QT1b0xw6UC5J2OtJ0gMHhs5jKWnlIhvCz07QRb0ckKjgm+WhHnx9nQjUI0VanH3LDUFhX+C86zCatVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DivkZfw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DivkZfw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C2EC4CEF7;
	Mon, 23 Mar 2026 22:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774305812;
	bh=p7HO9XDY3c3UHOq/CP+xJ5mzqUGLPR+z711wGORLXB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DivkZfw7m671l5LTyI2dgFK4rsbkxJDz2sfMji+C04PgU6YNzv/JHDcLwaQyFfLvn
	 bHn4dofGltCEG5wh0Qnuwd/CPUG1G/0OVuQrUi9p4I+j7CMikjQzOHbFouw/CzLMwc
	 I+BwDBJo9YZaaSYTmkQQSk0PbiXFTeBqMTLUsirG0oWKIfhK+AFZyQeHh3nC1Zux5h
	 5R7laKjklGBpYv7nV6yn6FQtPwmb2MUkDSzH3Q57Bvd4xnaBmhJW6E0AWyKYwh2cL6
	 S7J5csOBw1OufUCKKBQUDeqDInyWtXkS+SF4H1vNgiEfiPDCXFvqBCk3ZIwksj7fQh
	 i9bztM5CiZyEw==
Date: Mon, 23 Mar 2026 12:43:31 -1000
From: Tejun Heo <tj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, puranjay@kernel.org,
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com,
	Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH v2 2/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Message-ID: <acHCE96gzEUaGZFP@slm.duckdns.org>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
 <20260320-workqueue_sharded-v2-2-8372930931af@debian.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320-workqueue_sharded-v2-2-8372930931af@debian.org>

Hello,

On Fri, Mar 20, 2026 at 10:56:28AM -0700, Breno Leitao wrote:
> +/**
> + * llc_count_cores - count distinct cores (SMT groups) within a cpumask
> + * @pod_cpus: the cpumask to scan (typically an LLC pod)
> + * @smt_pt:   the SMT pod type, used to identify sibling groups
> + *
> + * A core is represented by the lowest-numbered CPU in its SMT group. Returns
> + * the number of distinct cores found in @pod_cpus.
> + */
> +static int __init llc_count_cores(const struct cpumask *pod_cpus,
> +				  struct wq_pod_type *smt_pt)
> +{
> +	const struct cpumask *smt_cpus;
> +	int nr_cores = 0, c;
> +
> +	for_each_cpu(c, pod_cpus) {
> +		smt_cpus = smt_pt->pod_cpus[smt_pt->cpu_pod[c]];
> +		if (cpumask_first(smt_cpus) == c)
> +			nr_cores++;
> +	}
> +
> +	return nr_cores;
> +}
> +
> +/**
> + * llc_cpu_core_pos - find a CPU's core position within a cpumask
> + * @cpu:      the CPU to locate
> + * @pod_cpus: the cpumask to scan (typically an LLC pod)
> + * @smt_pt:   the SMT pod type, used to identify sibling groups
> + *
> + * Returns the zero-based index of @cpu's core among the distinct cores in
> + * @pod_cpus, ordered by lowest CPU number in each SMT group.
> + */
> +static int __init llc_cpu_core_pos(int cpu, const struct cpumask *pod_cpus,
> +				   struct wq_pod_type *smt_pt)
> +{
> +	const struct cpumask *smt_cpus;
> +	int core_pos = 0, c;
> +
> +	for_each_cpu(c, pod_cpus) {
> +		smt_cpus = smt_pt->pod_cpus[smt_pt->cpu_pod[c]];
> +		if (cpumask_test_cpu(cpu, smt_cpus))
> +			break;
> +		if (cpumask_first(smt_cpus) == c)
> +			core_pos++;
> +	}
> +
> +	return core_pos;
> +}

Can you do the above two in a separate pass and record the results and then
use that to implement cpu_cache_shard_id()? Doing all of it on the fly makes
it unnecessarily difficult to follow and init_pod_type() is already O(N^2)
and the above makes it O(N^4). Make the machine large enough and this may
become noticeable.

> +/**
> + * cpu_cache_shard_id - compute the shard index for a CPU within its LLC pod
> + * @cpu: the CPU to look up
> + *
> + * Returns a shard index that is unique within the CPU's LLC pod. The LLC is
> + * divided into shards of at most wq_cache_shard_size cores, always split on
> + * core (SMT group) boundaries so that SMT siblings are never placed in
> + * different shards. Cores are distributed across shards as evenly as possible.
> + *
> + * Example: 36 cores with wq_cache_shard_size=8 gives 5 shards of
> + * 8+7+7+7+7 cores.
> + */

I always feel a bit uneasy about using max number as split point in cases
like this because the reason why you picked 8 as the default was that
testing showed shard sizes close to 8 seems to behave the best (or at least
acceptably in most cases). However, setting max number to 8 doesn't
necessarily keep you close to that. e.g. If there are 9 cores, you end up
with 5 and 4 even though 9 is a lot closer to the 8 that we picked as the
default. Can the sharding logic updated so that "whatever sharding that gets
the system closest to the config target?".

Thanks.

-- 
tejun
