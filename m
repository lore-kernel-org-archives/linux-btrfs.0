Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9728950F15C;
	Mon, 19 Oct 2026 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418208; cv=none; b=cJdYEMEuf9nEFopOOAapHgO0gHGRLqZs46vm7E86jqrZPAkbbj4MVfP58iPiZlKExph3D/1fY9dYTydbysLqB9gnX6CzGf8rBl/BGRfwnu7tIOZK87l36GMvP93mcfsL37fev3fqozCOCpfDpoBCs5XtV2eeGQ2diD8SRxM939s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418208; c=relaxed/simple;
	bh=C1UGyC5iPmJkN49m3Si2mhrEjEGxKh2aD03KCvh0pWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qHUuogaU+NNSMRR2vonvqjjks/4wbsoTXajWd2D4ayaPbtndEqEVu4Kwm6hluOwADyYzf8D9Em+YItbD5Lc+oZyL4PYGuvcDoXxFk40kE1x+mdENG1nccH1kNsrIRMa49QuusPMmmfy4o0/BEwm3ExMbJI2gi4SnXVK3ennsqec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YDiajION; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YDiajION"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC901F000C5;
	Mon, 19 Oct 2026 13:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418205;
	bh=KggA7O7wwFxjfQiaO0JBLflfjpRu9dzqNjPhKfCK+PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDiajIONOr4MgAzzy40qANeOtFOFQRL1pHKG97peTPHpL9cmcPvVEvo+85U+i1xeS
	 3Ao1jIRtZwuwWiTKrEICkvXLZLgwCdoQoHmS2LYWIAvCsZwK9iVfdNB9/jtvjxLfDE
	 6MTOM2Y10eVUqwmChe7uvSKDbmLkUaSt062MIelMMmm71bED9PB26+6/A8s0am+4NN
	 kuotZSp56PpRc33TI7Zw7OaPxgGb1dbY+1Z/z/DHK/BAmnDCReCHC768l4A90NLlbz
	 GVvpHLzJruhdW3Xm58bqFVXWdVJ3PluHKSei00w71Wq8sWVY67lS8253kSwkDbnAc1
	 Zz+tZWZLfIJCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] btrfs: fix memory barrier order in reloc_root_is_dead()
Date: Mon, 19 Oct 2026 09:46:18 -0400
Message-ID: <20261019135441.1420968-87-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6f1c97695a6e230ee15c9e052e1933bdccfd5fa3 ]

When we set a root's reloc_root to NULL, we do it like this:

   static void clear_reloc_root(struct btrfs_root *root)
   {
       root->reloc_root = NULL;
       /*
        * Need barrier to ensure clear_bit() only happens after
        * root->reloc_root = NULL. Pairs with have_reloc_root().
        */
        smp_wmb();
        clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
   }

So that a NULL reloc_root is always seen before seeing that the bit
BTRFS_ROOT_DEAD_RELOC_TREE was cleared.

But on the read side we have:

   static bool reloc_root_is_dead(const struct btrfs_root *root)
   {
        smp_rmb();
        if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
            return true;
        return false;
   }

And then callers of reloc_root_is_dead() access root->reloc_root.

Because the read memory barrier is placed before testing the bit, the CPU
is completely free to speculatively reorder those two loads. It can read
root->reloc_root before it actually checks the dead tree bit.

Sashiko reported this as an existing problem in another patch review, see
the link in the Link tag below.

Fix this by moving the read memory barrier to happen after testing the bit
and update the comment to reflect current reality.

Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana%40suse.com
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **Linux 6.18.53** (`pending-6.18`). The candidate is
mainline `6f1c97695a6e2` (`v7.3-rc1`) and is **not** in this checkout.
The misplaced `smp_rmb()` in `reloc_root_is_dead()` is still present,
and the write-side half of the same series is already here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[btrfs]` `[fix]` — correct read-side memory-barrier order in
`reloc_root_is_dead()` so the `BTRFS_ROOT_DEAD_RELOC_TREE` bit is
observed before callers load `root->reloc_root`.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Link:** https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd
  7afd36c9427.1781194426.git.fdmanana%40suse.com (Sashiko review of a
  related UAF patch, where this read-side bug was flagged)
- **Reviewed-by:** Boris Burkov `<boris@bur.io>`
- **Signed-off-by:** Filipe Manana `<fdmanana@suse.com>` (author), David
  Sterba `<dsterba@suse.com>` (btrfs maintainer)
- No **Fixes:**, **Reported-by:**, **Tested-by:**, **Cc: stable**,
  **Acked-by:**
- Ignore pipeline SOBs. Absence of Fixes/Cc-stable is expected.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** Writer does `root->reloc_root = NULL; smp_wmb();
  clear_bit(DEAD)`. Reader did `smp_rmb(); test_bit(DEAD)` and then
  callers loaded `root->reloc_root`.
- **Mechanism:** An `smp_rmb()` *before* the bit load does not order
  that load against the later `reloc_root` load. CPU/compiler may load
  `reloc_root` first.
- **Symptom:** Stale non-NULL `reloc_root` after the writer has NULLed
  it and cleared the dead bit, then `btrfs_drop_snapshot()` — use-after-
  free.
- **Root cause:** Classic MP (message-passing) pairing error:
  `smp_rmb()` must sit *between* the two loads, not before both.
- **Version info:** Buggy helper dates to `6282675e6708ec` (v5.5-rc7,
  2020).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Explicit barrier/UAF-class correctness fix, found by
Sashiko on a related reloc-root series.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `fs/btrfs/relocation.c` (+6 / −5)
- **Function:** `reloc_root_is_dead()`
- **Scope:** Single-function, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `smp_rmb(); if (test_bit(DEAD)) return true; return
  false;`
- **After:** `if (test_bit(DEAD)) return true; smp_rmb(); return false;`
- **Affected path:** Any caller that, on a false result, then reads
  `root->reloc_root` (`have_reloc_root()`, `btrfs_init_reloc_root()`,
  `btrfs_should_ignore_reloc_root()`).
- Early return when the bit is set skips the rmb; those callers do not
  load `reloc_root`. That is correct.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** Synchronization / race (memory-barrier pairing); failure
  mode is UAF
- **Mechanism:** Writer: store `reloc_root=NULL`, `smp_wmb()`,
  `clear_bit(DEAD)`. Required reader: load DEAD, `smp_rmb()`, load
  `reloc_root`. Current reader puts `smp_rmb()` *before* the bit load,
  so it does not pair. Compiler can hoist `root->reloc_root` above
  `test_bit()` after inlining (x86 included); weak memory models can
  also reorder the loads in hardware.

Verified against LKMM recipes (`tools/memory-
model/Documentation/recipes.txt`, MP + `smp_wmb`/`smp_rmb`): the read
barrier is between the two loads.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Minimal and matches documented pairing. No API/data-structure
change. Regression risk is low: if the bit is set we return without rmb
(callers do not touch `reloc_root`); if clear, rmb orders the subsequent
load. David Sterba initially doubted the move; Filipe explained the
pairing; David still merged with SOB.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy `smp_rmb()` + `test_bit()`: `6282675e6708ec` (“btrfs:
  relocation: fix reloc_root lifespan and access”), Qu Wenruo,
  2020-01-08, first in **v5.5-rc7**. That commit itself was `CC: stable
  # 5.4+` to fix KASAN UAFs on balance+snapshot.
- Write-side `clear_reloc_root()`: `fda1b6636ff184` in this tree
  (Upstream `83201804efa4a`).
- Original commit text even said “the pairing read side is before
  test_bit” — that comment is what this patch corrects.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag. Introducer is `6282675e6708ec`, present in this
tree (`git merge-base --is-ancestor` exit 0). Independently identified
in 2021 by Baptiste Lepers (`[PATCH] btrfs: relocation: fix misplaced
barrier in reloc_root_is_dead`, 2021-05-26) with `Fixes: 6282675e6708e`;
that patch was never merged.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Same-day 2-patch series `[PATCH 0/2] btrfs: fix incorrect
barrier usage in relocation`:
- **1/2** `b78fe9563e2d5` / this tree `63d6b1f04cd91` — write-side
  `clear_reloc_root()` in `merge_reloc_roots()`. **Already in this
  tree.**
- **2/2** this commit — read-side rmb. **Not in this tree.**

Prerequisite UAF helper `clear_reloc_root` (`fda1b6636ff184`) is also
already here. No later mainline rewrite of `reloc_root_is_dead()` after
`6f1c97695a6e2`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Filipe Manana is a core btrfs author (many reloc-root UAF/leak
fixes). David Sterba (listed btrfs maintainer) signed off. Boris Burkov
reviewed the series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: This hunk only reorders `smp_rmb()` vs `test_bit()` in
`reloc_root_is_dead()`. It does not call `clear_reloc_root()`.
Standalone. `git show 6f1c97695a6e2 | git apply --check` succeeded (hunk
offset −94 lines only).

The kbuild error on the series was `clear_reloc_root` undeclared when
**1/2** was applied without the UAF series; that does not apply to
**this** patch, and this 6.18.53 tree already has both the helper and
1/2.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **Lore/thread:** cover `cover.1781263239.git.fdmanana@suse.com`; 2/2
  msgid `62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanan
  a@suse.com`
- **Series:** v1 only (2026-06-12), two patches
- **b4 dig -c 6f1c97695a6e2** initially matched the related UAF v5
  thread (same Link/Sashiko URL / similar patch-id). Direct msgid fetch
  recovered the real 0/2 series (9 messages).
- **Reviewer feedback:**
  - Boris Burkov: `Reviewed-by` on the cover (both patches)
  - David Sterba (2026-06-18): argued rmb-before-`test_bit` was
    intentional “to have up-to-date value”; said post-test rmb “is
    wrong, or at least not entirely correct”; suggested dropping
    barriers
  - Filipe: pairing is load-bit / rmb / load-`reloc_root` against store-
    NULL / wmb / clear-bit; dropping barriers would regress the 2020
    KASAN races
  - David still merged (SOB on the commit)
- **kbuild:** false positive (1/2 vs missing helper on for-next vs
  Linus)
- **Stable nomination in thread:** none
- **NAKs:** no NAK; maintainer doubt was answered and the patch landed

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc `linux-btrfs@vger.kernel.org`. Boris reviewed. David (M:
in MAINTAINERS) engaged and merged.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot for this exact rmb placement. Sashiko flagged it while
reviewing the insert_dirty_subvol UAF series. Original 2020 KASAN
reports (Zygo Blaxell) are why the barriers exist. 2021 Baptiste patch:
same diagnosis; appears unreplied (odd `To:`), never applied.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Companion 1/2 already AUTOSEL’d and present in this 6.18 tree.
This 2/2 is the unfinished read-side half. UAF series that introduced
`clear_reloc_root` is also already here.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: Openwall/AUTOSEL traffic is for 1/2 and the UAF helper, not this
subject. No stable-list rejection of 2/2 was found. lore.kernel.org
search URLs returned 403; discussion was recovered via `b4 mbox`
instead.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `reloc_root_is_dead()` only.

**Step 5.2: TRACE CALLERS**

Record (this tree, `fs/btrfs/`):
- `have_reloc_root()` → `btrfs_update_reloc_root()`,
  `btrfs_reloc_pre_snapshot()`, `btrfs_reloc_post_snapshot()`
- `btrfs_init_reloc_root()` (direct) ← `fs/btrfs/transaction.c` when a
  shareable root is recorded in a transaction
- `btrfs_should_ignore_reloc_root()` ← `fs/btrfs/backref.c` during reloc
  backref walk

Contexts: relocation/balance, snapshot creation during balance,
transaction join for subvolumes. Not interrupt. Reachable from
`BTRFS_IOC_BALANCE` / snapshot ioctls.

**Step 5.3: TRACE CALLEES**

Record: `test_bit()`, `smp_rmb()`. Callers then read `root->reloc_root`
and may dereference `commit_root`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Writer `clean_dirty_subvols()` / `clear_reloc_root()`: save
pointer, NULL `reloc_root`, wmb, clear DEAD, `btrfs_drop_snapshot()`.
Concurrent reader: new transaction / snapshot / backref walk calling
`reloc_root_is_dead()` then loading `reloc_root`. Original 2020 analysis
called this the C–D window after `btrfs_commit_transaction()`.
Userspace-reachable on btrfs balance+snapshot. Unprivileged users
typically cannot ioctl-balance; a hit still crashes/corrals the
filesystem.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same class of misplaced rmb in `btrfs_record_root_in_trans`
(2021 Baptiste, later 2026 “btrfs: fix root-in-trans fast-path
ordering”). Write-side pairing in this file is already correct
(`clear_reloc_root`, `btrfs_update_reloc_root` `set_bit`+wmb).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `fs/btrfs/relocation.c` lines 246–257:

```246:257:fs/btrfs/relocation.c
static bool reloc_root_is_dead(const struct btrfs_root *root)
{
        /*
  - Pair with set_bit/clear_bit in clean_dirty_subvols and
  - btrfs_update_reloc_root. We need to see the updated bit before
  - trying to access reloc_root
         */
        smp_rmb();
        if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
                return true;
        return false;
}
```

Introduced v5.5; still wrong here. Write side already uses `smp_wmb()`
in `clear_reloc_root()` (1460–1468). `git merge-base --is-ancestor
6f1c97695a6e2 HEAD` → not an ancestor.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (`git apply --check` succeeded, offset only). No
helper dependency. Surrounding `have_reloc_root()` / callers match
mainline.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: 1/2 and `clear_reloc_root` UAF fix are here. This read-side
reorder is not. No substitute fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **fs/btrfs** — **IMPORTANT** (filesystem integrity; reloc UAF
can oops or corrupt during balance).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Active. Multiple 2026 reloc-root UAF/leak/barrier fixes already
landed in this 6.18.y tree.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Btrfs users who run balance/relocation, especially concurrent
with snapshots/subvolume updates. Not universal, but a standard admin
path.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Overlap of `clear_reloc_root()`/`clean_dirty_subvols()` with a
reader of `have_reloc_root()` / `btrfs_init_reloc_root()` /
`btrfs_should_ignore_reloc_root()`. Timing-dependent; same shape as the
2020 KASAN balance+snapshot reports. Typically privileged ioctls; impact
is whole-fs.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Stale `reloc_root` used after `btrfs_drop_snapshot()` → **UAF /
oops**, possible further refcount damage. **Severity: HIGH.**

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit: HIGH** — completes barrier pairing; write side already
  backported here, so this tree currently has an unpaired wmb.
- **Risk: LOW** — 11 lines, one static helper, no locking/API change.
- **Ratio:** Strongly favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real MP barrier bug; UAF if `reloc_root` is loaded before `test_bit`
  during dead-bit clear
- Buggy code verified in this 6.18.53 tree since v5.5
- Write-side companion already in this tree → read side is the missing
  half
- LKMM pairing is unambiguous (`smp_rmb` between the two loads)
- Small, applies cleanly, reviewed (Boris), merged by maintainer (David)
- Same race family as the 2020 KASAN reloc-root lifespan fix
- Sashiko + independent 2021 diagnosis

**AGAINST:**
- No dedicated syzbot/user crash for this rmb placement
- David initially disputed the move (later merged)
- Original 2020 text claimed a transaction as a higher-level barrier
  (barriers still added for the C–D window; this patch is that window)
- 2021 patch sat unmerged (likely overlooked, not NAK’d)

**UNRESOLVED:** Could not fetch lore.kernel.org HTML (403). Thread
recovered via `b4 mbox`. No evidence this 2/2 was rejected for stable.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — matches LKMM MP pairing;
   reviewed; in mainline as of v7.3-rc1
2. Fixes a real bug that affects users? **PASS** — unpaired barrier on a
   path built to stop reloc-root UAF
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   HIGH, UAF/oops during balance
4. Small and contained? **PASS** — +6/−5, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean apply; prerequisites
   already present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: N/A — ordinary correctness fix.

**Step 9.4: MAKE YOUR DECISION**

This 6.18.53 tree still has `smp_rmb()` before `test_bit()` in
`reloc_root_is_dead()`, so the write-side `smp_wmb()` already present in
`clear_reloc_root()` does not pair. Moving the rmb after the bit test is
the standard, small fix for a UAF-class race on btrfs relocation. It
should be backported here.

===============================================================
Verification
===============================================================

- **[Phase 1]** Parsed subject/tags/body from `git show 6f1c97695a6e2`
  on origin/master
- **[Phase 2]** Diff is +6/−5 in `reloc_root_is_dead()` only; compared
  to current `fs/btrfs/relocation.c:246-257`
- **[Phase 2]** Confirmed write side `clear_reloc_root()` at 1460–1468:
  NULL → `smp_wmb()` → `clear_bit`
- **[Phase 2]** LKMM recipes.txt MP example: load y, `smp_rmb()`, load x
- **[Phase 3]** `git blame -L 246,257`: `6282675e6708ec` (v5.5-rc7);
  `git describe --contains 6282675e6708ec` → `v5.5-rc7~22^2~2`
- **[Phase 3]** `git merge-base --is-ancestor 6282675e6708ec HEAD` →
  yes; `6f1c97695a6e2` → no
- **[Phase 3]** `git merge-base --is-ancestor 63d6b1f04cd91 HEAD` → 1/2
  present; `fda1b6636ff18` → `clear_reloc_root` present
- **[Phase 3]** `git show 6f1c97695a6e2 | git apply --check` → hunk
  succeeded at offset −94
- **[Phase 3]** `git describe --contains 6f1c97695a6e2` →
  `v7.3-rc1~117^2~66`
- **[Phase 4]** `b4 mbox` of msgid `50682caa6bbf…` → cover + 1/2 + 2/2 +
  Boris Reviewed-by + David concern + Filipe reply + kbuild false
  positive
- **[Phase 4]** 2021 Baptiste patch verified via openwall/lkml.iu (never
  in `git log origin/master --author='Baptiste Lepers' -- fs/btrfs`)
- **[Phase 4]** lore.kernel.org WebFetch 403; used b4 instead
- **[Phase 5]** `git grep` callers: `have_reloc_root`,
  `btrfs_init_reloc_root`, `btrfs_should_ignore_reloc_root` →
  transaction.c, relocation.c, backref.c
- **[Phase 6]** `git describe HEAD` / `make kernelversion` →
  `p-6.18-1-g03b85e06ca9bf`, **6.18.53**
- **[Phase 6]** `git grep -A20 reloc_root_is_dead origin/master` →
  mainline already has test_bit then rmb
- **[Phase 7]** MAINTAINERS: David Sterba is btrfs maintainer; he SOB’d
  the commit
- **[Phase 8]** Failure mode from original `6282675e6708ec` KASAN stacks
  (balance+snapshot) plus C–D window vs `drop_snapshot` after
  `clear_bit`
- **UNVERIFIED:** Direct sashiko.dev review text (JS page had no static
  content); inferred from Link tag + cover letter + Filipe changelog

The patch is a small, obviously correct pairing fix for a reloc-root UAF
race, the buggy code is in this 6.18.53 tree, and the write-side half is
already here.

**YES**

 fs/btrfs/relocation.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index eab9686b1bcdf..fcb0ab937de5c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -245,14 +245,15 @@ static struct btrfs_backref_node *walk_down_backref(
 
 static bool reloc_root_is_dead(const struct btrfs_root *root)
 {
+	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
+		return true;
 	/*
-	 * Pair with set_bit/clear_bit in clean_dirty_subvols and
-	 * btrfs_update_reloc_root. We need to see the updated bit before
-	 * trying to access reloc_root
+	 * Pairs with set_bit/clear_bit in clear_reloc_root() and
+	 * btrfs_update_reloc_root(). We need to see the updated bit before
+	 * trying to access root->reloc_root in our callers.
 	 */
 	smp_rmb();
-	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
-		return true;
+
 	return false;
 }
 
-- 
2.53.0

