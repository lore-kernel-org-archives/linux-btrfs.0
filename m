Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7FD3B7762;
	Thu, 12 Mar 2026 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773332316; cv=none; b=l4O0iCk7X4kOX5Qw5CdHzAW9jxSa8tCLHw5Go0TI8EXSyJhFU6iVY1mtwYRs5VcvZyYspAYDtjDYtlg5KpT5+duZG23siLcpKiWpuoLOviZerJUWMIOPhfZlB/OtKw8GdASgd1g4cMcCZGh5QzKTNYH/fbTLk5QFo0oc9ZAxEjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773332316; c=relaxed/simple;
	bh=nVjnReqOAl5uJl0frRqio6D4HaRCOrSArHGhyfJOQ3Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Rww/dhag99oyvTaJ3h2v6LWrd/pophVljRRpa6Xc6RVtJRZLhOyuBxVEBZt6YVTJzxKdX3jOFQ+RQlDRuWTyImiqsy4flPnUB4jMF5MEbWhf7AGH1744Ms2hwsFJ3UY+5Z9Mw5ziSMmGWwEwvyETRWGB36MfkUW1gla7G2oKCl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=SbdrXXov; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="SbdrXXov"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=8Ss7mEOdT1RpJHhhABP0Jood3v2pFXXVan/EUTluaWU=; b=SbdrXXovGgIo5ZmmuF7Cn04cAU
	TuatgM4LSZCILGoHrbxz9pMYnIqDhCGQZZkHbuP/OBiphYSOLm+uAPMvRsGmv2lADlurWIbLRiJFN
	I0myjuvynAqzN4rgNJKh6khkPQ5A3eIS5IxS5rW+mexP664QS3i6VL78Zfm2BYMiOGr/VdfAGdd6R
	gx2jhsW62HbNTilSAER19bMaebF5QuQ0jUdzCJcIoiajWrpvnWKstYHrocYI7zcE4oL0GzdYF8RWV
	3vFIXuf0foQ2uWvm3hCEIwoFB8UgGzX/EAZk+J/C2xPbI9jliS1GfNpuzVeT8okLkj9r3alIbSd1u
	bVmSyH6Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0ik5-004fNu-3t; Thu, 12 Mar 2026 16:18:33 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 12 Mar 2026 09:12:03 -0700
Subject: [PATCH RFC 2/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260312-workqueue_sharded-v1-2-2c43a7b861d0@debian.org>
References: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
In-Reply-To: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=5847; i=leitao@debian.org;
 h=from:subject:message-id; bh=nVjnReqOAl5uJl0frRqio6D4HaRCOrSArHGhyfJOQ3Q=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsudLwdUtxQFqQTctO8m367y6OICGWq/1bysG/
 F+KM2ZDQbqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabLnSwAKCRA1o5Of/Hh3
 bZHZEACxssmSChO53PROKFe45dY5yjvLvc3XjpM2V6Zdy1HX9dqtLw6sftpJ0qn4M8G9B6uTbJ3
 HScEc7q0H5l90dk/8+/8TBt6eqdbm/FxJJcw6xsSklWQsLNreiafTIJ0p8pq3zkTlnY1QguZTWW
 40lKdudb4xZw+fhGd9TZ2TWOmC0f4TXl8+l4xVRC//hBSahAcZrbUV90LoqIeDsAAAQVqGu4kYd
 UxVgwszYFY3kRPv4FG6PJKTbj4dRWu2oM/p+FZ7y1+i/hIcKNgHvG52m1U+6v/0kroWhvP01yqF
 RSl5oqMMZkfALqyQflMOq3GsbJrF71e+iq6ALO46UTsr2u9NAH7rNl/W+IdHT62MjShhEr2ixle
 7CNEW5DvVYxxZn8HU7V+fpZ7PvUbxDBEf4uEFafqIHkyLm4QntfF1HnpqiSujViTO6S/Sdge/Uo
 lnWhlcd6DXPJib9rzNreh9RLroX36/Ej6FBFXlALJg9V4vpizzucEPGpzAGxSIVirCONN0ZvHxa
 PfNhc+ReKLGiKPcmQwmc/2PHk5mjE2A4C/NV/Ntx+zIAnYWdVhPKoG361yf2vNF7saLaWDbkag6
 u4Z4lBlbEL+hd0cBcZhhL1L54AHHjT0mghoE5galkw0ZVUJ9edy2VjvH1Fcb7bdvFyctzmOznPO
 S6ssi1ULRBDAzNQ==
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
most wq_cache_shard_size CPUs (default 8, tunable via boot parameter).
CPUs are distributed across shards as evenly as possible -- for example,
72 CPUs with max shard size 8 produces 9 shards of 8 each.

The implementation follows the same comparator pattern as other affinity
scopes: cpu_cache_shard_id() computes a per-CPU shard index on the fly
from the already-initialized WQ_AFFN_CACHE topology, and
cpus_share_cache_shard() is passed to init_pod_type().

Benchmark on NVIDIA Grace (72 CPUs, single LLC, 50k items/thread):

  cpu          3433158 items/sec  p50=16416  p90=17376  p95=17664 ns
  smt          3449709 items/sec  p50=16576  p90=17504  p95=17792 ns
  cache_shard  2939917 items/sec  p50=8192   p90=11488  p95=12512 ns
  cache        602096 items/sec   p50=53056  p90=56320  p95=57248 ns
  numa         599090 items/sec   p50=53152  p90=56448  p95=57376 ns
  system       598865 items/sec   p50=53184  p90=56481  p95=57408 ns

cache_shard delivers ~5x the throughput and ~6.5x lower p50 latency
compared to cache scope on this 72-core single-LLC system.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/workqueue.h |  1 +
 kernel/workqueue.c        | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a4749f56398fd..41c946109c7d0 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -133,6 +133,7 @@ enum wq_affn_scope {
 	WQ_AFFN_CPU,			/* one pod per CPU */
 	WQ_AFFN_SMT,			/* one pod poer SMT */
 	WQ_AFFN_CACHE,			/* one pod per LLC */
+	WQ_AFFN_CACHE_SHARD,		/* synthetic sub-LLC shards */
 	WQ_AFFN_NUMA,			/* one pod per NUMA node */
 	WQ_AFFN_SYSTEM,			/* one pod across the whole system */
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 028afc3d14e59..6be884eb3450d 100644
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
 
@@ -8106,6 +8110,56 @@ static bool __init cpus_share_numa(int cpu0, int cpu1)
 	return cpu_to_node(cpu0) == cpu_to_node(cpu1);
 }
 
+/**
+ * cpu_cache_shard_id - compute the shard index for a CPU within its LLC pod
+ * @cpu: the CPU to look up
+ *
+ * Returns a shard index that is unique within the CPU's LLC pod. CPUs in
+ * the same LLC are divided into shards no larger than wq_cache_shard_size,
+ * distributed as evenly as possible. E.g., 20 CPUs with max shard size 8
+ * gives 3 shards of 7+7+6.
+ */
+static int __init cpu_cache_shard_id(int cpu)
+{
+	struct wq_pod_type *cache_pt = &wq_pod_types[WQ_AFFN_CACHE];
+	const struct cpumask *pod_cpus;
+	int nr_cpus, nr_shards, shard_size, remainder, c;
+	int pos = 0;
+
+	/* CPUs in the same LLC as @cpu */
+	pod_cpus = cache_pt->pod_cpus[cache_pt->cpu_pod[cpu]];
+	/* Total number of CPUs sharing this LLC */
+	nr_cpus = cpumask_weight(pod_cpus);
+	/* Number of shards to split this LLC into */
+	nr_shards = DIV_ROUND_UP(nr_cpus, wq_cache_shard_size);
+	/* Minimum number of CPUs per shard */
+	shard_size = nr_cpus / nr_shards;
+	/* First @remainder shards get one extra CPU */
+	remainder = nr_cpus % nr_shards;
+
+	/* Find position of @cpu within its cache pod */
+	for_each_cpu(c, pod_cpus) {
+		if (c == cpu)
+			break;
+		pos++;
+	}
+
+	/*
+	 * Map position to shard index. The first @remainder shards have
+	 * (shard_size + 1) CPUs, the rest have @shard_size CPUs.
+	 */
+	if (pos < remainder * (shard_size + 1))
+		return pos / (shard_size + 1);
+	return remainder + (pos - remainder * (shard_size + 1)) / shard_size;
+}
+
+static bool __init cpus_share_cache_shard(int cpu0, int cpu1)
+{
+	if (!cpus_share_cache(cpu0, cpu1))
+		return false;
+	return cpu_cache_shard_id(cpu0) == cpu_cache_shard_id(cpu1);
+}
+
 /**
  * workqueue_init_topology - initialize CPU pods for unbound workqueues
  *
@@ -8118,9 +8172,15 @@ void __init workqueue_init_topology(void)
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

