Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A87B56E05E;
	Mon, 31 Aug 2026 13:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184113; cv=none; b=jwnxU0yV7vdtnTggM63VRrWPDVZNWznhSVb07R2I/EqZK70pSXsyb80SHCSfEbsk1OrblA54l4A03LuXVDPDWr/oPW6s4YEpZbRga/zi0QhajOsDe9jSCc0qVnQwp9zfYqnMR+v5xARHH6LlmAFRqhWu4tCkQJSES2QLGmRyjF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184113; c=relaxed/simple;
	bh=beGrvt2bJvrK2cXpd8zByFr2iwq3XwR2ZJbLXi1lC4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UueCxw8dEeNlUvcm57tpHHChSV40TcjpqOaNo4TjxyyrzbYGEl8iG1D5xWOkvFXTJmPuILewwQqod+Eu/SbjxfslWsUsk1wbDGLOXAYwl9egPMPBMFug11awURJIGWbDN4MdAOV2Mm1fMVWkyj/OW46xQf8C3VrwIN9iVejejiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZZKqjO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZZKqjO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B941F00A3F;
	Mon, 31 Aug 2026 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184110;
	bh=k3TnupVf8TDdmVNJDnewwTVyL/eTi+RTKlqJkBbMoQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZZKqjO4CUWInVykbW2MYWIOxzsqmOenuL3SLObTbgG+2S4CAvjOhF83fzrMDZuVm
	 MFDYD/bn4wy0z/Mnl6nEVBty6nXLB/WSMvRNFopPFabuKZ9eUck/X0AsL0iXy/QC1k
	 7JKUA9cTNQ7xsjgHd4tinjo9TvIhcVwjO8Pf+2rTGOp/3qyCpgB9TLsBr7BuMzR1Di
	 fsnNibRmb2Yxq2DJCCi3/dzP14J4gEXHv5nJglHDsW1PR+v6KB/Qtz6f4SRB51qLOC
	 gl5X/Z8yGBLBrSeintMYnq6qJOJqDAdYu4ynuSyQGSH36xZf58ytJTdAtmIsk/GHhx
	 FTqXYvpy7k8jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] btrfs: balance: fix potential bg lookup failure in chunk_usage_range_filter()
Date: Mon, 31 Aug 2026 09:28:45 -0400
Message-ID: <20260831133314.4125787-497-sashal@kernel.org>
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

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit 7a308f6d29cc689ceaf313b9ebdf68099f50e452 ]

[BUG]
Running btrfs balance with a usage range filter (-dusage=min..max) can
trigger a null-ptr-deref when metadata corruption causes a chunk to have
no corresponding block group in the in-memory cache:

  KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
  RIP: 0010:chunk_usage_range_filter fs/btrfs/volumes.c:3845 [inline]
  RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4031 [inline]
  RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4182 [inline]
  RIP: 0010:btrfs_balance+0x249e/0x4320 fs/btrfs/volumes.c:4618
  ...
  Call Trace:
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    vfs_ioctl fs/ioctl.c:51 [inline]
    ...

The bug is reproducible on recent development branch.

[CAUSE]
Two separate data structures are involved:

1. The on-disk chunk tree, which records every chunk (logical address
   space region) and is iterated by __btrfs_balance().

2. The in-memory block group cache (fs_info->block_group_cache_tree),
   which is built at mount time by btrfs_read_block_groups() and holds
   a struct btrfs_block_group for each chunk. This cache is what the
   usage range filter queries.

On a well-formed filesystem, these two are kept in 1:1 correspondence.
However, btrfs_read_block_groups() builds the cache from block group
items in the extent tree, not directly from the chunk tree. A corrupted
image can therefore contain a chunk item in the chunk tree whose
corresponding block group item is absent from the extent tree; that
chunk's block group is then never inserted into the in-memory cache.

When balance iterates the chunk tree and reaches such an orphaned chunk,
should_balance_chunk() calls chunk_usage_range_filter(), which queries
the block group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_used = cache->used;   /* cache may be NULL */

btrfs_lookup_block_group() returns NULL silently when no cached entry
covers chunk_offset. chunk_usage_range_filter() does not check the return
value, so the immediately following dereference of cache->used triggers
the crash.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in
chunk_usage_range_filter(). When the lookup fails, emit a btrfs_err()
message identifying the affected bytenr and return -EUCLEAN to indicate
filesystem corruption.

Since chunk_usage_range_filter() now has an error path, change its
return type from bool to error pointer, return 0 if the chunk matches
the usage range, and 1 if it should be filtered out.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `btrfs: balance: fix potential bg lookup
failure in chunk_usage_range_filter()`

**Local tree:** `linux-6.18.y` at `v6.18.44` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[btrfs/balance]` **`fix`** — NULL block-group lookup in
`chunk_usage_range_filter()` during balance with usage-range filter
(`-dusage=min..max`).

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** David Sterba `<dsterba@suse.com>` (btrfs maintainer)
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected)
- **Signed-off-by:** ZhengYuan Huang `<gality369@gmail.com>`; David
  Sterba (committer)
- **Notable:** Reviewed and committed by btrfs maintainer; KASAN stack
  trace in body

### Step 1.3: Body Analysis
**Record:**
- **Bug:** NULL pointer dereference in `chunk_usage_range_filter()` when
  running `btrfs balance` with `BTRFS_BALANCE_ARGS_USAGE_RANGE` on a
  corrupted filesystem where a chunk exists in the chunk tree but has no
  matching block group in the in-memory cache.
- **Symptom:** KASAN null-ptr-deref at `cache->used` (offset ~0x70 into
  `struct btrfs_block_group`), reachable via `btrfs_ioctl_balance` →
  `btrfs_balance` → `__btrfs_balance` → `should_balance_chunk`.
- **Root cause:** `btrfs_lookup_block_group()` can return NULL; caller
  dereferences without checking.
- **Fix:** NULL check, `btrfs_err()` log, return `-EUCLEAN`; change
  return type from `bool` to `int` for error propagation.
- **Version info:** Reproducible on recent development branch; no
  specific kernel version cited.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly labeled `[BUG]` with KASAN trace.
Clear NULL-dereference fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **Files:** `fs/btrfs/volumes.c` only (+17 / -7 lines)
- **Functions modified:** `chunk_usage_range_filter()`,
  `should_balance_chunk()` (usage-range branch only)
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Changes
**Record:**
- **Hunk 1 (`chunk_usage_range_filter`):** Before: lookup block group,
  unconditionally dereference `cache->used`. After: check
  `unlikely(!cache)`, log error, return `-EUCLEAN`; otherwise same logic
  with `int` return (0 = match filter, 1 = filter out).
- **Hunk 2 (`should_balance_chunk`):** Before: inline bool call, filter
  out if true. After: call filter, propagate negative errors (`return
  ret2`), filter out if positive return.

### Step 2.3: Bug Mechanism
**Record:** **Category:** NULL pointer dereference (memory safety).
**Mechanism:** Missing NULL check after `btrfs_lookup_block_group()` on
a corruption path where chunk-tree and block-group cache are
inconsistent.

### Step 2.4: Fix Quality
**Record:** Fix is obviously correct and minimal. Matches the pattern
already applied to `chunk_usage_filter()` in prerequisite commit
`6dde5221f608e`. Low regression risk — only affects error path on
corrupted metadata. `btrfs_put_block_group()` still called on success
path only.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy NULL-deref line (`chunk_used = cache->used` without
check) introduced in `bc3094673f22d` (David Sterba, Oct 2015) — "btrfs:
extend balance filter usage to take minimum and maximum". Present in
this tree since 2015.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Part of a 3-commit series by ZhengYuan Huang (Mar 25, 2026):
1. `6dde5221f608e` — fix `chunk_usage_filter()` + change
   `should_balance_chunk()` to `int` + add `ret < 0` handling in
   `__btrfs_balance`
2. `7a308f6d29cc6` — **this commit** — fix `chunk_usage_range_filter()`
3. `18d32b0013efb` — fix `btrfs_may_alloc_data_chunk()`

None of these three are in `linux-6.18.y` yet.

### Step 3.4: Author Context
**Record:** ZhengYuan Huang is a btrfs contributor (other fixes in tree-
checker/root-item validation). David Sterba (maintainer) reviewed and
committed all three.

### Step 3.5: Dependencies
**Record:** **Prerequisite:** `6dde5221f608e` is required:
- Changes `should_balance_chunk()` from `bool` to `int` and adds `if
  (ret < 0) goto error` in `__btrfs_balance`
- Without it, `-EUCLEAN` propagation from this commit is broken
- Verified: `6dde5221` applies cleanly to `v6.18.44`; `7a308f6` fails
  alone but applies cleanly after `6dde5221`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 7a308f6d29cc6` — **no match found** on
lore.kernel.org. Lore web search blocked by bot protection. Cannot
verify mailing-list discussion or stable nominations.

### Step 4.2: Reviewers
**Record:** David Sterba (btrfs maintainer) — Reviewed-by and Signed-
off-by. Sufficient subsystem review.

### Step 4.3: Bug Report
**Record:** KASAN trace in commit message only. No syzbot, bugzilla, or
user reports. Author states reproducible on development branch.

### Step 4.4: Related Patches
**Record:** Sibling commits `6dde5221` and `18d32b0013efb` fix the same
class of bug in adjacent balance code paths. Ideally backported as a
series; this commit is not standalone for clean apply.

### Step 4.5: Stable List History
**Record:** Not searched successfully (lore inaccessible). No evidence
found of prior stable discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `chunk_usage_range_filter()`, `should_balance_chunk()`,
callers: `__btrfs_balance()`, `btrfs_balance()`,
`btrfs_ioctl_balance()`.

### Step 5.2: Callers
**Record:** `should_balance_chunk()` called from `__btrfs_balance()`
chunk-tree iteration loop (every balance operation per chunk).
`btrfs_ioctl_balance()` requires `CAP_SYS_ADMIN`.

### Step 5.3: Callees
**Record:** `btrfs_lookup_block_group()` →
`block_group_cache_tree_search()` — returns NULL when no cached block
group covers the bytenr. `btrfs_put_block_group()`, `mult_perc()`,
`btrfs_err()`.

### Step 5.4: Reachability
**Record:** Trigger: admin runs `btrfs balance` with usage-range filter
(`BTRFS_BALANCE_ARGS_USAGE_RANGE`) on filesystem with chunk/block-group
metadata inconsistency. Reachable from `ioctl()` syscall path. Requires
corruption + specific filter flag; not everyday path but real and
reproducible.

### Step 5.5: Similar Patterns
**Record:** Same missing-NULL-check pattern exists in:
- `chunk_usage_filter()` (fixed by `6dde5221`)
- `btrfs_may_alloc_data_chunk()` with `ASSERT(cache)` only (fixed by
  `18d32b0013efb`)

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** At lines 3968–3969 in `fs/btrfs/volumes.c`:

```3968:3969:fs/btrfs/volumes.c
        cache = btrfs_lookup_block_group(fs_info, chunk_offset);
        chunk_used = cache->used;
```

No NULL check. `BTRFS_BALANCE_ARGS_USAGE_RANGE` support present since
2015 (`bc3094673f22d` is ancestor).

### Step 6.2: Backport Complications
**Record:** Does not apply cleanly alone (`git apply --check` fails at
line 4158). Applies cleanly after prerequisite `6dde5221`. Minor
adaptation needed only if backported without prerequisite (not
recommended).

### Step 6.3: Related Fixes Already Present?
**Record:** **NO.** String `"has no corresponding block group"` not in
tree. `6dde5221` and `18d32b0013efb` also absent.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **fs/btrfs** — IMPORTANT. Btrfs is widely deployed; balance
is an admin maintenance operation on live filesystems.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained. Recent balance-related work includes
`f963e0128b180` (bool conversion, Apr 2025) and `c19830db30a09` (BUG() →
error handling in `__btrfs_balance`).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Btrfs users running balance with usage-range filter on
corrupted or inconsistently-metadata filesystems. Admin-only trigger
(`CAP_SYS_ADMIN`).

### Step 8.2: Trigger Conditions
**Record:** Corrupted chunk tree / extent tree inconsistency + balance
with `-dusage=min..max` range syntax. Uncommon but plausible during
recovery operations on damaged filesystems — exactly when robust error
handling matters most.

### Step 8.3: Failure Mode Severity
**Record:** **CRITICAL** — kernel NULL pointer dereference / oops.
System crash during admin maintenance on a filesystem that may already
be in distress.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents kernel crash; returns `-EUCLEAN` for
  corruption (correct btrfs behavior)
- **Risk:** LOW — ~17 lines, well-reviewed, mirrors already-accepted
  pattern from sibling commit
- **Ratio:** Strongly favorable, provided prerequisite `6dde5221` is
  included

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible NULL pointer dereference with KASAN trace
- Bug present in 6.18.44 since 2015
- Small, surgical, maintainer-reviewed fix
- Prevents kernel oops during balance on corrupted filesystems
- Matches established btrfs corruption-handling pattern (`-EUCLEAN`)

**AGAINST backport:**
- Requires prerequisite commit `6dde5221` for clean apply and correct
  error propagation
- Trigger needs metadata corruption + usage-range filter (less common
  than simple `-dusage=N`)
- No syzbot or user bug reports
- Admin-only path (not unprivileged attack surface)

**Unresolved:**
- No lore discussion found via b4
- Third sibling commit `18d32b0013efb` addresses another balance NULL-
  deref path; ideally included in same backport series

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — NULL check after documented-
   NULL-returning function; maintainer reviewed; KASAN-reproduced
2. Fixes real bug affecting users? **PASS** — kernel crash on balance
   ioctl
3. Important issue? **PASS** — CRITICAL (kernel oops)
4. Small and contained? **PASS** — 17 lines, one file
5. No new features/APIs? **PASS** — bug fix only
6. Can apply to local tree? **PASS** (with prerequisite `6dde5221`;
   verified via `git apply`)

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device ID/quirk/docs/build fix.

### Step 9.4: Decision Rationale

This commit fixes a long-standing NULL pointer dereference in btrfs
balance code that exists in the 6.18.44 tree. The fix is minimal,
obviously correct, and reviewed by the btrfs maintainer. While the
trigger requires filesystem corruption and the usage-range filter,
crashing the kernel during recovery/maintenance on a damaged btrfs
filesystem is exactly the kind of issue stable trees should fix.

The prerequisite commit `6dde5221f608e` must accompany this backport (it
applies cleanly to 6.18.44 and is required for proper `-EUCLEAN`
propagation). Commit `18d32b0013efb` fixes the same bug class in
`btrfs_may_alloc_data_chunk()` and should also be considered for a
complete fix.

---

## Verification

- **[Phase 1]** Parsed commit message: BUG/CAUSE/FIX sections, Reviewed-
  by David Sterba, no Fixes:/Reported-by:/Link: tags
- **[Phase 2]** Diff analysis: 17 lines in `fs/btrfs/volumes.c`; NULL
  check + int return type + error propagation in `should_balance_chunk`
- **[Phase 3]** `git blame`: buggy code from `bc3094673f22d` (Oct 2015)
- **[Phase 3]** `git log -S`: found series `6dde5221`, `7a308f6`,
  `18d32b0013efb` on master; none in 6.18.44
- **[Phase 3]** `git merge-base --is-ancestor`: `bc3094673f22d` present;
  `6dde5221` NOT present
- **[Phase 3]** `git apply --check 6dde5221`: applies cleanly to
  v6.18.44
- **[Phase 3]** `git apply --check 7a308f6` alone: **FAILS** at line
  4158
- **[Phase 3]** `git apply 6dde5221` then `git apply --check 7a308f6`:
  **SUCCEEDS**
- **[Phase 4]** `b4 dig -c 7a308f6d29cc6`: no lore match found
- **[Phase 4]** lore.kernel.org fetch: blocked by bot protection
- **[Phase 5]** Call chain verified: `btrfs_ioctl_balance`
  (CAP_SYS_ADMIN) → `btrfs_balance` → `__btrfs_balance` →
  `should_balance_chunk` → `chunk_usage_range_filter`
- **[Phase 5]** `btrfs_lookup_block_group()` in `block-group.c:279-283`
  returns NULL via `block_group_cache_tree_search`
- **[Phase 6]** `git describe HEAD`: v6.18.44 on `stable/linux-6.18.y`
- **[Phase 6]** Grep confirmed buggy code at lines 3968-3969; no `"has
  no corresponding block group"` string in tree
- **[Phase 6]** `BTRFS_BALANCE_ARGS_USAGE_RANGE` present in
  `include/uapi/linux/btrfs.h`
- **[Phase 8]** Failure mode: KASAN null-ptr-deref → kernel oops,
  severity CRITICAL

---

**YES**The background checks finished and match what the analysis
already used:

- **`b4 dig`** on HEAD found no lore.kernel.org thread for this commit.
- **`git log --grep="fix potential bg lookup failure"`** returned
  nothing — the fix isn’t in the local `linux-6.18.y` tree yet.

That supports the earlier **YES** verdict: the bug is still present in
6.18.44, and this commit should be backported together with prerequisite
`6dde5221f608e` (`chunk_usage_filter()` fix).The `git log -S "has no
corresponding block group"` search finished with no matches in the
current `linux-6.18.y` tree — that error string only appears in the
unfixed commits on `master` (`6dde5221`, `7a308f6`, `18d32b0013efb`),
which confirms the fix series hasn’t landed in 6.18.44 yet.

 fs/btrfs/volumes.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a17fcf8bd8a99..298e85a69e61c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3960,16 +3960,21 @@ static bool chunk_profiles_filter(u64 chunk_type, struct btrfs_balance_args *bar
 	return true;
 }
 
-static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
-				     struct btrfs_balance_args *bargs)
+static int chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
+				    struct btrfs_balance_args *bargs)
 {
 	struct btrfs_block_group *cache;
 	u64 chunk_used;
 	u64 user_thresh_min;
 	u64 user_thresh_max;
-	bool ret = true;
+	int ret = 1;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
+	if (unlikely(!cache)) {
+		btrfs_err(fs_info, "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_used = cache->used;
 
 	if (bargs->usage_min == 0)
@@ -3985,7 +3990,7 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
 		user_thresh_max = mult_perc(cache->length, bargs->usage_max);
 
 	if (user_thresh_min <= chunk_used && chunk_used < user_thresh_max)
-		ret = false;
+		ret = 0;
 
 	btrfs_put_block_group(cache);
 	return ret;
@@ -4155,9 +4160,14 @@ static int should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *
 			return ret2;
 		if (ret2)
 			return false;
-	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
-	    chunk_usage_range_filter(fs_info, chunk_offset, bargs)) {
-		return false;
+	} else if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) {
+		int ret2;
+
+		ret2 = chunk_usage_range_filter(fs_info, chunk_offset, bargs);
+		if (ret2 < 0)
+			return ret2;
+		if (ret2)
+			return false;
 	}
 
 	/* devid filter */
-- 
2.53.0

