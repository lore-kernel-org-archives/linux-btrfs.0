Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6EF3D9030;
	Fri, 20 Mar 2026 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029437; cv=none; b=h0f07FLO1w6DCNJPEt4aLI9dlRAyrrJBqUOWdEdMxdN9jRQUrL9y+1gLwlDJ82ld9XvhEW1ObvMRDKyvgG/+UuEZ/0I7LO2o8qeNT7t/8YKYuP+n6oIMr8dL7c43Pf+r6w8MabCRWhbhO/4Djl22bzf+BUHcGjR/U/zXdgyF7Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029437; c=relaxed/simple;
	bh=2haM9T7RhrH3s287f0aj4MUwH8E29ZjjYaiTksLYd2c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P8eX2rXTIvRCnLXUuuUBOjJw182TnQgburlXklvPWkXzHHVfcei/xeJ+u12I6Mcfq/0egDRgzaAN+G38whH2x+q4ZFCRclWGY2N7jJiu36dHqwFapsd8Xw0I+mnJtk50J/Fsj3oQiKtp+A0aeneMJ/Idb5G7y5/RDw6eecyyRuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=ojWMQJU8; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="ojWMQJU8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=eGt+oO6gUd77Vki78P1HXz8VnZe0HmkUW7YZyAfG5l4=; b=ojWMQJU8FpR7Do1xpuDPdmCBMV
	tIheHbGSE0wRFUziZ3MtiObhn2MDaNn/D4tMdR80jBu4q0A7hP72uCyyHIoG/XHmjfeYGUm0ih2GN
	tN3bXkqNa+ifVqWzX5SRMMF2kWoD7nCLAtyHfldMdakqW3UKjpuz0J8MZoLTFnsBLyc34w6Pv0WdK
	t+TH/sokPbFMsxkQpRQ9Bp7cDXKIXjHMGw2dqRb0P/t6RxL9z3xCu++AAZhaw+liM9vfcVBGaNSrf
	A1IxaDb2hdZTciTQOHyALCKrpmDUg3lOVWTJuWWmHucxrlk21smWmB/4khPrXOmfN8iugLGI9QVcK
	0on0xJDw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3e5y-005NfA-CT; Fri, 20 Mar 2026 17:57:13 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 20 Mar 2026 10:56:28 -0700
Subject: [PATCH v2 2/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-workqueue_sharded-v2-2-8372930931af@debian.org>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
In-Reply-To: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=7235; i=leitao@debian.org;
 h=from:subject:message-id; bh=2haM9T7RhrH3s287f0aj4MUwH8E29ZjjYaiTksLYd2c=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpvYprxdMfJdd0aSLdtoRT7SpRh+jvshNnVxoq3
 H39pBnkOyGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCab2KawAKCRA1o5Of/Hh3
 bQ++D/0R3MWF4hnvgh1G6NOvdyDqoTLglQS7/eRRaza7aLU+y1IipbwSiiaFSzjgypfsJ7yb71H
 r6djMl/X7sJDSiPuvxguyqo4Tn2b9A+G9FhltDXqhEXW4PbMARAlqXkcWyaq6uQy3ttcxo3IB5Y
 hHXtrfyJg+IVhJc6EO5aBNQqfuMuzHA1USYBIJVjMdhPc1sQDsTAEoRZMKafFxgj5SY2DaYSQ69
 V1GlXtCkk+kBxf8BbyTyLm4sEP5e21uTZo0+MjBQutm52YLu+/QRV1W2FGX1fPh7T9208FEcMoE
 OSpQXbs+NqqstBOkeo7r95b4XJu9CYWdTN8fmrorA08Tx+u6hcGZJC1NmAmGddmGXhKQqSjvguR
 ceVU6K5rKMjqcinOq70q2+MciYbktjZSZIWtI6D6AHd2tdsBe1/rrFZOJpr6D70rGLiANg+lFkq
 uKU64nBkbzfymivxPeVkvMC+Vs547MlMHUD2lvORoZqpIukOTTmgYMQRNp5L3nKLZM7yCNd6Kmj
 lYN4KialjsMytPHeRgsODRyeYD1iPqZgT2o3D3qGdSCLV1XV13Ffv1SYzG8Sf73QPCOXSLtAV80
 YgvS7HOwdwMoxCLMZDEU5LF/1k+f5Xqh8mUBGYJEOLOxYLGONHswC7Ry7lw8NxdygN/FJ/IF2Ck
 qF4fnH6QuSrKMQw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

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
---
 include/linux/workqueue.h |   1 +
 kernel/workqueue.c        | 108 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+)

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
index a050971393f1f..ebbc7971b4fa6 100644
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
 
@@ -8107,6 +8111,104 @@ static bool __init cpus_share_numa(int cpu0, int cpu1)
 	return cpu_to_node(cpu0) == cpu_to_node(cpu1);
 }
 
+/**
+ * llc_count_cores - count distinct cores (SMT groups) within a cpumask
+ * @pod_cpus: the cpumask to scan (typically an LLC pod)
+ * @smt_pt:   the SMT pod type, used to identify sibling groups
+ *
+ * A core is represented by the lowest-numbered CPU in its SMT group. Returns
+ * the number of distinct cores found in @pod_cpus.
+ */
+static int __init llc_count_cores(const struct cpumask *pod_cpus,
+				  struct wq_pod_type *smt_pt)
+{
+	const struct cpumask *smt_cpus;
+	int nr_cores = 0, c;
+
+	for_each_cpu(c, pod_cpus) {
+		smt_cpus = smt_pt->pod_cpus[smt_pt->cpu_pod[c]];
+		if (cpumask_first(smt_cpus) == c)
+			nr_cores++;
+	}
+
+	return nr_cores;
+}
+
+/**
+ * llc_cpu_core_pos - find a CPU's core position within a cpumask
+ * @cpu:      the CPU to locate
+ * @pod_cpus: the cpumask to scan (typically an LLC pod)
+ * @smt_pt:   the SMT pod type, used to identify sibling groups
+ *
+ * Returns the zero-based index of @cpu's core among the distinct cores in
+ * @pod_cpus, ordered by lowest CPU number in each SMT group.
+ */
+static int __init llc_cpu_core_pos(int cpu, const struct cpumask *pod_cpus,
+				   struct wq_pod_type *smt_pt)
+{
+	const struct cpumask *smt_cpus;
+	int core_pos = 0, c;
+
+	for_each_cpu(c, pod_cpus) {
+		smt_cpus = smt_pt->pod_cpus[smt_pt->cpu_pod[c]];
+		if (cpumask_test_cpu(cpu, smt_cpus))
+			break;
+		if (cpumask_first(smt_cpus) == c)
+			core_pos++;
+	}
+
+	return core_pos;
+}
+
+/**
+ * cpu_cache_shard_id - compute the shard index for a CPU within its LLC pod
+ * @cpu: the CPU to look up
+ *
+ * Returns a shard index that is unique within the CPU's LLC pod. The LLC is
+ * divided into shards of at most wq_cache_shard_size cores, always split on
+ * core (SMT group) boundaries so that SMT siblings are never placed in
+ * different shards. Cores are distributed across shards as evenly as possible.
+ *
+ * Example: 36 cores with wq_cache_shard_size=8 gives 5 shards of
+ * 8+7+7+7+7 cores.
+ */
+static int __init cpu_cache_shard_id(int cpu)
+{
+	struct wq_pod_type *cache_pt = &wq_pod_types[WQ_AFFN_CACHE];
+	struct wq_pod_type *smt_pt = &wq_pod_types[WQ_AFFN_SMT];
+	const struct cpumask *pod_cpus;
+	int nr_cores, nr_shards, cores_per_shard, remainder, core_pos;
+
+	/* CPUs in the same LLC as @cpu */
+	pod_cpus = cache_pt->pod_cpus[cache_pt->cpu_pod[cpu]];
+	nr_cores = llc_count_cores(pod_cpus, smt_pt);
+
+	/* Compute number of shards from the max cores per shard */
+	nr_shards = DIV_ROUND_UP(nr_cores, wq_cache_shard_size);
+	/* Distribute cores as evenly as possible across shards */
+	cores_per_shard = nr_cores / nr_shards;
+	remainder = nr_cores % nr_shards;
+
+	core_pos = llc_cpu_core_pos(cpu, pod_cpus, smt_pt);
+
+	/*
+	 * Map core position to shard index. The first @remainder shards have
+	 * (cores_per_shard + 1) cores, the rest have @cores_per_shard cores.
+	 */
+	if (core_pos < remainder * (cores_per_shard + 1))
+		return core_pos / (cores_per_shard + 1);
+
+	return remainder + (core_pos - remainder * (cores_per_shard + 1)) / cores_per_shard;
+}
+
+static bool __init cpus_share_cache_shard(int cpu0, int cpu1)
+{
+	if (!cpus_share_cache(cpu0, cpu1))
+		return false;
+
+	return cpu_cache_shard_id(cpu0) == cpu_cache_shard_id(cpu1);
+}
+
 /**
  * workqueue_init_topology - initialize CPU pods for unbound workqueues
  *
@@ -8119,9 +8221,15 @@ void __init workqueue_init_topology(void)
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
+	init_pod_type(&wq_pod_types[WQ_AFFN_CACHE_SHARD], cpus_share_cache_shard);
 	init_pod_type(&wq_pod_types[WQ_AFFN_NUMA], cpus_share_numa);
 
 	wq_topo_initialized = true;

-- 
2.52.0

