Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03D3D3012;
	Mon, 30 Mar 2026 12:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874347; cv=none; b=EMFsuwjOyZfT6LTcRRQSueVNnvUtp1HuV/HKAH2il7x9wXx9HVoyEJgSSRFGAH4sFaQkQV05rdknqgdLXZDqNEQogrMNF4K1r5EdY5hMj5j7n9Hb0oJpmCmm1lJh8o+GIkaNz9s8x+zlzKE41NaZ8VQFQyHpOwI7iiBw7ZFHmW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874347; c=relaxed/simple;
	bh=YuWcDvAIA902/gC2iLKD4evUCXTbwoD0XkMsT0s7uyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RT+ogXk9dl0WPP+YNNBCYqs3teGEmA0Lr2hD41c+l+/tuN/WLuESEvwUSomDKjS5AB66kTDbOwv/XOlFvq+nbPQlrX4Pww5iBrVMSIiwLzJSYijrezIF8g4dpjXlcZj+l86E8Jx/coVISwkexf3eebkYeyt3/YA86b0CQ3XsYp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjcfQE6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjcfQE6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62912C2BCB1;
	Mon, 30 Mar 2026 12:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874347;
	bh=YuWcDvAIA902/gC2iLKD4evUCXTbwoD0XkMsT0s7uyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjcfQE6rx0B6XN26PFvqRXklfL8uPsFKYilBOAm6l5cGGVqcWf8gIbdbn49KX3ldc
	 RfItFIHoXUOL8mwQ9lqhQA3E520PExhvM0vq880dlBbZvNCxwCkjJbjUWE6Du/JrxE
	 KpG6/4njysyyxt25ZLN13oFZBSfprn4mNMRfekoUDCMd3By0wRau/rZggf7Z1cS8nj
	 GlQPyf32OSm/RFVzbTFF9+ujmBszBI00XcVahd/PYrNBd46LOBkyr1AzHh34ZCRFHS
	 xWUPsHFn7cSSOU19IMxpiHR6GHB1XSWvWsfUerL1tpgs6xUvfMWb8Pk1s3JVe3Xoxh
	 PZSwkdg0iFj5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] btrfs: fix zero size inode with non-zero size after log replay
Date: Mon, 30 Mar 2026 08:38:30 -0400
Message-ID: <20260330123842.756154-17-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5254d4181add9dfaa5e3519edd71cc8f752b2f85 ]

When logging that an inode exists, as part of logging a new name or
logging new dir entries for a directory, we always set the generation of
the logged inode item to 0. This is to signal during log replay (in
overwrite_item()), that we should not set the i_size since we only logged
that an inode exists, so the i_size of the inode in the subvolume tree
must be preserved (as when we log new names or that an inode exists, we
don't log extents).

This works fine except when we have already logged an inode in full mode
or it's the first time we are logging an inode created in a past
transaction, that inode has a new i_size of 0 and then we log a new name
for the inode (due to a new hardlink or a rename), in which case we log
an i_size of 0 for the inode and a generation of 0, which causes the log
replay code to not update the inode's i_size to 0 (in overwrite_item()).

An example scenario:

  mkdir /mnt/dir
  xfs_io -f -c "pwrite 0 64K" /mnt/dir/foo

  sync

  xfs_io -c "truncate 0" -c "fsync" /mnt/dir/foo

  ln /mnt/dir/foo /mnt/dir/bar

  xfs_io -c "fsync" /mnt/dir

  <power fail>

After log replay the file remains with a size of 64K. This is because when
we first log the inode, when we fsync file foo, we log its current i_size
of 0, and then when we create a hard link we log again the inode in exists
mode (LOG_INODE_EXISTS) but we set a generation of 0 for the inode item we
add to the log tree, so during log replay overwrite_item() sees that the
generation is 0 and i_size is 0 so we skip updating the inode's i_size
from 64K to 0.

Fix this by making sure at fill_inode_item() we always log the real
generation of the inode if it was logged in the current transaction with
the i_size we logged before. Also if an inode created in a previous
transaction is logged in exists mode only, make sure we log the i_size
stored in the inode item located from the commit root, so that if we log
multiple times that the inode exists we get the correct i_size.

A test case for fstests will follow soon.

Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/af8c15fa-4e41-4bb2-885c-0bc4e97532a6@gmail.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: **[btrfs]** **[fix]** Incorrect inode `i_size` after log replay
— a file truncated to zero appears with its old non-zero size after
power failure and log replay, when a new name (hardlink/rename) is
logged for the inode.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reported-by:** Vyacheslav Kovalevsky
  \<slava.kovalevskiy.2014@gmail.com\> — a real user encountered this
  bug
- **Link:** https://lore.kernel.org/linux-
  btrfs/af8c15fa-4e41-4bb2-885c-0bc4e97532a6@gmail.com/ — bug report on
  the btrfs mailing list
- **Signed-off-by:** Filipe Manana \<fdmanana@suse.com\> — author,
  primary btrfs tree-log developer
- **Signed-off-by:** David Sterba \<dsterba@suse.com\> — btrfs
  maintainer
- No Fixes: tag (expected — this is why the commit is under manual
  review)
- No Cc: stable (expected)
- No Tested-by or Reviewed-by

Record: Single user reporter, fix from subsystem's primary tree-log
developer, accepted by maintainer.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit provides a concrete, reproducible scenario:
1. `mkdir /mnt/dir && xfs_io -f -c "pwrite 0 64K" /mnt/dir/foo`
2. `sync`
3. `xfs_io -c "truncate 0" -c "fsync" /mnt/dir/foo` — truncates to 0,
   fsync logs the inode with `i_size = 0`
4. `ln /mnt/dir/foo /mnt/dir/bar` — creates a hard link, triggering
   LOG_INODE_EXISTS logging
5. `xfs_io -c "fsync" /mnt/dir` — syncs the directory log
6. Power failure → after log replay, file has 64K size instead of 0

**Root cause:** When logging "inode exists" (`LOG_INODE_EXISTS`),
`fill_inode_item()` always sets generation=0. During log replay,
`overwrite_item()` sees generation=0 and `ino_size=0` and skips updating
the subvolume tree's `i_size`. The file retains its stale pre-truncate
size.

Record: Data integrity bug — wrong file size after crash recovery. Clear
mechanism, reproducible, user-reported.

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden — explicitly a correctness fix for log replay data
integrity.

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **File:** `fs/btrfs/tree-log.c` only
- **Functions modified:** `fill_inode_item()`, `logged_inode_size()` →
  renamed to `get_inode_size_to_log()`, `btrfs_log_inode()`
- **Scope:** ~70 lines changed across 3 hunks in a single file.
  Surgical, well-contained.

Record: Single-file fix, 3 functions modified, ~+55/-23 lines.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Hunk 1 — `fill_inode_item()`:**
- **Before:** Always `btrfs_set_inode_generation(leaf, item, 0)` when
  `log_inode_only=true`.
- **After:** Default `gen` to the real inode generation. Only set
  generation to 0 if `logged_trans < trans->transid` (i.e., the inode
  was NOT already logged in the current transaction). If it WAS
  previously logged in this transaction, keep the real generation so
  replay will correctly apply the logged `i_size`.

**Hunk 2 — `logged_inode_size()` → `get_inode_size_to_log()`:**
- **Before:** Always searched the log tree; if item not found,
  `*size_ret = 0`.
- **After:** If inode was logged in the current transaction, searches
  the log tree (same as before). If inode is from a past transaction and
  not yet logged, searches the **commit root** of the subvolume tree. If
  inode was created in the current transaction and not yet logged,
  returns 0. Added ASSERT/WARN_ON_ONCE safety checks.

**Hunk 3 — `btrfs_log_inode()`:**
- **Before:** `if (inode_only == LOG_INODE_EXISTS &&
  ctx->logged_before)` — only fetched `logged_isize` if inode was logged
  before.
- **After:** `if (inode_only == LOG_INODE_EXISTS)` — always fetches the
  inode size to log, removing the `logged_before` guard. This ensures
  correct size even on the first exists-only log in a transaction.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Category:** Logic/correctness fix — filesystem log replay invariant
violation leading to data inconsistency.

**Mechanism verified against `overwrite_item()` (lines 628-658 in
current tree):**

```644:658:fs/btrfs/tree-log.c
                if (btrfs_inode_generation(wc->log_leaf, src_item) == 0)
{
                        const u64 ino_size =
btrfs_inode_size(wc->log_leaf, src_item);
                        // ...
                        if (S_ISREG(btrfs_inode_mode(wc->log_leaf,
src_item)) &&
                            S_ISREG(btrfs_inode_mode(dst_eb, dst_item))
&&
                            ino_size != 0)
                                btrfs_set_inode_size(dst_eb, dst_item,
ino_size);
                        goto no_copy;
                }
```

When generation=0 AND `ino_size=0` (for a regular file), the size update
is skipped entirely and execution jumps to `no_copy`. This means the
subvolume tree's stale `i_size` (64K in the example) is preserved. The
fix ensures that when the inode was already logged in the same
transaction (with the truncated size), the real generation is used,
causing replay to take the full-copy path instead of the `no_copy` path.

### Step 2.4: ASSESS THE FIX QUALITY
- **Correctness:** The logic aligns with the documented
  `overwrite_item()` replay semantics. Using `logged_trans` to
  distinguish first-time vs. re-logging is consistent with existing
  patterns in `inode_logged()` (line 3744) which already uses
  `data_race(inode->logged_trans)`.
- **Minimality:** Well-contained to logging paths only.
- **Regression risk:** LOW — changes only affect the LOG_INODE_EXISTS
  code path (triggered by hard links, renames). The ASSERT and
  WARN_ON_ONCE provide debugging safety nets. No lock changes, no API
  changes.

Record: Fix is obviously correct when cross-referenced with
`overwrite_item()` replay code. Minimal regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
Verified via `git blame -L 4612,4625 fs/btrfs/tree-log.c`:
- The generation=0 logic was introduced by **`94edf4ae43a5f9`** (Josef
  Bacik, 2012-09-25) — "Btrfs: don't bother committing delayed inode
  updates when fsyncing"
- Lines 4620-4624 last touched by **`c418a1504540c6`** (David Sterba,
  2025-06-27) — cosmetic accessor conversion, not the logic origin.

Record: The buggy generation=0 behavior has existed since **2012**
(pre-v3.8). Present in ALL active stable trees.

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Verified recent related commits from the same reporter/timeframe:
- **`953902e4fb4c3`** — "btrfs: set inode flag
  BTRFS_INODE_COPY_EVERYTHING when logging new name" — different bug
  (names not persisted), touches `inode.c` and `tree-log.c`
- **`bfe3d755ef7ce`** — "btrfs: do not update last_log_commit when
  logging inode due to a new name" — different bug (directory fsync not
  persisting), 1-line change in `tree-log.c`

These are independent fixes for different bugs, all reported by the same
user during testing.

Record: Standalone fix. Not part of a series. Independent of the two
related commits above.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Filipe Manana is the primary btrfs tree-log developer. He authored
`logged_inode_size()` (commit `1a4bcf470c886`, v4.0) and most of the
tree-log fsync correctness fixes. David Sterba signed off as btrfs
maintainer.

Record: Author is THE subsystem expert for this code. Highest-confidence
authorship signal.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
- Uses `logged_trans`, `data_race()`, `search_commit_root`,
  `skip_locking` — all long-established.
- `ctx->logged_before` was introduced by **`0f8ce49821de3`** (Filipe
  Manana) in **v5.18-rc1**. This field exists in stable trees 6.1+ and
  later.
- `logged_inode_size()` was introduced by **`1a4bcf470c886`** in
  **v4.0-rc1**.

Record: Self-contained. Requires `ctx->logged_before` (v5.18+), so
applies to stable trees 6.1+.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.4: LORE RESEARCH
Both lore.kernel.org URLs returned Anubis bot protection (inaccessible).
The Link: tag in the commit confirms a real bug report exists on the
linux-btrfs mailing list from Vyacheslav Kovalevsky.

Record: Lore inaccessible. Bug report confirmed to exist via Link: tag.
UNVERIFIED: Full review discussion, any explicit stable nominations by
reviewers, any NAKs.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
Functions modified: `fill_inode_item()`, `logged_inode_size()` →
`get_inode_size_to_log()`, `btrfs_log_inode()`.

### Step 5.2: TRACE CALLERS
**`fill_inode_item()`** is called from:
1. `log_inode_item()` (line 4704) — with `log_inode_only=false` (NOT
   affected by this change)
2. `copy_inode_items_to_log()` (line 4966) — with `log_inode_only =
   (inode_only == LOG_INODE_EXISTS)` — **this is the affected path**

**`btrfs_log_inode()`** is called during fsync and directory logging.
The LOG_INODE_EXISTS path is triggered via `btrfs_log_new_name()`.

### Step 5.4: FOLLOW THE CALL CHAIN
Verified call chain for bug reachability:
- `link()` / `rename()` syscall → `btrfs_link()` / `btrfs_rename()` in
  `inode.c` → `btrfs_log_new_name()` (line 7931) → `btrfs_log_inode()`
  with `LOG_INODE_EXISTS` (line 6293) → `logged_inode_size()` (line
  6992) → `fill_inode_item()` (line 4966)

This is a **common userspace operation** — any unprivileged user can
trigger it with `link()` or `rename()` followed by `fsync()`.

Record: Bug reachable from common syscalls (link, rename, fsync).
Unprivileged users can trigger it.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
The `data_race(inode->logged_trans)` pattern already exists at line 3744
in `inode_logged()`. The new code follows the same established pattern.

Record: Consistent with existing code patterns.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
**Verified:** The pre-fix code (`logged_inode_size`, unconditional
generation=0 in `fill_inode_item`, `ctx->logged_before` guard) is still
present in the current tree (`v6.19.10`). `get_inode_size_to_log` does
not exist — the fix has NOT been applied yet.

- The generation=0 behavior dates to `94edf4ae43a5f9` (2012, pre-v3.8) —
  present in ALL stable trees.
- `logged_inode_size()` dates to `1a4bcf470c886` (v4.0) — present in all
  active stable trees.
- `ctx->logged_before` dates to `0f8ce49821de3` (v5.18) — present in
  6.1+ stable trees.

Record: All active stable trees (6.1+, 6.6+, 6.12+) contain the buggy
code.

### Step 6.2: BACKPORT COMPLICATIONS
`tree-log.c` has been actively modified (5+ recent commits since v6.12).
The patch modifies a function signature (`logged_inode_size` →
`get_inode_size_to_log`), changes the condition in `btrfs_log_inode`,
and restructures `fill_inode_item`. May require minor adaptation for
older stables, but the core logic should port cleanly.

Record: Expected backport difficulty: clean apply on recent stables
(6.12+), minor conflicts possible on older (6.1, 6.6).

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No evidence that a different fix for the same bug exists. The confirmed
related commits (`953902e4fb4c3`, `bfe3d755ef7ce`) address different
bugs.

Record: No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM
**Subsystem:** fs/btrfs — filesystem layer, specifically the tree-log
(fsync journal) subsystem.
**Criticality:** IMPORTANT — btrfs is widely used, and crash recovery
correctness is fundamental to filesystem integrity. Wrong file sizes
after recovery = silent data corruption from the user's perspective.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
`tree-log.c` is actively maintained with 30+ recent commits visible in
the log. This is a mature, well-maintained subsystem.

Record: Active subsystem, mature code, high importance for data
integrity.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
All btrfs users who rely on fsync for data integrity and who might
create hard links or rename files after truncating. This is a
fundamental filesystem operation.

Record: Affected population: all btrfs users (filesystem-specific but
btrfs is widely used).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Trigger:** truncate file to 0 → fsync → create hard link or rename →
  fsync directory → power failure
- **How common:** Realistic workflow — the reporter hit it naturally
- **Unprivileged:** Yes, any user can trigger this with normal file
  operations

Record: Realistic trigger, unprivileged, discovered by a real user.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
When triggered: **File appears with wrong (old) size after crash
recovery.** The file was truncated to 0 but shows 64K after log replay.
This is **data integrity corruption** — the filesystem state after
recovery does not match what was committed via fsync.

Record: **Failure mode: data integrity violation (wrong file size after
crash).** **Severity: HIGH** — silent data corruption, stale data
visible, violates fsync durability contract.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **Benefit: HIGH** — prevents data corruption after crash recovery in a
  production filesystem. Fixes a violation of the fsync durability
  guarantee.
- **Risk: LOW** — ~70 lines in one file, authored by the subsystem
  expert, changes only the LOG_INODE_EXISTS logging path. Uses
  established patterns (`data_race(logged_trans)`). Includes
  ASSERT/WARN_ON safety nets. No lock changes, no API changes.
- **Net ratio: Strongly favorable for backporting.**

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes a real, user-reported data integrity bug (wrong file size after
  crash recovery)
- Concrete, reproducible scenario provided in the commit message
- Verified against `overwrite_item()` replay code: generation=0 +
  ino_size=0 → skips `i_size` update → stale data preserved
- Authored by Filipe Manana, THE primary btrfs tree-log developer
- Accepted by David Sterba, btrfs maintainer
- Single file, ~70 lines, well-contained to logging paths
- Buggy code exists in ALL active stable trees (since 2012)
- Uses established patterns (`data_race(logged_trans)`)
- Trigger is realistic and reachable from unprivileged userspace
- Standalone fix with no dependencies beyond existing stable code

**AGAINST backporting:**
- Not trivial (not 1-5 lines) — moderate change size
- Function renamed and restructured (`logged_inode_size` →
  `get_inode_size_to_log`)
- May require minor adaptation for oldest stable trees
- Accesses commit root in a new code path (though safe and read-only)

**UNRESOLVED:**
- Lore discussion inaccessible (Anubis protection) — could not verify
  reviewer comments or explicit stable nominations
- Per-branch clean apply not verified

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — logic verified against
   `overwrite_item()` replay code; authored by subsystem expert; fstests
   mentioned as follow-up
2. **Fixes a real bug that affects users?** YES — user-reported,
   reproducible, data integrity violation
3. **Important issue?** YES — data corruption (wrong file size after
   crash recovery) — HIGH severity
4. **Small and contained?** YES — single file, ~70 lines, 3 functions in
   tree-log.c
5. **No new features or APIs?** YES — purely a bug fix
6. **Can apply to stable trees?** YES — should apply to 6.1+ with
   possible minor adaptation for older trees

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not applicable — this is a standard data integrity bug fix, not an
exception category.

### Step 9.4: DECISION
This is a clear **YES**. It fixes a real, user-reported data integrity
bug where a file's size is incorrect after crash recovery. The fix is
well-contained, authored by the subsystem's primary developer, and meets
all stable kernel criteria. The risk-benefit ratio strongly favors
backporting.

---

## Verification

- **[Phase 1]** Parsed tags: found Reported-by: Vyacheslav Kovalevsky,
  Link: to lore.kernel.org bug report, Signed-off-by from Filipe Manana
  (author) and David Sterba (maintainer)
- **[Phase 2]** Diff analysis: ~70 lines in `fs/btrfs/tree-log.c`,
  modifies `fill_inode_item()`, `logged_inode_size()` →
  `get_inode_size_to_log()`, `btrfs_log_inode()`
- **[Phase 2]** Verified `overwrite_item()` log replay logic at lines
  644-658: generation=0 AND ino_size=0 → skips `btrfs_set_inode_size()`
  → goto `no_copy` → stale size preserved. Confirms the described bug
  mechanism.
- **[Phase 3]** `git blame -L 4612,4625`: generation=0 behavior from
  `94edf4ae43a5f9` (Josef Bacik, 2012-09-25) — present since pre-v3.8
- **[Phase 3]** `git log -S "logged_inode_size"`: introduced by
  `1a4bcf470c886` "Btrfs: fix fsync data loss after adding hard link to
  inode" — `git describe`: v4.0-rc1
- **[Phase 3]** `git log -S "ctx->logged_before"`: introduced by
  `0f8ce49821de3` — `git describe`: v5.18-rc1 — present in stable trees
  6.1+
- **[Phase 3]** Verified `953902e4fb4c3` and `bfe3d755ef7ce` are
  independent fixes for different bugs (same reporter)
- **[Phase 3]** Confirmed Filipe Manana is the primary tree-log
  developer (10+ recent commits in this file)
- **[Phase 4]** Lore.kernel.org inaccessible (Anubis bot protection) —
  UNVERIFIED: full review discussion, explicit stable nominations
- **[Phase 5]** `fill_inode_item()` called from
  `copy_inode_items_to_log()` at line 4966 with `log_inode_only =
  (inode_only == LOG_INODE_EXISTS)` — verified
- **[Phase 5]** Call chain: `link()/rename()` → `btrfs_log_new_name()`
  (line 7931) → `btrfs_log_inode()` → LOG_INODE_EXISTS path (line
  6978/6992) — confirmed reachable from unprivileged syscalls
- **[Phase 5]** `data_race(inode->logged_trans)` pattern already used at
  line 3744 in `inode_logged()` — consistent
- **[Phase 6]** `get_inode_size_to_log` does NOT exist in current tree —
  patch not yet applied. Pre-fix code (`logged_inode_size`,
  generation=0, `ctx->logged_before` guard) all confirmed present.
- **[Phase 6]** Buggy code exists in all active stable trees:
  generation=0 since 2012, `logged_inode_size` since v4.0,
  `ctx->logged_before` since v5.18
- **[Phase 8]** Failure mode: data integrity violation — wrong file size
  after crash recovery. Severity: HIGH.
- **UNVERIFIED:** Lore review discussion content. Per-branch clean apply
  testing. Runtime fstests validation.

**YES**

 fs/btrfs/tree-log.c | 98 ++++++++++++++++++++++++++++++---------------
 1 file changed, 65 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6c40f48cc194d..4cea0489f121c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4609,21 +4609,32 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct inode *inode, bool log_inode_only,
 			    u64 logged_isize)
 {
+	u64 gen = BTRFS_I(inode)->generation;
 	u64 flags;
 
 	if (log_inode_only) {
-		/* set the generation to zero so the recover code
-		 * can tell the difference between an logging
-		 * just to say 'this inode exists' and a logging
-		 * to say 'update this inode with these values'
+		/*
+		 * Set the generation to zero so the recover code can tell the
+		 * difference between a logging just to say 'this inode exists'
+		 * and a logging to say 'update this inode with these values'.
+		 * But only if the inode was not already logged before.
+		 * We access ->logged_trans directly since it was already set
+		 * up in the call chain by btrfs_log_inode(), and data_race()
+		 * to avoid false alerts from KCSAN and since it was set already
+		 * and one can set it to 0 since that only happens on eviction
+		 * and we are holding a ref on the inode.
 		 */
-		btrfs_set_inode_generation(leaf, item, 0);
+		ASSERT(data_race(BTRFS_I(inode)->logged_trans) > 0);
+		if (data_race(BTRFS_I(inode)->logged_trans) < trans->transid)
+			gen = 0;
+
 		btrfs_set_inode_size(leaf, item, logged_isize);
 	} else {
-		btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
 		btrfs_set_inode_size(leaf, item, inode->i_size);
 	}
 
+	btrfs_set_inode_generation(leaf, item, gen);
+
 	btrfs_set_inode_uid(leaf, item, i_uid_read(inode));
 	btrfs_set_inode_gid(leaf, item, i_gid_read(inode));
 	btrfs_set_inode_mode(leaf, item, inode->i_mode);
@@ -5427,42 +5438,63 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int logged_inode_size(struct btrfs_root *log, struct btrfs_inode *inode,
-			     struct btrfs_path *path, u64 *size_ret)
+static int get_inode_size_to_log(struct btrfs_trans_handle *trans,
+				 struct btrfs_inode *inode,
+				 struct btrfs_path *path, u64 *size_ret)
 {
 	struct btrfs_key key;
+	struct btrfs_inode_item *item;
 	int ret;
 
 	key.objectid = btrfs_ino(inode);
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
-	ret = btrfs_search_slot(NULL, log, &key, path, 0, 0);
-	if (ret < 0) {
-		return ret;
-	} else if (ret > 0) {
-		*size_ret = 0;
-	} else {
-		struct btrfs_inode_item *item;
+	/*
+	 * Our caller called inode_logged(), so logged_trans is up to date.
+	 * Use data_race() to silence any warning from KCSAN. Once logged_trans
+	 * is set, it can only be reset to 0 after inode eviction.
+	 */
+	if (data_race(inode->logged_trans) == trans->transid) {
+		ret = btrfs_search_slot(NULL, inode->root->log_root, &key, path, 0, 0);
+	} else if (inode->generation < trans->transid) {
+		path->search_commit_root = true;
+		path->skip_locking = true;
+		ret = btrfs_search_slot(NULL, inode->root, &key, path, 0, 0);
+		path->search_commit_root = false;
+		path->skip_locking = false;
 
-		item = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				      struct btrfs_inode_item);
-		*size_ret = btrfs_inode_size(path->nodes[0], item);
-		/*
-		 * If the in-memory inode's i_size is smaller then the inode
-		 * size stored in the btree, return the inode's i_size, so
-		 * that we get a correct inode size after replaying the log
-		 * when before a power failure we had a shrinking truncate
-		 * followed by addition of a new name (rename / new hard link).
-		 * Otherwise return the inode size from the btree, to avoid
-		 * data loss when replaying a log due to previously doing a
-		 * write that expands the inode's size and logging a new name
-		 * immediately after.
-		 */
-		if (*size_ret > inode->vfs_inode.i_size)
-			*size_ret = inode->vfs_inode.i_size;
+	} else {
+		*size_ret = 0;
+		return 0;
 	}
 
+	/*
+	 * If the inode was logged before or is from a past transaction, then
+	 * its inode item must exist in the log root or in the commit root.
+	 */
+	ASSERT(ret <= 0);
+	if (WARN_ON_ONCE(ret > 0))
+		ret = -ENOENT;
+
+	if (ret < 0)
+		return ret;
+
+	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			      struct btrfs_inode_item);
+	*size_ret = btrfs_inode_size(path->nodes[0], item);
+	/*
+	 * If the in-memory inode's i_size is smaller then the inode size stored
+	 * in the btree, return the inode's i_size, so that we get a correct
+	 * inode size after replaying the log when before a power failure we had
+	 * a shrinking truncate followed by addition of a new name (rename / new
+	 * hard link). Otherwise return the inode size from the btree, to avoid
+	 * data loss when replaying a log due to previously doing a write that
+	 * expands the inode's size and logging a new name immediately after.
+	 */
+	if (*size_ret > inode->vfs_inode.i_size)
+		*size_ret = inode->vfs_inode.i_size;
+
 	btrfs_release_path(path);
 	return 0;
 }
@@ -6975,7 +7007,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			ret = drop_inode_items(trans, log, path, inode,
 					       BTRFS_XATTR_ITEM_KEY);
 	} else {
-		if (inode_only == LOG_INODE_EXISTS && ctx->logged_before) {
+		if (inode_only == LOG_INODE_EXISTS) {
 			/*
 			 * Make sure the new inode item we write to the log has
 			 * the same isize as the current one (if it exists).
@@ -6989,7 +7021,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			 * (zeroes), as if an expanding truncate happened,
 			 * instead of getting a file of 4Kb only.
 			 */
-			ret = logged_inode_size(log, inode, path, &logged_isize);
+			ret = get_inode_size_to_log(trans, inode, path, &logged_isize);
 			if (ret)
 				goto out_unlock;
 		}
-- 
2.53.0

