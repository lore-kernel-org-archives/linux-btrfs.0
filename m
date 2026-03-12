Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561132E3FE;
	Thu, 12 Mar 2026 16:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773332312; cv=none; b=JJ+jZurxZ6KiJGpwousht1sygQccqfRPk15/EPxAzcJS4hIWezGrTG45ohOdNiSpTAA0NaM4pphtJ7Rr/n6ype1AzG145ooQH1uiYpnxMMhU8KhsXb1a/WwpaOO1jp5kn8OcWiNyTnFrRIT26e+xn0KjHrYy+iJHmovqEl2wkHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773332312; c=relaxed/simple;
	bh=jHQXCTGTEh81pGQI5ovCtV4BR7vo7kiocBIpGSB/6V8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Ko61riavGhDrGDEI/5oPwqPfsR5hUzGxeKFi4LZ7/Y2Ms/GVxs+jDE1B//AgEpF8XHM/WTM8erI5GFftffwzVF5dtzQqRtP8MhIF168ICYblerlHxG0xpHdQKKLPpmHOXTbQASV+qtOngnuw7uOdfVLA/o1FcA/ReVqAlDVv5+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=H6xwub8s; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="H6xwub8s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=OTO8aN3iiCYIWs8KCCxCePBEVrjIPE/e0Hifk4yYCbs=; b=H6xwub8suN//TdZAwGQz+qXYCm
	lUsI9hnfLFEhhMbdLfUp292iZllkN7vVi0wcyCSuwRqB9tO8U7BBY45IZqHiHZLY+QmLP5BPg6MmC
	wy8QWod9Dgi9HF4rvfOxOwPDlqh82mu1nDsm26YzbRD5TS3yoc9lD9oQcxcbE3jdh/mpfxBiZIzDA
	f9tn5aZWgerIrHZAR9TYDwxI65bB+NpIDMyiz5pn6J3U3sEWae/D743Uj7oh3xEAToRATn++Kgj0n
	WclR3H8KpIvbj4D2VrdB7g9dv8uHUmXGUajEPaRuReVmxk6P8M4sJ4KUTnc8xbLxZXE8wIwa+z/ip
	5XXfHUjQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0ijw-004fNl-Cu; Thu, 12 Mar 2026 16:18:24 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH RFC 0/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Date: Thu, 12 Mar 2026 09:12:01 -0700
Message-Id: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIANLlsmkC/yXMQQrCMBAF0KsMf91ATLE22Qo9gFsRaZvRjkKrE
 6NC6d1F3b7Fm5FYhRMCzVB+SpJpRKBVQeiHdjyzkYhAcNZVtrTevCa93jNnPqah1cjRuNJt/Lr
 iuvYdCsJN+STv37nHrtni8MeUuwv3j++GZfkASvaug3oAAAA=
X-Change-ID: 20260309-workqueue_sharded-2327956e889b
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=10065; i=leitao@debian.org;
 h=from:subject:message-id; bh=jHQXCTGTEh81pGQI5ovCtV4BR7vo7kiocBIpGSB/6V8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsudLBKWu+8dlXvB6aT4PksjwFqZq3Q7NJnERw
 OmPvHxXEUSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabLnSwAKCRA1o5Of/Hh3
 bWCFD/9EdT9lnOWzTfLJRsJG0tso2iZnhWhTupiGaiwGMgYUtjBQU8GW6WiIyObhlW4cnSaU3n/
 L3qK4mt+wggvzWyf4UDb5LyNaQaYUEpIaMlPtPzuKbmO1VVZK56coXyzzEZHDYWsSAZ2Zcp3Nbg
 7bYlmWuv5Ry2pozm9qh2j+KzgO/ZkQluDsQ02XtiYVa1/JVfTtFjHKHbuBYxwwdoPbZDwBrqyBW
 S85GCMsdaALaG68HTU7oAAOtOw1eIYq0WzVA2Uspn5L8SFilYnN5996azOJ6WrzrzgerPe2J/Er
 dfVzAxr1K4vDIe0D8q+RmNPMDC8Pyu60OSSajMDzxavplR8avJF9CTSWh0CF8RyFgojReSZGowL
 BPyBLMmWc+kRXVJi+IQXRI/+Ku/lhaTVliumz15PPYd4B88pof1V4llvHDfGEaU7tfoF27cQZiB
 0DYOqfl3R9o3Y4F5Zo+8nRRIiNroYlJQezd2FxOUuN8Y4AlHrRMnxPniQdGgMwHtvix/+02/BSh
 ZSDbMELkqd+/d2RV9p6oB8zfCRqwsUg1HNbUvNQqe3FJigCgTTnxKBsgCxvkUmdW6ijE5ULysHY
 40bfYzldMFroyALSO0Gng4dJ09K1J8bh0Lh0HlhX5Lkty4m2HpyzXyAJNDmB7B3GSeeLurnHpWb
 wsX7Lk4eTKUt43w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

TL;DR: Some modern processors have many CPUs per LLC (L3 cache), and
unbound workqueues using the default affinity (WQ_AFFN_CACHE) collapse
to a single worker pool, causing heavy spinlock (pool->lock) contention.
Create a new affinity (WQ_AFFN_CACHE_SHARD) that caps each pool at
wq_cache_shard_size CPUs (default 8).

Problem
=======

Some modern systems have many CPUs sharing one LLC. Here are some examples I have
access to:

 * NVIDIA Grace CPU: 72 real CPUs per LLC
 * Intel(R) Xeon(R) Gold 6450C: 59 SMT threads per LLC
 * Intel(R) Xeon(R) Platinum 8321HC: 51 SMT threads per LLC

On these systems, the default unbound workqueue uses the WQ_AFFN_CACHE
affinity, which results in just a single pool for the whole system (when
all the CPUs share the same LLC as the systems above).

This causes contention on pool->lock, potentially affecting IO
performance (btrfs, writeback, etc)

When profiling an IO-intensive usercache at Meta, I found significant
contention on __queue_work(), making it one of the top 5 contended
locks.

Additionally, Chuck Lever recently reported this problem:

	"For example, on a 12-core system with a single shared L3 cache running
	NFS over RDMA with 12 fio jobs, perf shows approximately 39% of CPU
	cycles spent in native_queued_spin_lock_slowpath, nearly all from
	__queue_work() contending on the single pool lock.

	On such systems WQ_AFFN_CACHE, WQ_AFFN_SMT, and WQ_AFFN_NUMA
	scopes all collapse to a single pod."

Link: https://lore.kernel.org/all/20260203143744.16578-1-cel@kernel.org/

Solution
========

Tejun suggested solving this problem by creating an intermediate
affinity level (aka cache_shard), which would shard the WQ_AFFN_CACHE
using a heuristic, avoiding collapsing all those affinity levels to
a single pod.

Solve this by creating an intermediate sharded cache affinity, and use
it as the default one.

Micro benchmark
===============

To test its benefit, I created a microbenchmark (part of this series)
that enqueues work (queue_work) in a loop and reports the latency.

  Benchmark on NVIDIA Grace (72 CPUs, single LLC, 50k items/thread):

    cpu          3248519 items/sec p50=10944    p90=11488    p95=11648 ns
    smt          3362119 items/sec p50=10945    p90=11520    p95=11712 ns
    cache_shard  3629098 items/sec p50=6080     p90=8896     p95=9728 ns (NEW) **
    cache        708168 items/sec  p50=44000    p90=47104    p95=47904 ns
    numa         710559 items/sec  p50=44096    p90=47265    p95=48064 ns
    system       718370 items/sec  p50=43104    p90=46432    p95=47264 ns

Same benchmark on Intel 8321HC.

    cpu          2831751 items/sec p50=3909     p90=9222     p95=11580 ns
    smt          2810699 items/sec p50=2229     p90=4928     p95=5979 ns
    cache_shard  1861028 items/sec p50=4874     p90=8423     p95=9415 ns (NEW)
    cache        591001 items/sec p50=24901     p90=29865    p95=31169 ns
    numa         590431 items/sec p50=24901     p90=29819    p95=31133 ns
    system       591912 items/sec p50=25049     p90=29916    p95=31219 ns

(** It is still unclear why cache_shard is "better" than SMT on
Grace/ARM. The result is constantly reproducible, though. Still
investigating it)

Block benchmark
===============

Host: Intel(R) Xeon(R) D-2191A CPU @ 1.60GHz (16 Cores - 32 SMT)

In order to stress the workqueue, I am running fio on a dm-crypt device.

  1) Create a plain dm-crypt device on top of NVMe
   * cryptsetup creates an encrypted block device (/dev/mapper/crypt_nvme) on top
     of a raw NVMe drive. All I/O to this device goes through kcryptd — dm-crypt's
     workqueue that handles AES encryption/decryption of every data block.

   # cryptsetup open --type plain -c aes-xts-plain64 -s 256 /dev/nvme0n1 crypt_nvme -d -

  2) Run fio
   * fio hammers the encrypted device with 36 threads (one per CPU), each doing
     128-deep 4K _buffered_ I/O for 10 seconds. This generates massive workqueue
     pressure — every I/O completion triggers a kcryptd work item to encrypt or
     decrypt data.

   # fio --filename=/dev/mapper/crypt_nvme \
         --ioengine=io_uring --direct=0 \
         --bs=4k --iodepth=128 \
         --numjobs=$(nproc) --runtime=10 \
         --time_based --group_reporting

Running this for ~3 hours:

  ┌────────────┬────────────────────────┬────────────────────────┬───────────┬────────┬─────────────────┐
  │ Workload   │       Avg cache        │    Avg cache_shard     │ Avg delta │ Stddev │  2-sigma range  │
  ├────────────┼────────────────────────┼────────────────────────┼───────────┼────────┼─────────────────┤
  │ randread   │ 389 MiB/s (99.6k IOPS) │ 413 MiB/s (106k IOPS)  │ +5.9%     │ 3.3%   │ -0.7% to +12.5% │
  ├────────────┼────────────────────────┼────────────────────────┼───────────┼────────┼─────────────────┤
  │ randwrite  │ 622 MiB/s (159k IOPS)  │ 614 MiB/s (157k IOPS)  │ -1.3%     │ 0.9%   │ -3.1% to +0.5%  │
  ├────────────┼────────────────────────┼────────────────────────┼───────────┼────────┼─────────────────┤
  │ randrw     │ 240 MiB/s (61.4k IOPS) │ 250 MiB/s (64.1k IOPS) │ +4.3%     │ 3.4%   │ -2.5% to +11.1% │
  └────────────┴────────────────────────┴────────────────────────┴───────────┴────────┴─────────────────┘

Same results for buffered IO:

  ┌───────────┬────────────────────────┬────────────────────────┬───────────┬────────┬────────────────┐
  │ Workload  │       Avg cache        │    Avg cache_shard     │ Avg delta │ Stddev │ 2-sigma range  │
  ├───────────┼────────────────────────┼────────────────────────┼───────────┼────────┼────────────────┤
  │ randread  │ 559 MiB/s (143k IOPS)  │ 577 MiB/s (148k IOPS)  │ +3.1%     │ 1.3%   │ +0.5% to +5.7% │
  ├───────────┼────────────────────────┼────────────────────────┼───────────┼────────┼────────────────┤
  │ randwrite │ 437 MiB/s (112k IOPS)  │ 431 MiB/s (110k IOPS)  │ -1.5%     │ 1.0%   │ -3.5% to +0.5% │
  ├───────────┼────────────────────────┼────────────────────────┼───────────┼────────┼────────────────┤
  │ randrw    │ 272 MiB/s (69.7k IOPS) │ 273 MiB/s (69.8k IOPS) │ +0.1%     │ 1.5%   │ -2.9% to +3.1% │
  └───────────┴────────────────────────┴────────────────────────┴───────────┴────────┴────────────────┘

(randwrite result seems to be noise (!?))

Patchset organization
=====================

This series adds a new WQ_AFFN_CACHE_SHARD affinity scope that
subdivides each LLC into groups of at most wq_cache_shard_size CPUs
(default 8, tunable via boot parameter), providing an intermediate
option between per-LLC and per-SMT-core granularity.

On top of the feature, this patchset also prepares the code for the new
cache_shard affinity, and creates a stress test for workqueue.

Then, make this new cache affinity the default one.

On systems with 8 or fewer CPUs per LLC, CACHE_SHARD produces a single
shard covering the entire LLC, making it functionally identical to the
previous CACHE default. The sharding only activates when an LLC has more
than 8 CPUs.

---
Breno Leitao (5):
      workqueue: fix parse_affn_scope() prefix matching bug
      workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
      workqueue: set WQ_AFFN_CACHE_SHARD as the default affinity scope
      workqueue: add test_workqueue benchmark module
      tools/workqueue: add CACHE_SHARD support to wq_dump.py

 include/linux/workqueue.h  |   1 +
 kernel/workqueue.c         |  72 ++++++++++--
 lib/Kconfig.debug          |  10 ++
 lib/Makefile               |   1 +
 lib/test_workqueue.c       | 275 +++++++++++++++++++++++++++++++++++++++++++++
 tools/workqueue/wq_dump.py |   3 +-
 6 files changed, 352 insertions(+), 10 deletions(-)
---
base-commit: b29fb8829bff243512bb8c8908fd39406f9fd4c3
change-id: 20260309-workqueue_sharded-2327956e889b

Best regards,
--  
Breno Leitao <leitao@debian.org>

