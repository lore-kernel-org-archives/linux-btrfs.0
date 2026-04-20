Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4D43FF899;
	Mon, 20 Apr 2026 13:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691602; cv=none; b=jvxoF7JywcS6FQ7JhtFU72WsINQMseveCNDwWGlglHbFanUn0PcwDftwfHerP1ribfjnO9E/8pdV+HZ0QND4IYVp7ZwqIkuKbkiu+OgBoxL0BnCPB6B0Z8spuEsEswdzURC5Ei4ijs7htf6dqVmelXYcnOgL1LTpO55ZbgYiBb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691602; c=relaxed/simple;
	bh=95WN5sYertdwIMQjfnx9hCDly4/Zh3P/4b9JLd2upBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t/v7AiwHGHDuFifWHE4FwCYJ4ExM4isaX03oAi2ERshinvwlcvOA+5r16glF4+vfjyFDo4o7nSgwKm+Tt+uQvqw81bBbcPjcFxgFm2bbBMlmgwDDnz7ErJi0XBk3l/F+Pj9de8JykjeaQqXWlBufJSrS91yz5ej1Mv+1jnri9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwtyksGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwtyksGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB67C2BCB6;
	Mon, 20 Apr 2026 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691602;
	bh=95WN5sYertdwIMQjfnx9hCDly4/Zh3P/4b9JLd2upBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwtyksGq2lTIVwTjXkon6U2Ew1hKD4rwIR6YptqgE2PlzMYmWjPDolH+BNMmnVMF4
	 hlEkhglsMZ6kojnhUGBgBtLLbZcYunDVUYW1MklDMplN6mseLVDiaf4VakE64L/zRj
	 etZgaDKX/9P6KzBNqi7Ubzqc3RBZ7boLRdyZMN1rve0RCaAg7pe3DQxs0rp3oiYpVJ
	 vc75NUfoFac4aU6ZZLwi/Ev0Xzz64EjBSwyfvaB3p/FDdE7q60gbTBmGXhDbfzIHmg
	 ii/rZ7ggziWLgNvrut4xUaC+AJm/fNx8VYhkq/qktyhu9a1FnjGHp9W/BAHg18UEQN
	 kjcAZn4WuihMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leo Martins <loemra.dev@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] btrfs: avoid GFP_ATOMIC allocations in qgroup free paths
Date: Mon, 20 Apr 2026 09:18:39 -0400
Message-ID: <20260420132314.1023554-125-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Leo Martins <loemra.dev@gmail.com>

[ Upstream commit e0a85137a882db789b1bccc1e7db06356ac8c69f ]

When qgroups are enabled, __btrfs_qgroup_release_data() and
qgroup_free_reserved_data() pass an extent_changeset to
btrfs_clear_record_extent_bits() to track how many bytes had their
EXTENT_QGROUP_RESERVED bits cleared. Inside the extent IO tree spinlock,
add_extent_changeset() calls ulist_add() with GFP_ATOMIC to record each
changed range. If this allocation fails, it hits a BUG_ON and panics the
kernel.

However, both of these callers only read changeset.bytes_changed
afterwards — the range_changed ulist is populated and immediately freed
without ever being iterated. The GFP_ATOMIC allocation is entirely
unnecessary for these paths.

Introduce extent_changeset_init_bytes_only() which uses a sentinel value
(EXTENT_CHANGESET_BYTES_ONLY) on the ulist's prealloc field to signal
that only bytes_changed should be tracked. add_extent_changeset() checks
for this sentinel and returns early after updating bytes_changed,
skipping the ulist_add() call entirely. This eliminates the GFP_ATOMIC
allocation and makes the BUG_ON unreachable for these paths.

Callers that need range tracking (qgroup_reserve_data,
qgroup_unreserve_range, btrfs_qgroup_check_reserved_leak) continue to
use extent_changeset_init() and are unaffected.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is the `set_extent_bit()` path - the preallocation happens for set
operations (used by `qgroup_reserve_data`), not the clear operations.
The clear path doesn't prealloc. This confirms the commit's analysis -
the clear path (used by free/release) always hits the GFP_ATOMIC
allocation.

Now I have all the information needed for the full analysis. Let me
compile it.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [btrfs] [avoid] "Avoid GFP_ATOMIC allocations in qgroup free
paths" - The action verb "avoid" suggests preventing a problematic
behavior. While not a classic "fix" verb, the commit message body
reveals the actual bug: BUG_ON/kernel panic from failed GFP_ATOMIC
allocation.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reviewed-by: Qu Wenruo <wqu@suse.com>** - Qu Wenruo is a senior
  btrfs developer/maintainer
- **Signed-off-by: Leo Martins <loemra.dev@gmail.com>** - the author
- **Signed-off-by: David Sterba <dsterba@suse.com>** - the btrfs
  maintainer who committed it
- No Fixes: tag (expected for candidates under review)
- No Reported-by: tag
- No Link: tag

Record: Reviewed by a core btrfs developer, committed by the btrfs
maintainer.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit describes:
- **Bug:** When qgroups are enabled, `__btrfs_qgroup_release_data()` and
  `qgroup_free_reserved_data()` pass an `extent_changeset` to
  `btrfs_clear_record_extent_bits()`, which calls
  `add_extent_changeset()` under a spinlock. Inside, `ulist_add()` is
  called with `GFP_ATOMIC`. If this allocation fails, it hits a `BUG_ON`
  and panics the kernel.
- **Observation:** The callers only read `changeset.bytes_changed` - the
  `range_changed` ulist is never iterated for these paths.
- **Fix:** Introduces a "bytes only" mode that skips the `ulist_add()`
  call entirely.

Record: Bug = kernel panic (BUG_ON) from GFP_ATOMIC allocation failure
in qgroup free/release paths. Failure mode = kernel crash. Root cause =
unnecessary GFP_ATOMIC allocation that can fail under memory pressure.

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: This IS a bug fix disguised with the verb "avoid". The actual
bug is a kernel panic (BUG_ON) triggered by memory allocation failure
under memory pressure. The fix eliminates the problematic allocation
path entirely.

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- `fs/btrfs/extent-io-tree.c`: +3/-0 (add early return in
  `add_extent_changeset`)
- `fs/btrfs/extent_io.h`: +21/-2 (new inline functions + guard in
  release/prealloc)
- `fs/btrfs/qgroup.c`: +3/-2 (change two callsites to use `_bytes_only`,
  add 1 ASSERT)

Total: ~27 lines added, ~4 removed. Single-subsystem, well-contained.

Record: 3 files changed, ~30 lines of actual code. Functions modified:
`add_extent_changeset`, `extent_changeset_release`,
`extent_changeset_prealloc`, `qgroup_free_reserved_data`,
`__btrfs_qgroup_release_data`, `btrfs_qgroup_check_reserved_leak`.
Scope: single-subsystem surgical fix.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Hunk 1 (extent-io-tree.c):** Before: `add_extent_changeset()` always
calls `ulist_add()` with GFP_ATOMIC. After: If changeset is "bytes
only", returns early after incrementing `bytes_changed`, skipping
`ulist_add()`.

**Hunk 2 (extent_io.h):** Adds `EXTENT_CHANGESET_BYTES_ONLY` sentinel,
`extent_changeset_init_bytes_only()`, `extent_changeset_tracks_ranges()`
helper. Guards `extent_changeset_release()` and
`extent_changeset_prealloc()` against the sentinel.

**Hunk 3 (qgroup.c):** Changes `qgroup_free_reserved_data()` and
`__btrfs_qgroup_release_data()` from `extent_changeset_init()` to
`extent_changeset_init_bytes_only()`. Adds a safety ASSERT in
`btrfs_qgroup_check_reserved_leak()` (which needs ranges).

Record: The change flow is: callers opt into bytes-only mode ->
`add_extent_changeset` checks and returns early -> no GFP_ATOMIC
allocation -> BUG_ON becomes unreachable on this path.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **Kernel panic / BUG_ON from allocation failure**.

The call chain is:
1. `btrfs_qgroup_free_data()` / `btrfs_qgroup_release_data()` ->
   `__btrfs_qgroup_release_data()`
2. -> `btrfs_clear_record_extent_bits()` ->
   `btrfs_clear_extent_bit_changeset()`
3. -> `spin_lock(&tree->lock)` (acquires spinlock)
4. -> `clear_state_bit()` -> `add_extent_changeset()` ->
   `ulist_add(&changeset->range_changed, ..., GFP_ATOMIC)`
5. If GFP_ATOMIC allocation fails, returns -ENOMEM
6. `BUG_ON(ret < 0)` at line 570 fires -> kernel panic

Record: Bug category = kernel panic from allocation failure under
spinlock. The fix makes the allocation unreachable for callers that
don't need the result.

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct?** YES - The commit clearly shows that
  `qgroup_free_reserved_data` and `__btrfs_qgroup_release_data` only
  read `changeset.bytes_changed` and never iterate `range_changed`.
  Verified by reading the code.
- **Minimal/surgical?** YES - ~30 lines, well-contained.
- **Regression risk?** VERY LOW - The sentinel value approach is clean.
  The only risk would be if a future change to these callers started
  iterating the range_changed list without checking, but the ASSERT in
  `btrfs_qgroup_check_reserved_leak` shows the pattern is guarded.
- **Red flags?** None.

Record: Fix quality is high. Obviously correct, minimal, low regression
risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The `add_extent_changeset` function with its GFP_ATOMIC `ulist_add` was
introduced in the 2017-2018 timeframe. The BUG_ON was moved from inside
the function to callers by David Sterba in commit 57599c7e7722
(2018-03-01). The buggy code (`extent_changeset_init` in
`qgroup_free_reserved_data`) traces back to commit bc42bda22345e (Qu
Wenruo, 2017-02-27).

Record: Buggy code introduced in v4.11 (2017). Present in ALL active
stable trees.

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present (expected).

### Step 3.3: CHECK FILE HISTORY
Recent changes to extent-io-tree.c are mostly cleanups and
optimizations. No conflicting changes observed that would affect this
patch's applicability.

Record: Standalone fix, no prerequisites identified.

### Step 3.4: CHECK THE AUTHOR
Leo Martins appears to be a newer contributor. However, the patch was
reviewed by Qu Wenruo (core btrfs dev) and committed by David Sterba
(btrfs maintainer).

Record: Author is less experienced, but patch was reviewed by core btrfs
team.

### Step 3.5: CHECK FOR DEPENDENCIES
The patch is self-contained. The only dependency is on the `struct
ulist` having a `prealloc` field, which has existed since the ulist was
introduced.

Record: No dependencies. Can apply standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5:
Lore.kernel.org blocked access with bot protection. Web search did not
return the specific patch thread. However, the commit has `Reviewed-by:
Qu Wenruo` which indicates formal review, and was committed by the btrfs
maintainer David Sterba.

Record: Could not access lore.kernel.org. Review is indicated by the
Reviewed-by tag from a core btrfs developer.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
Modified: `add_extent_changeset`, `extent_changeset_release`,
`extent_changeset_prealloc`, `qgroup_free_reserved_data`,
`__btrfs_qgroup_release_data`, `btrfs_qgroup_check_reserved_leak`.

### Step 5.2: TRACE CALLERS
- `btrfs_qgroup_free_data()` and `btrfs_qgroup_release_data()` are
  called from: `inode.c` (11 call sites), `file.c` (1), `ordered-data.c`
  (3), `delalloc-space.c` (1), `qgroup.c` (7). These are core btrfs I/O
  paths.
- Any btrfs file write with qgroups enabled goes through
  `btrfs_qgroup_release_data`.
- Error paths go through `btrfs_qgroup_free_data`.

Record: The affected code path is reachable from every btrfs write
operation when qgroups are enabled. High-impact path.

### Step 5.3-5.5: CALL CHAIN
The chain from userspace: `write()` -> btrfs write path -> qgroup
accounting -> `__btrfs_qgroup_release_data()` ->
`btrfs_clear_record_extent_bits()` -> spinlock -> `clear_state_bit()` ->
`add_extent_changeset()` -> BUG_ON on failure.

Record: Reachable from userspace write operations. Very common path for
qgroup users.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: BUGGY CODE IN STABLE TREES?
Verified: The `extent_changeset_init()` calls in
`qgroup_free_reserved_data` and `__btrfs_qgroup_release_data` exist in
v5.15, v6.1, v6.6, and all newer trees. The BUG_ON exists in all these
versions.

Record: Bug exists in ALL active stable trees (v5.15+, likely v4.11+).

### Step 6.2: BACKPORT COMPLICATIONS
In v6.6, the code structure is essentially identical. The `extent_io.h`
structure, `add_extent_changeset`, and qgroup functions have the same
layout. Minor differences: `kmalloc_obj` vs `kmalloc` in
`extent_changeset_alloc()`, `int set` vs `bool set` parameter in
`add_extent_changeset`. The patch would need minor adaptation for v6.6
and older but is conceptually clean.

Record: Minor adaptation needed for stable trees, but the core logic
applies cleanly.

### Step 6.3: RELATED FIXES
No related fix for the same issue was found in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
btrfs is an IMPORTANT subsystem - widely used filesystem. Qgroups are
used for quota management, common in container deployments and multi-
user systems.

Record: [fs/btrfs] [IMPORTANT] - affects btrfs qgroup users.

### Step 7.2: SUBSYSTEM ACTIVITY
Very active - many commits per cycle. The btrfs maintainer committed
this fix.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
All btrfs users with qgroups enabled. This includes container
deployments (Docker, LXC), systems using btrfs quotas for storage
management.

Record: filesystem-specific, but a significant user population.

### Step 8.2: TRIGGER CONDITIONS
- Trigger: Memory pressure + btrfs qgroup-enabled file operations
- GFP_ATOMIC allocations fail when there's no immediately available
  memory (no sleeping allowed under spinlock)
- More likely under heavy workloads or constrained systems
- Can be triggered by any unprivileged user doing file writes on a btrfs
  filesystem with qgroups

Record: Trigger = memory pressure during file write with qgroups.
Moderate likelihood, but can affect production systems.

### Step 8.3: FAILURE MODE SEVERITY
BUG_ON -> kernel panic -> system crash. CRITICAL severity.

Record: CRITICAL - kernel panic, complete system loss.

### Step 8.4: RISK-BENEFIT RATIO
- **BENEFIT:** HIGH - Prevents kernel panic in a real-world scenario
  (memory pressure + qgroups)
- **RISK:** VERY LOW - ~30 lines, well-contained, obviously correct
  sentinel pattern, reviewed by btrfs maintainer
- **Ratio:** Very favorable for backporting

Record: High benefit, very low risk.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE EVIDENCE

**FOR backporting:**
- Fixes a real kernel panic (BUG_ON) triggered by GFP_ATOMIC allocation
  failure
- Code path is reachable from common btrfs operations (file writes with
  qgroups)
- Small, surgical fix (~30 lines, 3 files, single subsystem)
- Reviewed by core btrfs developer Qu Wenruo
- Committed by btrfs maintainer David Sterba
- Buggy code exists in ALL active stable trees (since v4.11)
- Eliminates unnecessary GFP_ATOMIC allocation entirely (not just
  handling failure differently)
- No risk of regression - sentinel pattern is well-guarded

**AGAINST backporting:**
- No explicit Cc: stable tag or Fixes: tag (expected - that's why it
  needs review)
- No reported-by tag (the bug may be rare in practice)
- Introduces new API functions (`extent_changeset_init_bytes_only`,
  `extent_changeset_tracks_ranges`, `EXTENT_CHANGESET_BYTES_ONLY`) -
  though these are internal inline helpers
- May need minor adaptation for older stable trees

**UNRESOLVED:**
- Could not access lore.kernel.org discussion for stable nomination
  signals
- No concrete report of this BUG_ON triggering in the wild

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** - Reviewed by core developer,
   clearly eliminates unnecessary allocation
2. Fixes a real bug? **YES** - BUG_ON/kernel panic from allocation
   failure
3. Important issue? **YES** - kernel panic (CRITICAL)
4. Small and contained? **YES** - ~30 lines, single subsystem
5. No new features or APIs? **YES** - internal helpers only, no
   userspace-visible changes
6. Can apply to stable trees? **YES** - with minor adaptation

### Step 9.3: EXCEPTION CATEGORIES
Not an exception category - this is a direct bug fix.

### Step 9.4: DECISION
The commit fixes a real kernel panic (BUG_ON triggered by GFP_ATOMIC
allocation failure under spinlock) in a commonly-used btrfs code path
(qgroup free/release). The fix is small, obviously correct, reviewed by
the btrfs core team, and committed by the btrfs maintainer. The buggy
code exists in all active stable trees. The risk of regression is very
low.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Qu Wenruo, SOB by Leo Martins and
  David Sterba (btrfs maintainer)
- [Phase 2] Diff analysis: 3 files, ~30 lines. Adds sentinel to skip
  ulist_add in bytes-only mode
- [Phase 2] Verified `qgroup_free_reserved_data` only reads
  `changeset.bytes_changed` (line 4364), never iterates `range_changed`
- [Phase 2] Verified `__btrfs_qgroup_release_data` only reads
  `changeset.bytes_changed` (lines 4402-4408), never iterates
  `range_changed`
- [Phase 2] Verified `btrfs_qgroup_check_reserved_leak` DOES iterate
  `range_changed` (line 4650) and correctly still uses
  `extent_changeset_init`
- [Phase 3] git blame: `qgroup_free_reserved_data` buggy code from
  bc42bda22345e (Qu Wenruo, 2017-02-27, v4.11)
- [Phase 3] git blame: BUG_ON moved to callers by commit 57599c7e7722
  (David Sterba, 2018-03-01)
- [Phase 3] Confirmed BUG_ON at lines 398 and 570 of current extent-io-
  tree.c
- [Phase 3] Confirmed `add_extent_changeset` called under
  `spin_lock(&tree->lock)` (line 647 -> line 709/740/746)
- [Phase 5] Verified
  `btrfs_qgroup_free_data`/`btrfs_qgroup_release_data` called from 25+
  sites across btrfs
- [Phase 6] Confirmed buggy pattern (`extent_changeset_init` in these
  functions) exists in v5.15, v6.1, v6.6
- [Phase 6] Confirmed BUG_ON on `add_extent_changeset` return exists in
  v5.15, v6.6
- [Phase 7] Qu Wenruo and David Sterba verified as core btrfs
  developers/maintainers
- [Phase 8] Failure mode: BUG_ON -> kernel panic, severity CRITICAL
- UNVERIFIED: Could not access lore.kernel.org to check for stable
  nomination in review comments
- UNVERIFIED: No concrete real-world reports of this BUG_ON triggering
  (does not invalidate the bug - GFP_ATOMIC failures are real)

**YES**

 fs/btrfs/extent-io-tree.c |  3 +++
 fs/btrfs/extent_io.h      | 23 ++++++++++++++++++++++-
 fs/btrfs/qgroup.c         |  5 +++--
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index d0dd50f7d2795..2a2bce0f1f7c8 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -193,7 +193,10 @@ static int add_extent_changeset(struct extent_state *state, u32 bits,
 		return 0;
 	if (!set && (state->state & bits) == 0)
 		return 0;
+
 	changeset->bytes_changed += state->end - state->start + 1;
+	if (!extent_changeset_tracks_ranges(changeset))
+		return 0;
 
 	return ulist_add(&changeset->range_changed, state->start, state->end, GFP_ATOMIC);
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 8d05f1a58b7c3..080215352b7a1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -196,6 +196,25 @@ static inline void extent_changeset_init(struct extent_changeset *changeset)
 	ulist_init(&changeset->range_changed);
 }
 
+/*
+ * Sentinel value for range_changed.prealloc indicating that the changeset
+ * only tracks bytes_changed and does not record individual ranges. This
+ * avoids GFP_ATOMIC allocations inside add_extent_changeset() when the
+ * caller doesn't need to iterate the changed ranges afterwards.
+ */
+#define EXTENT_CHANGESET_BYTES_ONLY	((struct ulist_node *)1)
+
+static inline void extent_changeset_init_bytes_only(struct extent_changeset *changeset)
+{
+	changeset->bytes_changed = 0;
+	changeset->range_changed.prealloc = EXTENT_CHANGESET_BYTES_ONLY;
+}
+
+static inline bool extent_changeset_tracks_ranges(const struct extent_changeset *changeset)
+{
+	return changeset->range_changed.prealloc != EXTENT_CHANGESET_BYTES_ONLY;
+}
+
 static inline struct extent_changeset *extent_changeset_alloc(void)
 {
 	struct extent_changeset *ret;
@@ -210,6 +229,7 @@ static inline struct extent_changeset *extent_changeset_alloc(void)
 
 static inline void extent_changeset_prealloc(struct extent_changeset *changeset, gfp_t gfp_mask)
 {
+	ASSERT(extent_changeset_tracks_ranges(changeset));
 	ulist_prealloc(&changeset->range_changed, gfp_mask);
 }
 
@@ -218,7 +238,8 @@ static inline void extent_changeset_release(struct extent_changeset *changeset)
 	if (!changeset)
 		return;
 	changeset->bytes_changed = 0;
-	ulist_release(&changeset->range_changed);
+	if (extent_changeset_tracks_ranges(changeset))
+		ulist_release(&changeset->range_changed);
 }
 
 static inline void extent_changeset_free(struct extent_changeset *changeset)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 41589ce663718..a95fa70def7f8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4326,7 +4326,7 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 	u64 freed = 0;
 	int ret;
 
-	extent_changeset_init(&changeset);
+	extent_changeset_init_bytes_only(&changeset);
 	len = round_up(start + len, root->fs_info->sectorsize);
 	start = round_down(start, root->fs_info->sectorsize);
 
@@ -4391,7 +4391,7 @@ static int __btrfs_qgroup_release_data(struct btrfs_inode *inode,
 	WARN_ON(!free && reserved);
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len, released);
-	extent_changeset_init(&changeset);
+	extent_changeset_init_bytes_only(&changeset);
 	ret = btrfs_clear_record_extent_bits(&inode->io_tree, start, start + len - 1,
 					     EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
@@ -4646,6 +4646,7 @@ void btrfs_qgroup_check_reserved_leak(struct btrfs_inode *inode)
 
 	WARN_ON(ret < 0);
 	if (WARN_ON(changeset.bytes_changed)) {
+		ASSERT(extent_changeset_tracks_ranges(&changeset));
 		ULIST_ITER_INIT(&iter);
 		while ((unode = ulist_next(&changeset.range_changed, &iter))) {
 			btrfs_warn(inode->root->fs_info,
-- 
2.53.0

