Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E7D4A2A7E;
	Mon, 31 Aug 2026 13:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183742; cv=none; b=nQSR3dtcVUUOwtR8mK5CBj9Y3IxTHbl5yOLwTgfzEALfhpVaaH+IIYqrDDrHpRC3ySPGNKabC5XNd9JSBkkj4rKDdhNF5w0NPhSjDmvwrroL/d6kyCNSsLyZ2CYwEqoywe2vKbOfliNjEM8PM/jkjum+2xMjQbSwkRiqxrqNFyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183742; c=relaxed/simple;
	bh=QSlgWUHKFieonTqmTqX+8UloC5qEueWyfKw3H/cpFgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZN3mBv+UN8l0YZrQmLweusprX9aebyJolR/8Rv0ApMCZzqVGjWukaocz3M3CMPSWLlyoJl8ZfDZUBNlRsWZmG+/1Nloo9Kr1czzHekq9y5WGhk570b1Ocm4mXQBW2dOntQ7fvJX6l8BcOg3K2VsZWQ4uIr6j/gVN6ndrR/Z0+EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AmYA8hfq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmYA8hfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905C51F000E9;
	Mon, 31 Aug 2026 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183739;
	bh=zGjJjwPm4jSrA8LTBjKCFqr80P0Fkin04Tc6rM8MmrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmYA8hfqGrDPsw4NOPRupIo+C/HCrslYZB+oy2hEVKqod0Hp5mP9eRGkI5eIqU6tj
	 IoxzH3DIinxLWjC5AZ5SFZuUjUgz8X5U1lvX8Uk0bEqvUrob3SSFP8Kh8FSOEn5GOI
	 P6aRAB6zFgujJAUG0ciScNlS08PQ5NpxdZ194I3lVjt3dw5DCBFxt/daaaP3M69QeV
	 gHOKaR8bSTnkOxBR2U/S5w+hLCb6BzieoB1F4FGcisOtBkCT7wFl7DmmhdcmIOz4Ld
	 AUp25VJNthKDy1xKG1U6vrTEA3l0urG+GLgogNk1Ly+Jz95yfZ8xtjq8DbO0+N6ioC
	 9ZF18MXde7OLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] btrfs: fix reloc root cleanup in merge_reloc_roots()
Date: Mon, 31 Aug 2026 09:25:03 -0400
Message-ID: <20260831133314.4125787-275-sashal@kernel.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit b78fe9563e2d5ae47805f1e5dc722c91fd30e1f8 ]

If the root we got has zero root refs in its root item, we are resetting
the root's ->reloc_root without using barriers like we do everywhere else.
Sashiko complained about this while reviewing another patch, and it's
correct (see the Link tag below).

Also, we should not clear BTRFS_ROOT_DEAD_RELOC_TREE from the root unless
the root points to the reloc root we have.

Fix this by using clear_reloc_root(), which issues the memory barrier
after setting the root's ->reloc_root to NULL and before clearing the bit
BTRFS_ROOT_DEAD_RELOC_TREE from the root.

Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana%40suse.com
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `btrfs: fix reloc root cleanup in
merge_reloc_roots()`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

**Commit analyzed:** `b78fe9563e2d5ae47805f1e5dc722c91fd30e1f8` (not yet
merged into this checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[btrfs]` `[fix]` — correct reloc-root cleanup in
`merge_reloc_roots()` when a reloc root has zero root refs.

### Step 1.2: Tags
**Record:**
- **Link:** Sashiko automated review (https://sashiko.dev/...)
- **Reviewed-by:** Boris Burkov `<boris@bur.io>`
- **Signed-off-by:** Filipe Manana, David Sterba
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
- Notable: found during code review (Sashiko), not a syzbot/user crash
  report for this specific path

### Step 1.3: Body Analysis
**Record:**
- **Bug:** In the zero-ref reloc-root branch of `merge_reloc_roots()`,
  `root->reloc_root` is cleared without the memory barrier used
  elsewhere; `BTRFS_ROOT_DEAD_RELOC_TREE` is cleared unconditionally
  even when `root->reloc_root != reloc_root`.
- **Symptom:** Incorrect synchronization with `have_reloc_root()` /
  `reloc_root_is_dead()`; can observe stale `reloc_root` pointers or
  wrong dead-tree state during relocation/balance.
- **Root cause:** Inconsistent barrier usage and misplaced `clear_bit()`
  outside the matching-reloc-root guard.
- **Fix approach:** Use `clear_reloc_root()` helper (sets NULL →
  `smp_wmb()` → `clear_bit()`), only when `root->reloc_root ==
  reloc_root`.

### Step 1.4: Hidden Bug Fix?
**Record:** No — explicitly described as a bug fix (barrier + logic
error).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/btrfs/relocation.c` (+2 / -3)
- **Function:** `merge_reloc_roots()`
- **Scope:** Single-file, surgical fix in one error/cleanup branch

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Zero-ref cleanup branch | `root->reloc_root = NULL;
btrfs_put_root(reloc_root);` then unconditional
`clear_bit(DEAD_RELOC_TREE)` | `clear_reloc_root(root);
btrfs_put_root(reloc_root);` only inside `if (root->reloc_root ==
reloc_root)` |

**Affected path:** Relocation merge when
`btrfs_root_refs(&reloc_root->root_item) == 0` (dead/orphan reloc tree
cleanup during balance).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Synchronization / logic correctness
- **Mechanism 1 (missing `smp_wmb()`):** Writers in
  `clean_dirty_subvols()` (lines 1474–1480) and
  `btrfs_update_reloc_root()` (lines 796–801) use `smp_wmb()` between
  NULL-ing `reloc_root` and clearing `BTRFS_ROOT_DEAD_RELOC_TREE`.
  `merge_reloc_roots()` did not, breaking pairing with
  `reloc_root_is_dead()`'s `smp_rmb()`.
- **Mechanism 2 (wrong `clear_bit` scope):** `clear_bit()` ran even when
  `root->reloc_root != reloc_root`, corrupting state for a root still
  associated with a different reloc root.

### Step 2.4: Fix Quality
**Record:** Fix is minimal and matches the established pattern in the
same file. Low regression risk. **Caveat:** depends on
`clear_reloc_root()` helper, which is **not present** in this tree (see
Phase 6).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy lines (1873–1879) blamed to `5d324e5159d9e` (6.18-rc8
era merge, Nov 2025). Barrier infrastructure (`reloc_root_is_dead`,
`BTRFS_ROOT_DEAD_RELOC_TREE`) introduced in same timeframe — relatively
new in 6.18.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related Changes
**Record:**
- `60a23d4ea169e` — related fix in same function (root leak on
  unexpected reloc_root); already in this tree.
- Part of 2-patch series `[PATCH 0/2] btrfs: fix incorrect barrier usage
  in relocation`:
  - **1/2:** this commit
  - **2/2:** `btrfs: fix memory barrier order in reloc_root_is_dead()`
- `clear_reloc_root()` introduced in separate UAF-fix series (`[PATCH
  v2] btrfs: fix use-after-free on reloc root after error in
  insert_dirty_subvol()`); **not in this tree**.

### Step 3.4: Author Context
**Record:** Filipe Manana — active btrfs maintainer; multiple recent
`merge_reloc_roots()` fixes in this tree.

### Step 3.5: Dependencies
**Record:** Commit calls `clear_reloc_root()`, which does not exist in
6.18.44. **Not standalone as-is**, but trivially adaptable using the
inline pattern already in `clean_dirty_subvols()`:

```c
root->reloc_root = NULL;
smp_wmb();
clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
```

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **b4 dig:** https://patch.msgid.link/50682caa6bbf69740c629a26ff6f19a72
  ce55e03.1781263239.git.fdmanana@suse.com
- **Series:** v1 only (2026-06-12)
- **Reviewer feedback:** Boris Burkov Reviewed-by on cover letter; David
  Sterba replied on patch 2/2; kernel test robot build-tested patch 2/2
- **Stable nomination:** None found in thread

### Step 4.2: Reviewers
**Record:** `linux-btrfs@vger.kernel.org`; Boris Burkov reviewed; David
Sterba (btrfs maintainer) engaged on patch 2/2.

### Step 4.3: Bug Report
**Record:** No syzbot/user crash report for this specific bug.
Identified by Sashiko during review of a related patch. Related UAF in
relocation (syzbot-reported) motivated the `clear_reloc_root()` helper
in a separate series.

### Step 4.4: Related Patches
**Record:** Patch 2/2 fixes read-side barrier ordering in
`reloc_root_is_dead()`. Ideally backported together for complete barrier
correctness, but patch 1/2 independently fixes a real write-side bug.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `merge_reloc_roots()`, `reloc_root_is_dead()`,
`have_reloc_root()`, `clear_reloc_root()` (upstream only)

### Step 5.2: Callers
**Record:** `merge_reloc_roots()` called from:
- `relocate_block_group()` (line 3653) — balance/relocation path
- Another relocation path (line 4198)

Both are btrfs balance/relocation operations, reachable via
`BTRFS_IOC_BALANCE` ioctl (privileged).

### Step 5.3: Callees
**Record:** `btrfs_get_fs_root()`, `btrfs_put_root()`, `clear_bit()`,
barrier primitives; interacts with refcounted `btrfs_root` objects.

### Step 5.4: Reachability
**Record:** Triggered during btrfs balance/relocation (admin/root
operation). Not every boot, but real production use (rebalancing, device
replacement). Unprivileged users cannot directly trigger, but corruption
from a privileged balance affects the whole filesystem.

### Step 5.5: Similar Patterns
**Record:** Correct barrier pattern exists in `clean_dirty_subvols()` at
lines 1474–1480; `merge_reloc_roots()` is the inconsistent outlier.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES** — confirmed at lines 1873–1879:

```1873:1880:fs/btrfs/relocation.c
                        if (!IS_ERR(root)) {
                                if (root->reloc_root == reloc_root) {
                                        root->reloc_root = NULL;
                                        btrfs_put_root(reloc_root);
                                }
                                clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
                                          &root->state);
                                btrfs_put_root(root);
```

Barrier infrastructure (`BTRFS_ROOT_DEAD_RELOC_TREE`,
`reloc_root_is_dead`) also present since 6.18.

### Step 6.2: Backport Complications
**Record:** **Minor adaptation needed.** `clear_reloc_root()` does not
exist in this tree. Equivalent inline fix (matching
`clean_dirty_subvols()`) is straightforward. No conflicting refactors in
this area.

### Step 6.3: Related Fixes Already Present?
**Record:** `60a23d4ea169e` (root leak fix) is present. This
barrier/logic fix is **not** present. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** **fs/btrfs** — IMPORTANT (filesystem, data integrity)

### Step 7.2: Activity
**Record:** Active — multiple recent `merge_reloc_roots()` fixes in
6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users running btrfs balance/relocation on 6.18.y kernels
with the `BTRFS_ROOT_DEAD_RELOC_TREE` barrier mechanism.

### Step 8.2: Trigger Conditions
**Record:** Balance/relocation reaching `merge_reloc_roots()` with a
reloc root whose root item has zero refs. Uncommon relative to normal
I/O, but standard admin workflow. Privileged trigger only.

### Step 8.3: Failure Mode Severity
**Record:**
- Stale `reloc_root` pointer observed after bit cleared → potential
  **UAF** or double-free (same class as syzbot-reported relocation UAF)
- Wrong `clear_bit` when `reloc_root` doesn't match → incorrect
  `have_reloc_root()` behavior
- **Severity: HIGH** (filesystem corruption / crash potential)

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents barrier/logic bug in relocation cleanup
- **Risk:** LOW — 3-line effective change, matches existing in-file
  pattern
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable bug in this tree (missing barrier + unconditional
  `clear_bit`)
- Same file already documents correct pattern (`clean_dirty_subvols`)
- Small, surgical fix reviewed by btrfs reviewers
- Same bug class as syzbot-reported relocation UAF (barrier
  inconsistency in reloc-root lifecycle)
- Barrier infrastructure is present in 6.18.44 — bug is live

**AGAINST backport:**
- No direct crash report for this exact path (review-found)
- Depends on `clear_reloc_root()` not in tree (needs minor backport
  adaptation)
- Patch 2/2 ideally accompanies for complete read-side fix
- Only affects balance/relocation (not hot path)

**Unresolved:** No runtime reproduction confirmed for this exact path;
impact inferred from code analysis and related UAF class.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — matches established in-
file pattern; reviewed by Boris Burkov; build-tested in series |
| 2. Fixes real bug affecting users? | **PASS** — barrier + logic error
in relocation cleanup |
| 3. Important issue? | **PASS** — potential UAF/corruption during
balance |
| 4. Small and contained? | **PASS** — 5 lines net in one function |
| 5. No new features/APIs? | **PASS** — correctness fix only |
| 6. Can apply to local tree? | **PASS** (with adaptation) — inline
`smp_wmb()` pattern substitutes for missing `clear_reloc_root()` |

### Step 9.3: Exception Category
**Record:** N/A — standard bug fix.

### Step 9.4: Decision Rationale
The buggy code exists in Linux 6.18.44. The fix corrects a memory-
ordering inconsistency and a logic error (`clear_bit` outside the
matching-reloc-root guard) in btrfs relocation cleanup — the same
synchronization design used elsewhere in `relocation.c`. While the patch
calls `clear_reloc_root()` which is not yet in this tree, the equivalent
inline fix is trivial and already demonstrated in
`clean_dirty_subvols()`. The fix is small, low-risk, and addresses a
HIGH-severity failure mode in filesystem code.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed no syzbot Reported-by; Sashiko Link tag
  present
- **[Phase 2]** Read diff: +2/-3 in `merge_reloc_roots()` zero-ref
  branch
- **[Phase 2]** Read current buggy code at lines 1873–1879 in
  `fs/btrfs/relocation.c`
- **[Phase 2]** Read correct barrier pattern at lines 1474–1480 and
  796–801
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `git blame -L 1873,1880`: lines from 5d324e5159d9e (Nov
  2025)
- **[Phase 3]** `git log --grep="clear_reloc_root"`: no results in tree
- **[Phase 3]** `grep clear_reloc_root fs/btrfs/`: no matches — helper
  absent
- **[Phase 3]** `60a23d4ea169e` confirmed related prior fix already in
  tree
- **[Phase 3]** `git merge-base --is-ancestor b78fe95 HEAD`: exit 1 —
  commit not merged
- **[Phase 4]** `b4 dig -c b78fe95`: found lore URL, patch 1/2 of
  2-patch series
- **[Phase 4]** `b4 dig -a`: v1 only
- **[Phase 4]** `b4 dig -w`: linux-btrfs@vger.kernel.org CC'd
- **[Phase 4]** Read `/tmp/b78fe95.mbox`: cover letter, patch 2/2
  content, Boris Reviewed-by
- **[Phase 4]** spinics.net msg166109: confirmed `clear_reloc_root()`
  introduced in separate UAF series
- **[Phase 5]** `grep merge_reloc_roots(`: 2 call sites (lines 3653,
  4198)
- **[Phase 5]** Read `reloc_root_is_dead()` / `have_reloc_root()` at
  lines 246–274
- **[Phase 6]** Confirmed buggy code present in 6.18.44 checkout
- **[Phase 6]** Confirmed `clear_reloc_root()` absent; inline adaptation
  viable
- **[Phase 8]** Assessed severity from barrier pairing analysis and
  related UAF class (not directly reproduced)

**YES**The background search finished: **`clear_reloc_root` does not
appear anywhere in this 6.18.44 tree** — no commits introduce it under
`fs/btrfs/` or elsewhere.

That matches the earlier analysis: commit `b78fe95` calls a helper that
isn’t here yet (it lands in a separate UAF-fix series). A backport would
need a small adaptation — use the same inline pattern already in
`clean_dirty_subvols()` (`reloc_root = NULL` → `smp_wmb()` →
`clear_bit`) instead of calling `clear_reloc_root()`.

The verdict for this tree remains **YES**, with that minor backport
tweak.

 fs/btrfs/relocation.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 851cef16d4017..6b0bf7eff9d3e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1910,11 +1910,10 @@ void merge_reloc_roots(struct reloc_control *rc)
 		} else {
 			if (!IS_ERR(root)) {
 				if (root->reloc_root == reloc_root) {
-					root->reloc_root = NULL;
+					clear_reloc_root(root);
+					/* Drop the ref for root->reloc_root. */
 					btrfs_put_root(reloc_root);
 				}
-				clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
-					  &root->state);
 				btrfs_put_root(root);
 			}
 
-- 
2.53.0

