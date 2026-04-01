Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA6F413245;
	Wed,  1 Apr 2026 13:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048676; cv=none; b=uBbrSppVsdCW0tEosY8QWJAyh/j/ru8pl672RQbTtm1X6gdF742N2brCsq2tJ68ryBlXE/rEh4xsZgJpqNwsIQvA4BK/jcuuzfOF2MM0FhFgNal7yyMZUHzg0Ft3en4fmqgU1ga0XKjreP0UXbHmwqXMRsoJ6oBY+V6y7bdRQd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048676; c=relaxed/simple;
	bh=lzyk9Q32hb8/ESHa+z9bZun2ttyufg2hEeyWdc20Lqc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OslhfR+rq7k2eJrvwAwmqX5Ni+CJwthQANvvP/8j+n1kDRMnVcaSOrLhnjkS4jDEn+myCoJmssSKQX3ySVzNNQYuyNxnJCQA9tZp5urvM+zElSu5kEjNcs0ZkX8jI9u5qcVj9tCu41gHK+Ckw0cTTcB3JPH/6IPeNmUTunTNRSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=b9x9X/iu; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="b9x9X/iu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=uA6NwbSAM5Stt0CSfKD6RNJYCyIOL5imWVO8WuD/wrc=; b=b9x9X/iuhZnwSOJY39LbAZCD5w
	3qNJpxdSryFOP/m5kIZgMbqZgo4UtLhNEQpL7P0nL2v7yAsj6+sZ/NzL7H3kaRz8KlYz2lequhDhP
	XwatpTXwgG9lu4x/tIyXpbFpYzkQbgrk1ey2+RFhgAlo1AHqDe+jufwvihn9EElq0fmm7x364TuVO
	3ToldNKTZAX5825RWheAWWiGgl81K93FoBTTfjfQk9oKNRoAKwYPAaWfYv717ZJ8DobfznSGdyrWq
	8qQ1uU8xHoX9cJY6fqlLQo69pjoqicGiaRuub34NUiL8Ko0kYFHFcwKPg3sUCis5GXC3bRm2YfPxH
	SA4ERthQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7vFJ-0030QD-2i;
	Wed, 01 Apr 2026 13:04:32 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 06:03:56 -0700
Subject: [PATCH v3 5/6] workqueue: add test_workqueue benchmark module
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-workqueue_sharded-v3-5-ab0b9336bf0b@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10462; i=leitao@debian.org;
 h=from:subject:message-id; bh=lzyk9Q32hb8/ESHa+z9bZun2ttyufg2hEeyWdc20Lqc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzRfIiZwOV4kL5EYS1u6FVvrMq51T1CG6uBQas
 GHWOMITlUuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac0XyAAKCRA1o5Of/Hh3
 bY30EAClSbNrzqv6st731jFECxyynBfdcuZYoari30VGPoqb0XLL/uhZUNDWxb9nlzddRG4zA21
 wZCVFUXAOhbjowXFVOWZ4N78I/Cn2Ue5oqjTuy0k70ACDzF2qhOZmlE6zJuSyG37IayO2irzvDT
 cPzof1ek2iUVSzvk5QoxhEmbJjqtzKstMjLr1nPd8hm9ge7ROWlXpX2ztmuZEM+BJ4jl7vD7EEt
 YRyu8kDFApcc2D/JY+QylGf/4r5nhBQhoIT6x+jjwzxVU0hPKeoNj/gFqF5pS4sIAx/vYR4YUuf
 vlV3JitZrfI90Yk7JGoZkSaSPFsAY4FsHYb/rG9fnmnYJpAe6C22x7oMVC74hF53mhS1RmJcWfx
 Ny0zTFJnIsGmte45SVbQvbsCRN7vY2wO3FPNW94IVQZi4+rSjV3G9JvRlmN1YK4fzWu2ycrb3rm
 CNrSlVAvY+cupg5wWLOzo0MKxkkM7/9GfWqtMD9fkVeB8nmibtk1vf0kaYukdcNbL9Qs9XiYvau
 4Ejwe5UkGq8xYzJ6bicRX7IlFRJgYJ0vw2rbUjmMFCdd9zUFAo+RjvZjn8h0RMUpUsjZuGgcr5y
 EnjiKfLoau+faUaKBUZZ0fPJBuCp3ZARnCVGaRH5ntvazCMP4QD05TyNrp0dUWrfa5d3BXic9Jt
 HSXSUxs62nxs7iQ==
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

Example of the output:

 running 50 threads, 50000 items/thread

   cpu              6806017 items/sec p50=2574    p90=5068    p95=5818 ns
   smt              6821040 items/sec p50=2624    p90=5168    p95=5949 ns
   cache_shard      1633653 items/sec p50=5337    p90=9694    p95=11207 ns
   cache            286069 items/sec p50=72509    p90=82304   p95=85009 ns
   numa             319403 items/sec p50=63745    p90=73480   p95=76505 ns
   system           308461 items/sec p50=66561    p90=75714   p95=78048 ns

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 lib/Kconfig.debug    |  10 ++
 lib/Makefile         |   1 +
 lib/test_workqueue.c | 294 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 305 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 93f356d2b3d9..38bee649697f 100644
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
index 1b9ee167517f..ea660cca04f4 100644
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
index 000000000000..f2ae1ac4bd93
--- /dev/null
+++ b/lib/test_workqueue.c
@@ -0,0 +1,294 @@
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
+		 "Number of threads to spawn (default: 0 = num_online_cpus())");
+
+static int wq_items = 50000;
+module_param(wq_items, int, 0444);
+MODULE_PARM_DESC(wq_items,
+		 "Number of work items each thread queues (default: 50000)");
+
+static struct workqueue_struct *bench_wq;
+static atomic_t threads_done;
+static DECLARE_COMPLETION(start_comp);
+static DECLARE_COMPLETION(all_done_comp);
+
+struct thread_ctx {
+	struct completion work_done;
+	struct work_struct work;
+	u64 *latencies;
+	int cpu;
+	int items;
+};
+
+static void bench_work_fn(struct work_struct *work)
+{
+	struct thread_ctx *ctx = container_of(work, struct thread_ctx, work);
+
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
+	if (kthread_should_stop())
+		return 0;
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
+	/*
+	 * Wait for kthread_stop() so the module text isn't freed
+	 * while we're still executing.
+	 */
+	while (!kthread_should_stop())
+		schedule();
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
+static int __init run_bench(int n_threads, const char *scope, const char *label)
+{
+	struct task_struct **tasks;
+	unsigned long total_items;
+	struct thread_ctx *ctxs;
+	u64 *all_latencies;
+	ktime_t start, end;
+	int cpu, i, j, ret;
+	s64 elapsed_us;
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
+			/* Unblock threads waiting on start_comp before stopping them */
+			complete_all(&start_comp);
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
+	/* Wait for all threads to finish the benchmark */
+	wait_for_completion(&all_done_comp);
+
+	/* Drain any remaining work */
+	flush_workqueue(bench_wq);
+
+	/* Ensure all kthreads have fully exited before module memory is freed */
+	for (i = 0; i < n_threads; i++)
+		kthread_stop(tasks[i]);
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
+	pr_info("test_workqueue:   %-16s %llu items/sec\tp50=%llu\tp90=%llu\tp95=%llu ns\n",
+		label,
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
+	int n_threads = min(nr_threads ?: num_online_cpus(), num_online_cpus());
+	int i;
+
+	if (wq_items <= 0) {
+		pr_err("test_workqueue: wq_items must be > 0\n");
+		return -EINVAL;
+	}
+
+	bench_wq = alloc_workqueue(WQ_NAME, WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!bench_wq)
+		return -ENOMEM;
+
+	pr_info("test_workqueue: running %d threads, %d items/thread\n",
+		n_threads, wq_items);
+
+	for (i = 0; i < ARRAY_SIZE(bench_scopes); i++)
+		run_bench(n_threads, bench_scopes[i], bench_scopes[i]);
+
+	destroy_workqueue(bench_wq);
+
+	/* Return -EAGAIN so the module doesn't stay loaded after the benchmark */
+	return -EAGAIN;
+}
+
+module_init(test_workqueue_init);
+MODULE_AUTHOR("Breno Leitao <leitao@debian.org>");
+MODULE_DESCRIPTION("Stress/performance benchmark for workqueue subsystem");
+MODULE_LICENSE("GPL");

-- 
2.52.0

