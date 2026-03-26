Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21510391820;
	Thu, 26 Mar 2026 16:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774542029; cv=none; b=nYAO0vFQfC2Svq+dWuzLhgQ4APktw1cvIZpoQtvYCNn5NXP3CBnxqVp5WlC88/4WwLvLUKgl8zvVbwqiVjYQnB6u5N+13c9Uozs6KH9/8hbjQaVSvkaMQ/QyPeisbclAvpTShwyJGv4pWWfxQWMRD6Ny3Wv+SQWE90M+9yFeBOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774542029; c=relaxed/simple;
	bh=h9KQUNZ3nU4oDRO9NNPxIpgGaJf4P2X/pStGlaCTgLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlWqXzPiLULJPDQ55iK8kEVxnbRmeIXa2/KkIWEBGkIYakZVbLgrY3vM7H04pN0pS/Zqwb+PX+odsI5Pfo6Aef0JDti95ewJIULP1HbTf2blLMXQNCC+OZjU4M8J/9F2I7lk/ObWKqXy8qXMzEj6HDFUt3ahNQUgYQNp022lufk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=fHJoR5Fy; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="fHJoR5Fy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=M9WbKSfdhxAnxWJ7oePL8TFjqLQaITQqH9/xwjx1+nU=; b=fHJoR5FyMcqiBqfTIq2bU61rUD
	pinOWhd7r4Yr6h1aAdFALLJCthl6uvEPkmWMxmlazw/ybJVKCiEf6RlDRxlxegIK+tYcyCKZvIyTL
	VGlAyRIoLmElpwN8fJgHHcI7IhbUC6JkKPktHWYyeRlM9A8mXQ4+rLsVweo+9jF88/KIQW/7c7yCG
	hvNCqfTHZq6i9DhG8q4/mtSgf+iJUubmWKImd8Grb7cPICosBt3Rdm09c5nYi9YOJ55o1ARj1rO6B
	O1tmYLHwyj9dDyOcz8nYik5ITXTYK83kci74VtK/e/8YxDwrlO5CL4DdCfTaExHMoB3QReJZ4gNA4
	Urx9dndA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w5nRV-009yaC-99; Thu, 26 Mar 2026 16:20:21 +0000
Date: Thu, 26 Mar 2026 09:20:15 -0700
From: Breno Leitao <leitao@debian.org>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, puranjay@kernel.org, 
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
	jlayton@kernel.or
Subject: Re: [PATCH v2 2/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Message-ID: <acVbF0cGGJx--Tci@gmail.com>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
 <20260320-workqueue_sharded-v2-2-8372930931af@debian.org>
 <acHCE96gzEUaGZFP@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acHCE96gzEUaGZFP@slm.duckdns.org>
X-Debian-User: leitao

Hello Tejun,

On Mon, Mar 23, 2026 at 12:43:31PM -1000, Tejun Heo wrote:
> On Fri, Mar 20, 2026 at 10:56:28AM -0700, Breno Leitao wrote:
> > +static int __init llc_cpu_core_pos(int cpu, const struct cpumask *pod_cpus,
> > +				   struct wq_pod_type *smt_pt)
> > +{
> > +	const struct cpumask *smt_cpus;
> > +	int core_pos = 0, c;
> > +
> > +	for_each_cpu(c, pod_cpus) {
> > +		smt_cpus = smt_pt->pod_cpus[smt_pt->cpu_pod[c]];
> > +		if (cpumask_test_cpu(cpu, smt_cpus))
> > +			break;
> > +		if (cpumask_first(smt_cpus) == c)
> > +			core_pos++;
> > +	}
> > +
> > +	return core_pos;
> > +}
> 
> Can you do the above two in a separate pass and record the results and then
> use that to implement cpu_cache_shard_id()? Doing all of it on the fly makes
> it unnecessarily difficult to follow and init_pod_type() is already O(N^2)
> and the above makes it O(N^4). Make the machine large enough and this may
> become noticeable.

Ack. I am planning to create a __initdata per-CPU array to host the
shard per CPU, and query it instad.

	/* Per-CPU shard index within its LLC pod; populated by precompute_cache_shard_ids() */
	static int __initdata cpu_shard_id[NR_CPUS];



> > + * cpu_cache_shard_id - compute the shard index for a CPU within its LLC pod
> > + * @cpu: the CPU to look up
> > + *
> > + * Returns a shard index that is unique within the CPU's LLC pod. The LLC is
> > + * divided into shards of at most wq_cache_shard_size cores, always split on
> > + * core (SMT group) boundaries so that SMT siblings are never placed in
> > + * different shards. Cores are distributed across shards as evenly as possible.
> > + *
> > + * Example: 36 cores with wq_cache_shard_size=8 gives 5 shards of
> > + * 8+7+7+7+7 cores.
> > + */
> 
> I always feel a bit uneasy about using max number as split point in cases
> like this because the reason why you picked 8 as the default was that
> testing showed shard sizes close to 8 seems to behave the best (or at least
> acceptably in most cases). However, setting max number to 8 doesn't
> necessarily keep you close to that. e.g. If there are 9 cores, you end up
> with 5 and 4 even though 9 is a lot closer to the 8 that we picked as the
> default. Can the sharding logic updated so that "whatever sharding that gets
> the system closest to the config target?".

I think DIV_ROUND_CLOSEST will do what we want, something as:

	nr_shards       = max(1, DIV_ROUND_CLOSEST(nr_cores,
	wq_cache_shard_size))
	cores_per_shard = nr_cores / nr_shards
	remainder       = nr_cores % nr_shards

The first remainder shards get cores_per_shard+1 cores (large shards),
the rest get cores_per_shard.

Assuming wq_cache_shard_size = 8;, we would have the following number of pool
per number of CPU (not vCPU):

  - 1–11 CPUs → DIV_ROUND_CLOSEST(n, 8) ≤ 1 → 1 pool containing all CPUs.
  - 12 CPUs → DIV_ROUND_CLOSEST(12, 8) = 2 → 2 pools of 6 cores each. This is the first split.
  - 12–19 → 2 pools
  - 20–27 → 3 pools
  - 28–35 → 4 pools
  - 36–43 → 5 pools
  - 44–51 → 6 pools
  - 52–59 → 7 pools
  - 60–67 → 8 pools
  - 68–75 → 9 pools (e.g. 72-CPU NVIDIA Grace → 9×8)
  - 76–83 → 10 pools
  - 84–91 → 11 pools
  - 92–99 → 12 pools
  - 100 → 13 pools (9×8 + 4×7)


Is this what you meant?

This is the current code I have been testing with the changes above:

commit ff6c6272e5925d3099109107789e685f58bd4c1e
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
index cbff51397ea77..8f432ba2bba65 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -409,6 +409,7 @@ static const char * const wq_affn_names[WQ_AFFN_NR_TYPES] = {
 	[WQ_AFFN_CPU]		= "cpu",
 	[WQ_AFFN_SMT]		= "smt",
 	[WQ_AFFN_CACHE]		= "cache",
+	[WQ_AFFN_CACHE_SHARD]	= "cache_shard",
 	[WQ_AFFN_NUMA]		= "numa",
 	[WQ_AFFN_SYSTEM]	= "system",
 };
@@ -431,6 +432,9 @@ module_param_named(cpu_intensive_warning_thresh, wq_cpu_intensive_warning_thresh
 static bool wq_power_efficient = IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
 module_param_named(power_efficient, wq_power_efficient, bool, 0444);
 
+static unsigned int wq_cache_shard_size = 8;
+module_param_named(cache_shard_size, wq_cache_shard_size, uint, 0444);
+
 static bool wq_online;			/* can kworkers be created yet? */
 static bool wq_topo_initialized __read_mostly = false;
 
@@ -8107,6 +8111,136 @@ static bool __init cpus_share_numa(int cpu0, int cpu1)
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
+/**
+ * llc_core_to_shard - map a core position to a shard index
+ * @core_pos:       zero-based position of the core within its LLC pod
+ * @cores_per_shard: base number of cores per shard (floor division)
+ * @remainder:      number of shards that get one extra core
+ *
+ * Cores are distributed as evenly as possible: the first @remainder shards
+ * have (@cores_per_shard + 1) cores (aka large shards), the rest have
+ * @cores_per_shard cores.
+ *
+ *  In summary, the initial `remainder` shards are large, the rest
+ *  are standard shards
+ *
+ * Returns the shard index for the given core position.
+ */
+static int __init llc_core_to_shard(int core_pos, int cores_per_shard,
+				    int remainder)
+{
+	int ret;
+
+	/*
+	 * These cores falls within the large shards.
+	 * Each large shard has (cores_per_shard + 1) cores
+	 */
+	if (core_pos < remainder * (cores_per_shard + 1))
+		return core_pos / (cores_per_shard + 1);
+
+	/* These are standard shards */
+	ret = (core_pos - remainder * (cores_per_shard + 1)) / cores_per_shard;
+
+	/*
+	 * Regular shards start after index 'remainder'
+	 */
+	return ret + remainder;
+}
+
+/**
+ * llc_assign_shard_ids - record the shard index for each CPU in an LLC pod
+ * @pod_cpus:  the cpumask of CPUs in the LLC pod
+ * @smt_pods:  the SMT pod type, used to identify sibling groups
+ * @nr_cores:  number of distinct cores in @pod_cpus (from llc_count_cores())
+ *
+ * Chooses the number of shards that keeps average shard size closest to
+ * wq_cache_shard_size, then walks @pod_cpus advancing the shard index at
+ * each new core (SMT group leader) boundary. Results are written to
+ * cpu_shard_id[].
+ */
+static void __init llc_assign_shard_ids(const struct cpumask *pod_cpus,
+					struct wq_pod_type *smt_pods, int nr_cores)
+{
+	int nr_shards, cores_per_shard, remainder;
+	const struct cpumask *sibling_cpus;
+	int core_pos, shard_id, c;
+
+	/*
+	 * This is the total number of shared we re going to have for this
+	 * cache pod
+	 */
+	nr_shards = max(1, DIV_ROUND_CLOSEST(nr_cores, wq_cache_shard_size));
+	cores_per_shard = nr_cores / nr_shards;
+	remainder = nr_cores % nr_shards;
+
+	core_pos = -1;
+	shard_id = 0;
+	for_each_cpu(c, pod_cpus) {
+		sibling_cpus = smt_pods->pod_cpus[smt_pods->cpu_pod[c]];
+		if (cpumask_first(sibling_cpus) == c)
+			shard_id = llc_core_to_shard(++core_pos, cores_per_shard,
+						     remainder);
+		cpu_shard_id[c] = shard_id;
+	}
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
+	int pod;
+
+	for (pod = 0; pod < llc_pods->nr_pods; pod++) {
+		const struct cpumask *cpus_sharing_llc = llc_pods->pod_cpus[pod];
+		int nr_cores;
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
@@ -8119,9 +8253,16 @@ void __init workqueue_init_topology(void)
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
 	init_pod_type(&wq_pod_types[WQ_AFFN_NUMA], cpus_share_numa);
 
 	wq_topo_initialized = true;
