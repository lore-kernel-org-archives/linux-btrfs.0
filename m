Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033BF40DFDA;
	Thu, 19 Mar 2026 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929000; cv=none; b=Rw2pkPQqHtyzoMRbocLK1fSlywWnHzOXR2+dsC9YpnesDl4wUe68S9ulv6IBn+lo9J+KCvlWaihI5x0hXP6G9VOZAmD+r514lR9eFWke6TctjR+Pl7ML487k+I8xKVGFoMNqHlc2F5fhyzKgp/yi4hiRYnFTVnGt+Low2IP0h6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929000; c=relaxed/simple;
	bh=rrK1DEKvdfzzbViu1VH4kX9mz5h9D1buXrSBejxy2QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vC9ibgS2Lk8DbZ1HdztsSJ/Ur9miJnFbNHZ7Ly66BrpcYNFvKQWyOtgeQldNlHSCewEDsTF2/doZ9GsDRMrjxT/+dwuZDtdCJCH/3yB6Jc4mQ5zDrjOvDMssJyOVLU6BTVpaQD5hDGLeuvpCa21pg+wu575OAScbToRhKOEXs1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=gXc7ztyR; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="gXc7ztyR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=lrKQ0lUDcZ4n9cZJSU/bLkmFE9iZLfmP9PtFseK4jVk=; b=gXc7ztyReVEoTPs5EeLZ5HOYef
	JDz07PAsrL0Bu/OfZbL1MB+cwr24V/8hRIyPKMBsQ08vS4WGMDqB+j08sKMOq0yEWsMqgW6Ae5Twl
	19ryY3XOCjQINeMB4rywXX0b+vZaCF7BFgkIzktVyWxrVgLFg+R8eT3G+bsWwx5NOAJxhJk31ujGA
	yKjXucQe8s/altsMY6nXdcSqbcAKDuR3YyZzzPJ0sBv8kp0wBsJpEDAWs0SN0kSO6LEz3eNQfOXC2
	MSFxEQJ6adO3UQu4p2d8myMpiC8X5Vm37idRuiLj+OYKskQOHscejUeM42U3dOIXKV2P6Z879Z3Nm
	mG0KnuDA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3Dxp-004To0-2l; Thu, 19 Mar 2026 14:03:04 +0000
Date: Thu, 19 Mar 2026 07:02:58 -0700
From: Breno Leitao <leitao@debian.org>
To: Tejun Heo <tj@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, puranjay@kernel.org, linux-crypto@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com
Subject: Re: [PATCH RFC 0/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Message-ID: <abv8CBeQMlB-Zb2z@gmail.com>
References: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
 <6b952e7087c5fd8f040b692a92374871@kernel.org>
 <abk6PMrSDcb-yXZ9@gmail.com>
 <30adaf6c-657c-41f1-9234-79d807d74f02@oracle.com>
 <abrkrZc52h0vcTTj@gmail.com>
 <absud4FKm-3Trvjj@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <absud4FKm-3Trvjj@slm.duckdns.org>
X-Debian-User: leitao

On Wed, Mar 18, 2026 at 01:00:07PM -1000, Tejun Heo wrote:
> On Wed, Mar 18, 2026 at 10:51:15AM -0700, Breno Leitao wrote:
> > On Tue, Mar 17, 2026 at 09:58:54AM -0400, Chuck Lever wrote:
> > > On 3/17/26 7:32 AM, Breno Leitao wrote:
> > > >> - How was the default shard size of 8 picked? There's a tradeoff
> > > >> between the number of kworkers created and locality. Can you also
> > > >> report the number of kworkers for each configuration? And is there
> > > >> data on different shard sizes? It'd be useful to see how the numbers
> > > >> change across e.g. 4, 8, 16, 32.
> > > >
> > > > The choice of 8 as the default shard size was somewhat arbitrary – it was
> > > > selected primarily to generate initial data points.
> > >
> > > Perhaps instead of basing the sharding on a particular number of CPUs
> > > per shard, why not cap the total number of shards? IIUC that is the main
> > > concern about ballooning the number of kworker threads.
> >
> > That's a great suggestion. I'll send a v2 that implements this approach,
> > where the parameter specifies the number of shards rather than the number
> > of CPUs per shard.
>
> Woudl it make sense tho? If feels really odd to define the maximum number of
> shards when contention is primarily a function of the number of CPUs banging
> on the same CPU. Why would 32 cpu and 512 cpu systems have the same number
> of shards?

The trade-off is that specifying the maximum number of shards makes it
clearer how many times the LLC is being sharded, which might be easier
to reason about, but it will have less impact on contention scaling as
you reported above.

I've collected some numbers with sharding per LLC, and I will switch
back to the original approach to gather comparison data.

Current change:
https://github.com/leitao/linux/commit/bedaf9ebe9594320976dcbf0cb507ecf083097c0


Workload:
========

I've finally found a workload that exercises the workqueue sufficiently,
which allows me to obtain stable benchmark results.

This is what I am doing:

  - Sets  up a local loopback NFS environment backed by an 8 GB tmpfs
    (/tmp/nfsexport → /mnt/nfs)
  - Iterates over six fio I/O engines: sync, psync, vsync, pvsync, pvsync2,
    libaio
  - For each engine, runs a 200-job, 512-byte block size fio benchmark (writes
    then reads)
  - Tests each workload under both cache and cache_shard workqueue affinity
    scopes via /sys/module/workqueue/parameters/default_affinity_scope
  - Prints a summary table with aggregate bandwidth (MB) per scope and the
    percentage delta to show whether cache_shard helps or hurts
  - Restores the affinity scope back to cache when done

The test I am running could be found at
https://github.com/leitao/debug/blob/main/workqueue_performance/test_affinity.sh

Hosts:
======

 * ARM (NVIDIA Grace - Neoverse V2 - single L3 domain: CPUs 0-71)
	# cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u
	0-71

 * Intel (AMD EPYC 9D64 88-Core Processor - 11 L3 domains, 8 Cores / 16 vCPUs each)
	#   cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u
	0-7,88-95
	16-23,104-111
	24-31,112-119
	32-39,120-127
	40-47,128-135
	48-55,136-143
	56-63,144-151
	64-71,152-159
	72-79,160-167
	80-87,168-175
	8-15,96-103


Results
=======


Tl;DR: 

 * ARM (single L3, 72 CPUs): cache_shard consistently improves write
   throughput by +6 to +12% across all shard counts (2-32), with
   the peak at 2 shards. Read impact is minimal (noise-level).
   Shard=1 confirms no effect as expected.

 * Intel (11 L3 domains, 16 CPUs each): cache_shard shows no meaningful
   benefit at 1-4 shards (all within noise/stddev). At 8 shards it
   regresses by ~4% for both reads and writes, likely due to loss of
   data locality when sharding already-small 16-CPU cache domains
   further.

benchmark Data:
===============

ARM:

  ┌────────┬───────────────────┬──────────────┬──────────────────┬─────────────┐
  │ Shards │ Write Delta (avg) │ Write stddev │ Read Delta (avg) │ Read stddev │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │      1 │             -0.2% │        ±1.0% │            +1.2% │       ±1.7% │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │      2 │            +12.5% │        ±1.3% │            -0.3% │       ±0.9% │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │      4 │             +8.7% │        ±0.9% │            +1.8% │       ±1.5% │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │      8 │            +11.4% │        ±1.8% │            +3.1% │       ±1.5% │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │     16 │             +7.8% │        ±1.3% │            +1.6% │       ±1.0% │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │     32 │             +6.1% │        ±0.6% │            +0.3% │       ±1.5% │
  └────────┴───────────────────┴──────────────┴──────────────────┴─────────────┘

Intel:

  ┌────────┬───────────────────┬──────────────┬──────────────────┬─────────────┐
  │ Shards │ Write Delta (avg) │ Write stddev │ Read Delta (avg) │ Read stddev │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │      1 │             -0.2% │        ±1.2% │            +0.1% │       ±1.0% │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │      2 │             +0.7% │        ±1.4% │            +0.5% │       ±1.1% │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │      4 │             +0.8% │        ±1.1% │            +1.3% │       ±1.2% │
  ├────────┼───────────────────┼──────────────┼──────────────────┼─────────────┤
  │      8 │             -4.0% │        ±1.3% │            -4.5% │       ±0.9% │
  └────────┴───────────────────┴──────────────┴──────────────────┴─────────────┘


Microbenchmark result
=====================

I've run the micro-benchmark from this patchset as well, and the resluts
comparison:

 * Intel (11 L3 domains, 16 CPUs each): cache_shard delivers +45-55%
   throughput and 36-44% lower latency at 2-8 shards. The sweet spot is
   4 shards (+55%, p50 cut nearly in half). Shard=1 confirms no effect.

   Even though Intel already has multiple L3 domains, each 16-CPU domain
   still has enough contention to benefit from further splitting (for
   the sake of this microbenchmark/stress test)

 * ARM (single L3, 72 CPUs): The gains are dramatic — 2x at 2 shards,
   3.2x at 4 shards, and 4.4x at 8 shards. At 8 shards, cache_shard
   (3.2M items/s) nearly matches cpu scope performance (3.7M), with p50
   latency dropping from 43.5 us to 6.9 us.

   The single monolithic L3 makes cache scope degenerate to a single
   contended pool, so sharding  has a massive effect.


Intel

  ┌────────┬─────────────────┬───────────────────────┬─────────────────┬───────────┬───────────┬───────────────────┐
  │ Shards │ cache (items/s) │ cache_shard (items/s) │ Throughput gain │ cache p50 │ shard p50 │ Latency reduction │
  ├────────┼─────────────────┼───────────────────────┼─────────────────┼───────────┼───────────┼───────────────────┤
  │      1 │       2,660,103 │             2,667,740 │           +0.3% │   27.5 us │   27.5 us │                0% │
  ├────────┼─────────────────┼───────────────────────┼─────────────────┼───────────┼───────────┼───────────────────┤
  │      2 │       2,619,884 │             3,788,454 │          +44.6% │   28.0 us │   17.8 us │              -36% │
  ├────────┼─────────────────┼───────────────────────┼─────────────────┼───────────┼───────────┼───────────────────┤
  │      4 │       2,506,185 │             3,891,064 │          +55.3% │   29.3 us │   16.5 us │              -44% │
  ├────────┼─────────────────┼───────────────────────┼─────────────────┼───────────┼───────────┼───────────────────┤
  │      8 │       2,628,321 │             4,015,312 │          +52.8% │   27.9 us │   16.4 us │              -41% │
  └────────┴─────────────────┴───────────────────────┴─────────────────┴───────────┴───────────┴───────────────────┘

  Reference scopes (stable across shard counts): cpu ~6.2M items/s, smt ~4.0M, numa/system ~422K.

ARM

  ┌────────┬─────────────────┬───────────────────────┬─────────────────┬───────────┬───────────┬───────────────────┐
  │ Shards │ cache (items/s) │ cache_shard (items/s) │ Throughput gain │ cache p50 │ shard p50 │ Latency reduction │
  ├────────┼─────────────────┼───────────────────────┼─────────────────┼───────────┼───────────┼───────────────────┤
  │      2 │         725,999 │             1,516,967 │           +109% │   43.8 us │   19.6 us │              -55% │
  ├────────┼─────────────────┼───────────────────────┼─────────────────┼───────────┼───────────┼───────────────────┤
  │      4 │         729,615 │             2,347,335 │           +222% │   43.6 us │   11.0 us │              -75% │
  ├────────┼─────────────────┼───────────────────────┼─────────────────┼───────────┼───────────┼───────────────────┤
  │      8 │         731,517 │             3,230,168 │           +342% │   43.5 us │    6.9 us │              -84% │
  └────────┴─────────────────┴───────────────────────┴─────────────────┴───────────┴───────────┴───────────────────┘


Next Steps:
  * Revert the code to sharding by CPU count (instead of by shard count) and
    report it again. 
  * Any other test that would help us?
