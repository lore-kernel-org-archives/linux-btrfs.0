Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A97F224D6;
	Wed,  1 Apr 2026 13:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048658; cv=none; b=jyJv/63MvbdruwJuSEOiu+Kpot9bhZm6q3d52I6amYEKxrx9tKHRRYwdtu35vY1FctMBToidM6uwbWLJccDk8iQHXww4P4KyPbG69UE3Lwh4VHyxXlK6sP9RPH29BetXekN1ucbqBeI7V8/5dyQppbT22I/+QWqxvEpq5QERMNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048658; c=relaxed/simple;
	bh=DZlJJE//7ME5WbHtpkZ/5ylEwDc50p4PUNykZIL3dE4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=sy0prPSjYa/9eW3/80J4ycYyinrAmtFb4wAC46HsAkYAHIwkuA+lqaxkybP/R2WClV+0AQHRWApB5JBTks/IQlk0TwhIFPMwud6UPr0sXSBjFU0RE+A6WUuJ2UP0NpNJhZxLaDUNuqSqr7B/NbkvraZJOS47FnE52Rv1tg5Rzy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=whVaJ/AY; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="whVaJ/AY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zdILjjFkgMtRkAyedJRW7ZLrxS3B+nsezPFoLz3GV4c=; b=whVaJ/AYnufKUzsx9A6M8qqORa
	EbNa+KMRvsgikpFAvwa6XpALL+z7jYkuLDVT0C438I91vszmNv2nIezVvRqnBDyRjYHXGPF91OqCY
	b2YTzmxAGPzXQa+KIo9MjoKFILiVFBB67ymSKRFoIheZ+gXcMXFbvVw2kbtADKh0JN7Eycj+k7ueJ
	iZ2KlfDgrsYK2DoH8jj+P6Mi0EG5OM573lisHV7SD4II8odoAOJRGF/7LfUEARxL2klDNxdNkjTwD
	Jumt9KCaUGHZuikX1HwkssQRmhpfBKm3abIfUsx+guyoKqu4cQc3lzeWfMpd+c1hinaYk4uF4PLsO
	X3Ty+NFw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7vEz-0030PJ-2I;
	Wed, 01 Apr 2026 13:04:12 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/6] workqueue: Introduce a sharded cache affinity scope
Date: Wed, 01 Apr 2026 06:03:51 -0700
Message-Id: <20260401-workqueue_sharded-v3-0-ab0b9336bf0b@debian.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIALkXzWkC/23N0QqCMBTG8VcZ57rFdlbqvOo9ImK6o67A1aZWi
 O8eWhcFXn7w5/eNECk4ipCzEQINLjrfQs7UhkHZmLYm7izkDFBgIpTQ/OHD9d5TT+fYmGDJclS
 Y6n1CWaYL2DC4BarcczGPp8+OfXGhspuhuWhc7Hx4LaeDnLuvL3HFHyQXHMudMmmRJdKKg6XCm
 XbrQw3zwYA/BIo1ArngmUpRK6GVNNUfMU3TG9chtE0IAQAA
X-Change-ID: 20260309-workqueue_sharded-2327956e889b
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=6639; i=leitao@debian.org;
 h=from:subject:message-id; bh=DZlJJE//7ME5WbHtpkZ/5ylEwDc50p4PUNykZIL3dE4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzRfHJPQl1Eb838NSqHN547SX4YBg2XmJQJjiy
 Unp4pECIfeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac0XxwAKCRA1o5Of/Hh3
 bTdlD/9JV/New+GMbwXF0D6YAbQOGCpBMiT32z2LAixH0sx/+Ugi02NdvOKvn383acHkvfnepSj
 2VnNgh9aXc2GRffjKFzS2oPJLWmwTxg5S2FBDYSZ06WcuRiJ8/kT/Wdh5xBCh9wg8AFPi6F9xd0
 y1eNEz+7OebByklyJCvJsIT0KrMTuM3g2RvAwglHL1AHPbqeWzU2aY11qiHx1Z79PGkH2LayNsf
 /RJ7+ul359ig1h5HoBE5QuayEdrqHrl5IIYkch5RFlU9GhMXyvO+QmVIVGb0EOB+GNVMbqRUFVs
 HivrdGyd+BkqptNg2PjlRTZDDKzA/7LOXkTHxRp32wXlkwmnY6LnUW++ecc33RiNEa3C1dxJaa0
 lEVBvXgrSYBWqHtP/pPMosvUYxheBtgA19Sa4cFPT3gOZJ0bb+gEEgvCFdY6muhT2DO5l8Klj8C
 pUJ5QisqSjYlkjeztKmHGJhVs5/pdLElVjESO5DXORjUXx9GBkMXZQ6Tv21w5M4La0dhj+RxWvI
 g4JaJsL0fckepuVvQCcpiFERxd1fWYCicZs3m2jOrWe8l5hmHjgxTWAMTlxiErPGle3cPLs2/Zr
 Fin/7A9KV5vlDootvvO/9o4EJYO2XFyoR0oYs98BceTaq/cA8cn/77J9Ng3GKNgYMa5CYNIU69E
 keq7NRnm0YuE/jA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

TL;DR: Some modern processors have many CPUs per LLC (L3 cache), and
unbound workqueues using the default affinity (WQ_AFFN_CACHE) collapse
to a single worker pool, causing heavy spinlock (pool->lock) contention.
Create a new affinity (WQ_AFFN_CACHE_SHARD) that caps each pool at
wq_cache_shard_size CPUs (default 8).

Changes from RFC:

* wq_cache_shard_size is in terms of cores (not vCPU). So,
  wq_cache_shard_size=8 means the pool will have 8 cores and their siblings,
  like 16 threads/CPUs if SMT=1

* Got more data:

  - AMD EPYC: All means are within ~1 stdev of zero. The deltas are
    indistinguishable from noise. Shard scoping has no measurable effect
    regardless of shard size. This is justified due to AMD EPYC having
    11 L3 domains and lock contention not being a problem:

  - ARM: A strong, consistent signal. At shard sizes 8 and 16 the mean
    improvement is ~7% with relatively tight stdev (~1–2%) at write,
    meaning the gain is real and reproducible across all IO engines.
    Even shard size 4 shows a solid +3.5% with the tightest stdev
    (0.97%).

    Reads: Small shard sizes (2, 4) show a slight regression of
    ~1.3–1.7% (low stdev, so consistent). Larger shard sizes (8, 16)
    flip to a modest +1.4% gain, though shard_size=8 reads have high
    variance (stdev 2.79%) driven by a single outliers (which seems
    noise)

  - Sweet spot: Shard size 8 to 16 offers the best overall profile
    — highest write gain (6.95%) with the lowest write stdev (1.18%),
    plus a consistent read gain (1.42%, stdev 0.70%), no impact on
    AMD/x86.

* ARM (NVIDIA Grace - Neoverse V2 - single L3 domain: CPUs 0-71)

  ┌────────────┬────────────┬─────────────┬───────────┬────────────┐
  │ Shard Size │ Write Mean │ Write StDev │ Read Mean │ Read StDev │
  ├────────────┼────────────┼─────────────┼───────────┼────────────┤
  │ 2          │ +0.75%     │ 1.32%       │ -1.28%    │ 0.45%      │
  ├────────────┼────────────┼─────────────┼───────────┼────────────┤
  │ 4          │ +3.45%     │ 0.97%       │ -1.73%    │ 0.52%      │
  ├────────────┼────────────┼─────────────┼───────────┼────────────┤
  │ 8          │ +6.72%     │ 1.97%       │ +1.38%    │ 2.79%      │
  ├────────────┼────────────┼─────────────┼───────────┼────────────┤
  │ 16         │ +6.95%     │ 1.18%       │ +1.42%    │ 0.70%      │
  └────────────┴────────────┴─────────────┴───────────┴────────────┘

 * x86 (AMD EPYC 9D64 88-Core Processor - 11 L3 domains, 8 Cores / 16 vCPUs each)

  ┌────────────┬────────────┬─────────────┬───────────┬────────────┐
  │ Shard Size │ Write Mean │ Write StDev │ Read Mean │ Read StDev │
  ├────────────┼────────────┼─────────────┼───────────┼────────────┤
  │ 2          │ +3.22%     │ 1.90%       │ -0.08%    │ 0.72%      │
  ├────────────┼────────────┼─────────────┼───────────┼────────────┤
  │ 4          │ +0.92%     │ 1.59%       │ +0.67%    │ 2.33%      │
  ├────────────┼────────────┼─────────────┼───────────┼────────────┤
  │ 8          │ +1.75%     │ 1.47%       │ -0.42%    │ 0.72%      │
  ├────────────┼────────────┼─────────────┼───────────┼────────────┤
  │ 16         │ +1.22%     │ 1.72%       │ +0.43%    │ 1.32%      │
  └────────────┴────────────┴─────────────┴───────────┴────────────┘

---
Changes in v3:
- Precomputed the shards to avoid exponential time when creating the
  pool. (Tejun)
- Add documentation about the new cache sharding affinity.
- Fixed use-after-free on module unload (on the selftest)
- Link to v2: https://patch.msgid.link/20260320-workqueue_sharded-v2-0-8372930931af@debian.org

Changes in v2:
- wq_cache_shard_size is in terms of cores (not vCPU)
- Link to v1: https://patch.msgid.link/20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org

---
Breno Leitao (6):
      workqueue: fix typo in WQ_AFFN_SMT comment
      workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
      workqueue: set WQ_AFFN_CACHE_SHARD as the default affinity scope
      tools/workqueue: add CACHE_SHARD support to wq_dump.py
      workqueue: add test_workqueue benchmark module
      docs: workqueue: document WQ_AFFN_CACHE_SHARD affinity scope

 Documentation/admin-guide/kernel-parameters.txt |   3 +-
 Documentation/core-api/workqueue.rst            |  14 +-
 include/linux/workqueue.h                       |   3 +-
 kernel/workqueue.c                              | 185 ++++++++++++++-
 lib/Kconfig.debug                               |  10 +
 lib/Makefile                                    |   1 +
 lib/test_workqueue.c                            | 294 ++++++++++++++++++++++++
 tools/workqueue/wq_dump.py                      |   3 +-
 8 files changed, 505 insertions(+), 8 deletions(-)
---
base-commit: 0e4f8f1a3d081e834be5fd0a62bdb2554fadd307
change-id: 20260309-workqueue_sharded-2327956e889b

Best regards,
--  
Breno Leitao <leitao@debian.org>

