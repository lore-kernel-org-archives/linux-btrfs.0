Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0CC3F20E8;
	Thu, 12 Mar 2026 16:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773332324; cv=none; b=T8IX6N0jNCbbLG4yS2l1q6L9HbJH9zbK1FpxuJE8bPVlWiTDI2jG/Cl6wcIJboXkHKb8q3nMT5F36YNzsi2XpyTl5YKwzyQeuZw5j5y6/AtRVnlsR0rV3Mn0FvHmaW8ygIw/DrqRJh6i1dZR3/pNlecLcOXzVTtEKL16jBUtEAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773332324; c=relaxed/simple;
	bh=Gj8IfKq47j96G0fKxsPudSwO7TRrM8S+UvuPgEmizNs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oVHsDwYkQ1CNGHsW3X4hvQ502j52JWzpoxCukeuxi0NtMv1rUvHIgMloj+/kzkpC1pSgCWnDN/SD3S8mjxgKy9RKkOLmj+KGY0pBTPRLfpW1AXlN9tcOoNaLmgxw0IZl9AIqEnJt9v/uhNUkWnKfCCPG7VP4dexE4oU11UMHtNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Y2Z4tnok; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Y2Z4tnok"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ZIHytvKe6v2JmVfhWdYItXKJ9NthmUM7xANrJTNvyAw=; b=Y2Z4tnok2izaOnmjLcLD+XStds
	tFNrXdcOXoBJFPfQyv3eRDDBqkAuf7KQsBdotVWPWwj6xM5NTSMG5N2eRkjT8fRFXZGiy30La5iZW
	NuRo/qtNnpzZTcq161ZIzOLwsPqiybw/NcyMFz5S2JfCjuKjHnjS6Kt5JAuA5aBXWMBEP7r+jDQwW
	93m7XMIfRkt/xVk+mgF0jpu6oC1YJ+JJRYRulRLgm/JI/aUTmPcYQnKQ4R4TFrXQ3xG2kQOYpA7HV
	FUpIBGFhGvcgy2ukZS5/lMQdec6ZuDInYa1b1nwPMZpTvMo15yfahkewn33dkxqrmH8Vvwz82jmeh
	I5PZifJg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0ikD-004fOG-AP; Thu, 12 Mar 2026 16:18:41 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 12 Mar 2026 09:12:05 -0700
Subject: [PATCH RFC 4/5] workqueue: add test_workqueue benchmark module
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260312-workqueue_sharded-v1-4-2c43a7b861d0@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9313; i=leitao@debian.org;
 h=from:subject:message-id; bh=Gj8IfKq47j96G0fKxsPudSwO7TRrM8S+UvuPgEmizNs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsudL+tfkq//0w425LRC/heBwiMlasFBT7f8cN
 jS21m7ItbGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabLnSwAKCRA1o5Of/Hh3
 bSiHEACQp1tkO1ZaXom6sAAUHzGRAKZXHC3kdQ0XASKS7egkwXSmBf2rI//rtQkINdGpMhbL3c3
 FRmywug4ymxsf5paetNu8lhki9loJ6ZQEGUxLz5BQyQX652uarRdA8JMhEV5iAC8ajaXLTN/TXz
 0K5WU5/kLZFnUJ9/l3k0aqtgA0O6phdvFFjseUzO1dRVlQ0m1N+kO15E7NZs6zH+6V8AMCicDna
 EUYCsMf0IEOdVmRyeXjU1wUzCnXESMUxeS61Cbgqm0HeqtzTHO8e7iIARodZ1iK8Gyj6GSEUif+
 aZXCVqCkviWwsX5nUX6HjtdE1fKpvp1ioiOMcTgSG6Guuoc1pC1VuDsUjQhtVAnSzTEXyLOlNgD
 5JPhuvSR7ElMA0o9sFE7K7SXpFc8mL/J/KNa48OVNCIrjrSsUBB9CxUSQ++T/I8N+R7uA/GclUm
 iU2LvYWIzqkiinCKMIm+iPqlU8e+/79/Y0l9q+ITxz39qM5RLXtJXa+w32cw0g2pVg8Hihq4UGj
 vHnXSa30BqU8/DDupuSyKSwbXyhWt/yPJdbtYOQ9nskuR3bp0Gc10S5tQGItJoYMDlcQ+xTOKfR
 W9lBadVLh7UmTPvfCmRZS6RXAkgjQPfbsg4T3Gi5u8Dvo/FWBpQ/ypCmZDwcCjhLn6p0EA8m34a
 COmQpeyiR2uuKLw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Add a kernel module that benchmarks queue_work() throughput on an
unbound workqueue to measure pool->lock contention under different
affinity scope configurations (cache vs cache_shard).

The module spawns N kthreads (default: num_online_cpus()), each bound
to a different CPU. All threads start simultaneously and queue work
items, measuring the latency of each queue_work() call. Results are
reported as p50/p90/p95 latencies for each affinity scope.

The affinity scope is switched between runs via the workqueue's sysfs
affinity_scope attribute (WQ_SYSFS), avoiding the need for any new
exported symbols.

The module runs as __init-only, returning -EAGAIN to auto-unload,
and can be re-run via insmod.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 lib/Kconfig.debug    |  10 ++
 lib/Makefile         |   1 +
 lib/test_workqueue.c | 275 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 286 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 93f356d2b3d95..38bee649697f3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2628,6 +2628,16 @@ config TEST_VMALLOC
 
 	  If unsure, say N.
 
+config TEST_WORKQUEUE
+	tristate "Test module for stress/performance analysis of workqueue"
+	default n
+	help
+	  This builds the "test_workqueue" module for benchmarking
+	  workqueue throughput under contention. Useful for evaluating
+	  affinity scope changes (e.g., cache_shard vs cache).
+
+	  If unsure, say N.
+
 config TEST_BPF
 	tristate "Test BPF filter functionality"
 	depends on m && NET
diff --git a/lib/Makefile b/lib/Makefile
index 1b9ee167517f3..ea660cca04f40 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -79,6 +79,7 @@ UBSAN_SANITIZE_test_ubsan.o := y
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
 obj-$(CONFIG_TEST_VMALLOC) += test_vmalloc.o
+obj-$(CONFIG_TEST_WORKQUEUE) += test_workqueue.o
 obj-$(CONFIG_TEST_RHASHTABLE) += test_rhashtable.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_keys.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_key_base.o
diff --git a/lib/test_workqueue.c b/lib/test_workqueue.c
new file mode 100644
index 0000000000000..82540e5536078
--- /dev/null
+++ b/lib/test_workqueue.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Test module for stress and performance analysis of workqueue.
+ *
+ * Benchmarks queue_work() throughput on an unbound workqueue to measure
+ * pool->lock contention under different affinity scope configurations
+ * (e.g., cache vs cache_shard).
+ *
+ * The affinity scope is changed between runs via the workqueue's sysfs
+ * affinity_scope attribute (WQ_SYSFS).
+ *
+ * Copyright (c) 2026 Meta Platforms, Inc. and affiliates
+ * Copyright (c) 2026 Breno Leitao <leitao@debian.org>
+ *
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/moduleparam.h>
+#include <linux/completion.h>
+#include <linux/atomic.h>
+#include <linux/slab.h>
+#include <linux/ktime.h>
+#include <linux/cpumask.h>
+#include <linux/sched.h>
+#include <linux/sort.h>
+#include <linux/fs.h>
+
+#define WQ_NAME "bench_wq"
+#define SCOPE_PATH "/sys/bus/workqueue/devices/" WQ_NAME "/affinity_scope"
+
+static int nr_threads;
+module_param(nr_threads, int, 0444);
+MODULE_PARM_DESC(nr_threads,
+	"Number of threads to spawn (default: 0 = num_online_cpus())");
+
+static int wq_items = 50000;
+module_param(wq_items, int, 0444);
+MODULE_PARM_DESC(wq_items,
+	"Number of work items each thread queues (default: 50000)");
+
+static struct workqueue_struct *bench_wq;
+static atomic_t completed;
+static atomic_t threads_done;
+static DECLARE_COMPLETION(start_comp);
+static DECLARE_COMPLETION(all_done_comp);
+
+struct thread_ctx {
+	struct work_struct work;
+	struct completion work_done;
+	u64 *latencies;
+	int cpu;
+	int items;
+};
+
+static void bench_work_fn(struct work_struct *work)
+{
+	struct thread_ctx *ctx = container_of(work, struct thread_ctx, work);
+
+	atomic_inc(&completed);
+	complete(&ctx->work_done);
+}
+
+static int bench_kthread_fn(void *data)
+{
+	struct thread_ctx *ctx = data;
+	ktime_t t_start, t_end;
+	int i;
+
+	/* Wait for all threads to be ready */
+	wait_for_completion(&start_comp);
+
+	for (i = 0; i < ctx->items; i++) {
+		reinit_completion(&ctx->work_done);
+		INIT_WORK(&ctx->work, bench_work_fn);
+
+		t_start = ktime_get();
+		queue_work(bench_wq, &ctx->work);
+		t_end = ktime_get();
+
+		ctx->latencies[i] = ktime_to_ns(ktime_sub(t_end, t_start));
+		wait_for_completion(&ctx->work_done);
+	}
+
+	if (atomic_dec_and_test(&threads_done))
+		complete(&all_done_comp);
+
+	return 0;
+}
+
+static int cmp_u64(const void *a, const void *b)
+{
+	u64 va = *(const u64 *)a;
+	u64 vb = *(const u64 *)b;
+
+	if (va < vb)
+		return -1;
+	if (va > vb)
+		return 1;
+	return 0;
+}
+
+static int __init set_affn_scope(const char *scope)
+{
+	struct file *f;
+	loff_t pos = 0;
+	ssize_t ret;
+
+	f = filp_open(SCOPE_PATH, O_WRONLY, 0);
+	if (IS_ERR(f)) {
+		pr_err("test_workqueue: open %s failed: %ld\n",
+		       SCOPE_PATH, PTR_ERR(f));
+		return PTR_ERR(f);
+	}
+
+	ret = kernel_write(f, scope, strlen(scope), &pos);
+	filp_close(f, NULL);
+
+	if (ret < 0) {
+		pr_err("test_workqueue: write '%s' failed: %zd\n", scope, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __init run_bench(int n_threads, const char *scope)
+{
+	struct thread_ctx *ctxs;
+	struct task_struct **tasks;
+	u64 *all_latencies;
+	unsigned long total_items;
+	ktime_t start, end;
+	s64 elapsed_us;
+	int cpu, i, j, ret;
+
+	ret = set_affn_scope(scope);
+	if (ret)
+		return ret;
+
+	ctxs = kcalloc(n_threads, sizeof(*ctxs), GFP_KERNEL);
+	if (!ctxs)
+		return -ENOMEM;
+
+	tasks = kcalloc(n_threads, sizeof(*tasks), GFP_KERNEL);
+	if (!tasks) {
+		kfree(ctxs);
+		return -ENOMEM;
+	}
+
+	total_items = (unsigned long)n_threads * wq_items;
+	all_latencies = kvmalloc_array(total_items, sizeof(u64), GFP_KERNEL);
+	if (!all_latencies) {
+		kfree(tasks);
+		kfree(ctxs);
+		return -ENOMEM;
+	}
+
+	/* Allocate per-thread latency arrays */
+	for (i = 0; i < n_threads; i++) {
+		ctxs[i].latencies = kvmalloc_array(wq_items, sizeof(u64),
+						   GFP_KERNEL);
+		if (!ctxs[i].latencies) {
+			while (--i >= 0)
+				kvfree(ctxs[i].latencies);
+			kvfree(all_latencies);
+			kfree(tasks);
+			kfree(ctxs);
+			return -ENOMEM;
+		}
+	}
+
+	atomic_set(&completed, 0);
+	atomic_set(&threads_done, n_threads);
+	reinit_completion(&all_done_comp);
+	reinit_completion(&start_comp);
+
+	/* Create kthreads, each bound to a different online CPU */
+	i = 0;
+	for_each_online_cpu(cpu) {
+		if (i >= n_threads)
+			break;
+
+		ctxs[i].cpu = cpu;
+		ctxs[i].items = wq_items;
+		init_completion(&ctxs[i].work_done);
+
+		tasks[i] = kthread_create(bench_kthread_fn, &ctxs[i],
+					  "wq_bench/%d", cpu);
+		if (IS_ERR(tasks[i])) {
+			ret = PTR_ERR(tasks[i]);
+			pr_err("test_workqueue: failed to create kthread %d: %d\n",
+			       i, ret);
+			while (--i >= 0)
+				kthread_stop(tasks[i]);
+			goto out_free;
+		}
+
+		kthread_bind(tasks[i], cpu);
+		wake_up_process(tasks[i]);
+		i++;
+	}
+
+	/* Start timing and release all threads */
+	start = ktime_get();
+	complete_all(&start_comp);
+
+	/* Wait for all threads to finish */
+	wait_for_completion(&all_done_comp);
+
+	/* Drain any remaining work */
+	flush_workqueue(bench_wq);
+
+	end = ktime_get();
+	elapsed_us = ktime_us_delta(end, start);
+
+	/* Merge all per-thread latencies and sort for percentile calculation */
+	j = 0;
+	for (i = 0; i < n_threads; i++) {
+		memcpy(&all_latencies[j], ctxs[i].latencies,
+		       wq_items * sizeof(u64));
+		j += wq_items;
+	}
+
+	sort(all_latencies, total_items, sizeof(u64), cmp_u64, NULL);
+
+	pr_info("test_workqueue:   %-12s %llu items/sec\tp50=%llu\tp90=%llu\tp95=%llu ns\n",
+		scope,
+		elapsed_us ? total_items * 1000000ULL / elapsed_us : 0,
+		all_latencies[total_items * 50 / 100],
+		all_latencies[total_items * 90 / 100],
+		all_latencies[total_items * 95 / 100]);
+
+	ret = 0;
+out_free:
+	for (i = 0; i < n_threads; i++)
+		kvfree(ctxs[i].latencies);
+	kvfree(all_latencies);
+	kfree(tasks);
+	kfree(ctxs);
+
+	return ret;
+}
+
+static const char * const bench_scopes[] = {
+	"cpu", "smt", "cache_shard", "cache", "numa", "system",
+};
+
+static int __init test_workqueue_init(void)
+{
+	int n_threads = nr_threads ?: num_online_cpus();
+	int i;
+
+	bench_wq = alloc_workqueue(WQ_NAME, WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!bench_wq)
+		return -ENOMEM;
+
+	pr_info("test_workqueue: running %d threads, %d items/thread\n",
+		n_threads, wq_items);
+
+	for (i = 0; i < ARRAY_SIZE(bench_scopes); i++)
+		run_bench(n_threads, bench_scopes[i]);
+
+	destroy_workqueue(bench_wq);
+
+	return -EAGAIN;
+}
+
+module_init(test_workqueue_init);
+MODULE_AUTHOR("Breno Leitao <leitao@debian.org>");
+MODULE_DESCRIPTION("Stress/performance benchmark for workqueue subsystem");
+MODULE_LICENSE("GPL");

-- 
2.52.0

