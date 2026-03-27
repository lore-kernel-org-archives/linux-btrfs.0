Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE749221DB6;
	Fri, 27 Mar 2026 12:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774615112; cv=none; b=hQ13usiFcQ7gILJU43hMkjVbs/T1xEnyDvs3BG5tY2qGM1+kxvy6R7AQDm8Hvwz/zqFQlTWu+012APxHxxnM1bmnNukNM9x0FtQCuXhuWVYOIHLKCeBn3NHbKYxkgdC5SXfU9lUJhP4DxbVpEklFtRmY0VoJeDLR9pi5fp661zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774615112; c=relaxed/simple;
	bh=cGqX813SiPQWRpSfMIiQVW0ar/4lZdARa9aL+E3p44Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCiwUn3dw2t5SHZHNae62C9ZDV+wr2FedrGcm7SiAzHAfjWeEm0tkKyktjKyVJG4R/ZSMmrOZZIm4Ysh376lMAa8xiIyj4qkAQsYz0fd5iv1W3nEpdvJyHFct167P6BCS7p/1mgFoYZ1/o0a7945yeefL+1MPOYN/Yv4SnFtYq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=N/2SjDKr; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="N/2SjDKr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YnT1ZAtSy5JL3W6PHa+nnpbh1Tv8Tup7L1UhauNgxGc=; b=N/2SjDKrtBPPRyyADUVZcluXIl
	oqirdM+okLyh/vAz6KsnpaONOGofTJEq1kEplFqCOfpsfPMN1NVi+CC/DYjq5xxxDCa5L3jSxikxt
	SkPlymlrJRlk6uMvfMLCwgG9ctQEDx3OeKzBdQaS8s086gUtmBuu2wVnRnUU30gTucW1411QFqRj/
	/eddLK89LCcHI3RPAUE6fzSSK0+uBIrKXZGYP4IY54x3An4Ay0QsVXdMHTDKW71JG7mL+0folSPTh
	i0SStPQCT3nhDNQYvwvzGQt3zpq/NpgNXkQFmYp6ScZEORSGvbjSSQiuqYl0ulS2ah5ywC1gWpkTl
	6E5Yx1UQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w66SF-00Ad5B-Po; Fri, 27 Mar 2026 12:38:24 +0000
Date: Fri, 27 Mar 2026 05:38:18 -0700
From: Breno Leitao <leitao@debian.org>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, puranjay@kernel.org, 
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
	jlayton@kernel.or
Subject: Re: [PATCH v2 2/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Message-ID: <acZ5KXIZfa08ziig@gmail.com>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
 <20260320-workqueue_sharded-v2-2-8372930931af@debian.org>
 <acHCE96gzEUaGZFP@slm.duckdns.org>
 <acVbF0cGGJx--Tci@gmail.com>
 <acWL2hxO7m2H4g_r@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acWL2hxO7m2H4g_r@slm.duckdns.org>
X-Debian-User: leitao

On Thu, Mar 26, 2026 at 09:41:14AM -1000, Tejun Heo wrote:
> On Thu, Mar 26, 2026 at 09:20:15AM -0700, Breno Leitao wrote:
> > +static int __init llc_core_to_shard(int core_pos, int cores_per_shard,
> > +				    int remainder)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * These cores falls within the large shards.
> > +	 * Each large shard has (cores_per_shard + 1) cores
> > +	 */
> > +	if (core_pos < remainder * (cores_per_shard + 1))
> > +		return core_pos / (cores_per_shard + 1);
> > +
> > +	/* These are standard shards */
> > +	ret = (core_pos - remainder * (cores_per_shard + 1)) / cores_per_shard;
> 
> This is too smart. Any chance you can dumb it down? If you have to go
> through intermediate data structures, that's fine too.

Thanks, Let me create a layout to represent the shard, and give some
names to shard, then it will make the code easier to digest.

Tl;DR: We have "large shard" and "regular shards". Where large shards is
regular shards + 1 (if the division is not exact).

	/* Layout of shards within one LLC pod */
	struct llc_shard_layout {
		int nr_large_shards;	/* number of large shards (cores_per_shard + 1) */
		int cores_per_shard;	/* base number of cores per default shard */
		int nr_shards;		/* total number of shards */
		/* nr_default shards = (nr_shards - nr_large_shards) */
	};

Then, when populating the it using:


	static struct llc_shard_layout __init llc_calc_shard_layout(int nr_cores)
	{
		struct llc_shard_layout layout;

		layout.nr_shards = max(1, DIV_ROUND_CLOSEST(nr_cores, q_cache_shard_size));
		layout.cores_per_shard = nr_cores / layout.nr_shards;
		layout.nr_large_shards = nr_cores % layout.nr_shards; (whit was the remainder in the last patch)

		return layout;
	}


This is the full patch I am working on:



commit ea801773c3b80f50d81c52f4e174276013f1e562
Author: Breno Leitao <leitao@debian.org>
Date:   Mon Mar 9 08:39:52 2026 -0700

    workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
    
    On systems where many CPUs share one LLC, unbound workqueues using
    WQ_AFFN_CACHE collapse to a single worker pool, causing heavy spinlock
    contention on pool->lock. For example, Chuck Lever measured 39% of
    cycles lost to native_queued_spin_lock_slowpath on a 12-core shared-L3
    NFS-over-RDMA system.
    
    The existing affinity hierarchy (cpu, smt, cache, numa, system) offers
    no intermediate option between per-LLC and per-SMT-core granularity.
    
    Add WQ_AFFN_CACHE_SHARD, which subdivides each LLC into groups of at
    most wq_cache_shard_size cores (default 8, tunable via boot parameter).
    Shards are always split on core (SMT group) boundaries so that
    Hyper-Threading siblings are never placed in different pods. Cores are
    distributed across shards as evenly as possible -- for example, 36 cores
    in a single LLC with max shard size 8 produces 5 shards of 8+7+7+7+7
    cores.
    
    The implementation follows the same comparator pattern as other affinity
    scopes: cpu_cache_shard_id() computes a per-CPU shard index on the fly
    from the already-initialized WQ_AFFN_CACHE and WQ_AFFN_SMT topology,
    and cpus_share_cache_shard() is passed to init_pod_type().
    
    Benchmark on NVIDIA Grace (72 CPUs, single LLC, 50k items/thread), show
    cache_shard delivers ~5x the throughput and ~6.5x lower p50 latency
    compared to cache scope on this 72-core single-LLC system.
    
    Suggested-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 17543aec2a6e1..50bdb7e30d35f 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -133,6 +133,7 @@ enum wq_affn_scope {
 	WQ_AFFN_CPU,			/* one pod per CPU */
 	WQ_AFFN_SMT,			/* one pod per SMT */
 	WQ_AFFN_CACHE,			/* one pod per LLC */
+	WQ_AFFN_CACHE_SHARD,		/* synthetic sub-LLC shards */
 	WQ_AFFN_NUMA,			/* one pod per NUMA node */
 	WQ_AFFN_SYSTEM,			/* one pod across the whole system */
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cbff51397ea77..22dcd977bbf87 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -130,6 +130,14 @@ enum wq_internal_consts {
 	WORKER_ID_LEN		= 10 + WQ_NAME_LEN, /* "kworker/R-" + WQ_NAME_LEN */
 };
 
+/* Layout of shards within one LLC pod */
+struct llc_shard_layout {
+	int nr_large_shards;	/* number of large shards (cores_per_shard + 1) */
+	int cores_per_shard;	/* base number of cores per default shard */
+	int nr_shards;		/* total number of shards */
+	/* nr_default shards = (nr_shards - nr_large_shards) */
+};
+
 /*
  * We don't want to trap softirq for too long. See MAX_SOFTIRQ_TIME and
  * MAX_SOFTIRQ_RESTART in kernel/softirq.c. These are macros because
@@ -409,6 +417,7 @@ static const char * const wq_affn_names[WQ_AFFN_NR_TYPES] = {
 	[WQ_AFFN_CPU]		= "cpu",
 	[WQ_AFFN_SMT]		= "smt",
 	[WQ_AFFN_CACHE]		= "cache",
+	[WQ_AFFN_CACHE_SHARD]	= "cache_shard",
 	[WQ_AFFN_NUMA]		= "numa",
 	[WQ_AFFN_SYSTEM]	= "system",
 };
@@ -431,6 +440,9 @@ module_param_named(cpu_intensive_warning_thresh, wq_cpu_intensive_warning_thresh
 static bool wq_power_efficient = IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
 module_param_named(power_efficient, wq_power_efficient, bool, 0444);
 
+static unsigned int wq_cache_shard_size = 8;
+module_param_named(cache_shard_size, wq_cache_shard_size, uint, 0444);
+
 static bool wq_online;			/* can kworkers be created yet? */
 static bool wq_topo_initialized __read_mostly = false;
 
@@ -8107,6 +8119,150 @@ static bool __init cpus_share_numa(int cpu0, int cpu1)
 	return cpu_to_node(cpu0) == cpu_to_node(cpu1);
 }
 
+/* Per-CPU shard index within its LLC pod; populated by precompute_cache_shard_ids() */
+static int __initdata cpu_shard_id[NR_CPUS];
+
+/**
+ * llc_count_cores - count distinct cores (SMT groups) within an LLC pod
+ * @pod_cpus:  the cpumask of CPUs in the LLC pod
+ * @smt_pods:  the SMT pod type, used to identify sibling groups
+ *
+ * A core is represented by the lowest-numbered CPU in its SMT group. Returns
+ * the number of distinct cores found in @pod_cpus.
+ */
+static int __init llc_count_cores(const struct cpumask *pod_cpus,
+				  struct wq_pod_type *smt_pods)
+{
+	const struct cpumask *smt_cpus;
+	int nr_cores = 0, c;
+
+	for_each_cpu(c, pod_cpus) {
+		smt_cpus = smt_pods->pod_cpus[smt_pods->cpu_pod[c]];
+		if (cpumask_first(smt_cpus) == c)
+			nr_cores++;
+	}
+
+	return nr_cores;
+}
+
+/*
+ * llc_shard_size - number of cores in a given shard
+ *
+ * Cores are spread as evenly as possible. The first @nr_large_shards shards are
+ * "large shards" with (cores_per_shard + 1) cores; the rest are "default
+ * shards" with cores_per_shard cores.
+ */
+static int __init llc_shard_size(int shard_id, int cores_per_shard, int nr_large_shards)
+{
+	/* The first @nr_large_shards shards are large shards */
+	if (shard_id < nr_large_shards)
+		return cores_per_shard + 1;
+
+	/* The remaining shards are default shards */
+	return cores_per_shard;
+}
+
+/*
+ * llc_calc_shard_layout - compute the shard layout for an LLC pod
+ * @nr_cores:  number of distinct cores in the LLC pod
+ *
+ * Chooses the number of shards that keeps average shard size closest to
+ * wq_cache_shard_size. Returns a struct describing the total number of shards,
+ * the base size of each, and how many are large shards.
+ */
+static struct llc_shard_layout __init llc_calc_shard_layout(int nr_cores)
+{
+	struct llc_shard_layout layout;
+
+	layout.nr_shards = max(1, DIV_ROUND_CLOSEST(nr_cores, wq_cache_shard_size));
+	layout.cores_per_shard = nr_cores / layout.nr_shards;
+	layout.nr_large_shards = nr_cores % layout.nr_shards;
+
+	return layout;
+}
+
+static bool __init llc_shard_is_full(int cores_in_shard, int shard_id,
+				     const struct llc_shard_layout *layout)
+{
+	return cores_in_shard == llc_shard_size(shard_id, layout->cores_per_shard,
+						layout->nr_large_shards);
+}
+
+/**
+ * llc_assign_shard_ids - record the shard index for each CPU in an LLC pod
+ * @pod_cpus:  the cpumask of CPUs in the LLC pod
+ * @smt_pods:  the SMT pod type, used to identify sibling groups
+ * @nr_cores:  number of distinct cores in @pod_cpus (from llc_count_cores())
+ *
+ * Walks @pod_cpus in order. At each SMT group leader, advances to the next
+ * shard once the current shard is full. Results are written to cpu_shard_id[].
+ */
+static void __init llc_assign_shard_ids(const struct cpumask *pod_cpus,
+					struct wq_pod_type *smt_pods, int nr_cores)
+{
+	struct llc_shard_layout layout = llc_calc_shard_layout(nr_cores);
+	const struct cpumask *sibling_cpus;
+	/* Count the number of cores in the current shard_id */
+	int cores_in_shard = 0;
+	/* This is a cursor for the shards. Go from zero to nr_shards - 1*/
+	int shard_id = 0;
+	int c;
+
+	/* Iterate at every CPU for a given LLC pod, and assign it a shard */
+	for_each_cpu(c, pod_cpus) {
+		sibling_cpus = smt_pods->pod_cpus[smt_pods->cpu_pod[c]];
+		if (cpumask_first(sibling_cpus) == c) {
+			/* This is the CPU leader for the siblings */
+			if (llc_shard_is_full(cores_in_shard, shard_id, &layout)) {
+				shard_id++;
+				cores_in_shard = 0;
+			}
+			cores_in_shard++;
+			cpu_shard_id[c] = shard_id;
+		} else {
+			/*
+			 * The siblings' shard MUST be the same as the leader.
+			 * never split threads in the same core.
+			 */
+			cpu_shard_id[c] = cpu_shard_id[cpumask_first(sibling_cpus)];
+		}
+	}
+
+	WARN_ON_ONCE(shard_id != (layout.nr_shards - 1));
+}
+
+/**
+ * precompute_cache_shard_ids - assign each CPU its shard index within its LLC
+ *
+ * Iterates over all LLC pods. For each pod, counts distinct cores then assigns
+ * shard indices to all CPUs in the pod. Must be called after WQ_AFFN_CACHE and
+ * WQ_AFFN_SMT have been initialized.
+ */
+static void __init precompute_cache_shard_ids(void)
+{
+	struct wq_pod_type *llc_pods = &wq_pod_types[WQ_AFFN_CACHE];
+	struct wq_pod_type *smt_pods = &wq_pod_types[WQ_AFFN_SMT];
+	const struct cpumask *cpus_sharing_llc;
+	int nr_cores;
+	int pod;
+
+	for (pod = 0; pod < llc_pods->nr_pods; pod++) {
+		cpus_sharing_llc = llc_pods->pod_cpus[pod];
+
+		/* Number of cores in this given LLC */
+		nr_cores = llc_count_cores(cpus_sharing_llc, smt_pods);
+		llc_assign_shard_ids(cpus_sharing_llc, smt_pods, nr_cores);
+	}
+}
+
+static bool __init cpus_share_cache_shard(int cpu0, int cpu1)
+{
+	if (!cpus_share_cache(cpu0, cpu1))
+		return false;
+
+	return cpu_shard_id[cpu0] == cpu_shard_id[cpu1];
+}
+
 /**
  * workqueue_init_topology - initialize CPU pods for unbound workqueues
  *
@@ -8119,9 +8275,21 @@ void __init workqueue_init_topology(void)
 	struct workqueue_struct *wq;
 	int cpu;
 
+	if (!wq_cache_shard_size) {
+		pr_warn("workqueue: cache_shard_size must be > 0, setting to 1\n");
+		wq_cache_shard_size = 1;
+	}
+
 	init_pod_type(&wq_pod_types[WQ_AFFN_CPU], cpus_dont_share);
 	init_pod_type(&wq_pod_types[WQ_AFFN_SMT], cpus_share_smt);
 	init_pod_type(&wq_pod_types[WQ_AFFN_CACHE], cpus_share_cache);
+	precompute_cache_shard_ids();
+	init_pod_type(&wq_pod_types[WQ_AFFN_CACHE_SHARD], cpus_share_cache_shard);
+
+	for (cpu = 0; cpu < wq_pod_types[WQ_AFFN_CACHE_SHARD].nr_pods; cpu++)
+		pr_info("workqueue: cache_shard %d: cpus %*pbl\n", cpu,
+			cpumask_pr_args(wq_pod_types[WQ_AFFN_CACHE_SHARD].pod_cpus[cpu]));
+
 	init_pod_type(&wq_pod_types[WQ_AFFN_NUMA], cpus_share_numa);
 
 	wq_topo_initialized = true;
