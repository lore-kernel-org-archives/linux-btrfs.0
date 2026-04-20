Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D823A3A9DB3;
	Mon, 20 Apr 2026 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691929; cv=none; b=fjrjTJzEism7Bw93iAUWDJ4+SdPls3aLe4eJdCLo0RURRKuGNOOnnsfm01srONVsbmfjIwrA5ei673UQ/uQdAK6CmiQVOv4PLtL+hfrd40lR0qpXAi0/zxjEXDFSERLoM8IdGdQjJH1jaNRd0TVKdU4K6fF1c7ZPNvwMket4xL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691929; c=relaxed/simple;
	bh=ezqlU37ANbeKsqozw/1jOWoBmKYZeToNqHXnc2Ys4rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8ks1EQjL/hKWYD2YBYPskhoaYtB3tZaPo0MQOX+FKoHCIghB78o50gHCKlZzKclL6jaMG+lpJHzg2Ufuv7bdEjIEKUhF3vjRwvaMxqTCis98UltK/tn6991pVyzwKh2nYq7gvSNdmNM5AIzU9GncUzWgDw8TMo9MtkHgyrVZEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=txde56fa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="txde56fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982DAC19425;
	Mon, 20 Apr 2026 13:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691929;
	bh=ezqlU37ANbeKsqozw/1jOWoBmKYZeToNqHXnc2Ys4rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txde56faJQKBBmpJl2S97m1nnkvJL6KmRykK2MR9eekEV/KgTw/BRafHtDLoo8il6
	 aRflBNa3YMTbFWNKufIMQGf0hSypOXBpPSra8EjcAuGYv6R1fBgraNSZ+RTiV+BNSH
	 ExNZtzMJrIL0q5JCfWLcMvSrhCIR3KNtvmhx8cHwXrn95EXATpFsNFGAYdueinf0uN
	 sJPBDcuHFtdHk5DbO+bgGnRmx1A0NEC3f+iCNB8RYxZq1iszEJMYd05ByFfOAdlNOY
	 bcKM9p7jWmNnrL+Rl5rAWzN1/I96BIgMlusaTl7CPe94xw60rivEjnHzUch/3fPOy8
	 09eCcc6tZ2Jhg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit
Date: Mon, 20 Apr 2026 09:21:09 -0400
Message-ID: <20260420132314.1023554-275-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 7bcb04de982ff0718870112ad9f38c35cbca528b ]

On zoned filesystems metadata space accounting can become overly optimistic
due to delayed refs reservations growing without a hard upper bound.

The delayed_refs_rsv block reservation is allowed to speculatively grow and
is only backed by actual metadata space when refilled. On zoned devices this
can result in delayed_refs_rsv reserving a large portion of metadata space
that is already effectively unusable due to zone write pointer constraints.
As a result, space_info->may_use can grow far beyond the usable metadata
capacity, causing the allocator to believe space is available when it is not.

This leads to premature ENOSPC failures and "cannot satisfy tickets" reports
even though commits would be able to make progress by flushing delayed refs.

Analysis of "-o enospc_debug" dumps using a Python debug script
confirmed that delayed_refs_rsv was responsible for the majority of
metadata overcommit on zoned devices. By correlating space_info counters
(total, used, may_use, zone_unusable) across transactions, the analysis
showed that may_use continued to grow even after usable metadata space
was exhausted, with delayed refs refills accounting for the excess
reservations.

Here's the output of the analysis:

  ======================================================================
  Space Type: METADATA
  ======================================================================

  Raw Values:
    Total:                256.00 MB (268435456 bytes)
    Used:                 128.00 KB (131072 bytes)
    Pinned:                16.00 KB (16384 bytes)
    Reserved:             144.00 KB (147456 bytes)
    May Use:              255.48 MB (267894784 bytes)
    Zone Unusable:        192.00 KB (196608 bytes)

  Calculated Metrics:
    Actually Usable:       255.81 MB (total - zone_unusable)
    Committed:             255.77 MB (used + pinned + reserved + may_use)
    Consumed:              320.00 KB (used + zone_unusable)

  Percentages:
    Zone Unusable:    0.07% of total
    May Use:         99.80% of total

Fix this by adding a zoned-specific cap in btrfs_delayed_refs_rsv_refill():
Before reserving additional metadata bytes, limit the delayed refs
reservation based on the usable metadata space (total bytes minus
zone_unusable). If the reservation would exceed this cap, return -EAGAIN
to trigger the existing flush/commit logic instead of overcommitting
metadata space.

This preserves the existing reservation and flushing semantics while
preventing metadata overcommit on zoned devices. The change is limited to
metadata space and does not affect non-zoned filesystems.

This patch addresses premature metadata ENOSPC conditions on zoned devices
and ensures delayed refs are throttled before exhausting usable metadata.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding. Let me compile the final analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `btrfs: zoned:` (btrfs filesystem, zoned device mode)
- **Action verb**: "cap" (limit/constrain)
- **Summary**: Cap delayed refs metadata reservation to avoid overcommit
  on zoned filesystems

Record: [btrfs: zoned] [cap] [Limit delayed refs metadata reservation to
prevent metadata overcommit on zoned devices]

### Step 1.2: Tags
- **Reviewed-by**: Filipe Manana <fdmanana@suse.com> -- a core btrfs
  developer and the most prolific btrfs contributor
- **Signed-off-by**: Johannes Thumshirn <johannes.thumshirn@wdc.com> --
  author, WDC employee, active btrfs/zoned contributor
- **Signed-off-by**: David Sterba <dsterba@suse.com> -- btrfs maintainer
  who merged it
- No Fixes: tag (expected for manual review candidates)
- No Cc: stable tag (expected)
- No Reported-by tag (author-discovered through debugging)

Record: Reviewed by Filipe Manana (core btrfs developer), committed by
maintainer David Sterba. No bug report reference.

### Step 1.3: Commit Body
The commit describes a real-world ENOSPC problem on zoned btrfs:
- `delayed_refs_rsv` speculatively grows without a hard upper bound
- On zoned devices, zone write pointer constraints make some space
  unusable
- `space_info->may_use` grows beyond usable metadata capacity
- This causes premature ENOSPC failures ("cannot satisfy tickets")
- The author provided extensive analysis output from enospc_debug dumps
  showing may_use at 99.80% of total while consumed was only 320KB

**Failure mode**: Premature ENOSPC errors on zoned devices, preventing
writes even though space could be recovered by flushing delayed refs.

Record: [Bug: Metadata overcommit on zoned devices leads to premature
ENOSPC] [Symptom: cannot satisfy tickets, premature ENOSPC] [Root cause:
delayed_refs_rsv unbounded growth relative to zone_unusable space]

### Step 1.4: Hidden Bug Fix Detection
This is NOT a hidden bug fix - the commit explicitly describes fixing
premature ENOSPC on zoned devices. It's a clear bug fix with detailed
analysis.

Record: [Direct bug fix, not hidden]

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
- **fs/btrfs/delayed-ref.c**: +28 lines (new function
  `btrfs_zoned_cap_metadata_reservation` + 3-line call site)
- **fs/btrfs/transaction.c**: +8 lines (handle -EAGAIN from refill by
  committing transaction and retrying)
- **Total**: ~36 lines added, 0 removed
- **Functions modified**: `btrfs_delayed_refs_rsv_refill()`,
  `start_transaction()`
- **New function**: `btrfs_zoned_cap_metadata_reservation()` (static
  helper)
- **Scope**: Two-file surgical fix, limited to zoned mode

Record: [2 files, ~36 lines added] [btrfs_delayed_refs_rsv_refill
modified, start_transaction modified] [Small surgical fix]

### Step 2.2: Code Flow Changes

**Hunk 1 (delayed-ref.c)**: New static function
`btrfs_zoned_cap_metadata_reservation`:
- Before: No cap on delayed refs reservation
- After: On zoned devices, checks if `block_rsv->size` exceeds half of
  usable metadata (`total_bytes - bytes_zone_unusable`). Returns -EAGAIN
  if exceeded.
- Only affects zoned mode (`btrfs_is_zoned` check at start)

**Hunk 2 (delayed-ref.c)**: Call to new function in
`btrfs_delayed_refs_rsv_refill`:
- Before: Directly calls `btrfs_reserve_metadata_bytes`
- After: First checks the zoned cap; if exceeded, returns -EAGAIN before
  attempting actual reservation

**Hunk 3 (transaction.c)**: -EAGAIN handling in `start_transaction`:
- Before: Any error from `btrfs_delayed_refs_rsv_refill` goes to
  `reserve_fail`
- After: If -EAGAIN (zoned cap hit), commits current transaction (which
  flushes delayed refs, freeing space), then retries the refill

Record: [New cap check prevents overcommit] [EAGAIN triggers transaction
commit + retry] [Only zoned mode affected]

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** for metadata accounting on zoned
devices.

What was broken: The delayed refs block reserve could grow arbitrarily
large on zoned filesystems, where zone write pointer constraints
(tracked as `bytes_zone_unusable`) make portions of metadata space
physically unusable. The overcommit logic didn't account for this, so
`may_use` could far exceed actually usable space.

How the fix works: Adds a zoned-specific cap at 50% of usable metadata
space (`usable >> 1`). When the cap is hit, returns -EAGAIN instead of
proceeding with the reservation. The caller (transaction start) responds
by committing the current transaction, which flushes delayed refs and
frees the overcommitted space.

Record: [Logic/correctness bug in metadata accounting on zoned devices]
[Fix: cap at 50% usable space, trigger flush when cap exceeded]

### Step 2.4: Fix Quality
- The fix is well-contained: adds one static helper + two call sites
- The zoned-only guard (`btrfs_is_zoned`) ensures non-zoned systems are
  completely unaffected
- The `ASSERT(btrfs_is_zoned(fs_info))` in the EAGAIN handler is good
  defensive coding
- The retry pattern (commit, then retry) is a well-established pattern
  in btrfs space management
- Reviewed by Filipe Manana who is the most active btrfs contributor
- Potential regression risk is LOW: only affects zoned mode, uses
  existing flush/commit mechanisms, and the cap is generous (50% of
  usable)

Record: [Obviously correct, well-reviewed, minimal regression risk for
non-zoned users] [Zero risk for non-zoned, low risk for zoned]

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- `btrfs_delayed_refs_rsv_refill()` was introduced by Josef Bacik in
  commit `6ef03debdb3d82` (2019-06-19), present since approximately
  v5.3.
- The function has been refined by Filipe Manana (2023) and others but
  its core logic (grow unbounded) has been present since inception.
- The zoned mode support was added later, but the interaction with
  delayed refs rsv was never specifically addressed.

Record: [Refill function from v5.3 (6ef03debdb3d82)] [Zoned support
added later without accounting for delayed refs rsv interaction]

### Step 3.2: Fixes Tag
No Fixes: tag present. The bug is a design gap in how delayed refs rsv
interacts with zoned mode constraints, not introduced by a single
commit.

Record: [No Fixes: tag - this is a design gap, not a single-commit
regression]

### Step 3.3: Related Changes
- `28270e25c69a2` (v6.7) - "btrfs: always reserve space for delayed refs
  when starting transaction" - changed how delayed refs reservations
  work, may have exacerbated the issue
- `64d2c847ba380` (v6.9) - "btrfs: zoned: fix
  calc_available_free_space() for zoned mode" - closely related fix for
  overcommit on zoned, was CC'd to stable
- `a1359d06d7878` (v7.0) - API change to `btrfs_reserve_metadata_bytes`
  that would affect clean backport

Record: [Related to 28270e25c69a2 and 64d2c847ba380] [API differences
across stable trees]

### Step 3.4: Author
Johannes Thumshirn is a WDC employee and regular btrfs/zoned contributor
with 20+ btrfs commits visible. He is a recognized expert on zoned
btrfs.

Record: [Author is a recognized zoned btrfs expert at WDC]

### Step 3.5: Dependencies
**CRITICAL**: `btrfs_commit_current_transaction()` was introduced in
commit `ded980eb3fadd7` (2024-05-22), which is only present in v6.11+.
This function is used in the `transaction.c` hunk. Backporting to v6.6.y
or older stable trees would require either:
1. Also backporting `ded980eb3fadd7` (and its dependents)
2. Replacing the call with the inline equivalent
   (`btrfs_attach_transaction_barrier` + `btrfs_commit_transaction`)

Additionally, `btrfs_reserve_metadata_bytes()` had its signature changed
by `a1359d06d7878` (dropping `fs_info` argument), which is only in the
latest tree. Older trees have a different API.

Record: [Depends on ded980eb3fadd7 (btrfs_commit_current_transaction) -
only in v6.11+] [API differences for btrfs_reserve_metadata_bytes across
versions]

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5
b4 dig could not find the commit (likely very recent, post-7.0-rc or in
a merge window). Web searches also did not find the specific patch
discussion. Lore.kernel.org was protected by anti-bot measures.

Record: [Could not find mailing list discussion - commit appears very
recent, possibly in 7.0 merge window or rc cycle] [UNVERIFIED: Full
mailing list discussion not available]

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Functions and Call Chains
- `btrfs_delayed_refs_rsv_refill()` is called from:
  1. `start_transaction()` in `transaction.c` - called on every
     transaction start with num_items==0
  2. `btrfs_truncate_inode_items()` in `inode-item.c` - called during
     truncate/unlink (with BTRFS_RESERVE_NO_FLUSH)
- `start_transaction()` is called from many places throughout btrfs
  (dozens of call sites)
- The `num_items == 0` path specifically handles callers using
  `btrfs_start_transaction(root, 0)` which is a very common pattern (24+
  call sites across btrfs)

The `inode-item.c` caller already converts ALL errors to `-EAGAIN` (line
708), so the new -EAGAIN from the cap function is handled correctly
without modification.

Record: [btrfs_delayed_refs_rsv_refill called from transaction start and
truncate] [Very widely called function] [inode-item.c caller unaffected
by change]

### Step 5.5: Similar Patterns
The previous fix `64d2c847ba380` ("btrfs: zoned: fix
calc_available_free_space() for zoned mode") addressed a very similar
issue - overcommit on zoned mode leading to ENOSPC. That fix was CC'd to
stable 6.9+. This new fix addresses a different vector of the same
overcommit problem.

Record: [Similar fix 64d2c847ba380 was CC'd to stable 6.9+]

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Existence in Stable Trees
- The delayed refs rsv refill mechanism exists since v5.3
- Zoned mode support has been present since ~v5.12
- The interaction problem exists in all stable trees with zoned mode
  support
- However, `28270e25c69a2` (v6.7) changed delayed refs reservation
  behavior and may have worsened the problem

Record: [Buggy interaction exists in v5.12+, but may be worse in v6.7+
due to 28270e25c69a2]

### Step 6.2: Backport Complications
**SIGNIFICANT backport complications:**
1. `btrfs_commit_current_transaction()` only exists in v6.11+ - requires
   adaptation for older trees
2. `btrfs_reserve_metadata_bytes()` API changed - minor adaptation
   needed for older trees
3. The `delayed-ref.c` hunk adding the new function should apply
   relatively cleanly

Record: [Needs adaptation for v6.6-v6.10 due to missing
btrfs_commit_current_transaction] [API differences need resolution]

### Step 6.3: Related Fixes Already in Stable
`64d2c847ba380` (CC: stable 6.9+) addresses a different vector of the
same overcommit problem. This new patch addresses a complementary
vector.

Record: [64d2c847ba380 is a related but different fix, CC'd to stable
6.9+]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: btrfs filesystem, zoned device support
- **Criticality**: IMPORTANT (btrfs is a widely used filesystem, but
  zoned mode is a specialized use case for SMR/ZNS devices)
- Zoned btrfs is increasingly used on enterprise/datacenter storage
  systems with ZNS SSDs

Record: [btrfs filesystem, zoned mode - IMPORTANT but specialized use
case]

### Step 7.2: Subsystem Activity
btrfs is one of the most actively developed filesystems in the kernel.
The zoned mode subsystem specifically is under active development by
WDC/Seagate engineers.

Record: [Very active subsystem]

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users of btrfs on zoned block devices (SMR HDDs, ZNS SSDs). This is a
growing but still specialized use case, primarily in
enterprise/datacenter environments.

Record: [Affected: btrfs zoned mode users, primarily
enterprise/datacenter]

### Step 8.2: Trigger Conditions
- Occurs on zoned devices when delayed refs accumulate
- Triggered by normal write workloads that generate many delayed
  references
- More likely with sustained write activity and many COW operations
- Not timing-dependent - deterministic once space accounting gets out of
  balance

Record: [Triggered by normal sustained write workloads on zoned devices]
[Deterministic, not timing-dependent]

### Step 8.3: Failure Mode Severity
- **ENOSPC errors** - writes fail prematurely
- This is a HIGH severity issue for affected users: they lose the
  ability to write to their filesystem even though space could be
  reclaimed
- Not a crash/security issue, but a significant usability/functionality
  bug
- Data in-flight could potentially be lost if applications don't handle
  ENOSPC gracefully

Record: [Premature ENOSPC - HIGH severity for affected users] [No
crash/corruption, but functional failure]

### Step 8.4: Risk-Benefit Ratio
**BENEFIT**: High for zoned btrfs users - fixes a real ENOSPC issue
preventing normal operation
**RISK**:
- Very low for non-zoned users (completely unaffected - `btrfs_is_zoned`
  guard)
- Low for zoned users (uses existing transaction commit mechanism)
- ~36 lines added, well-contained
- BUT: requires backport adaptation due to
  `btrfs_commit_current_transaction` dependency

Record: [HIGH benefit for zoned users] [LOW risk overall] [Needs
adaptation for older stable trees]

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes a real, significant ENOSPC bug affecting zoned btrfs users
- Well-analyzed and well-documented by the author
- Reviewed by Filipe Manana (core btrfs developer)
- Committed by David Sterba (btrfs maintainer)
- Small and well-contained (~36 lines, 2 files)
- Zero risk to non-zoned users
- Author is a recognized zoned btrfs expert
- Related fix (64d2c847ba380) was explicitly CC'd to stable

**AGAINST backporting:**
- Requires adaptation for stable trees older than v6.11
  (`btrfs_commit_current_transaction` dependency)
- API differences in `btrfs_reserve_metadata_bytes` across stable trees
- No Fixes: tag or Cc: stable tag (design gap, not single-commit
  regression)
- Zoned mode is a specialized use case (fewer affected users)
- The new static function adds ~25 lines of new code (more than a
  trivial one-liner)

**UNRESOLVED:**
- Could not access mailing list discussion to check for stable
  nominations by reviewers
- Could not verify whether this was part of a larger series

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - reviewed by Filipe Manana,
   well-analyzed
2. Fixes a real bug? **YES** - premature ENOSPC on zoned devices
3. Important issue? **YES** - prevents normal filesystem operation
   (ENOSPC)
4. Small and contained? **YES** - ~36 lines, 2 files, zoned-only
5. No new features or APIs? **YES** - no new features, just a cap on
   existing behavior
6. Can apply to stable trees? **NEEDS ADAPTATION** - requires backport
   work for v6.6-v6.10

### Step 9.3: Exception Categories
Not an exception category (not a device ID, quirk, DT, build fix, or doc
fix). It's a standard bug fix.

### Step 9.4: Decision

This is a genuine bug fix for premature ENOSPC on zoned btrfs devices.
The fix is well-contained, well-reviewed, and carries very low
regression risk (zero for non-zoned users). However, it has notable
backport complications:

1. The dependency on `btrfs_commit_current_transaction()` (v6.11+) means
   this cannot be cleanly cherry-picked to older stable trees without
   adaptation.
2. API differences in `btrfs_reserve_metadata_bytes()` add further
   complications for older trees.

Despite the backport complications, the fix addresses a real,
significant user-facing bug (premature ENOSPC preventing writes), is
well-reviewed by the top btrfs developer, and is small enough to warrant
the adaptation effort. The related fix `64d2c847ba380` was CC'd to
stable 6.9+, indicating the maintainers recognize zoned overcommit
issues as stable-worthy.

## Verification

- [Phase 1] Parsed tags: Reviewed-by: Filipe Manana, Signed-off-by:
  Johannes Thumshirn (author), David Sterba (maintainer)
- [Phase 2] Diff analysis: ~36 lines added across 2 files, new static
  helper + EAGAIN handling
- [Phase 2] Verified inode-item.c caller already handles all errors as
  -EAGAIN (line 708)
- [Phase 3] git blame: btrfs_delayed_refs_rsv_refill from 6ef03debdb3d82
  (Josef Bacik, 2019, v5.3)
- [Phase 3] git blame: btrfs_commit_current_transaction from
  ded980eb3fadd7 (Filipe Manana, 2024-05-22)
- [Phase 3] Verified ded980eb3fadd7 is in v6.11+ but NOT in v6.10 or
  earlier
- [Phase 3] Verified 28270e25c69a2 (always reserve for delayed refs) is
  in v6.7+
- [Phase 3] git show 64d2c847ba380: confirmed related zoned overcommit
  fix was CC'd to stable 6.9+
- [Phase 4] b4 dig failed to find commit (too recent); lore.kernel.org
  blocked by anti-bot
- [Phase 4] UNVERIFIED: Could not access mailing list discussion for
  stable nominations
- [Phase 5] Verified btrfs_delayed_refs_rsv_refill callers:
  start_transaction (transaction.c), btrfs_truncate_inode_items (inode-
  item.c)
- [Phase 5] Verified btrfs_start_transaction(root, 0) has 24+ call sites
  across btrfs
- [Phase 6] Verified btrfs_commit_current_transaction exists in current
  tree (line 2040 of transaction.c) but not in v6.6
- [Phase 6] Verified bytes_zone_unusable field exists in space-info.h
  (all relevant stable trees)
- [Phase 6] Verified btrfs_reserve_metadata_bytes API changed by
  a1359d06d7878 (signature differs in older trees)
- [Phase 8] Failure mode: premature ENOSPC preventing writes on zoned
  devices - severity HIGH for affected users

**YES**

 fs/btrfs/delayed-ref.c | 28 ++++++++++++++++++++++++++++
 fs/btrfs/transaction.c |  8 ++++++++
 2 files changed, 36 insertions(+)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 3766ff29fbbb1..605858c2d9a95 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -207,6 +207,30 @@ void btrfs_dec_delayed_refs_rsv_bg_updates(struct btrfs_fs_info *fs_info)
  * This will refill the delayed block_rsv up to 1 items size worth of space and
  * will return -ENOSPC if we can't make the reservation.
  */
+static int btrfs_zoned_cap_metadata_reservation(struct btrfs_space_info *space_info)
+{
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
+	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
+	u64 usable;
+	u64 cap;
+	int ret = 0;
+
+	if (!btrfs_is_zoned(fs_info))
+		return 0;
+
+	spin_lock(&space_info->lock);
+	usable = space_info->total_bytes - space_info->bytes_zone_unusable;
+	spin_unlock(&space_info->lock);
+	cap = usable >> 1;
+
+	spin_lock(&block_rsv->lock);
+	if (block_rsv->size > cap)
+		ret = -EAGAIN;
+	spin_unlock(&block_rsv->lock);
+
+	return ret;
+}
+
 int btrfs_delayed_refs_rsv_refill(struct btrfs_fs_info *fs_info,
 				  enum btrfs_reserve_flush_enum flush)
 {
@@ -228,6 +252,10 @@ int btrfs_delayed_refs_rsv_refill(struct btrfs_fs_info *fs_info,
 	if (!num_bytes)
 		return 0;
 
+	ret = btrfs_zoned_cap_metadata_reservation(space_info);
+	if (ret)
+		return ret;
+
 	ret = btrfs_reserve_metadata_bytes(space_info, num_bytes, flush);
 	if (ret)
 		return ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8dd77c431974d..86c5ebdf56998 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -678,6 +678,14 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		 * here.
 		 */
 		ret = btrfs_delayed_refs_rsv_refill(fs_info, flush);
+		if (ret == -EAGAIN) {
+			ASSERT(btrfs_is_zoned(fs_info));
+			ret = btrfs_commit_current_transaction(root);
+			if (ret)
+				goto reserve_fail;
+			ret = btrfs_delayed_refs_rsv_refill(fs_info, flush);
+		}
+
 		if (ret)
 			goto reserve_fail;
 	}
-- 
2.53.0

