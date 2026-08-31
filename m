Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AF5449B2D;
	Mon, 31 Aug 2026 13:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183645; cv=none; b=f7AzY/W1ZiLcQcL4uqkhOit3vfplu7UgGOeIJL/K1G5faIz5uUIMC+8NuIl9LABl/DEky2LXks088JWvYnCWse+MUwSax0hgibrhPYV2RQkdRNqjOJJOmoVDclzP98c6ijcgwjERg3WmB+uZ+P7Z8AVMJ9yk9hjFPhp/QhWQnf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183645; c=relaxed/simple;
	bh=k7aiax2xeTYrk7YdAP2H1wi1KLgmG2GDiCNvyVMe7iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GbnvGcbOU9TjPWBCIbzgA9CXGiFMgvZ2cTSkt24FanNwC3wMCac6cGtY4eCvBcJWbU6xfAXLm0POn8hRgAaxJ2ieyM7Pw8E+g7oPWFdEclKmnofxzLLBIvT5lZhyq1zLiTyTgLbIvb4qGfhKlT2dpYJxMJ+DRx0gaGe0+nOlnao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfxdgnAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfxdgnAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFC91F00A3F;
	Mon, 31 Aug 2026 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183643;
	bh=gUeiXI3XyC926PlbUI79LZb1H3ffCrHpQ8ozWKv0f2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfxdgnALaQRqmWDpSl2NRdx/Ibo7HwlRpmjQ7FwlWlX3RztiIIZC6zHHOqJVf69FS
	 o6FBKaYUgGu6ep3bZzJJKPQS4MygSDI2bHAajkGbzPHBeI6TJY+lcB2oIC3z6DpUaO
	 2gAOekwU6lPpoG09KPnY8oBkvKONAjXw6MhjuA4bL+fzppFBNkdZJTi0z8LEUiesN0
	 9h9hK57XtPTYprwtCPqlLNPPrYbczvNFEJhmpFy1YYBl9/5U+6l2Vz70mczuH4nACv
	 t0R1ykdXH+czbJfqon/6jKusgXl5Oy8RwudqZyqXMkQ90SyySBfhetM7PxvGJxZeAQ
	 kCHTOM9lwwY9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] btrfs: balance: fix potential bg lookup failure in btrfs_may_alloc_data_chunk()
Date: Mon, 31 Aug 2026 09:24:04 -0400
Message-ID: <20260831133314.4125787-216-sashal@kernel.org>
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

[ Upstream commit 18d32b0013efba19f7ad3e5b08d7aee813d604a6 ]

[BUG]
Running btrfs balance can trigger a null-ptr-deref before relocating a
data chunk when metadata corruption leaves a chunk in the chunk tree
without a corresponding block group in the in-memory cache:

  KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
  RIP: 0010:btrfs_may_alloc_data_chunk+0x40/0x1c0 fs/btrfs/volumes.c:3601
  Call Trace:
    __btrfs_balance fs/btrfs/volumes.c:4217 [inline]
    btrfs_balance+0x2516/0x42b0 fs/btrfs/volumes.c:4604
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    ...

[CAUSE]
__btrfs_balance() iterates the on-disk chunk tree and passes the chunk
logical bytenr to btrfs_may_alloc_data_chunk() before relocating a data
chunk. That helper then queries the in-memory block group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_type = cache->flags;   /* cache may be NULL */

A corrupt image can contain a chunk item whose matching block group
item is missing, so no block group is ever inserted into the cache. In
that case btrfs_lookup_block_group() returns NULL.

The code only guards this with ASSERT(cache), which becomes a no-op when
CONFIG_BTRFS_ASSERT is disabled. The subsequent dereference of
cache->flags therefore crashes the kernel.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in
btrfs_may_alloc_data_chunk() and print and error message for clarity.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[btrfs: balance]` `[fix]` — Fix potential block-group
lookup failure in `btrfs_may_alloc_data_chunk()` during balance
operations.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** none in the provided message (v1/v3 on lore have `Fixes:
  a6f93c71d412`)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** David Sterba `<dsterba@suse.com>` (btrfs maintainer)
- **Acked-by:** none
- **Link:** none in provided message
- **Cc: stable@vger.kernel.org:** absent in provided message; present in
  v1 lore submission
- **Signed-off-by:** ZhengYuan Huang; David Sterba (ignore any pipeline-
  added SOBs)

Notable: maintainer review; v1 explicitly nominated for stable on lore.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** NULL pointer dereference in `btrfs_may_alloc_data_chunk()`
  when running `btrfs balance` on a filesystem where metadata corruption
  leaves a chunk in the chunk tree without a matching in-memory block
  group.
- **Symptom:** KASAN null-ptr-deref at `cache->flags` (offset 0x88),
  stack through `__btrfs_balance` → `btrfs_balance` →
  `btrfs_ioctl_balance`.
- **Root cause:** `btrfs_lookup_block_group()` can return NULL; only
  `ASSERT(cache)` guards it, and `ASSERT` is a no-op when
  `CONFIG_BTRFS_ASSERT` is disabled (the default).
- **Fix:** NULL check, `btrfs_err()` message, return `-EUCLEAN`.
- **Version info:** Bug tied to function introduced in `a6f93c71d412ba`
  (2017/2018).

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — explicitly a NULL-deref crash fix. The
`unlikely()` wrapper in the provided diff matches existing EUCLEAN-path
style in this tree (e.g. commit `9264d004a6c97`).

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `fs/btrfs/volumes.c` (+5/-1 net in v1; +6/-1 with
  `unlikely` in provided diff)
- **Function:** `btrfs_may_alloc_data_chunk()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `cache = btrfs_lookup_block_group(...); ASSERT(cache);
  chunk_type = cache->flags;` — ASSERT no-op in production → NULL deref.
- **After:** If `!cache`, log error and return `-EUCLEAN`; otherwise
  proceed as before.
- **Path affected:** Balance relocation path in `__btrfs_balance()`
  before `btrfs_relocate_chunk()`.

### Step 2.3: Bug Mechanism
**Record:** **Category:** NULL pointer dereference (memory safety).
**Mechanism:** Missing NULL check after lookup; assertion disabled in
production kernels. Fix converts kernel oops into controlled `-EUCLEAN`
error propagation.

### Step 2.4: Fix Quality
**Record:** Obviously correct and minimal. Matches existing patterns in
the same file (e.g. lines 3587–3589, 8326–8328). `-EUCLEAN` is the
established btrfs corruption error code (used at lines 4272, 2041,
etc.). **Regression risk:** Very low — only affects the already-broken
corruption case.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:** `btrfs_may_alloc_data_chunk()` introduced in
`a6f93c71d412ba` (Liu Bo, 2017-11-15 / committed 2018-01-22).
`ASSERT(cache)` present since introduction. Bug has existed ~8 years in
this code path.

### Step 3.2: Follow Fixes Tag
**Record:** N/A in provided message. Lore v3 has `Fixes: a6f93c71d412` —
that commit is in this tree and introduced the vulnerable function.

### Step 3.3: Related File History
**Record:** Related recent fix `c19830db30a09` replaced `BUG()` with
`-EUCLEAN` in `__btrfs_balance()` — same corruption-handling philosophy.
Fix commit not found in this tree (`git log --grep='null-ptr-deref in
btrfs_may_alloc_data_chunk'` returned empty). Buggy code confirmed
present at lines 3723–3725.

### Step 3.4: Author's Other Commits
**Record:** ZhengYuan Huang has other btrfs fixes in this tree (e.g.
root drop_level validation). Part of a 4-patch series on lore fixing
similar balance NULL derefs.

### Step 3.5: Dependencies
**Record:** **Standalone.** Patch 3/4 in the series; fixes only
`btrfs_may_alloc_data_chunk()`. Other series patches fix
`chunk_usage_filter()` and `chunk_usage_range_filter()` separately. No
structural prerequisites — applies cleanly to v6.18.44.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- `b4 dig` / `b4 am` did not find the commit (not yet merged here; no
  commit hash provided).
- Lore v1: https://lkml.iu.edu/2603.2/00971.html (Mar 16, 2026)
- Lore v3 patch 3/4: https://lkml.iu.edu/2603.3/02434.html (Mar 24,
  2026)
- Series cover v3: https://lkml.iu.edu/2603.3/02432.html
- v1 included `Cc: stable@vger.kernel.org`
- v3 adds `btrfs_may_alloc_data_chunk` fix per maintainer feedback;
  reviewed by David Sterba

### Step 4.2: Reviewers
**Record:** David Sterba (btrfs maintainer) reviewed and signed off.
Series CC'd `linux-btrfs@`.

### Step 4.3: Bug Report
**Record:** KASAN null-ptr-deref with full stack trace in commit
message. Reproducible on corrupted images. No syzbot report. Trigger:
`btrfs balance` on corrupted metadata.

### Step 4.4: Related Patches
**Record:** 4-patch series; patches 1–2 fix analogous NULL derefs in
balance filters; patch 4 fixes mount-time verification. This commit
(patch 3) is independently valuable even without the others.

### Step 4.5: Stable Mailing List
**Record:** v1 explicitly requested stable backport via `Cc:
stable@vger.kernel.org`. No stable-list rejection found.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `btrfs_may_alloc_data_chunk()` (modified); callers:
`__btrfs_balance()`, device-shrink path (~line 5119), zoned repair path
(~line 8333).

### Step 5.2: Callers
**Record:**
- `__btrfs_balance()` at line 4347 — primary path, checks `ret < 0` →
  `goto error`
- Device shrink loop at line 5119 — same error handling
- Zoned repair at line 8333 — `ret < 0` → `goto out`
All three callers properly propagate negative returns.

### Step 5.3: Callees
**Record:** `btrfs_lookup_block_group()` →
`block_group_cache_tree_search()` — can return NULL when no matching
block group exists in cache.

### Step 5.4: Call Chain / Reachability
**Record:**
```
userspace btrfs balance (CAP_SYS_ADMIN)
  → btrfs_ioctl_balance() [ioctl.c:3555]
    → btrfs_balance() [volumes.c:4733]
      → __btrfs_balance() [volumes.c:4347]
        → btrfs_may_alloc_data_chunk() [volumes.c:3723]
```
Reachable from userspace via `BTRFS_IOC_BALANCE_V2` ioctl by root/admin.

### Step 5.5: Similar Patterns
**Record:** Same file already NULL-checks `btrfs_lookup_block_group()`
at lines 3587–3589 and 8326–8328. `chunk_usage_filter()` and
`chunk_usage_range_filter()` at lines 3968 and 3997 still dereference
without NULL checks (fixed by sibling patches, not this one).

---

## Phase 6: Cross-Referencing Against Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Local tree is **v6.18.44** (`git describe HEAD`).
At `fs/btrfs/volumes.c:3723–3725`:

```3723:3726:fs/btrfs/volumes.c
        cache = btrfs_lookup_block_group(fs_info, chunk_offset);
        ASSERT(cache);
        chunk_type = cache->flags;
        btrfs_put_block_group(cache);
```

Fix error string not present (`grep` found no matches). Bug introduced
with function in 2018.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Function and call sites unchanged
in structure. Only line numbers differ from lore (3601 vs 3723) due to
tree evolution.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** `c19830db30a09` fixed a different
`__btrfs_balance()` BUG() path. Sibling NULL-deref fixes for balance
filters not present.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **btrfs filesystem** — IMPORTANT (widely deployed, data
integrity critical).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent balance-related hardening
(`c19830db30a09`, EUCLEAN annotations `9264d004a6c97`).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** btrfs users running balance on filesystems with chunk/block-
group metadata inconsistency. All btrfs-enabled configs.

### Step 8.2: Trigger Conditions
**Record:** Metadata corruption (chunk without block group) + balance
operation. Uncommon but realistic — corruption can survive mount due to
incomplete `check_chunk_block_group_mappings()` (per series cover).
Requires `CAP_SYS_ADMIN` for balance ioctl.

### Step 8.3: Failure Mode Severity
**Record:** **CRITICAL** — kernel NULL pointer dereference / oops. Fix
downgrades to `-EUCLEAN` returned to userspace with error log.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents kernel crash during balance on corrupted
  FS; balance is a common recovery/maintenance tool
- **Risk:** VERY LOW — 5-line defensive check on error-only path
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real NULL deref with KASAN stack trace
- Kernel crash → controlled error
- Small, surgical, maintainer-reviewed fix
- Bug present since 2018 in this tree
- Consistent with existing EUCLEAN handling
- v1 nominated for stable
- Applies cleanly to v6.18.44

**AGAINST backport:**
- Requires metadata corruption (rare)
- Requires admin privileges to trigger via balance
- Sibling patches fix related NULL derefs in other balance filters (this
  commit doesn't fix those)

**Unresolved:** Exact upstream commit hash not in local tree (candidate
evaluation). Does not affect decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — maintainer reviewed; logic
   matches existing NULL-check patterns
2. Fixes real bug? **PASS** — KASAN-confirmed NULL deref
3. Important issue? **PASS** — kernel oops (CRITICAL severity)
4. Small and contained? **PASS** — ~5 lines, one function
5. No new features/APIs? **PASS** — defensive error handling only
6. Can apply to local tree? **PASS** — buggy code confirmed present,
   clean apply expected

### Step 9.3: Exception Categories
**Record:** None (standard bug fix, not device ID/quirk/build fix).

### Step 9.4: Decision Rationale

For **v6.18.44**, this commit fixes a long-standing NULL dereference in
the btrfs balance path that crashes the kernel when metadata corruption
leaves a chunk without a corresponding block group. The fix is minimal,
follows established btrfs error-handling conventions (`-EUCLEAN`), is
reviewed by the btrfs maintainer, and converts a kernel oops into a
clean error return. The bug exists in this tree and the fix is not yet
applied.

---

## Verification

- **[Phase 1]** Parsed subject, tags (Reviewed-by: David Sterba), body
  (KASAN trace, root cause, fix)
- **[Phase 2]** Diff: replaces `ASSERT(cache)` with NULL check +
  `-EUCLEAN` in `btrfs_may_alloc_data_chunk()`
- **[Phase 3]** `git blame`: function from `a6f93c71d412ba` (2018);
  `ASSERT(cache)` since introduction
- **[Phase 3]** `git log --grep='null-ptr-deref in
  btrfs_may_alloc_data_chunk'`: empty — fix not in tree
- **[Phase 3]** Related commit `c19830db30a09`: BUG→EUCLEAN in
  `__btrfs_balance()`
- **[Phase 4]** `b4 am`: no match (commit not merged)
- **[Phase 4]** WebFetch lkml v1 (00971): `Cc: stable@vger.kernel.org`
  confirmed
- **[Phase 4]** WebFetch lkml v3 (02434): patch 3/4, Reviewed-by David
  Sterba
- **[Phase 4]** WebFetch series cover (02432): standalone per-function
  fixes, mount-time gap described
- **[Phase 5]** Grep callers: lines 4347, 5119, 8333 — all check `ret <
  0`
- **[Phase 5]** `btrfs_lookup_block_group()` in `block-group.c:279-283`
  — returns search result, can be NULL
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Read `volumes.c:3723-3725`: buggy code present
- **[Phase 6]** Grep for fix message string: not found — fix absent
- **[Phase 6]** Existing NULL checks at lines 3587-3589, 8326-8328
  confirmed
- **[Phase 6]** `messages.h:170-171`: `ASSERT` → `(void)(cond)` when
  `CONFIG_BTRFS_ASSERT` disabled
- **[Phase 6]** `Kconfig:76-85`: BTRFS_ASSERT defaults to N ("If unsure,
  say N")
- **[Phase 8]** Call chain traced: ioctl → balance → `__btrfs_balance` →
  `btrfs_may_alloc_data_chunk`
- **[Phase 8]** Error propagation: `ret < 0` → `goto error` → returned
  through `btrfs_balance` → `btrfs_ioctl_balance`

**YES**The background searches finished and match the earlier analysis:

- The fix commit is **not in v6.18.44** — `git log --grep` for the null-
  ptr-deref / bg lookup fix returned nothing.
- The only related hit was an older indentation cleanup
  (`5ae2169290695`), not this fix.
- The buggy `ASSERT(cache)` path is still present in
  `fs/btrfs/volumes.c`.

Verdict stands: **YES** for backport to this tree.

 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ff67f5ecacb2e..a17fcf8bd8a99 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3721,7 +3721,11 @@ static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
 	u64 chunk_type;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
-	ASSERT(cache);
+	if (unlikely(!cache)) {
+		btrfs_err(fs_info, "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_type = cache->flags;
 	btrfs_put_block_group(cache);
 
-- 
2.53.0

