Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F6B3D34B2;
	Fri, 20 Mar 2026 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029433; cv=none; b=QLw59og42WeH2LrlqS7SR9hUPzG7HOX+eXT1SxCwepuLH4wgxDZElqh8K+zgucKj5m3lpHMJ8CHKKMtfu2/BH8wjLquLZa7AK5nCNmHOBw+pBIoSVxn9zE6/37vMbzNMPLDA1/Hl/dpjAuqRByxUAbJWclPKIONxcgRKAXWY3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029433; c=relaxed/simple;
	bh=El5ibJ79wHlp/UQyQg10sj63O6vV45KV3KVRT42VTaQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=sukm/wzzcIZ5TVebXqEPhmS2Q3QEEZqr/PPFsBtrakHrRiINVyv+PoMaZRICKrjL2RGX1eIofG3bMfOALIqtdt5NEp01r+sGdzITuFwSe6XhgSBmAhQme6ClpeP9yh8tlb2jUD0fe3o1Y6CBJovgBXC/9mkl58tFZG71O9vPf/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=dHifkCS+; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="dHifkCS+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=xNzfgZE3GvOiZ8lnfvpmq6wiqYLCeS1daD7szf0/GSI=; b=dHifkCS+/8LbdLoqIRxfkbw40M
	u2D3FkrvAu5HCoT+veawSELv8EZCGaX/+21fJOZToA8QEReUas+SPp9WCQttMgQqtqAffYGdigBrs
	XmXW/SaIkYyXODAEYkfoXquz1m1Uh7zeIvm8ZzdFwIH158i0Joz9vXNV848pzzcnQc6i/c5Gkadzx
	JPEXtyy/I1xhNuMksWVMek/87ktNtEHi1LZK3SAZ6blQSGCydc7aMfEeasSbwcRlp6llywS2kqREq
	aDIfnP4zj1JKXZ5OUsscZUmE7I5HgUJr9OPmFunZHaX1FRpqivF80BW5SQPP0qFz76raKSHvg3GT6
	FHohfHag==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3e5p-005Nef-SG; Fri, 20 Mar 2026 17:57:04 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/5] workqueue: Introduce a sharded cache affinity scope
Date: Fri, 20 Mar 2026 10:56:26 -0700
Message-Id: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAEuKvWkC/23Nyw6CMBCF4VdpZk1NOyi3le9hiGnpCNWE6hRQQ
 3h3A7p0eZI/35khEnuKUIkZmCYffeihEpgIaDrTtyS9g0oAKsxUqkr5DHx7jDTSOXaGHTmJKeb
 lIaOiKC0kAu5MF//azFP93XG0V2qGFVqLzsch8Hs7nfTa/XyNf/xJSyWx2acmt0WmnTo6st70u
 8At1MuyfADyghqXxQAAAA==
X-Change-ID: 20260309-workqueue_sharded-2327956e889b
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=6032; i=leitao@debian.org;
 h=from:subject:message-id; bh=El5ibJ79wHlp/UQyQg10sj63O6vV45KV3KVRT42VTaQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpvYprvZl176tK78m4VrjPORFM6f0Ln/+yYwobN
 3ddatwOAPOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCab2KawAKCRA1o5Of/Hh3
 bawtD/4j+QLuOMawIhP4kc/Z6B1Hh91k2iqu1hle2iDyejlGhaSHlqZW7bEI4DvRrtrn5Fp1fy9
 bnKaczvs5uFqQ6EN9BrBPQp5NaexUdEsQ3pkEzsqZiOSGb344q/pVpXDTEvCxgihsgg02FoLGa+
 UWnjtBPorWWRF5P2cknGeBrNA1nHIea64ra+WlWfTCd4Y6z4pG0EcAGgn1Xt9rj+HeB5xCPnXZg
 JCs7b2qLf+7FbmH28YmHXOaTi+GL6HcE9HIGEZQsrDM9bAAMLeayncOYS69mkI15z5VdIpwMCXb
 /VlYGHxVuiuNCOf31qkCf/BUBEjPEWOTZeumeR7W9/8fk3nqq44Xb3m7JDN3Mh431ph1pYsnnUx
 Bupjt2zLTDT+kCPyZFmdVyyANb53UvvWD7QSBf8sSI4g9rDNufgn+QuTjSYM4m7Vg5eW0xuE3u5
 HmVIi3FWSxXbXjL8paAkjTIvOzSKA0X8Fl5oXx0Od7gqRUnpJTZsj2QwLHuzf5B4Ln8FFawW/cU
 Z8EUcj0Tz+8rvDtiDq0LXvLpKg56K8qjAJ8HWDmpO/6JEHAsYixz6YUhchuuyLGrkjrkhttXRsu
 g21kcJYpavMryaXnnpTuCSIUnd5F7HBsId9Qbnk1TEZwLeqbzts21YpmgB4LVp+FOOG7PJiEHhy
 wsZzPERwWYGo67g==
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
    Intel.

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

 * Intel (AMD EPYC 9D64 88-Core Processor - 11 L3 domains, 8 Cores / 16 vCPUs each)

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
Changes in v2:
- wq_cache_shard_size is in terms of cores (not vCPU)
- Link to v1: https://patch.msgid.link/20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org

---
Breno Leitao (5):
      workqueue: fix typo in WQ_AFFN_SMT comment
      workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
      workqueue: set WQ_AFFN_CACHE_SHARD as the default affinity scope
      tools/workqueue: add CACHE_SHARD support to wq_dump.py
      workqueue: add test_workqueue benchmark module

 include/linux/workqueue.h  |   3 +-
 kernel/workqueue.c         | 110 +++++++++++++++++-
 lib/Kconfig.debug          |  10 ++
 lib/Makefile               |   1 +
 lib/test_workqueue.c       | 277 +++++++++++++++++++++++++++++++++++++++++++++
 tools/workqueue/wq_dump.py |   3 +-
 6 files changed, 401 insertions(+), 3 deletions(-)
---
base-commit: 1adb306427e971ccac25b19410c9f068b92bd583
change-id: 20260309-workqueue_sharded-2327956e889b

Best regards,
--  
Breno Leitao <leitao@debian.org>

