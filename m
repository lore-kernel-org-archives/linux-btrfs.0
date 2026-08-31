Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456B44F20E2;
	Mon, 31 Aug 2026 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183657; cv=none; b=QUEYnl203ZWphwmQDLsD7IGQRvbgkASFwfUlZT52+tNub3m3Oz6IQUqpSQG66rqIDkqMKqbqTyiL/OyZLF1OB+JaotNpSVSgTxPZ5xk02ilTNyhEt8Zqpdzhqwlw2m0j0ZoqlW1Hqsy4ETr9LsKX5aVuOD0Iye5jnv75fV3NkLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183657; c=relaxed/simple;
	bh=zEqDHXYanW2nHpJvndVZMnpeEEV2ilg51qXHaFl1dl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=giL6YH8NU0dR+thOBPO164NfV+e+suz+84BoeaQ0fByJLxheMndEQqT17mNVOvVq0PQdVIrEJzguUKigu3Ox3hnVuisFxLH8wIl5m1Mh8iM6+eM2teFDeMU1VpzJdXJnd327rXcBy8N+x3ptIRpcmUPsjLvPfKTgplXTsYHmGTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4QrMNFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4QrMNFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873E61F00A3E;
	Mon, 31 Aug 2026 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183654;
	bh=PtQvqlNXGtq66sgWNvsXQTCS7ZRTUVtCQ5YBqjGfQhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4QrMNFEOCyJyiKY/UFLzi2EYTAnUtOzGhtlvgEtvSdknviBtykaD17mo8W+9hAvG
	 NhKJOkgY5GRh2D5D/39YJhHAnMWoz2nngBwEfx0d+LIVsdPgGTFXH+Rv92YO5m7TJK
	 OlrdyD3nHUcgCouaHBCmCpJEHDJoEW+GTGKilae5samTWTk8Q+peGl9yBvWnOM7by/
	 lCRapEPr3ynvHV645vjoIssfrzpKb9+EVxMe4d04Hd10JlRmGo+gH4s+IGWlJ6xOHL
	 jbnhFEv+h56hHajh/oMO1ZPGZsCtM2rRypOSGixDdSc24Ykl5GlrihPXOsuKb1uXUR
	 JfGrctvgkE8Rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ben Maurer <bmaurer@meta.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] btrfs: use lockless read in nr_cached_objects shrinker callback
Date: Mon, 31 Aug 2026 09:24:11 -0400
Message-ID: <20260831133314.4125787-223-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Maurer <bmaurer@meta.com>

[ Upstream commit 1ba72d847c7aa3c0887f749115af5232fd61b598 ]

Under heavy memcg-driven slab reclaim with many memcgs and CPUs,
shrink_slab_memcg() invokes the per-superblock count callback once per
(memcg, NUMA node) tuple. For btrfs that callback reaches
percpu_counter_sum_positive() on fs_info->evictable_extent_maps, which
takes the percpu_counter's raw spinlock with IRQs disabled and walks
every online CPU. With hundreds of memcgs driving reclaim on a host with
dozens of CPUs, this counter lock becomes a global serialization point:
profiles show CPU pinned in the spin_lock_irqsave acquire under
__percpu_counter_sum, with cross-CPU IPIs hitting csd_lock_wait_toolong
while waiting for spinning vCPUs.

The shrinker count is advisory -- super_cache_count() already notes
"counts can change between super_cache_count and super_cache_scan, so we
really don't need locks here." Use percpu_counter_read_positive(), which
is lockless. Worst-case skew is bounded by batch * num_online_cpus (a
few thousand), negligible compared to the millions of extent maps a busy
filesystem accumulates and well within the noise that the shrinker
already tolerates.

Tested-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Ben Maurer <bmaurer@meta.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[btrfs]` `[use]` — Replace the locked
`percpu_counter_sum_positive()` call in the extent-map shrinker count
callback with the lockless `percpu_counter_read_positive()`.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Tested-by:** Boris Burkov `<boris@bur.io>` — fix verified on real
  workload
- **Reviewed-by:** Qu Wenruo `<wqu@suse.com>` — btrfs maintainer
- **Reviewed-by:** Shakeel Butt `<shakeel.butt@linux.dev>` — memcg/mm
  maintainer
- **Signed-off-by:** Ben Maurer `<bmaurer@meta.com>` — author
- **Signed-off-by:** David Sterba `<dsterba@suse.com>` — btrfs
  maintainer
- No `Fixes:`, `Reported-by:`, `Link:`, or `Cc: stable@vger.kernel.org`
  tags (expected for manual review)
- Notable: dual maintainer review (btrfs + memcg), production-scale
  author (Meta)

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** Under heavy memcg-driven slab reclaim with many memcgs and
  CPUs, `shrink_slab_memcg()` invokes the per-superblock count callback
  once per (memcg, NUMA node) tuple. For btrfs this reaches
  `percpu_counter_sum_positive()` on `fs_info->evictable_extent_maps`,
  which takes a raw spinlock with IRQs disabled and walks every online
  CPU.
- **Symptom:** Global serialization — CPUs pinned in `spin_lock_irqsave`
  under `__percpu_counter_sum`, cross-CPU IPIs hitting
  `csd_lock_wait_toolong` while waiting for spinning vCPUs.
- **Root cause:** Using the expensive accurate-sum API in an advisory
  shrinker count path that explicitly does not require locks or
  precision.
- **Fix rationale:** `super_cache_count()` already documents that counts
  are advisory and locks are unnecessary; use lockless
  `percpu_counter_read_positive()` instead.
- **Accuracy bound:** Worst-case skew ≤ `batch * num_online_cpus` (a few
  thousand), negligible vs. millions of extent maps.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Yes — described as a performance optimization, but it fixes
a scalability defect in the memory-reclaim hot path. The VFS shrinker
framework deliberately avoids locking in `super_cache_count()`; btrfs's
locked sum undermines that design and can stall reclaim under memory
pressure. This is a correctness-of-API-usage fix with stability impact,
not mere throughput tuning.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `fs/btrfs/super.c` only (+0/-0 net, 1 line changed)
- **Functions:** `btrfs_nr_cached_objects()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk (line 2413):** Before:
  `percpu_counter_sum_positive(&fs_info->evictable_extent_maps)` —
  acquires `fbc->lock`, iterates all online/dying CPUs, sums per-CPU
  values. After:
  `percpu_counter_read_positive(&fs_info->evictable_extent_maps)` —
  single `READ_ONCE(fbc->count)`, no lock, no cross-CPU walk.
- **Execution path:** Called from `super_cache_count()` →
  `sb->s_op->nr_cached_objects()` during `shrink_slab_memcg()` reclaim,
  potentially once per (memcg, node) per shrinker invocation.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Scalability / lock-contention bug in hot reclaim path
  (synchronization misuse)
- **Mechanism:** `__percpu_counter_sum()` in `lib/percpu_counter.c`
  takes a global raw spinlock and walks every CPU. Invoked repeatedly
  from memcg-aware superblock shrinker counting. Creates a global
  serialization point exactly when the system is under memory pressure
  and needs fast reclaim.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct — direct API substitution; matches VFS
  shrinker contract and btrfs precedent in `space-info.c` (commit
  `2cdb3909c9e95`).
- **Regression risk:** Very low. Under-counting bounded by
  `percpu_counter_batch` (32) × num_cpus; shrinker counts are advisory
  per `fs/super.c:247-249`. xfs uses the same estimate-vs-sum pattern
  (`xfs_estimate_freecounter()`).
- **No new APIs, no behavior change beyond count approximation in an
  already-tolerant path.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- `btrfs_nr_cached_objects()` introduced in `956a17d9d0507` ("btrfs: add
  a shrinker for extent maps", 2024-05-07) by Filipe Manana
- `percpu_counter_sum_positive()` line from `0d89a15e1a0dcc`
  (tracepoints commit, 2024-04-09)
- Bug present since extent-map shrinker landed (~kernel 6.9); confirmed
  ancestor of current HEAD (6.18.44)

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- `956a17d9d0507` — added extent map shrinker and
  `btrfs_nr_cached_objects`
- `f1d97e7691528` — added `evictable_extent_maps` percpu counter
- `2cdb3909c9e95` — btrfs already switched `need_preemptive_reclaim()`
  from `sum_positive` to `read_positive` for same reason (perf/lock
  avoidance)
- `15b3b3254d145` — extent map shrinker iput fix
- Standalone 1-line fix, not part of a series

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** No prior commits from Ben Maurer in this tree's btrfs
history. David Sterba (committer) is btrfs maintainer.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Requires only `evictable_extent_maps`
counter and `btrfs_nr_cached_objects()` — both present in 6.18.44.
Applies cleanly as a single-line change.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** UNVERIFIED — commit not yet in this tree (no SHA for `b4 dig
-c`). `b4 dig` subject search not supported. lore.kernel.org returned
403 (bot protection). Review tags in commit message are the available
review evidence.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** From commit message: Qu Wenruo (btrfs), Shakeel Butt
(memcg/mm), David Sterba (btrfs maintainer/committer). Appropriate
reviewers for this change.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** N/A — no `Reported-by:` or `Link:` tags. Issue identified
via production profiling at Meta (per commit body).

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone fix. Direct precedent: `2cdb3909c9e95` (same
sum→read change in btrfs `space-info.c`).

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** UNVERIFIED — lore.kernel.org inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `btrfs_nr_cached_objects()` (modified); callers:
`super_cache_count()` in `fs/super.c`

### Step 5.2: TRACE CALLERS
**Record:**
- `super_cache_count()` → `shrinker->count_objects` for superblock
  shrinker (`s->s_shrink`, `SHRINKER_MEMCG_AWARE | SHRINKER_NUMA_AWARE`)
- Invoked from `do_shrink_slab()` → `shrink_slab_memcg()` →
  `shrink_slab()` during memory reclaim
- Hot path under memory pressure; frequency scales with num_memcgs ×
  num_nodes × num_shrinkers

### Step 5.3: TRACE CALLEES
**Record:**
- Before: `percpu_counter_sum_positive()` → `__percpu_counter_sum()` →
  `raw_spin_lock_irqsave` + per-CPU iteration
- After: `percpu_counter_read_positive()` → `READ_ONCE(fbc->count)`
  (from `include/linux/percpu_counter.h:118-126`)

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Memory reclaim (kernel-initiated under pressure, triggered
by allocation failures or memcg limits) → `shrink_slab` → superblock
shrinker count → btrfs extent map count. Reachable whenever btrfs is
mounted and memory reclaim runs. Container hosts with many memcgs are
the high-impact scenario.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:**
- btrfs `space-info.c:1031-1032` — already uses `read_positive` for
  heuristic decisions
- xfs `xfs_mount.h:733-736` — `xfs_estimate_freecounter()` uses
  `read_positive` with comment "just provides an estimate"
- `backing-dev.h`, `mm.h` — same read-vs-sum pattern for hot paths vs.
  accurate counts

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** YES. Local tree is **6.18.44** (`git describe HEAD` =
v6.18.44). `fs/btrfs/super.c:2413` still uses
`percpu_counter_sum_positive()`. Extent map shrinker present since
`956a17d9d0507` (May 2024, in 6.18.y ancestry).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Clean apply expected — single-line substitution, no
structural changes needed. No recent churn around
`btrfs_nr_cached_objects()`.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** The `space-info.c` precedent fix (`2cdb3909c9e95`) is
already in tree. This specific shrinker callback fix is NOT yet applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **btrfs filesystem** / memory reclaim interaction.
**Criticality: IMPORTANT** — affects memory reclaim behavior for all
btrfs mounts under memory pressure; severity scales with memcg count.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** btrfs actively maintained in 6.18.y with regular merges from
for-6.17/6.18 tags. Extent map shrinker is relatively new (2024) but
stable in tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** btrfs users under memory pressure, especially:
- Systems with `CONFIG_MEMCG` and many cgroups (containers/K8s)
- Multi-socket / many-CPU hosts
- btrfs root or btrfs data volumes on memory-constrained systems

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Heavy memcg-driven slab reclaim + btrfs mounted + many
(memcg, node) tuples. Common on container hosts; not every boot, but
realistic in production. Unprivileged users can trigger via memory
allocation within their cgroup.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** Global spinlock contention during reclaim → CPU spinning,
cross-CPU IPI stalls (`csd_lock_wait_toolong`), severely degraded
reclaim throughput, potential soft-lockup warnings and system
unresponsiveness under memory pressure. **Severity: HIGH** (stability
under memory pressure, not data corruption or security).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH for affected deployments — removes global lock from
  hot reclaim path; aligns btrfs with VFS shrinker design
- **Risk:** VERY LOW — 1-line change, bounded count imprecision already
  tolerated by shrinker framework
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real production issue (Meta, profiled lock contention)
- Reviewed by btrfs and memcg maintainers; Tested-by present
- 1-line, obviously correct fix
- VFS explicitly documents shrinker counts need no locks
  (`fs/super.c:247-249`)
- Direct btrfs precedent (`2cdb3909c9e95`) and xfs pattern
  (`xfs_estimate_freecounter`)
- Bug present in 6.18.44 since extent map shrinker (6.9+)
- Can cause severe reclaim stalls under memory pressure — stability-
  relevant per stable rules for perf fixes that prevent lockups

**AGAINST backporting:**
- Primarily a scalability/performance issue, not
  crash/corruption/security
- Only affects btrfs + memcg + high-scale configurations
- Approximate count could theoretically under-report objects (bounded,
  maintainer-accepted)

**UNRESOLVED:**
- Mailing list thread and stable-list discussion (lore inaccessible,
  commit not in tree for b4 dig)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — maintainer-reviewed, Tested-
   by, matches established API-usage pattern
2. Fixes a real bug affecting users? **PASS** — lock contention in
   reclaim path on production workloads
3. Important issue? **PASS** — HIGH severity stability under memory
   pressure (reclaim stalls, potential lockup warnings)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code confirmed present,
   clean apply

### Step 9.3: EXCEPTION CATEGORIES
**Record:** N/A — not a device ID, quirk, DT, build, or docs fix.
Standard bug fix.

### Step 9.4: DECISION RATIONALE

This commit fixes btrfs using the wrong percpu_counter API in a shrinker
count callback. The VFS shrinker framework deliberately avoids locking
because counts are advisory; btrfs's use of
`percpu_counter_sum_positive()` introduces a global spinlock into a path
invoked repeatedly per (memcg, node) during reclaim. On large container
hosts this creates a serialization bottleneck during exactly the
operation (memory reclaim) that must remain fast.

The fix is minimal, maintainer-reviewed, has direct precedent in the
same btrfs codebase, and carries negligible regression risk. While not a
traditional crash or corruption bug, it causes serious stability
degradation under memory pressure — a scenario stable trees must handle
well.

---

## Verification

- [Phase 1] Parsed commit message tags: Tested-by, 2× Reviewed-by, 2×
  Signed-off-by; no Fixes/Reported-by/Link
- [Phase 2] Diff analysis: 1-line change in `btrfs_nr_cached_objects()`,
  `sum_positive` → `read_positive`
- [Phase 2] Read `include/linux/percpu_counter.h:97-126`: confirmed
  `sum_positive` locks and iterates CPUs; `read_positive` is lockless
  `READ_ONCE`
- [Phase 2] Read `lib/percpu_counter.c:159-185`: `__percpu_counter_sum`
  documented as "more accurate but much slower"
- [Phase 3] `git describe HEAD`: v6.18.44 / 6.18.44
- [Phase 3] `git blame fs/btrfs/super.c:2410-2418`: function from
  `956a17d9d0507` (2024-05-07)
- [Phase 3] `git merge-base --is-ancestor 956a17d9d0507 HEAD`: shrinker
  commit in 6.18.y
- [Phase 3] `git show 2cdb3909c9e95`: btrfs precedent for same API
  change
- [Phase 4] UNVERIFIED: `b4 dig` failed (no commit SHA in tree);
  lore.kernel.org returned 403
- [Phase 5] Read `fs/super.c:235-262`: `super_cache_count()` explicitly
  avoids locks, notes counts are advisory
- [Phase 5] Read `fs/super.c:377-385`: superblock shrinker is
  `SHRINKER_MEMCG_AWARE | SHRINKER_NUMA_AWARE`
- [Phase 5] Read `mm/shrinker.c:478-594`: `shrink_slab_memcg()` iterates
  shrinkers per memcg/node
- [Phase 5] Read `fs/xfs/xfs_mount.h:729-736`: xfs uses `read_positive`
  for estimates
- [Phase 6] `grep fs/btrfs/super.c`: buggy `percpu_counter_sum_positive`
  confirmed at line 2413
- [Phase 6] `git log -S evictable_extent_maps`: counter and shrinker
  both in tree since 2024
- [Phase 8] `percpu_counter_batch` default = 32
  (`lib/percpu_counter.c:255`)

**YES**

 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9dc399e5dc091..d3661be700810 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2435,7 +2435,7 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_control *sc)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-	const s64 nr = percpu_counter_sum_positive(&fs_info->evictable_extent_maps);
+	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
 
 	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
 
-- 
2.53.0

