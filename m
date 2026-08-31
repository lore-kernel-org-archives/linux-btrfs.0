Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FCD5AB238;
	Mon, 31 Aug 2026 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184364; cv=none; b=RE4bHD62OeXSlk1XmlIO0Ec8FtrgsausyEZWsFcXLyIBtuFbGkYaelwGatadMZsHnlVkhToKpome0MfC9+iwvlaO/0mOyGbsRpS3yc/cQD2StWW20g6ESTMdPjplzolqvhXs5OupoHdP4BYbZ5mdFqx01IPdwm+ZEHBP0DKn418=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184364; c=relaxed/simple;
	bh=aUMBBnwF6XMzoE9QYbZBPO7MZL3jdNKcSCyd740XR2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=REcyp/EvKW+bamQF359KYhQPzn4S0ODlhdXRdNn/9fpyLJ3H+BULFMv0p8H3HL0OBEX8D6KA11e7OUY8mr0YE6n3eiPoYn+oc+b5yXo0BJ68d/IRrjhegQXUnfszBAWXr+6Ppg1CTofHaYBB/IoOhXMPrOlqKduow7QnsXZXYBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxWrOaUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxWrOaUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F521F000E9;
	Mon, 31 Aug 2026 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184361;
	bh=QPeZ0wi9nlfmmqDf/06OscKfZ8nxNAF1gvkAK7UQUQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxWrOaUAvznMDpVzLbzucTVf7RWOMP0TjFYC3o3FxCq/AUa8xahQZiEKWM1qcTitK
	 Y59N4lrPkfUnlWk1X4q1PLN4ClHhZhQQfZLsMzM+/4ZMu4L80hAiVjD492gddPgDU7
	 fNxsL2SuY4zKZjT3k/vlzCqlRwl6ErLAG0O+/nld3uRmVbvxIId3TJWxAhbvYPheEa
	 od1S+Y7dmMFl6M/MEtfyXFclyfOaldl4jCPWLOtl+M/STxpJWlS81L5YWG2qjRs2IA
	 f/xnGPZWUjL9VBUz5YA4TGRMv1turs5qWREkWLZOkoWXlZoHvApQ2T2HODJ3KHAR18
	 iJ9KNZutFRA7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] btrfs: zoned: always set data_relocation_bg
Date: Mon, 31 Aug 2026 09:31:16 -0400
Message-ID: <20260831133314.4125787-648-sashal@kernel.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 82fd26090ebdbe6fa4b6039d059a7ea0a974cc36 ]

When searching for a data relocation block-group on mount,
btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
block-group. But it first checks if the block-group is empty and if yes
continues the search, and then checks if it is the first DATA block-group.

There is actually no point in looking for the second empty DATA block
group as new DATA allocations will just allocate a new chunk for it. Pick
the first DATA block-group without any allocations done and set it as
relocation block-group.

At first, the commit 694ce5e143d6 ("btrfs: zoned: reserve data_reloc
block group on mount") introduced the functionality. At that time, we
took second unused (used == 0) block group, as the first one might be a
block group used for normal data.  Later, commit daa0fde32235 ("btrfs:
zoned: fix data relocation block group reservation") switched to look
for an empty block group (alloc_offset == 0). At this point, there is no
reason taking the second one anymore. So, this commit is fixing an issue
in commit daa0fde32235.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `btrfs: zoned: always set
data_relocation_bg`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
`make kernelversion` → `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 – Subject line**
Record: `[btrfs: zoned]` `[always set]` — ensures `data_relocation_bg`
is set on mount by picking the first empty DATA block group instead of
skipping it.

**Step 1.2 – Tags**
Record:
- `Reviewed-by: Boris Burkov <boris@bur.io>`
- `Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>`
- `Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>`
- `Signed-off-by: David Sterba <dsterba@suse.com>`
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, or `Tested-by:`
  tags
- Notable: two btrfs zoned subsystem reviewers signed off

**Step 1.3 – Body analysis**
Record:
- **Bug:** After `daa0fde32235` switched selection to `alloc_offset ==
  0`, the code still skipped the first empty DATA block group (leftover
  from when `used == 0` was the criterion).
- **Symptom:** When only one empty DATA block group exists and the
  device cannot allocate a new chunk (zone-limited), `data_reloc_bg` is
  never set on mount.
- **Root cause:** Obsolete “take the second empty block group” logic
  from `694ce5e143d6` was not removed when the selection criterion
  changed in `daa0fde32235`.
- **Version context:** Fix targets a regression in `daa0fde32235`;
  original feature in `694ce5e143d6`.

**Step 1.4 – Hidden bug fix?**
Record: **Yes.** Despite the neutral subject, this is a logic-correction
bug fix. Mailing-list discussion (Boris Burkov) documents a real remount
scenario where no relocation block group gets reserved.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 – Inventory**
Record:
- **Files:** `fs/btrfs/zoned.c` only (+1 / −10 lines)
- **Function:** `btrfs_zoned_reserve_data_reloc_bg()`
- **Scope:** Single-file surgical fix

**Step 2.2 – Code flow change**
Record per hunk:
- **Before:** Loop skips every block group with `alloc_offset != 0`,
  then skips the first empty one (`first` flag), uses the second empty
  block group for relocation.
- **After:** Loop skips only non-empty block groups (`alloc_offset !=
  0`), immediately uses the first empty block group.
- **Also removed:** `bool first`, comment about “second one”,
  `ASSERT(!list_empty(...))` (invalid when only one empty BG exists),
  and `first = false` after chunk allocation.

**Step 2.3 – Bug mechanism**
Record: **Logic / correctness fix** in mount-time block-group
reservation. Stale algorithm from an earlier criterion (`used == 0` →
skip first) persisted after criterion changed to `alloc_offset == 0`,
causing failure to reserve relocation space on zone-constrained
filesystems with a single empty DATA block group.

**Step 2.4 – Fix quality**
Record: Fix is minimal and obviously correct — removes dead logic and an
assertion that assumed a second empty block group always exists. Low
regression risk; only changes which empty block group is chosen on
mount.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 – Blame**
Record: Buggy “skip first empty” logic introduced in `daa0fde32235`
(Naohiro Aota, 2025-07-16). Loop structure from `694ce5e143d6` (Johannes
Thumshirn, 2025-06-03). Both are in v6.18 and in this tree.

**Step 3.2 – Fixes: tag**
Record: N/A — no `Fixes:` tag. Author explicitly states this corrects
`daa0fde32235`, which is present in this tree.

**Step 3.3 – Related file history**
Record: Recent `fs/btrfs/zoned.c` changes in this tree include deadlock
fixes and zone pointer fixes; no duplicate fix for this issue found.

**Step 3.4 – Author context**
Record: Johannes Thumshirn is a btrfs zoned contributor; authored
`694ce5e143d6` (original mount-time reservation feature, with `Cc:
stable@vger.kernel.org # 6.6+`).

**Step 3.5 – Dependencies**
Record: **Standalone.** Patch is 3/5 in a series (“fix deadlock and
space reporting issues for zoned filesystems”), but only touches
`btrfs_zoned_reserve_data_reloc_bg()` and does not depend on patches
1/2/4/5. `git apply --check` confirms clean apply to 6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 – Original discussion**
Record:
- `b4 dig -c 82fd26090ebd` → https://patch.msgid.link/20260522090247.274
  45-4-johannes.thumshirn@wdc.com (v3 submission)
- Series revisions: v1 (2026-05-13), v2 (2026-05-19), v3 (2026-05-22);
  committed version matches v3 (removes `first` entirely, not v2’s
  reorder-only approach)
- Boris Burkov review identified the concrete failure: after GC-heavy
  workload and remount, all non-empty BGs skipped, first empty BG also
  skipped, drive out of free zones → no relocation BG set

**Step 4.2 – Reviewers**
Record: `b4 dig -w` shows CC to `linux-btrfs@vger.kernel.org`, David
Sterba, Filipe Manana, Naohiro Aota, Boris Burkov, Christoph Hellwig,
Damien Le Moal.

**Step 4.3 – Bug report**
Record: No formal bugzilla/syzbot report. Failure scenario documented in
list discussion (remount after heavy GC on zone-limited device).

**Step 4.4 – Series context**
Record: Other patches in series cover tracepoints (1/2), statfs
accounting (4/5), deadlock (5/5) — separate issues; this patch is
independently backportable.

**Step 4.5 – Stable list**
Record: lore.kernel.org/stable search blocked (bot protection). Original
feature commit `694ce5e143d6` had explicit stable nomination (`Cc:
stable # 6.6+`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 – Key functions**
Record: `btrfs_zoned_reserve_data_reloc_bg()` modified.

**Step 5.2 – Callers**
Record: Called once from `btrfs_open_devices()` path in `fs/btrfs/disk-
io.c:3556` during filesystem mount, after `btrfs_read_block_groups()`.

**Step 5.3 – Callees**
Record: Block-group list iteration, space_info migration
(`list_del_init`, `btrfs_add_bg_to_space_info`), `btrfs_chunk_alloc()`
fallback, `btrfs_zone_activate()`.

**Step 5.4 – Reachability**
Record: Triggered on every read-write mount of a zoned btrfs filesystem
(`btrfs_is_zoned()`). Common operational path for zoned-storage users.

**Step 5.5 – Similar patterns**
Record: Treelog block-group reservation uses related but separate logic
in `extent-tree.c`. No other “skip first empty” pattern found for data
relocation.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 – Buggy code present?**
Record: **Yes.** Current `fs/btrfs/zoned.c:2760–2787` still has `bool
first = true`, comment “Take the second one”, and skip-first-empty
logic. Fix commit `82fd26090ebd` is **not** an ancestor of HEAD
(6.18.44).

**Step 6.2 – Backport complications**
Record: **Clean apply.** `git format-patch -1 82fd260 | git apply
--check` succeeds on current tree.

**Step 6.3 – Related fixes already present?**
Record: Prerequisites `694ce5e143d6` and `daa0fde32235` are in v6.18 and
this tree. No alternate fix for this issue found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 – Subsystem**
Record: **btrfs / zoned mode** — IMPORTANT for zoned-btrfs deployments
(SMR/ZNS storage); not universal but operationally critical for that
subset.

**Step 7.2 – Activity**
Record: `fs/btrfs/zoned.c` actively maintained in 6.18.y with multiple
recent zoned fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 – Who is affected**
Record: Users of **zoned btrfs** (`CONFIG_BTRFS_FS` + zoned devices).
Not all kernel users, but all zoned-btrfs users on affected versions.

**Step 8.2 – Trigger conditions**
Record: Mount after workload leaving one empty DATA block group and no
spare zones for new chunk allocation (e.g., remount after heavy GC).
Realistic on zone-limited SMR/ZNS hardware.

**Step 8.3 – Failure severity**
Record: `data_reloc_bg` remains 0 → garbage collection / data relocation
cannot reserve dedicated space → **ENOSPC under overwrite workloads**
(the exact problem `694ce5e143d6` was designed to prevent). Severity:
**HIGH** for affected configurations; mount succeeds silently so the
failure is deferred.

**Step 8.4 – Risk-benefit**
Record:
- **Benefit:** HIGH for zoned btrfs — restores guaranteed relocation
  block-group reservation
- **Risk:** LOW — 10-line deletion, reviewed by two btrfs developers,
  applies cleanly
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 – Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Real bug with documented remount scenario | Narrow audience (zoned
btrfs only) |
| Can leave `data_reloc_bg` unset → ENOSPC/GC failure | Part of 5-patch
series (but this patch is standalone) |
| Small, surgical, reviewed fix | No syzbot/fuzzer report |
| Applies cleanly to 6.18.44 | Bug only exists since `daa0fde32235` (not
in older trees) |
| Fixes regression in already-stable code | |
| Original feature had stable CC | |

**Step 9.2 – Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic fix reviewed by Boris
   Burkov and Naohiro Aota; applies cleanly
2. Fixes a real user-affecting bug? **PASS** — documented remount/zone-
   exhaustion scenario
3. Important issue? **PASS** — ENOSPC / broken GC on zoned btrfs (HIGH
   for affected users)
4. Small and contained? **PASS** — 1 file, net −9 lines
5. No new features/APIs? **PASS** — removes obsolete logic only
6. Can apply to local tree? **PASS** — verified with `git apply --check`

**Step 9.3 – Exception categories**
Record: None (not a quirk/DT/build/doc fix), but a straightforward logic
bug fix.

**Step 9.4 – Problem and why it matters**

On mount, zoned btrfs reserves a dedicated data-relocation block group
so garbage collection always has space under heavy overwrite. Commit
`daa0fde32235` changed the selection criterion to `alloc_offset == 0`
but kept the old “skip the first empty block group” rule. When a
filesystem has only one empty DATA block group and the device cannot
allocate a new chunk (common after GC-heavy use on zone-limited drives),
the mount path silently fails to set `data_reloc_bg`. The filesystem
then hits ENOSPC when GC is needed — defeating the purpose of the mount-
time reservation added in `694ce5e143d6`.

This fix simply picks the first empty DATA block group, which is correct
under the new criterion. It is minimal, self-contained, and directly
relevant to Linux 6.18.44 where both the feature and the regression are
present.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes/Reported-by/Cc:stable
  on this commit
- [Phase 1] Identified hidden bug fix from message and list discussion
- [Phase 2] Diff: 1 file, `btrfs_zoned_reserve_data_reloc_bg()`, −10/+1
  lines
- [Phase 2] Mechanism: stale skip-first-empty logic after criterion
  change
- [Phase 3] `git blame -L 2777,2800 fs/btrfs/zoned.c`: skip logic from
  `daa0fde32235`
- [Phase 3] `git merge-base --is-ancestor`: `694ce5e143d6` and
  `daa0fde32235` both in HEAD and v6.18
- [Phase 3] `git show 694ce5e143d6`: original feature with `Cc: stable #
  6.6+`
- [Phase 3] `git show daa0fde32235`: introduced skip-first-empty with
  `alloc_offset == 0`
- [Phase 3] `git merge-base --is-ancestor 82fd260 HEAD`: fix **NOT** in
  6.18.44
- [Phase 4] `b4 dig -c 82fd260`: lore URL found
- [Phase 4] `b4 dig -a`: v1/v2/v3 series revisions confirmed; v3 is
  final form
- [Phase 4] `b4 dig -w`: btrfs maintainers/reviewers CC'd
- [Phase 4] WebFetch spinics msg165574: Boris documented remount + zone
  exhaustion scenario
- [Phase 5] `grep btrfs_zoned_reserve_data_reloc_bg`: caller at `disk-
  io.c:3556` on mount
- [Phase 5] Read `extent-tree.c:3870–3966`: `data_reloc_bg == 0` breaks
  relocation allocation paths
- [Phase 6] `git describe HEAD` / `make kernelversion`: tree is 6.18.44
- [Phase 6] Read `fs/btrfs/zoned.c:2752–2845`: buggy code confirmed
  present
- [Phase 6] `git format-patch -1 82fd260 | git apply --check`: clean
  apply
- [Phase 8] Failure mode: no relocation BG → ENOSPC on zoned btrfs,
  severity HIGH for affected configs

**YES**The background searches finished and matched what the analysis
already used:

- The fix commit (`always set data_relocation_bg`) is **not** in
  6.18.44; the tree still has the skip-first-empty logic in
  `fs/btrfs/zoned.c`.
- The prerequisite commits are present: `694ce5e143d6` (reserve
  data_reloc BG on mount) and `daa0fde32235` (the regression this fix
  corrects).
- `b4 dig` on HEAD didn’t match (expected — the fix isn’t applied yet);
  digging by commit hash `82fd260` found the v3 lore thread.

**Verdict remains YES** for backporting to this 6.18.44 tree.

 fs/btrfs/zoned.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 6ca5816a67381..660f516cb9357 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2759,7 +2759,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_block_group *bg;
 	struct list_head *bg_list;
 	u64 alloc_flags;
-	bool first = true;
 	bool did_chunk_alloc = false;
 	int index;
 	int ret;
@@ -2776,17 +2775,12 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	alloc_flags = btrfs_get_alloc_profile(fs_info, space_info->flags);
 	index = btrfs_bg_flags_to_raid_index(alloc_flags);
 
-	/* Scan the data space_info to find empty block groups. Take the second one. */
 again:
 	bg_list = &space_info->block_groups[index];
 	list_for_each_entry(bg, bg_list, list) {
-		if (bg->alloc_offset != 0)
-			continue;
 
-		if (first) {
-			first = false;
+		if (bg->alloc_offset != 0)
 			continue;
-		}
 
 		if (space_info == data_sinfo) {
 			/* Migrate the block group to the data relocation space_info. */
@@ -2798,8 +2792,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 
 			down_write(&space_info->groups_sem);
 			list_del_init(&bg->list);
-			/* We can assume this as we choose the second empty one. */
-			ASSERT(!list_empty(&space_info->block_groups[index]));
 			up_write(&space_info->groups_sem);
 
 			spin_lock(&space_info->lock);
@@ -2843,7 +2835,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 		 * We allocated a new block group in the data relocation space_info. We
 		 * can take that one.
 		 */
-		first = false;
 		did_chunk_alloc = true;
 		goto again;
 	}
-- 
2.53.0

