Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151C84302E6;
	Mon, 31 Aug 2026 13:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183226; cv=none; b=D+VmDt1bSqIQTt/W8wS31WVGxcsrIO0cTSMgLfcEQ5sTTayyXSsgt/sUKiE9iwuw7s6AvEnJwPAJFul3SlPJCyDycCKgbgQqjNcXkn9v/RBaOjswdL9o4yXyBRvmixvj3675v6V6iHqwtDqjuCxNzWCJPrqgwOwSZqAJPVNX20s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183226; c=relaxed/simple;
	bh=5lVvHXIAUsKrO0pyLf/HW3pkVaqBJ8tAE+mm6jRn8H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RM0w4tZztsd/+vSbX/P7MWFmpCrGdFULw3v1OIxOZ2fJAE/KfymWvplm5fp1vcGXvmLC912WUzC+JD2MLxRuq52wPt1h80If1cShHoOaYoE4KmPTr2j4JQu8LL5W7DgMuBNjEGNTwul7AdeeSV42lSYLo3JVmBua1Rj8JuY0f9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xr7lewpm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xr7lewpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F401F00A3D;
	Mon, 31 Aug 2026 13:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183224;
	bh=fCErg2Hrtok/522CbFYTLLln1nhr7kRsQGC5jRupeks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xr7lewpmztG8pX+8qXqZhOdaBvc2GCj87P4z4uJ5bJwNV3zCF01DC8/kmuon+wOAR
	 LaU/5DxR20mN6N2gzhcgQKC52156B37ndvunCUfpDDmaGhUH628dy0QVZuo3SbcwLX
	 ckyOGRTd/Y4rqU7sqmM/SSjJDqBk8iVQJoP6ksNVm8kBguPor0yrXF+bGdlgFEumKP
	 KUW3btnt1q6IZTdY6W8DTKwbPUTTSbn+zzEmn8oDLR5u8gLz/KLTEGlOJLTlzJNtth
	 HO4IlqW1IjIXL71YJyYRg90zFFFyWXkgrSIFrFhe9U1qe7BLrWy4gMD5SwKe7lwO1B
	 zDKdSCjSnLBXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: KangNing Liao <lkangn.kernel@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] btrfs: protect sb_write_pointer() with invalidate lock
Date: Mon, 31 Aug 2026 09:20:47 -0400
Message-ID: <20260831133314.4125787-19-sashal@kernel.org>
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

From: KangNing Liao <lkangn.kernel@gmail.com>

[ Upstream commit 123b9a545f4d0348e81f558a032bf2a93ee5722f ]

sb_write_pointer() reads the super block from the block device page cache
using read_cache_page_gfp(). This has the same race with BLKBSZSET as the
one fixed by commit 3f29d661e568 ("btrfs: sync read disk super and set
block size").

Take the mapping invalidate lock around read_cache_page_gfp() to
serialize the read against block size changes.

Signed-off-by: KangNing Liao <lkangn.kernel@gmail.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `btrfs: protect sb_write_pointer() with
invalidate lock`

**Tree under review:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD)

**Commit analyzed:** `123b9a545f4d0` (not yet in this tree; applies
cleanly)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[btrfs]` `[protect]` — Add invalidate-lock protection
around superblock page-cache reads in `sb_write_pointer()` for zoned
btrfs.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** KangNing Liao `<lkangn.kernel@gmail.com>` (author)
- **Reviewed-by:** Qu Wenruo `<wqu@suse.com>` (btrfs maintainer)
- **Signed-off-by:** David Sterba `<dsterba@suse.com>` (btrfs
  maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, or `Tested-by:`
  tags
- Notable: References upstream commit `3f29d661e568` as the prior fix
  for the same race class

### Step 1.3: Body analysis
**Record:**
- **Bug:** `sb_write_pointer()` calls `read_cache_page_gfp()` without
  synchronizing against `BLKBSZSET` block-size changes on the block
  device mapping.
- **Symptom:** Same race as the syzbot-reported crash fixed in
  `3f29d661e568` / stable `ccb3c75d57039`: folio order vs.
  `mapping_min_folio_order()` mismatch → `VM_BUG_ON_FOLIO` or NULL
  pointer dereference in `create_empty_buffers()`.
- **Root cause:** Block-size change via `BLKBSZSET` alters
  `mapping->flags` while a folio is being allocated/read.
- **Fix:** Wrap `read_cache_page_gfp()` with `filemap_invalidate_lock()`
  / `filemap_invalidate_unlock()`.

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite “protect” wording rather than “fix”, this is a
real concurrency/crash bug fix, not cleanup. It completes the same
protection pattern already applied to `btrfs_read_disk_super()` in this
tree.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/btrfs/zoned.c` only (+2 lines)
- **Functions:** `sb_write_pointer()` only
- **Scope:** Single-file, surgical fix (2 insertions)

### Step 2.2: Code flow per hunk
**Record:**
- **Before:** In the `full[0] && full[1]` branch (both superblock log
  zones full), loop calls `read_cache_page_gfp()` unlocked to compare
  superblock generations.
- **After:** Same path, but `read_cache_page_gfp()` is serialized
  against block-size invalidation via `filemap_invalidate_lock/unlock`.
- **Affected path:** Error and success paths unchanged; only the page-
  cache read is synchronized.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Race condition / memory safety (folio order mismatch)
- **Mechanism:** Concurrent `BLKBSZSET` changes
  `mapping_min_folio_order()` after folio allocation begins but before
  `filemap_add_folio()` completes, producing kernel BUG or NULL deref —
  identical to the already-backported `btrfs_read_disk_super()` bug.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct — mirrors the exact pattern already in
  `btrfs_read_disk_super()` at `fs/btrfs/volumes.c:1368-1370`.
- **Regression risk:** Very low; `filemap_invalidate_lock` is the
  established synchronization primitive for this race.
- **No new APIs, no behavior change beyond preventing the race.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `read_cache_page_gfp()` in `sb_write_pointer()` introduced in
  `12659251ca5df` (Nov 2020, “implement log-structured superblock for
  ZONED mode”).
- Loop structure updated in `02ca9e6fb5f66a` / `d2715d1db455e`
  (2023–2024).
- Buggy unlocked read has been present since zoned superblock logging
  was added.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Referenced commit `3f29d661e568`
exists in repo; equivalent backport `ccb3c75d57039` **is** in this tree
(committed by Greg K-H, Feb 2026).

### Step 3.3: Related file history
**Record:**
- `ccb3c75d57039` backported the `btrfs_read_disk_super()` fix to
  6.18.y.
- `123b9a545f4d0` is on `master` but not yet on `stable/linux-6.18.y`.
- Standalone single-patch series (v1 only per `b4 dig -a`).

### Step 3.4: Author context
**Record:** KangNing Liao has prior btrfs zoned contributions. Patch
reviewed by Qu Wenruo (active btrfs maintainer).

### Step 3.5: Dependencies
**Record:**
- References `3f29d661e568` conceptually; stable tree has
  `ccb3c75d57039` (same fix, different hash).
- No structural dependencies — patch applies cleanly (`git apply
  --check` succeeded).
- Standalone; does not require other commits from the series.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260521122945.524890-1-
  lkangn.kernel@gmail.com
- **Series:** v1 only (2026-05-21)
- **Reviewer feedback:** Qu Wenruo replied with `Reviewed-by:` and
  “Thanks” — no NAKs or concerns
- **Stable nomination:** None found in thread

### Step 4.2: Reviewers
**Record:** `b4 dig -w` shows CC to `linux-btrfs@vger.kernel.org`, David
Sterba, Edward Davis (author of the original BLKBSZSET fix), Filipe
Manana’s address not listed but David Sterba committed.

### Step 4.3: Bug report
**Record:** No direct syzbot report for this path. Indirect evidence
from `ccb3c75d57039` syzbot report (`b4a2af3000eaa84d95d5`) documenting
identical failure mode in `btrfs_read_disk_super()`.

### Step 4.4: Related patches
**Record:** Companion to `ccb3c75d57039` — same race, different code
path in zoned superblock handling.

### Step 4.5: Stable list
**Record:** Lore fetch blocked by bot protection for full thread; mbox
download via `b4 dig -m` succeeded. No stable-list discussion found in
mbox content.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `sb_write_pointer()` (modified)

### Step 5.2: Callers
**Record:**
- `sb_log_location()` → `sb_write_pointer()`
- `btrfs_sb_log_location_bdev()` → `sb_log_location()` — called from
  `btrfs_read_disk_super()` (`fs/btrfs/volumes.c:1346`)
- `btrfs_sb_log_location()` → `sb_log_location()` — called from `disk-
  io.c` (super write/read), `scrub.c`, and zoned device validation
  (`zoned.c:585`)

### Step 5.3: Callees
**Record:** `filemap_invalidate_lock()`, `read_cache_page_gfp()`,
`filemap_invalidate_unlock()`, `btrfs_release_disk_super()`

### Step 5.4: Reachability
**Record:**
- Triggered on zoned block devices (`bdev_is_zoned()`) when both
  superblock log zones are full.
- Reachable during **mount** (`btrfs_read_disk_super` →
  `btrfs_sb_log_location_bdev`), **superblock writes**, **scrub**, and
  **device validation**.
- `BLKBSZSET` requires privileged access to the block device; syzbot
  demonstrated the race is reachable from userspace with appropriate
  privileges.

### Step 5.5: Similar patterns
**Record:** Identical lock pattern already present in
`btrfs_read_disk_super()` in this tree (`volumes.c:1368-1370`). This
path was simply missed when that fix was backported.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.y)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `fs/btrfs/zoned.c:133-134` calls
`read_cache_page_gfp()` without invalidate lock. Bug present since zoned
superblock logging (2020).

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` passed with zero
conflicts.

### Step 6.3: Related fixes already present?
**Record:** **Partial.** `ccb3c75d57039` fixed `btrfs_read_disk_super()`
in this tree but left `sb_write_pointer()` unprotected. This commit
closes that gap.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `fs/btrfs` — filesystem, zoned-mode superblock handling.
**Criticality: IMPORTANT** (filesystem mount/write path; not universal
like VFS core, but crash on mount/write for zoned btrfs users).

### Step 7.2: Activity
**Record:** Actively maintained; recent zoned fixes in 6.18.y
(`deddd28fd83c2`, `4d4ef6627304a`, etc.).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of **zoned btrfs** on host-managed zoned block devices
(SMR/ZNS SSDs). Config: btrfs with zoned devices enabled at format/mount
time.

### Step 8.2: Trigger conditions
**Record:**
- Zoned btrfs with both superblock log zones full (normal steady-state
  after superblock updates)
- Concurrent `BLKBSZSET` on the same block device
- Uncommon in production but proven reachable (syzbot for sibling path);
  mount-time scenario explicitly described in `ccb3c75d57039`

### Step 8.3: Failure mode
**Record:** Kernel `VM_BUG_ON_FOLIO` or KASAN NULL pointer dereference
in buffer-head setup → **CRITICAL** (oops/panic during mount or
superblock I/O).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for zoned btrfs users — prevents kernel crash;
  completes already-backported fix family
- **Risk:** VERY LOW — 2 lines, identical to proven pattern already in
  tree
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real race bug with documented crash mechanism (syzbot for same pattern
  in `btrfs_read_disk_super`)
- Partial fix already in 6.18.y (`ccb3c75d57039`); this closes the
  remaining hole
- Kernel crash severity (CRITICAL)
- Tiny, surgical, obviously correct
- Reviewed by btrfs maintainer (Qu Wenruo)
- Applies cleanly to 6.18.y

**AGAINST backport:**
- Affects only zoned btrfs (niche subset of btrfs users)
- No direct syzbot report for this exact function (indirect evidence
  only)
- Requires privileged `BLKBSZSET` concurrent with superblock read

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors in-tree fix;
   maintainer reviewed
2. Fixes a real bug? **PASS** — race with `BLKBSZSET` on page-cache read
3. Important issue? **PASS** — kernel crash (BUG/null deref)
4. Small and contained? **PASS** — 2 lines, 1 file, 1 function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified;
   prerequisite fix already present

### Step 9.3: Exception category
**Record:** N/A (standard bug fix, not device-ID/quirk/DT/docs
exception)

### Step 9.4: Decision rationale

This tree (`6.18.44`) already backported the `BLKBSZSET` vs.
`read_cache_page_gfp()` race fix for `btrfs_read_disk_super()`, but
`sb_write_pointer()` — called from the same mount and superblock I/O
paths on zoned devices — still performs the identical unlocked read when
both superblock log zones are full. Leaving this unprotected means the
backport is incomplete: zoned btrfs users can still hit the same crash
class the stable tree already decided was worth fixing. The patch is
minimal, follows the established pattern already in `volumes.c`, and
applies without modification.

---

## Verification

- **[Phase 1]** `git show 123b9a545f4d0 --format=fuller`: parsed
  subject, body, tags
- **[Phase 1]** No syzbot/Fixes tags on this commit; references
  `3f29d661e568`
- **[Phase 2]** Diff: +2 lines in `sb_write_pointer()`,
  `filemap_invalidate_lock/unlock` around `read_cache_page_gfp()`
- **[Phase 2]** Read `fs/btrfs/zoned.c:88-159`: confirmed buggy unlocked
  read in `full[0] && full[1]` branch
- **[Phase 2]** Read `fs/btrfs/volumes.c:1368-1370`: confirmed identical
  fix pattern already in tree
- **[Phase 3]** `git describe HEAD`: `v6.18.44`
- **[Phase 3]** `git blame -L 128,140 fs/btrfs/zoned.c`:
  `read_cache_page_gfp` since `12659251ca5df` (2020)
- **[Phase 3]** `git merge-base --is-ancestor ccb3c75d57039 HEAD`:
  prerequisite fix **in tree**
- **[Phase 3]** `git merge-base --is-ancestor 123b9a545f4d0 HEAD`: fix
  commit **not in tree**
- **[Phase 3]** `git show ccb3c75d57039`: stable backport of BLKBSZSET
  race fix with syzbot stack trace
- **[Phase 3]** `git apply --check` on patch: **applies cleanly**
- **[Phase 4]** `b4 dig -c 123b9a545f4d0`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1 only, no revisions
- **[Phase 4]** `b4 dig -w`: CC to linux-btrfs, dsterba, eadavis
- **[Phase 4]** `b4 dig -m /tmp/sb_write_pointer.mbox`: Qu Wenruo
  `Reviewed-by`, no NAKs, no stable CC
- **[Phase 5]** `grep btrfs_sb_log_location`: callers in `volumes.c`,
  `disk-io.c`, `scrub.c`, `zoned.c`
- **[Phase 5]** Traced mount path: `btrfs_read_disk_super` →
  `btrfs_sb_log_location_bdev` → `sb_write_pointer`
- **[Phase 6]** Confirmed `v6.18.44` tree has unlocked
  `read_cache_page_gfp` at `zoned.c:133-134`
- **[Phase 6]** Confirmed `ccb3c75d57039` already protects
  `btrfs_read_disk_super()` read
- **[Phase 8]** Failure mode from `ccb3c75d57039` message: KASAN null-
  ptr-deref / VM_BUG_ON — CRITICAL

**YES**

 fs/btrfs/zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0dfbb28b7445c..6ca5816a67381 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -130,8 +130,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
 
+			filemap_invalidate_lock(mapping);
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
+			filemap_invalidate_unlock(mapping);
 			if (IS_ERR(page[i])) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-- 
2.53.0

