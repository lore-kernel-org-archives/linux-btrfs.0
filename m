Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B39A3FBEAB;
	Wed,  1 Apr 2026 13:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048664; cv=none; b=GTcpxL7AQfKXJKEnBEmaF6fwiO8z2vgr6nLa3aOeiB0FKFfLVMQV3Lyt49suUGoFXHZbrwpjRIr/lKLQBs1zvAAfyeA6LKR9MHixDmt5KSj2+jgVT5jA8GX3O6IqW45jo+EUWBoXoB0JGM+5e8RbYvDXRbCsASdpTu4MUt0LXTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048664; c=relaxed/simple;
	bh=uqrRZqvJAR6Dw5ouGkDItmGD0F8LaFtmPzGnhC6hEt0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EjIrSNl9SJRyRCiOMc9ej8RbHVmofEsMXE9hsBcLzyVN+uSPrqcow/sqxMUxqsZIj9zXe45kCp8otSOBRSW49Y+JISQjFOl9SD8VZS4tvQLO9KaVA7lzBlqOURIzVJVw09iMAC7Be9aFXwVS9D7mxQGuu+u57xih/R+9VMbYTeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=nZZGvwuu; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="nZZGvwuu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=O8eQKJWzpv4gl/M+Dvotl6MYTbNuE9E+fGGayQ0vTmk=; b=nZZGvwuuq+ccds+UNi1PPfWIhI
	x0kh8J0B+EoFI7Z2Yf+8S76wpTiEZYfevCXU8U4FA/Pt9VpHINf9/rFsOeORs0uH6SOrcEBX3cRhm
	6X6labsHHLffJEHONnAT73iQGgs50YPJaqvkB6x+eci09cakppEi4w1dPsa6D2YzP4r3ZSjevoC+6
	WKIybIJrf7Z4ojbTkAHOH4426AdaId22QDzREoaQhYAiUFVXiFRXER8nkxtTWl1dbelNeiOg+uEOz
	GKjgXpGf3s0p6kOTnauFUKn+hbGjWqxVch8TGox7EIhWvYstUM6xhaAizq89kiB7qCcts28v3Jd8U
	lqjAPdbw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7vF7-0030PY-2m;
	Wed, 01 Apr 2026 13:04:20 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 06:03:53 -0700
Subject: [PATCH v3 2/6] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-workqueue_sharded-v3-2-ab0b9336bf0b@debian.org>
References: <20260401-workqueue_sharded-v3-0-ab0b9336bf0b@debian.org>
In-Reply-To: <20260401-workqueue_sharded-v3-0-ab0b9336bf0b@debian.org>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=10302; i=leitao@debian.org;
 h=from:subject:message-id; bh=uqrRZqvJAR6Dw5ouGkDItmGD0F8LaFtmPzGnhC6hEt0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzRfIDkzGroJJBI6P940u/GdXAPCS7FR3mNuE6
 71Z/xBRVaCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac0XyAAKCRA1o5Of/Hh3
 bZdcEACrYYLKBhswPM6eGRH61pJxjy+EiEGtU/VK/5B3WPkbKjZB/4IoEPBtgwCmRNC3VI/Hbf9
 kcWe7i0HtER4NuP46onE7xO+pL5Qe2Vr2cEFrte0LroBiWwdxhXP/Vpy7Ssc+ZX0UG+afSSviMN
 q2/9MdO7tWO+cNF8iI8mLYkFu/QPHJQknc+gUSx+XHzszTBsTiGSIVtNatnelN2cZw9GT/pU/Gp
 MigkHZ7JRirBnaaWEBuj5us0muKRlX2inZ60wff/i4gwb6ct6Sc4Zgy4Tc7kR3hOY0a6KNlARHS
 7v//bIys7z660YtJx4El1eODG8p0ie1EqFBteKi5BNqhMwotMFdmhaHdc/qLuWzbJTDiXNQSfR1
 Av/QH3KRJ69jolJJsYqMLAhgKFjPEuFnz4ycPotp+fgd5sEDVzZbnyei70kb2+blcoKgpzp5zbN
 uz66Gq7ZpNtO4Sji+T1yPVnRTvcKBn0xIVXdNFGw3+xRLvsHpFGrQ/r3ZlFL8r9fZyS+bzUW5Wj
 igZBimZDdm6UROaZjUkm+SnmRLYDdJ7KH4apYzAcwb1heXDBblu1ksRosGvTN8jx7AjWh+PEcdn
 jAVgtXpcbX9/VjvKad+/86aQ9fLc1+YTn4+fNlAX9Z1kphNmzMmObGVQBgrGBbIoDESl/+Czur5
 GM4L5WuxQagwguQ==
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
scopes: precompute_cache_shard_ids() pre-fills the cpu_shard_id[] array
from the already-initialized WQ_AFFN_CACHE and WQ_AFFN_SMT topology,
and cpus_share_cache_shard() is passed to init_pod_type().

Benchmark on NVIDIA Grace (72 CPUs, single LLC, 50k items/thread), show
cache_shard delivers ~5x the throughput and ~6.5x lower p50 latency
compared to cache scope on this 72-core single-LLC system.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/workqueue.h |   1 +
 kernel/workqueue.c        | 183 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 184 insertions(+)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 17543aec2a6e..50bdb7e30d35 100644
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
index b77119d71641..5b1d42115e20 100644
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
@@ -409,6 +417,7 @@ static const char *wq_affn_names[WQ_AFFN_NR_TYPES] = {
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
 
@@ -8113,6 +8125,175 @@ static bool __init cpus_share_numa(int cpu0, int cpu1)
 	return cpu_to_node(cpu0) == cpu_to_node(cpu1);
 }
 
+/* Maps each CPU to its shard index within the LLC pod it belongs to */
+static int cpu_shard_id[NR_CPUS] __initdata;
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
+	const struct cpumask *sibling_cpus;
+	int nr_cores = 0, c;
+
+	/*
+	 * Count distinct cores by only counting the first CPU in each
+	 * SMT sibling group.
+	 */
+	for_each_cpu(c, pod_cpus) {
+		sibling_cpus = smt_pods->pod_cpus[smt_pods->cpu_pod[c]];
+		if (cpumask_first(sibling_cpus) == c)
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
+	/* Ensure at least one shard; pick the count closest to the target size */
+	layout.nr_shards = max(1, DIV_ROUND_CLOSEST(nr_cores, wq_cache_shard_size));
+	layout.cores_per_shard = nr_cores / layout.nr_shards;
+	layout.nr_large_shards = nr_cores % layout.nr_shards;
+
+	return layout;
+}
+
+/*
+ * llc_shard_is_full - check whether a shard has reached its core capacity
+ * @cores_in_shard: number of cores already assigned to this shard
+ * @shard_id:       index of the shard being checked
+ * @layout:         the shard layout computed by llc_calc_shard_layout()
+ *
+ * Returns true if @cores_in_shard equals the expected size for @shard_id.
+ */
+static bool __init llc_shard_is_full(int cores_in_shard, int shard_id,
+				     const struct llc_shard_layout *layout)
+{
+	return cores_in_shard == llc_shard_size(shard_id, layout->cores_per_shard,
+						layout->nr_large_shards);
+}
+
+/**
+ * llc_populate_cpu_shard_id - populate cpu_shard_id[] for each CPU in an LLC pod
+ * @pod_cpus:  the cpumask of CPUs in the LLC pod
+ * @smt_pods:  the SMT pod type, used to identify sibling groups
+ * @nr_cores:  number of distinct cores in @pod_cpus (from llc_count_cores())
+ *
+ * Walks @pod_cpus in order. At each SMT group leader, advances to the next
+ * shard once the current shard is full. Results are written to cpu_shard_id[].
+ */
+static void __init llc_populate_cpu_shard_id(const struct cpumask *pod_cpus,
+					     struct wq_pod_type *smt_pods,
+					     int nr_cores)
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
+	if (!wq_cache_shard_size) {
+		pr_warn("workqueue: cache_shard_size must be > 0, setting to 1\n");
+		wq_cache_shard_size = 1;
+	}
+
+	for (pod = 0; pod < llc_pods->nr_pods; pod++) {
+		cpus_sharing_llc = llc_pods->pod_cpus[pod];
+
+		/* Number of cores in this given LLC */
+		nr_cores = llc_count_cores(cpus_sharing_llc, smt_pods);
+		llc_populate_cpu_shard_id(cpus_sharing_llc, smt_pods, nr_cores);
+	}
+}
+
+/*
+ * cpus_share_cache_shard - test whether two CPUs belong to the same cache shard
+ *
+ * Two CPUs share a cache shard if they are in the same LLC and have the same
+ * shard index. Used as the pod affinity callback for WQ_AFFN_CACHE_SHARD.
+ */
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
@@ -8128,6 +8309,8 @@ void __init workqueue_init_topology(void)
 	init_pod_type(&wq_pod_types[WQ_AFFN_CPU], cpus_dont_share);
 	init_pod_type(&wq_pod_types[WQ_AFFN_SMT], cpus_share_smt);
 	init_pod_type(&wq_pod_types[WQ_AFFN_CACHE], cpus_share_cache);
+	precompute_cache_shard_ids();
+	init_pod_type(&wq_pod_types[WQ_AFFN_CACHE_SHARD], cpus_share_cache_shard);
 	init_pod_type(&wq_pod_types[WQ_AFFN_NUMA], cpus_share_numa);
 
 	wq_topo_initialized = true;

-- 
2.52.0

