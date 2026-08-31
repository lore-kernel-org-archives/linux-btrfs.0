Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5404582F7;
	Mon, 31 Aug 2026 13:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183851; cv=none; b=rtGKxBmpAd7dQsvQPF2Hmb/iCMCXA3yG9QIASB7Z+np/DHgBXsbOIkwVharaVApbNmzvK/qecoezHrrdAUJcELoCzR6zPx5bGhFwczS0qT4QYJ1v8pNZNxI4VDsiEQyBh0w0lPul7C9GOt6qBAlz1/dyhjSEEz5jqKi8qoF4Cl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183851; c=relaxed/simple;
	bh=HJsFqcZe9TOHqmaEGiFYco8d84mj/FeUcvNWg284YqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnGqrQwpkBiHshIEimanZ+lYTRENHIpWpQEkni3/uTtoPsYnv36YdYroagmbvQEIoLrnReWlqC2n71AQlecuGPWoit1D6j9WDUkT/sGilbnwlsezSK/PGmirwgn26nqnvTKgdgEufT1TrLiwlV5/AgH/30rd+fMiWKXNwI6UOj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZ+IHlvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZ+IHlvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443271F00A3F;
	Mon, 31 Aug 2026 13:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183848;
	bh=ghenvDoXBgLOI+XHMoui/XCdvU2v2PNvyDMg6wsGwCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZ+IHlvZI3ld4GdzlcapbO1/d2lWpAMC/RxZqhxHd0fiG/CV7kiiDrpMOnSe8giWy
	 cMXU3RMXB+JvSWUnoKHfYKLvoXwcdkShjR3JdZ/VRmKMRGqck6y0Tx4qcBEK3cUIYB
	 vq9nbAPke7W1Xt53Z1ou+mDPVsDtYUMHbHYs3BBcGFWsBMJxHpVIWnG37V626ZnEQM
	 /gewIxuqQbkxAcgFw1OgIfrgZ2ccxEOrpHKyxUFAkAfHOW/1aa1QLFE6aCKtlpQhJX
	 yIHszIdRookXR1lLabN0vqCWjA+MtbPNnQYfquZ3wDDCjBMuJhZKzWKxpVWdJiyzgU
	 47j7KNR42P/5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] btrfs: balance: fix potential bg lookup failure in chunk_usage_filter()
Date: Mon, 31 Aug 2026 09:26:08 -0400
Message-ID: <20260831133314.4125787-340-sashal@kernel.org>
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

[ Upstream commit 6dde5221f608e0b548fcf43c68034496f1e58542 ]

[BUG]
Running btrfs balance with a usage filter (-dusage=N) can trigger a
null-ptr-deref when metadata corruption causes a chunk to have no
corresponding block group in the in-memory cache:

  KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
  RIP: 0010:chunk_usage_filter fs/btrfs/volumes.c:3874 [inline]
  RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4018 [inline]
  RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4172 [inline]
  RIP: 0010:btrfs_balance+0x2024/0x42b0 fs/btrfs/volumes.c:4604
  ...
  Call Trace:
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    vfs_ioctl fs/ioctl.c:51 [inline]
    ...

The bug is reproducible on current development branch.

[CAUSE]
Two separate data structures are involved:

1. The on-disk chunk tree, which records every chunk (logical address
   space region) and is iterated by __btrfs_balance().

2. The in-memory block group cache (fs_info->block_group_cache_tree),
   which is built at mount time by btrfs_read_block_groups() and holds
   a struct btrfs_block_group for each chunk. This cache is what the
   usage filter queries.

On a well-formed filesystem, these two are kept in 1:1 correspondence.
However, btrfs_read_block_groups() builds the cache from block group
items in the extent tree, not directly from the chunk tree. A corrupted
image can therefore contain a chunk item in the chunk tree whose
corresponding block group item is absent from the extent tree; that
chunk's block group is then never inserted into the in-memory cache.

When balance iterates the chunk tree and reaches such an orphaned chunk,
should_balance_chunk() calls chunk_usage_filter(), which queries the block
group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_used = cache->used;   /* cache may be NULL */

btrfs_lookup_block_group() returns NULL silently when no cached entry
covers chunk_offset. chunk_usage_filter() does not check the return value,
so the immediately following dereference of cache->used triggers the crash.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in chunk_usage_filter().
When the lookup fails, emit a btrfs_err() message identifying the
affected bytenr and return -EUCLEAN to indicate filesystem corruption.

Since chunk_usage_filter() now has an error path, change its return type
from bool to error pointer and 0 if the chunk passes the usage filter,
and 1 if it should be skipped.

Update should_balance_chunk() accordingly to propagate negative errors
from the usage filter.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: btrfs balance NULL deref in
`chunk_usage_filter()`

**Local tree:** `v6.18.44` (6.18.y stable)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[btrfs: balance]` `[fix]` — Fix potential block-group
lookup failure in `chunk_usage_filter()` during btrfs balance with a
usage filter.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** David Sterba `<dsterba@suse.com>` (btrfs maintainer)
- **Acked-by:** — none
- **Link:** — none in committed message
- **Cc: stable@vger.kernel.org:** — absent from final commit message;
  present in v2 mailing-list submission (per web search)
- **Signed-off-by:** ZhengYuan Huang (author); David Sterba (maintainer)

Notable: maintainer reviewed and committed; author nominated stable in
patch series v2.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** NULL pointer dereference in `chunk_usage_filter()` when
  running `btrfs balance` with `-dusage=N` on a filesystem where
  metadata corruption left a chunk in the chunk tree without a matching
  in-memory block group.
- **Symptom:** KASAN null-ptr-deref at `cache->used` (offset ~0x70),
  call chain through `should_balance_chunk()` → `__btrfs_balance()` →
  `btrfs_ioctl_balance()`.
- **Root cause:** `btrfs_lookup_block_group()` returns NULL when no
  cached block group covers the chunk offset; `chunk_usage_filter()`
  dereferences without checking.
- **Fix:** NULL check, `btrfs_err()` log, return `-EUCLEAN`; change
  `chunk_usage_filter()` and `should_balance_chunk()` to propagate
  errors; handle negative return in `__btrfs_balance()`.
- **Version info:** Bug reproducible on current development branch;
  underlying usage-filter code dates to 2012.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — explicitly a NULL pointer dereference fix.
The return-type refactor (`bool` → `int`) is required to propagate
`-EUCLEAN`, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `fs/btrfs/volumes.c` only (~40 lines changed)
- **Functions modified:** `chunk_usage_filter()`,
  `should_balance_chunk()`, `__btrfs_balance()`
- **Scope:** Single-file surgical fix in btrfs balance filtering path

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Hunk 1 — `chunk_usage_filter()`:**
- **Before:** `btrfs_lookup_block_group()` → immediate `cache->used`
  dereference; returns `bool`.
- **After:** NULL check with `unlikely(!cache)` → log + `-EUCLEAN`;
  returns `int` (negative=error, 0=pass filter, 1=skip chunk).

**Hunk 2 — `should_balance_chunk()`:**
- **Before:** `if (usage flag && chunk_usage_filter()) return false;`
- **After:** Calls filter, propagates `ret2 < 0`, treats `ret2` truthy
  as skip; return type `bool` → `int`.

**Hunk 3 — `__btrfs_balance()`:**
- **Before:** `ret = should_balance_chunk(...)` then `if (!ret) goto
  loop` with no error handling.
- **After:** `if (ret < 0) { unlock; goto error; }` before the skip
  check.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Category:** NULL pointer dereference (memory safety).
**Mechanism:** On corrupted metadata, chunk tree iteration reaches an
orphaned chunk; block group cache lookup returns NULL; unchecked
dereference of `cache->used` crashes the kernel during balance ioctl.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is obviously correct — mirrors existing btrfs patterns (e.g.
  `scrub.c` checks `if (!cache) goto skip`).
- Minimal, focused change; no unrelated edits.
- Low regression risk: only affects the usage-filter error path on
  corrupted FS; normal filesystems unchanged.
- Minor note: `chunk_usage_range_filter()` has the same unchecked
  dereference but is a separate code path (usage-range filter, not
  `-dusage`); not addressed by this commit.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `chunk_usage_filter()` introduced in `5ce5b3c0916ba`
("Btrfs: usage filter", Ilya Dryomov, 2012-01-16). The unchecked
`cache->used` dereference (`bf38be65f3703d`, David Sterba, 2019) has
been present for years. Bug is long-standing, not recently introduced.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag in commit message. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Recent `volumes.c` changes include `c19830db30a09` ("replace
BUG() with error handling in __btrfs_balance()") — complementary error-
path hardening, not a prerequisite. No duplicate fix for this NULL deref
found in this tree. Patch is part of a larger series (v2/v3: also fixes
`chunk_usage_range_filter` and mount-time
`check_chunk_block_group_mappings()`), but this commit is self-contained
for the `-dusage` path.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** ZhengYuan Huang has btrfs contributions in this tree (e.g.
`850de3d87f472` tree-checker fix). David Sterba is btrfs maintainer and
committed this patch.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No prerequisites. All modified functions and
`btrfs_lookup_block_group()` exist in 6.18.44. The `error:` path in
`__btrfs_balance()` already exists and returns errors to userspace.
Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c HEAD` failed (commit not in local tree). Web
search found:
- [PATCH v2 1/3] on spinics/lore — subject matches, includes `Cc:
  stable@vger.kernel.org`
- [PATCH v3 1/4] on linux-btrfs list — evolved version with `unlikely()`
  annotation
- Series cover (v2 0/3): describes two balance NULL derefs plus mount-
  time verification fix

Reviewer feedback (v2): David Sterba noted `bool ret = true`
inconsistent with changed return type — addressed in committed version
(`int ret = 1`).

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC'd to `linux-btrfs@`, `linux-kernel@`, David Sterba.
**Reviewed-by** and **Signed-off-by** David Sterba (maintainer).

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report or syzbot link. Reproducibility
claimed by author with KASAN stack trace in commit message. Self-
contained reproduction: corrupted btrfs image + `btrfs balance` with
usage filter.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Part of 3–4 patch series fixing:
1. `chunk_usage_filter()` NULL deref (this commit)
2. `chunk_usage_range_filter()` NULL deref (separate patch)
3. `check_chunk_block_group_mappings()` iteration bug (separate patch)

This commit stands alone for the `-dusage` crash.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Author explicitly nominated `Cc: stable@vger.kernel.org` in
v2 submission. No evidence of rejection from stable maintainers found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `chunk_usage_filter()`, `should_balance_chunk()`,
`__btrfs_balance()`

### Step 5.2: TRACE CALLERS
**Record:**
- `chunk_usage_filter()` ← `should_balance_chunk()` (when
  `BTRFS_BALANCE_ARGS_USAGE` set)
- `should_balance_chunk()` ← `__btrfs_balance()` (chunk tree iteration
  loop)
- `__btrfs_balance()` ← `btrfs_balance()` ← `btrfs_ioctl_balance()` ←
  `btrfs_ioctl()` ← `vfs_ioctl()`

Balance is triggered via `BTRFS_IOC_BALANCE` ioctl, requiring
`CAP_SYS_ADMIN`.

### Step 5.3: TRACE CALLEES
**Record:** `btrfs_lookup_block_group()` →
`block_group_cache_tree_search()` (returns NULL when no matching entry);
`btrfs_put_block_group()`, `btrfs_err()`, `mult_perc()`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Userspace admin runs `btrfs balance start -dusage=N` → ioctl
→ balance iterates chunk tree → hits orphaned chunk → NULL deref.
**Reachable from userspace** (with admin capability) on corrupted
filesystems.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `scrub.c:2690-2695` already handles NULL from
`btrfs_lookup_block_group()` with `if (!cache) goto skip`.
`check_chunk_block_group_mappings()` in `block-group.c:2339-2346`
returns `-EUCLEAN` on missing block group. This fix aligns balance with
established btrfs corruption-handling patterns.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** In 6.18.44 at `fs/btrfs/volumes.c:3997-3998`:

```3997:3998:fs/btrfs/volumes.c
        cache = btrfs_lookup_block_group(fs_info, chunk_offset);
        chunk_used = cache->used;
```

No NULL check. Bug present since 2012 in this code path.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply**. Code structure matches the diff
base. `__btrfs_balance()` already has `error:` label at line 4384.
Recent `volumes.c` churn is unrelated to these functions.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Fix not present (no "has no corresponding block group" error
string in tree). `check_chunk_block_group_mappings()` exists but has a
known iteration limitation (separate series patch); does not prevent
this balance crash.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Subsystem:** btrfs filesystem (`fs/btrfs/`).
**Criticality:** IMPORTANT — filesystem code; balance is an
administrative maintenance operation; crash affects system stability.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** btrfs is actively maintained in 6.18.y with regular fixes
(error handling, corruption detection). Long-standing balance filter
code with a latent NULL deref.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** btrfs users running balance with usage filter (`-dusage`,
`-musage`, `-susage`) on filesystems with chunk/block-group metadata
inconsistency. Config-specific (btrfs + balance + usage filter) but
affects real admin workflows on damaged images.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- **Trigger:** Metadata corruption (chunk in chunk tree, no block group
  in cache) + balance with usage filter
- **Likelihood:** Low in healthy systems; realistic on
  corrupted/recovered images
- **Privilege:** Requires `CAP_SYS_ADMIN` — not unprivileged attack, but
  admin shouldn't kernel-panic the system

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **NULL pointer dereference → kernel oops/panic.**
**Severity: CRITICAL** (system crash during filesystem maintenance).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — prevents kernel crash; returns `-EUCLEAN` so admin
  gets actionable corruption error
- **Risk:** LOW — ~40 lines, error-path only, maintainer-reviewed,
  matches existing patterns
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real, reproducible NULL pointer dereference
- Kernel crash (CRITICAL severity)
- Buggy code confirmed present in 6.18.44
- Long-standing bug (since 2012)
- Small, single-file fix
- Reviewed and committed by btrfs maintainer (David Sterba)
- Author nominated for stable
- Aligns with btrfs corruption-handling conventions (`-EUCLEAN`)
- No prerequisites; applies standalone
- Prevents crash that mount-time checks may not catch

**AGAINST backport:**
- Requires filesystem corruption to trigger (mitigated: btrfs routinely
  hardens corruption paths)
- Only affects usage-filter balance path, not all balance operations
- `chunk_usage_range_filter()` has same latent bug (separate fix;
  doesn't invalidate this one)
- Requires admin capability (not a general security CVE, but still a
  stability bug)

**Unresolved:** No syzbot or user bugzilla report; reproduction relies
on author's KASAN trace.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — NULL check + error
   propagation; maintainer reviewed
2. Fixes a real bug affecting users? **PASS** — NULL deref on balance
   with corrupted FS
3. Important issue? **PASS** — kernel oops/panic (CRITICAL)
4. Small and contained? **PASS** — one file, ~40 lines
5. No new features or APIs? **PASS** — defensive error handling only
6. Can apply to local tree? **PASS** — code exists, clean apply expected

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: DECISION RATIONALE

For **6.18.44**, this commit fixes a confirmed NULL pointer dereference
in a reachable admin code path on corrupted btrfs filesystems. The fix
is minimal, maintainer-reviewed, and converts a kernel crash into a
proper `-EUCLEAN` error — consistent with how btrfs handles metadata
inconsistency elsewhere. The bug has existed since 2012 and is present
in this tree today.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; found Reviewed-by/Signed-
  off-by David Sterba
- **[Phase 1]** No Fixes:/Reported-by:/Link: tags in commit message
- **[Phase 2]** Diff analysis: NULL check in `chunk_usage_filter()`,
  error propagation through `should_balance_chunk()` and
  `__btrfs_balance()`
- **[Phase 2]** Confirmed `chunk_usage_range_filter()` at lines
  3968-3969 has same unchecked pattern (not fixed by this commit)
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- **[Phase 3]** `git blame` lines 3990-4012: function from 2012
  (`5ce5b3c0916ba`), unchecked deref from 2019
- **[Phase 3]** `git show 5ce5b3c0916ba` — introduced usage filter
- **[Phase 3]** `git log --oneline -20 -- fs/btrfs/volumes.c` — no
  duplicate fix found
- **[Phase 3]** No prerequisite commits identified
- **[Phase 4]** `b4 dig -c HEAD` — failed (commit not in tree)
- **[Phase 4]** Web search found v2/v3 lore submissions with `Cc:
  stable@vger.kernel.org`
- **[Phase 4]** Reviewer feedback on bool/int mismatch documented in v2
  thread
- **[Phase 5]** Call chain verified: ioctl → balance →
  `should_balance_chunk()` → `chunk_usage_filter()`
- **[Phase 5]** `btrfs_ioctl_balance()` requires `CAP_SYS_ADMIN`
  (ioctl.c:3490)
- **[Phase 5]** `btrfs_lookup_block_group()` returns NULL when no match
  (block-group.c:230-264)
- **[Phase 5]** `scrub.c:2694` — precedent for NULL check after lookup
- **[Phase 6]** Buggy code confirmed at volumes.c:3997-3998 in 6.18.44
- **[Phase 6]** `grep "has no corresponding block group"` — fix not yet
  applied
- **[Phase 6]** `check_chunk_block_group_mappings()` exists at block-
  group.c:2321 but has separate iteration limitation
- **[Phase 8]** Failure mode: NULL deref → kernel oops; severity
  CRITICAL

**YES**The background searches finished and matched what the main
analysis already used:

- **Related commits search** — `git log --grep` turned up older btrfs
  balance work (e.g. balance vs. unused block group deletion), but
  nothing that already fixes this NULL deref in 6.18.44.
- **b4 dig** — Failed because the commit isn’t in this checkout; the
  lore context came from web search instead.
- **Author search** — ZhengYuan Huang has other btrfs fixes in-tree
  (e.g. tree-checker), which fits a focused corruption-handling fix
  reviewed by David Sterba.

**Verdict for 6.18.44: YES** — small, maintainer-reviewed fix for a real
NULL deref on corrupted btrfs during `balance` with a usage filter
(`-dusage=N`).

 fs/btrfs/volumes.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 863f69b9cf14b..ff67f5ecacb2e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3987,14 +3987,19 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
 	return ret;
 }
 
-static bool chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
-			       struct btrfs_balance_args *bargs)
+static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
+			      struct btrfs_balance_args *bargs)
 {
 	struct btrfs_block_group *cache;
 	u64 chunk_used, user_thresh;
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
@@ -4005,7 +4010,7 @@ static bool chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 		user_thresh = mult_perc(cache->length, bargs->usage);
 
 	if (chunk_used < user_thresh)
-		ret = false;
+		ret = 0;
 
 	btrfs_put_block_group(cache);
 	return ret;
@@ -4110,8 +4115,8 @@ static bool chunk_soft_convert_filter(u64 chunk_type, struct btrfs_balance_args
 	return false;
 }
 
-static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
-				 u64 chunk_offset)
+static int should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
+				u64 chunk_offset)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
@@ -4138,9 +4143,14 @@ static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk
 	}
 
 	/* usage filter */
-	if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE) &&
-	    chunk_usage_filter(fs_info, chunk_offset, bargs)) {
-		return false;
+	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE) {
+		int ret2;
+
+		ret2 = chunk_usage_filter(fs_info, chunk_offset, bargs);
+		if (ret2 < 0)
+			return ret2;
+		if (ret2)
+			return false;
 	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
 	    chunk_usage_range_filter(fs_info, chunk_offset, bargs)) {
 		return false;
@@ -4302,6 +4312,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		ret = should_balance_chunk(leaf, chunk, found_key.offset);
 
 		btrfs_release_path(path);
+		if (ret < 0) {
+			mutex_unlock(&fs_info->reclaim_bgs_lock);
+			goto error;
+		}
 		if (!ret) {
 			mutex_unlock(&fs_info->reclaim_bgs_lock);
 			goto loop;
-- 
2.53.0

