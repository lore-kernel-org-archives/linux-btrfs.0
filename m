Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89043D8911;
	Mon, 20 Apr 2026 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691433; cv=none; b=JHf69iPz+3Xyh2vEVpz3nDJ51wL6Va+M43EDxg3ETxLFBy3Wvp0JBvB69Bf3K9WbKiEDuId0cDnOtqtMTfIE/OFV+pv+qLKH17Emtgno7vQxvnBRx3QEm2dyfk+zNATtUdxYOVv7PP+wwfCTtR1h8K4LG/igoOIv+rh7cYJNV94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691433; c=relaxed/simple;
	bh=woOuaIF/NH4sCQd2PLTtEulMutv4uo4EA4cyUTm+uA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HqOIWLhnYmDU8kuwjHi17+eAb+E+y8Z2eyHWg8WE6MzcJLMYHz/wwixArXzx+xew9wlcA2xCDGnSVIl5DsuvVS5urDYvtqmzZ2Sr7Ztu3OaUvDZF0bGQNrbUIm2O77cEz0A3IqpduBIGCaCNVrX+l6TOB8HSZ7uOnFGznBENPXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRNXy4vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRNXy4vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81C7C2BCB7;
	Mon, 20 Apr 2026 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691433;
	bh=woOuaIF/NH4sCQd2PLTtEulMutv4uo4EA4cyUTm+uA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRNXy4vuvbSEbYe61oYzTV6t1vJxMMtJEmb4JEZDA34sSnvYJqxOI0ol6ZLQbnkGQ
	 dUnXp+DjyISw5kKDrYVWOGVb6mU15P252wvqPv9sSBSuCwmFLfLtz/wgvlxDC7z6Vm
	 MDc6eoI/TGrA9F0W67cV1EF+zg9bDnWBNbjv5Fo4tqi3ZN9NHJM4eXSlx66gUdRo1l
	 0xbQvtH22OyewQxq9rq5vynX+sHSOOM3nW4hogRTE1Bg+ULl/c7FQt61LRlx5SD2Iy
	 gMvNUqpDTB4yz/jI2Y1lfgpF4KQiOCeyoxLvDtbuVJwI2CjfO1qBkcx2DgT+5Z+9zL
	 m9Xh6hCkkVq1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Leo Martins <loemra.dev@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] btrfs: don't allow log trees to consume global reserve or overcommit metadata
Date: Mon, 20 Apr 2026 09:16:58 -0400
Message-ID: <20260420132314.1023554-24-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 40f2b11c1b7c593bbbfbf6bf333228ee53ed4050 ]

For a fsync we never reserve space in advance, we just start a transaction
without reserving space and we use an empty block reserve for a log tree.
We reserve space as we need while updating a log tree, we end up in
btrfs_use_block_rsv() when reserving space for the allocation of a log
tree extent buffer and we attempt first to reserve without flushing,
and if that fails we attempt to consume from the global reserve or
overcommit metadata. This makes us consume space that may be the last
resort for a transaction commit to succeed, therefore increasing the
chances for a transaction abort with -ENOSPC.

So make btrfs_use_block_rsv() fail if we can't reserve metadata space for
a log tree extent buffer allocation without flushing, making the fsync
fallback to a transaction commit and avoid using critical space that could
be the only resort for a transaction commit to succeed when we are in a
critical space situation.

Reviewed-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to compile my full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `btrfs` (filesystem)
- **Action verb**: "don't allow" — preventing unwanted behavior,
  indicating a correctness fix
- **Summary**: Prevent log trees from consuming the global reserve or
  overcommitting metadata space

### Step 1.2: Tags
- **Reviewed-by**: Leo Martins `<loemra.dev@gmail.com>` — reviewed
- **Signed-off-by**: Filipe Manana `<fdmanana@suse.com>` — author, core
  btrfs developer (1903 commits)
- **Signed-off-by**: David Sterba `<dsterba@suse.com>` — btrfs
  maintainer
- No Fixes: tag — expected for AUTOSEL candidates. The bug is a design
  oversight, not from a single commit.
- No Reported-by: tag — author identified the issue through code
  analysis
- No Cc: stable — expected for AUTOSEL candidates

### Step 1.3: Commit Body Analysis
The message clearly describes:
- **Bug mechanism**: During fsync, log trees don't reserve space in
  advance. When `btrfs_use_block_rsv()` can't reserve with NO_FLUSH, it
  falls through to consuming the global reserve or overcommitting
  metadata.
- **Symptom**: This depletes critical space needed for transaction
  commits to succeed, increasing the chances of transaction abort with
  -ENOSPC.
- **Failure mode**: Transaction abort with -ENOSPC makes the filesystem
  read-only.
- **Fix approach**: Fail immediately for log trees after NO_FLUSH
  attempt, forcing fsync to fall back to a full transaction commit.

### Step 1.4: Hidden Bug Fix Detection
This is NOT a hidden fix — it's explicitly described as preventing a
problematic behavior that leads to transaction aborts. Record: This is a
clear bug fix for ENOSPC transaction aborts.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: `fs/btrfs/block-rsv.c` only (single file)
- **Lines added**: ~25 (of which 2 are code, rest are extensive
  comments)
- **Lines removed**: 0
- **Function modified**: `btrfs_use_block_rsv()` — a single function
- **Scope**: Single-file surgical fix

### Step 2.2: Code Flow Change
The change inserts an early return AFTER the `BTRFS_RESERVE_NO_FLUSH`
attempt fails (line ~543) and BEFORE:
1. The global reserve fallback (lines 549-553)
2. The `BTRFS_RESERVE_FLUSH_EMERGENCY` overcommit (lines 562-565)

**Before**: Log tree allocations could steal from the global reserve and
use emergency flush.
**After**: Log tree allocations fail immediately, causing fsync to fall
back to a full transaction commit.

### Step 2.3: Bug Mechanism
This is a **logic/correctness fix**: Log trees are an optimization path
(fsync via log replay vs full commit). When they consume the global
reserve or use emergency flush, they deplete resources needed for
regular transaction commits, creating conditions for -ENOSPC transaction
aborts.

### Step 2.4: Fix Quality
- **Obviously correct**: YES — the 2-line check is trivial: `if
  (btrfs_root_id(root) == BTRFS_TREE_LOG_OBJECTID) return ERR_PTR(ret);`
- **Minimal/surgical**: YES — only 2 lines of actual code
- **Regression risk**: ZERO — the worst case is fsync falls back to a
  full transaction commit (slower but safe and already well-tested). All
  callers in `tree-log.c` handle this via `btrfs_set_log_full_commit()`.
- **Red flags**: None

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The `try_reserve` section was originally by Josef Bacik (commit
`67f9c2209e885c`, 2019). The emergency flush was added by Josef Bacik in
commit `765c3fe99bcda0` (Sept 2022, ~v6.1). The bug has existed since
the original code and was worsened by the emergency flush addition.

### Step 3.2: Fixes Tag
No Fixes tag. This is a design oversight that goes back to when the
function was first written. The global reserve stealing has been
possible since the original `btrfs_use_block_rsv()`, and the emergency
flush (added in v6.1 timeframe) made it worse.

### Step 3.3: File History
Recent changes to `block-rsv.c` are mostly refactoring (removing fs_info
arguments, adding treelog_rsv, etc.). No other fix for this specific
issue exists.

### Step 3.4: Author
Filipe Manana is one of the top 3 btrfs contributors with 1903 commits.
He is a core developer and deeply familiar with ENOSPC handling. He also
wrote related fixes like commit `09e44868f1e03` ("btrfs: do not abort
transaction on failure to update log root"), which follows the same
principle: log tree failures should gracefully fall back, not abort
transactions.

### Step 3.5: Dependencies
- `btrfs_root_id()` was introduced in commit `e094f48040cda` (April
  2024, v6.12). For older stable trees, this would need to be
  `root->root_key.objectid`.
- No other structural dependencies — the check is independent of
  `treelog_rsv`.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
Lore.kernel.org was inaccessible due to bot protection. The commit was
submitted by Filipe Manana, signed by the btrfs maintainer David Sterba,
and reviewed by Leo Martins. The emergency flush commit message
(765c3fe99bcda0) mentions "100-200 ENOSPC aborts per day" at Facebook,
demonstrating the real-world impact of ENOSPC issues.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
Modified function: `btrfs_use_block_rsv()`

### Step 5.2: Callers
`btrfs_use_block_rsv()` is called from `btrfs_alloc_tree_block()` in
`extent-tree.c` (line 5367). This is the central tree block allocation
function used by ALL btree operations including log tree operations.

### Step 5.3-5.4: Call Chain
For log trees: `btrfs_sync_log()` →
`btrfs_search_slot()`/`btrfs_cow_block()` → `btrfs_alloc_tree_block()` →
`btrfs_use_block_rsv()`. Errors propagate back, and `btrfs_sync_log()`
calls `btrfs_set_log_full_commit()` to fall back to full transaction
commit. This path is reachable from any `fsync()` syscall — a very
common user operation.

### Step 5.5: Similar Patterns
The pattern of checking root type before allowing dangerous operations
is used elsewhere in btrfs (e.g., `btrfs_init_root_block_rsv()` already
distinguishes log trees from other roots).

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
The `btrfs_use_block_rsv()` function exists in ALL active stable trees.
The global reserve stealing has been there since the function was
written. Emergency flush was added in ~v6.1. Both paths allow log trees
to deplete critical reserves.

### Step 6.2: Backport Complications
- For 7.0.y: should apply cleanly
- For 6.12.y, 6.6.y: minor adjustment needed — `btrfs_root_id()` doesn't
  exist in 6.6; needs `root->root_key.objectid`
- For 6.1.y: same `btrfs_root_id` issue +
  `btrfs_reserve_metadata_bytes()` has `fs_info` parameter
- The function structure is preserved across all stable trees

### Step 6.3: No related fixes already in stable for this issue.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**btrfs** (`fs/btrfs/`) — **CORE/IMPORTANT**. Btrfs is a major Linux
filesystem used widely, especially in enterprise (SUSE, Facebook/Meta),
NAS devices, and desktop Linux.

### Step 7.2: Activity
btrfs is actively developed with regular fixes. Filipe Manana alone has
many ENOSPC-related fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All btrfs users who use `fsync()` under near-full filesystem conditions.
This is common for database workloads, log-heavy applications, and any
system with significant write activity.

### Step 8.2: Trigger Conditions
- Filesystem must be near-full or under metadata pressure
- Application calls `fsync()` which triggers log tree updates
- The NO_FLUSH reservation fails, and the log tree consumes the global
  reserve
- Subsequently, a real transaction commit fails because the global
  reserve is depleted
- Not timing-dependent — purely resource-based

### Step 8.3: Failure Mode Severity
**CRITICAL**: Transaction abort with -ENOSPC forces the filesystem read-
only. This is a data availability issue (filesystem becomes unusable
until remounted). The emergency flush commit message confirms "100-200
ENOSPC aborts per day" at scale at Facebook.

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: VERY HIGH — prevents transaction aborts that make
  filesystem read-only
- **Risk**: VERY LOW — 2 lines of code, the fallback (full commit) is
  well-tested, zero regression potential
- **Ratio**: Overwhelmingly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Prevents CRITICAL failure (ENOSPC transaction abort → filesystem goes
  read-only)
- Extremely small and surgical fix (2 lines of code)
- Obviously correct — log trees are an optimization that always has a
  safe fallback
- Written by core btrfs developer (Filipe Manana, 1903 commits)
- Reviewed and signed off by btrfs maintainer (David Sterba)
- Bug exists in all stable trees
- Zero regression risk — worst case is slightly slower fsync
- Well-established error handling path (`btrfs_set_log_full_commit()`)
- Emergency flush commit explicitly called out real-world ENOSPC aborts
  at scale

**AGAINST backporting:**
- No explicit Cc: stable (expected for AUTOSEL)
- No Fixes: tag (design oversight, not single-commit introduction)
- Minor adaptation needed for older stable trees (`btrfs_root_id` →
  `root->root_key.objectid`)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — 2-line check, well-understood
   semantics
2. **Fixes a real bug?** YES — prevents ENOSPC transaction aborts
3. **Important issue?** YES — CRITICAL (filesystem goes read-only)
4. **Small and contained?** YES — single function, single file, 2 lines
   of code
5. **No new features or APIs?** CORRECT — no new features
6. **Can apply to stable?** YES (7.0 cleanly; older trees need trivial
   adaptation)

### Step 9.3: Exception Categories
Not applicable — this is a standard bug fix, not an exception category.

### Step 9.4: Decision
The evidence overwhelmingly supports backporting. This is a small,
obviously correct fix from a core btrfs developer that prevents a
critical failure mode (filesystem forced read-only by ENOSPC transaction
abort). The fix has zero regression risk because the fallback (full
transaction commit instead of log-based fsync) is a well-established
code path.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Leo Martins, SOB by Filipe Manana
  (author) and David Sterba (maintainer)
- [Phase 2] Diff analysis: 2 lines of code added in
  `btrfs_use_block_rsv()` after NO_FLUSH fails, before global reserve
  fallback
- [Phase 2] Verified the error path returns `ERR_PTR(ret)` which
  propagates correctly through `btrfs_alloc_tree_block()`
- [Phase 3] git blame: the `try_reserve` section from commit
  `67f9c2209e885c` (2019), emergency flush from `765c3fe99bcda0` (2022,
  v6.1 timeframe)
- [Phase 3] git log: confirmed 1903 commits from Filipe Manana to
  fs/btrfs/
- [Phase 3] Confirmed `btrfs_root_id()` introduced in `e094f48040cda`
  (April 2024, v6.12)
- [Phase 5] Grep confirmed `btrfs_use_block_rsv()` called from
  `btrfs_alloc_tree_block()` in extent-tree.c:5367
- [Phase 5] Grep confirmed 28+ calls to `btrfs_set_log_full_commit()` in
  tree-log.c — error recovery is well-established
- [Phase 5] Verified `BTRFS_RESERVE_FLUSH_EMERGENCY` comment explicitly
  says "This is potentially dangerous" (space-info.h:75)
- [Phase 6] Buggy code exists in all active stable trees (function
  existed since 2019, emergency flush since ~v6.1)
- [Phase 7] Confirmed btrfs is a major filesystem, ENOSPC issues
  documented at Facebook scale
- [Phase 8] Failure mode: transaction abort → filesystem forced read-
  only → CRITICAL severity
- UNVERIFIED: Could not access lore.kernel.org for mailing list
  discussion (bot protection)

**YES**

 fs/btrfs/block-rsv.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 6064dd00d041b..9efb3016ef116 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -541,6 +541,31 @@ struct btrfs_block_rsv *btrfs_use_block_rsv(struct btrfs_trans_handle *trans,
 					   BTRFS_RESERVE_NO_FLUSH);
 	if (!ret)
 		return block_rsv;
+
+	/*
+	 * If we are being used for updating a log tree, fail immediately, which
+	 * makes the fsync fallback to a transaction commit.
+	 *
+	 * We don't want to consume from the global block reserve, as that is
+	 * precious space that may be needed to do updates to some trees for
+	 * which we don't reserve space during a transaction commit (update root
+	 * items in the root tree, device stat items in the device tree and
+	 * quota tree updates, see btrfs_init_root_block_rsv()), or to fallback
+	 * to in case we did not reserve enough space to run delayed items,
+	 * delayed references, or anything else we need in order to avoid a
+	 * transaction abort.
+	 *
+	 * We also don't want to do a reservation in flush emergency mode, as
+	 * we end up using metadata that could be critical to allow a
+	 * transaction to complete successfully and therefore increase the
+	 * chances for a transaction abort.
+	 *
+	 * Log trees are an optimization and should never consume from the
+	 * global reserve or be allowed overcommitting metadata.
+	 */
+	if (btrfs_root_id(root) == BTRFS_TREE_LOG_OBJECTID)
+		return ERR_PTR(ret);
+
 	/*
 	 * If we couldn't reserve metadata bytes try and use some from
 	 * the global reserve if its space type is the same as the global
-- 
2.53.0

