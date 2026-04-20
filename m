Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189583A6EE1;
	Mon, 20 Apr 2026 13:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691066; cv=none; b=Pf5tGQBnR89ZVDoP/2+fCyHYaKN4Y4PmoXDUACCOmElOCwbGKoZi8SfHxK1r7k1IUNiJn/v3khEDysFcnvuinVCtD72LMtGt27rJu0DC1Zlu7S5CCNMxv+S3tIwvWDNxzxExZowPLSs+ylX6ob4rGOdQN8Fq+5yU8dS8icdwGfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691066; c=relaxed/simple;
	bh=ArOCUE3+Y8VR7T0cVnTsPyfhBwK+5Y4/JLiBPjzYrH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NT50fMYggFLiXTe22UUdGy6PQ133ngdy3Q6OseQE63PDRfwh/FibAUAPBY3lhUhlozIzbcVBs7OXg9eMShatDEWazTCjfUuk5gNbWKV6V4Qtppi9BqaePrXRNacQVe6AJ7BXvzDerLeI6Twu/pXbmd2H3+qrwcwzSLIEOL80Vfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/YRZadA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/YRZadA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDF9C2BCB8;
	Mon, 20 Apr 2026 13:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691065;
	bh=ArOCUE3+Y8VR7T0cVnTsPyfhBwK+5Y4/JLiBPjzYrH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/YRZadAv2oMtMByyma8TDR1+1b9JoovTv6icImy+7VqZzKIowwISzcbTMOzSuijM
	 grJ9wpFVWuOG5H6K1hyAaAGwfMAB0mh2Z6eCEHig/cg0aBElhd+gOITV1+yu4yvGdy
	 3zogp6q3B3THGWV/P7c6O5xbJfDibhDbJn8LJoch2FbcwbNY9L2BcqrXFY/HVyHpp/
	 8NswYCCiXZiNCADoibpegwp16xLtOrn2slTg+r4JEGFO3hPLX4koFSNI4g4eeFU7HY
	 hGzdQlgTFUhYPxN8n6xom4d9AaRelUgQo57oZav0+OT5WqnE0vO5poSLhhyJew5myl
	 i6bf6rkYFzppA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Chen <davechen@synology.com>,
	Filipe Manana <fdmanana@suse.com>,
	Robbie Ko <robbieko@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	josef@toxicpanda.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] btrfs: use BTRFS_FS_UPDATE_UUID_TREE_GEN flag for UUID tree rescan check
Date: Mon, 20 Apr 2026 09:08:59 -0400
Message-ID: <20260420131539.986432-73-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Dave Chen <davechen@synology.com>

[ Upstream commit e70e3f858e084aee34a2206e5f4dd49a47673f6a ]

The UUID tree rescan check in open_ctree() compares
fs_info->generation with the superblock's uuid_tree_generation.
This comparison is not reliable because fs_info->generation is
bumped at transaction start time in join_transaction(), while
uuid_tree_generation is only updated at commit time via
update_super_roots().

Between the early BTRFS_FS_UPDATE_UUID_TREE_GEN flag check and the
late rescan decision, mount operations such as file orphan cleanup
from an unclean shutdown start transactions without committing
them. This advances fs_info->generation past uuid_tree_generation
and produces a false-positive mismatch.

Use the BTRFS_FS_UPDATE_UUID_TREE_GEN flag directly instead. The
flag was already set earlier in open_ctree() when the generations
were known to match, and accurately represents "UUID tree is up to
date" without being affected by subsequent transaction starts.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile the final analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [btrfs] [use] [Replace unreliable generation comparison with
reliable flag for UUID tree rescan check]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reviewed-by:** Filipe Manana <fdmanana@suse.com> — Filipe is a
  prolific btrfs maintainer/developer (verified: 5+ recent commits in
  btrfs)
- **Signed-off-by:** Dave Chen <davechen@synology.com> — Author
- **Signed-off-by:** Robbie Ko <robbieko@synology.com> — Co-
  author/submitter from Synology
- **Signed-off-by:** Filipe Manana <fdmanana@suse.com> — Committer path
- **Signed-off-by:** David Sterba <dsterba@suse.com> — Btrfs tree
  maintainer

No Fixes: tag, no Reported-by, no Link, no Cc: stable. Absence is
expected.

Record: Patch was reviewed by Filipe Manana (btrfs expert) and committed
through Filipe and David Sterba (btrfs maintainer). Strong review chain.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit explains:
- **Bug mechanism:** `fs_info->generation` is bumped at transaction
  start time in `join_transaction()`, while `uuid_tree_generation` is
  only updated at commit time in `update_super_roots()`.
- **What goes wrong:** Between the early `BTRFS_FS_UPDATE_UUID_TREE_GEN`
  flag check and the late UUID rescan decision, mount operations (orphan
  cleanup from unclean shutdown) start transactions without committing
  them. This advances `fs_info->generation` past `uuid_tree_generation`,
  producing a **false-positive mismatch**.
- **Result:** Unnecessary UUID tree rescan on mount after unclean
  shutdown.
- **Fix:** Use the `BTRFS_FS_UPDATE_UUID_TREE_GEN` flag directly instead
  of re-comparing generations.

Record: Real bug — false-positive UUID tree rescan triggered on mount
after unclean shutdown. Root cause is generation counter advancing from
uncommitted transactions between the flag-set point and the check point.

### Step 1.4: DETECT HIDDEN BUG FIXES
This IS a real bug fix, though the commit message doesn't use the word
"fix" directly. The language "not reliable," "false-positive mismatch,"
and the explanation of the broken mechanism clearly describe a bug being
corrected.

Record: Yes, this is a real bug fix for an incorrect condition that
triggers unnecessary rescans.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- **File:** `fs/btrfs/disk-io.c` — 1 line changed (1 removed, 1 added)
- **Function:** `open_ctree()` — the main btrfs mount function
- **Scope:** Single-file, single-line, surgical fix

Record: 1 file, 1 line change, in `open_ctree()`. Minimal scope.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Before (line 3677):**
```c
fs_info->generation != btrfs_super_uuid_tree_generation(disk_super)
```
Compares current in-memory generation counter vs. on-disk
uuid_tree_generation.

**After:**
```c
!test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags)
```
Tests the flag that was set earlier at line 3537 when generations were
known to match.

Record: Normal mount path affected. Changes the condition from an
unreliable runtime comparison to a stable flag check.

### Step 2.3: IDENTIFY THE BUG MECHANISM
This is a **logic/correctness bug**. The comparison `fs_info->generation
!= uuid_tree_generation` was correct at the time it was originally
written, but commit 44c0ca211a4da (Boris Burkov, 2020) refactored the
code to move orphan cleanup and other rw mount operations *before* this
check via `btrfs_start_pre_rw_mount()`. Those operations start
transactions (confirmed: `btrfs_orphan_cleanup()` calls
`btrfs_start_transaction()` at line 3870 of `inode.c`), which bumps
`fs_info->generation` (confirmed: `join_transaction()` at line 392 of
`transaction.c`). The on-disk `uuid_tree_generation` doesn't change
until `update_super_roots()` at commit time (confirmed: line 1985-1986
of `transaction.c`).

Record: Logic bug category. Condition became incorrect after code was
reordered by refactoring commit 44c0ca211a4da.

### Step 2.4: ASSESS THE FIX QUALITY
- Obviously correct: The flag `BTRFS_FS_UPDATE_UUID_TREE_GEN` is already
  set at line 3537 exactly when the generations match, and is unaffected
  by transaction starts
- Minimal/surgical: 1 line change
- No regression risk: The flag is already the authoritative indicator
  (used by `update_super_roots()` at commit time)
- Reviewed by Filipe Manana

Record: Fix quality is excellent. Obviously correct, minimal, no
regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The buggy line (3677) was introduced by commit 44c0ca211a4da9 (Boris
Burkov, 2020-11-18) — "btrfs: lift read-write mount setup from mount and
remount". This refactoring moved rw mount setup into
`btrfs_start_pre_rw_mount()` but left the generation comparison in
`open_ctree()` after the call, creating the false-positive window.

Record: Buggy code introduced by 44c0ca211a4da (v5.11). Present in all
active stable trees from 5.15+.

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag, but the bug was introduced by 44c0ca211a4da. The earlier
fix attempt (75ec1db8717a8 by Josef Bacik, 2020) set the flag *before*
the problematic code paths, specifically to prevent this exact class of
bug. But the 44c0ca211a4da refactoring reintroduced the problem by
moving more transaction-starting code between the flag set and the
rescan check, without updating the check to use the flag.

Record: 44c0ca211a4da introduced the bug. It's in v5.11+ (all active
stable trees).

### Step 3.3: CHECK FILE HISTORY
Recent file history shows active maintenance with various fixes. No
dependency concerns.

Record: Standalone fix, no prerequisites needed.

### Step 3.4: AUTHOR
Dave Chen from Synology is a btrfs contributor. Robbie Ko from Synology
is also a known btrfs contributor with multiple commits. Filipe Manana
reviewed.

Record: Authors are active btrfs contributors, reviewer is btrfs expert.

### Step 3.5: DEPENDENCIES
The fix depends on `BTRFS_FS_UPDATE_UUID_TREE_GEN` flag existing and
being set early in `open_ctree()`. This was added by 75ec1db8717a8
(Josef Bacik, 2020, v5.6, CC stable 4.19+). Verified: The flag and the
early set_bit at line 3537 exist in current code.

Record: No additional dependencies. The flag infrastructure exists since
v5.6.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
b4 dig could not find the specific patch submission (the commit may be
very recent or submitted through a different path). Web searches also
couldn't reach lore due to anti-bot protection. The commit message and
review chain (Reviewed-by: Filipe Manana, SOBs from Filipe Manana and
David Sterba) confirm it went through proper btrfs review.

Record: Could not access mailing list discussion directly. Review chain
confirms proper vetting.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
Modified function: `open_ctree()` — the main btrfs filesystem mount
function.

### Step 5.2: CALLERS
`open_ctree()` is called during every btrfs mount. This is a universally
exercised path.

### Step 5.3-5.4: TRIGGER PATH
The false-positive triggers when:
1. Filesystem had an unclean shutdown (so orphan items exist)
2. Mount starts a transaction during orphan cleanup → bumps generation
3. UUID rescan check falsely detects a mismatch → triggers unnecessary
   rescan

This is extremely common — every btrfs mount after crash/power failure.

Record: Bug path is very commonly triggered (any mount after unclean
shutdown).

### Step 5.5: SIMILAR PATTERNS
Josef Bacik's commit 75ec1db8717a8 fixed the exact same class of bug
earlier (log replay bumping generation), showing this is a recurring
pattern.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: BUGGY CODE IN STABLE
The bug was introduced in 44c0ca211a4da (v5.11). It exists in stable
trees: 5.15.y, 6.1.y, 6.6.y, 6.12.y, and now 7.0.

### Step 6.2: BACKPORT COMPLICATIONS
The fix is a single-line change. The surrounding code context may differ
slightly between stable trees, but the essential structure (uuid_root
check with generation comparison) should be present in all affected
trees.

Record: Clean apply expected in most trees; minor conflicts possible in
very old trees due to surrounding code changes.

### Step 6.3: RELATED FIXES
No other fix for this specific issue found in history.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
btrfs (fs/btrfs/) — IMPORTANT. Major Linux filesystem used in many
distributions (SUSE, openSUSE, Fedora) and NAS products (Synology, which
is where this fix comes from).

### Step 7.2: ACTIVITY
Very actively developed and maintained. Multiple fixes merged during 7.0
cycle.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
All btrfs users who experience unclean shutdowns (crash, power failure,
hard reset).

### Step 8.2: TRIGGER CONDITIONS
- Trigger: Mount after unclean shutdown when orphan items exist → very
  common
- No special privileges needed, just mounting the filesystem
- Deterministic (not timing-dependent)

### Step 8.3: FAILURE MODE SEVERITY
- **Not a crash or data corruption** — the UUID tree rescan is
  unnecessary but harmless
- **Performance impact:** The rescan walks the entire UUID tree,
  verifying every entry. On a filesystem with many subvolumes/snapshots,
  this can be expensive and slow down mount time significantly
- **User-visible symptom:** "checking UUID tree" message in dmesg on
  every mount after unclean shutdown, plus slower mount

Record: Severity: MEDIUM. Unnecessary expensive operation during mount.
No data risk.

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** Eliminates unnecessary UUID tree rescans on mount after
  unclean shutdown. Improves mount time for btrfs users (especially
  those with many subvolumes)
- **Risk:** Extremely low — 1-line change, obviously correct, uses a
  flag that was designed for exactly this purpose
- **Ratio:** Very favorable

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE

**FOR backporting:**
- Fixes a real bug: unnecessary UUID tree rescan triggered by false-
  positive generation mismatch
- Extremely small and surgical: 1 line change
- Obviously correct: uses the flag designed for this exact purpose
- Reviewed by Filipe Manana (btrfs expert)
- Bug affects all btrfs users who experience unclean shutdowns
- Bug exists since v5.11 (all active stable trees)
- No regression risk
- The flag infrastructure is already present in all stable trees

**AGAINST backporting:**
- Not a crash, security issue, or data corruption
- The unnecessary rescan is a performance issue, not a correctness issue
  (the rescan itself is harmless)
- No Fixes: or Cc: stable tags from the author (expected — that's why
  we're reviewing)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — trivial 1-line change
   reviewed by btrfs expert
2. Fixes a real bug that affects users? **YES** — unnecessary expensive
   operation on mount after crash
3. Important issue? **MEDIUM** — performance issue on common path, not
   crash/corruption
4. Small and contained? **YES** — 1 line, 1 file
5. No new features or APIs? **YES** — no new features
6. Can apply to stable trees? **YES** — simple change to code present
   since v5.11

### Step 9.3: EXCEPTION CATEGORIES
Not an exception category, but a straightforward bug fix.

### Step 9.4: DECISION
This is a clean, minimal, obviously correct fix for a real bug that
causes unnecessary expensive UUID tree rescans during btrfs mount after
unclean shutdown. It was reviewed by btrfs expert Filipe Manana and
committed through the proper btrfs maintainer chain. While not a crash
or security issue, it fixes a genuine problem that affects all btrfs
users who experience power failures or crashes, and the risk of
regression from this 1-line change is essentially zero. This meets
stable kernel criteria.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Filipe Manana, SOBs from Dave Chen,
  Robbie Ko, Filipe Manana, David Sterba
- [Phase 2] Diff analysis: 1 line changed in `open_ctree()` at line 3677
  of disk-io.c — replaces `fs_info->generation !=
  btrfs_super_uuid_tree_generation(disk_super)` with
  `!test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags)`
- [Phase 3] git blame: buggy line introduced by commit 44c0ca211a4da
  (Boris Burkov, v5.11, 2020-11-18)
- [Phase 3] git show 75ec1db8717a8: confirmed this is the original fix
  that added the flag and early set_bit, with CC: stable 4.19+
- [Phase 3] Verified `join_transaction()` bumps generation at
  transaction.c:392
- [Phase 3] Verified `btrfs_orphan_cleanup()` starts transactions at
  inode.c:3870
- [Phase 3] Verified `update_super_roots()` uses the flag to write
  uuid_tree_generation at transaction.c:1985-1986
- [Phase 3] Verified the flag is set early at disk-io.c:3535-3537
- [Phase 3] Verified `btrfs_start_pre_rw_mount()` calls orphan cleanup
  at disk-io.c:3119, before the UUID rescan check at line 3677
- [Phase 3] git merge-base: 44c0ca211a4da is in v5.11 but not v5.10; bug
  exists in stable trees 5.15+
- [Phase 4] b4 dig: could not find original submission thread
- [Phase 4] UNVERIFIED: Could not access lore.kernel.org discussion due
  to anti-bot protection
- [Phase 5] `open_ctree()` called on every btrfs mount — universal code
  path
- [Phase 5] Trigger: mount after unclean shutdown → orphan cleanup →
  transaction → generation bump → false positive
- [Phase 7] btrfs is an important filesystem used by major distributions
  and NAS vendors
- [Phase 8] Failure mode: unnecessary UUID tree rescan (walks entire
  tree), severity MEDIUM (performance, not crash)

**YES**

 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1b0eb246b7147..70357b12508d0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3674,7 +3674,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	if (fs_info->uuid_root &&
 	    (btrfs_test_opt(fs_info, RESCAN_UUID_TREE) ||
-	     fs_info->generation != btrfs_super_uuid_tree_generation(disk_super))) {
+	     !test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))) {
 		btrfs_info(fs_info, "checking UUID tree");
 		ret = btrfs_check_uuid_tree(fs_info);
 		if (ret) {
-- 
2.53.0

