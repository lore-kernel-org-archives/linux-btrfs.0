Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330773F65E9;
	Tue, 24 Mar 2026 11:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351195; cv=none; b=EYDA1sqLHyrd77ukVcyHCnsydogZpVyBJWRZ3ngqgSE41oipR7Nvx4Igsqz13W4cmT5EMC4SqxSO3ZNPX25qxWE1nWxFxSa4ndqZFFvEFdhLrCL9AXRCY43d8aQrohq5XEVX3QKnWBKvONt9cY8RG6jf7vP7SHl8kHAExlnGrf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351195; c=relaxed/simple;
	bh=JI+jykHAeIctJCOavzDSDwHWy/c+aQ6tobfaMAnbCRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0DduqcIkyAkX1FTEq6LiOSbuBV0ds6vIcOvBp1z8UQDKcnOAIMSyrRCUch/nSV3QwOfKpTR40Aw1PvstAGHHGQ7d3t0hCAIO2z9kS5ZhycjRuk9e2PbewZlkO8f4VBjO6og7+vIW955B5ExNuy/z74uw14wYDFPtNGKkVeYUQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m15M0Y5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m15M0Y5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C8BC2BCB3;
	Tue, 24 Mar 2026 11:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351194;
	bh=JI+jykHAeIctJCOavzDSDwHWy/c+aQ6tobfaMAnbCRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m15M0Y5ma7uXWGCfTVwfSoI570Sm7xMCpwXvzxo61R44UNe03vPDTkyZwON6I2fZC
	 8S6ImnJrTLaAgppdUaAJVRIlTd6cQGGtltDKeeB98+xsUfYzgQeJcbdJKUTfMJe3f4
	 N892PtZ+jW1EYteTjo50DLaR9LOxvdjRaCJoQRXp3Unyd8ZELUpWul5G2wrb7GXSO+
	 WdXZc7KzWx26mSQQKjCGM7kiFKi6YWrp7iv13+N4GmRqULP+04hHZzXx/fhBifYZBv
	 1QHvfAqnHdxYVeoYOlUqNmHoJYaaKedpF+O+gOEmc59zdBGzuDZlO6gfwo+4DCVX7F
	 vIxevAL6vg69A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhengYuan Huang <gality369@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] btrfs: reject root items with drop_progress and zero drop_level
Date: Tue, 24 Mar 2026 07:19:25 -0400
Message-ID: <20260324111931.3257972-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit b17b79ff896305fd74980a5f72afec370ee88ca4 ]

[BUG]
When recovering relocation at mount time, merge_reloc_root() and
btrfs_drop_snapshot() both use BUG_ON(level == 0) to guard against
an impossible state: a non-zero drop_progress combined with a zero
drop_level in a root_item, which can be triggered:

------------[ cut here ]------------
kernel BUG at fs/btrfs/relocation.c:1545!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 283 ... Tainted: 6.18.0+ #16 PREEMPT(voluntary)
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
RIP: 0010:merge_reloc_root+0x1266/0x1650 fs/btrfs/relocation.c:1545
Code: ffff0000 00004589 d7e9acfa ffffe8a1 79bafebe 02000000
Call Trace:
 merge_reloc_roots+0x295/0x890 fs/btrfs/relocation.c:1861
 btrfs_recover_relocation+0xd6e/0x11d0 fs/btrfs/relocation.c:4195
 btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
 open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
 btrfs_fill_super fs/btrfs/super.c:987 [inline]
 btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
 btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
 btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 ...
RIP: 0033:0x7f969c9a8fde
Code: 0f1f4000 48c7c2b0 fffffff7 d8648902 b8ffffff ffc3660f
---[ end trace 0000000000000000 ]---

The bug is reproducible on 7.0.0-rc2-next-20260310 with our dynamic
metadata fuzzing tool that corrupts btrfs metadata at runtime.

[CAUSE]
A non-zero drop_progress.objectid means an interrupted
btrfs_drop_snapshot() left a resume point on disk, and in that case
drop_level must be greater than 0 because the checkpoint is only
saved at internal node levels.

Although this invariant is enforced when the kernel writes the root
item, it is not validated when the root item is read back from disk.
That allows on-disk corruption to provide an invalid state with
drop_progress.objectid != 0 and drop_level == 0.

When relocation recovery later processes such a root item,
merge_reloc_root() reads drop_level and hits BUG_ON(level == 0). The
same invalid metadata can also trigger the corresponding BUG_ON() in
btrfs_drop_snapshot().

[FIX]
Fix this by validating the root_item invariant in tree-checker when
reading root items from disk: if drop_progress.objectid is non-zero,
drop_level must also be non-zero. Reject such malformed metadata with
-EUCLEAN before it reaches merge_reloc_root() or btrfs_drop_snapshot()
and triggers the BUG_ON.

After the fix, the same corruption is correctly rejected by tree-checker
and the BUG_ON is no longer triggered.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Record: The `btrfs_root_drop_level()` accessor was added in
c842268458d90 (v5.10). Before that, code accessed
`root_item->drop_level` directly. The `btrfs_disk_key_objectid()`
accessor has existed much longer. In stable trees v5.4 and older, the
patch would need minor adjustment to use `ri.drop_progress.objectid` and
`ri.drop_level` directly instead of accessor macros. For v5.10+ the
patch should apply cleanly or with minimal fuzz.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
The new check uses:
- `btrfs_disk_key_objectid(&ri.drop_progress)` — long-standing accessor
- `btrfs_root_drop_level(&ri)` — added in v5.10 (c842268458d90)

For stable trees ≥ 5.10, the patch should apply cleanly. For 5.4.y, a
trivial modification would be needed.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- **Subsystem:** btrfs (filesystem)
- **Criticality:** IMPORTANT — btrfs is a widely-used filesystem.
  Corruption handling is critical for data integrity.
- **Component:** tree-checker (metadata validation layer) — the
  defensive layer against on-disk corruption

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Active subsystem with regular commits. The tree-checker is actively
maintained by Qu Wenruo and David Sterba.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
All btrfs users who encounter on-disk corruption (which can happen from
hardware failures, power loss, firmware bugs, etc.). This is filesystem-
specific but btrfs has a large user base.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Trigger:** Mounting a btrfs filesystem with specific metadata
  corruption (non-zero drop_progress.objectid + zero drop_level in a
  root item)
- **How common:** Not frequent in normal operation, but can happen with
  disk corruption, power loss during snapshot deletion, or intentional
  fuzzing
- **Security relevance:** An unprivileged user might be able to mount a
  crafted filesystem image (e.g., USB drive) to trigger the BUG_ON and
  crash the kernel

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- **Failure mode:** Kernel BUG (invalid opcode trap) → full kernel
  crash/oops
- **Severity:** CRITICAL — system crash on mount with corrupted
  metadata. No graceful error handling.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **BENEFIT:** Very high — prevents kernel crash (BUG_ON) from corrupted
  filesystem metadata. Converts crash into clean -EUCLEAN rejection.
- **RISK:** Very low — adds 17 lines of pure validation in an existing
  validation function. Only rejects metadata that was guaranteed to
  crash the kernel. Zero chance of regression for valid filesystems.
- **Ratio:** Excellent. Very high benefit, very low risk.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
1. Prevents kernel BUG_ON crash (system crash) — CRITICAL severity
2. Small, surgical fix (17 lines added to existing validation function)
3. Follows established tree-checker validation patterns
4. Reviewed by senior btrfs developer Qu Wenruo
5. Merged by btrfs maintainer David Sterba
6. Author explicitly tagged `Cc: stable@vger.kernel.org # 5.3+`
7. Bug exists since v5.4 (when check_root_item was introduced) — affects
   ALL active stable trees
8. No dependencies on other commits
9. Reproducible with fuzzing tool, stack trace provided
10. Potential security implication (crafted filesystem image → kernel
    crash)
11. Related fix (4289b494ac553) was already Cc'd to stable

**Evidence AGAINST backporting:**
- None identified.

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — invariant is well-documented
   (drop_level must be >0 when drop_progress is set), enforced on write
   path, now validated on read path. Tested by reproducer.
2. **Fixes a real bug?** YES — BUG_ON kernel crash on corrupted
   metadata.
3. **Important issue?** YES — CRITICAL (kernel crash at mount time).
4. **Small and contained?** YES — 17 lines, single file, single
   function.
5. **No new features or APIs?** Correct — pure validation addition.
6. **Can apply to stable trees?** YES — clean for 5.10+, trivial
   adjustment for 5.4.

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category — this is a standard, high-quality bug fix.

### Step 9.4: MAKE YOUR DECISION
This is a textbook stable backport candidate. It prevents a kernel
BUG_ON crash from corrupted metadata with a minimal, obviously-correct
validation check in the tree-checker, following established patterns.
The author, reviewer, and maintainer all participated, and the author
explicitly nominated it for stable.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Qu Wenruo, SOBs from author and
  maintainer David Sterba. No syzbot, found via metadata fuzzing tool.
- [Phase 2] Diff analysis: +17 lines in `check_root_item()` in tree-
  checker.c, adds validation for drop_progress vs drop_level invariant,
  returns -EUCLEAN on invalid combination.
- [Phase 3] git blame: `check_root_item()` introduced in commit
  259ee7754b6793 (v5.4, 2019-07-16). Bug (missing validation) present
  since inception.
- [Phase 3] Confirmed 3 BUG_ON(level == 0) crash sites:
  relocation.c:1538, relocation.c:1621, extent-tree.c:6118.
- [Phase 3] No Fixes: tag to follow (expected).
- [Phase 3] Author has no other commits in tree (first-time
  contributor), but patch reviewed by subsystem expert.
- [Phase 3] `btrfs_root_drop_level()` accessor exists since v5.10
  (c842268458d90). Patch applies cleanly to 5.10+ stable trees.
- [Phase 4] lore.kernel.org: Found patch v2 discussion. Patch includes
  `Cc: stable@vger.kernel.org # 5.3+`. No NAKs found.
- [Phase 4] Related fix 4289b494ac553 ("btrfs: do not allow relocation
  of partially dropped subvolumes") also Cc'd to stable 5.15+.
- [Phase 5] Call chain: `btrfs_check_leaf()` → `__btrfs_check_leaf()` →
  `check_leaf_items()` → `check_root_item()`. Called during all metadata
  reads from disk.
- [Phase 6] Buggy code exists in all active stable trees (v5.4+). Patch
  standalone, no dependencies.
- [Phase 7] btrfs filesystem — IMPORTANT subsystem, actively maintained.
- [Phase 8] Failure mode: BUG_ON kernel crash at mount time. Severity
  CRITICAL. Fix risk: very low (pure validation addition).
- UNVERIFIED: Exact applicability to v5.4.y (may need trivial accessor
  adjustment) — does not affect decision.

**YES**

 fs/btrfs/tree-checker.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 12d6ae49bc078..902a5874bda81 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1260,6 +1260,23 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
 	}
+	/*
+	 * If drop_progress.objectid is non-zero, a btrfs_drop_snapshot() was
+	 * interrupted and the resume point was recorded in drop_progress and
+	 * drop_level.  In that case drop_level must be >= 1: level 0 is the
+	 * leaf level and drop_snapshot never saves a checkpoint there (it
+	 * only records checkpoints at internal node levels in DROP_REFERENCE
+	 * stage).  A zero drop_level combined with a non-zero drop_progress
+	 * objectid indicates on-disk corruption and would cause a BUG_ON in
+	 * merge_reloc_root() and btrfs_drop_snapshot() at mount time.
+	 */
+	if (unlikely(btrfs_disk_key_objectid(&ri.drop_progress) != 0 &&
+		     btrfs_root_drop_level(&ri) == 0)) {
+		generic_err(leaf, slot,
+			    "invalid root drop_level 0 with non-zero drop_progress objectid %llu",
+			    btrfs_disk_key_objectid(&ri.drop_progress));
+		return -EUCLEAN;
+	}
 
 	/* Flags check */
 	if (unlikely(btrfs_root_flags(&ri) & ~valid_root_flags)) {
-- 
2.51.0

