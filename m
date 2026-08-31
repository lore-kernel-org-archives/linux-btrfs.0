Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238F4478E36;
	Mon, 31 Aug 2026 13:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183346; cv=none; b=ZJ04Nofvb73XvWBX621BT3V8WOiTCG49soPTkuRQwMx1VuSfWcjz5WlVmkcyZLcZ8/CdiFC4rAAB/U1mPiUEcfRQ8VpXqpmEp38KJiT4XaGsrRxtm6WYaIpB8i67LZOIswX6ez11ORtMyGu16lgYVpFZfHc4B9nQGJ+ETr0dpxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183346; c=relaxed/simple;
	bh=X4171WGsHTSp1/+if5YR5339+GWSQvBoemWG6Lv1PJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WhAGxMKvH3NUa0hKA86Ly4+132kRLS89L5DBd/0hqP5YDDgd6QLr/B9f+vN23MrREeC76NKZY55VCw7vJW0w0UaZvWvQo5N29DgX1SWRMM7HRfxKBHZ96CjsPLzhqpH7Yq1VKfVeWi7beDrhImBrOQ6sA5KLqXDbTurkrKEHDbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQYrw9Mf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQYrw9Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F9C1F000E9;
	Mon, 31 Aug 2026 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183344;
	bh=8q7qGEwv1jrnrOHSrDnXGmZ2OVQyuSC08lz5mLCUKw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQYrw9MfD0V92csz1WiIzL4W1nDH4LZjapvkHyZlaMSxrzWIKHgETQBY/kHoltLZp
	 OW5V4gAfz8wLFEHzRLy22VQgRxI/7K3D48kYCsfiy6aGwAWSFhpOomJ9wo3S5Z5H6A
	 gr+8zRRjG3bIl9W+rD9Az5V5r+35PHLDs5XMUQfZWpALlMz1Y7gbZQk16GfARIVZi9
	 AFuG7JuXs4Ph04n78VUt1Ap6jBxX7k5/6X5c/bZhFlF3tUfEv2XTwB2xcPCMBDOhuh
	 rfzD05prA5dc6e3Y2HPgmS/yhr574bC4FZwdhUUFjjtXhh+vNlWbHJibUFJf+1vjB7
	 JhotTIiMf7yOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] btrfs: fix transaction abort logic in btrfs_fileattr_set()
Date: Mon, 31 Aug 2026 09:22:00 -0400
Message-ID: <20260831133314.4125787-92-sashal@kernel.org>
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

[ Upstream commit 9d78a98796f215d9973e1e53871b2d63420f3608 ]

There's no need to abort the transaction if we failed to set or delete a
property, as we haven't done any change. However we need to abort if we
set a property or delete a property and then fail to update the inode
item, as that would leave the inode's state in subvolume tree
inconsistent.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `btrfs: fix transaction abort logic in
btrfs_fileattr_set()`

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[btrfs]` `[fix]` — Correct transaction abort handling in
`btrfs_fileattr_set()` when setting/deleting compression properties and
updating the inode item.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Qu Wenruo `<wqu@suse.com>` — btrfs developer
- **Signed-off-by:** Filipe Manana `<fdmanana@suse.com>` — author
- **Reviewed-by:** David Sterba `<dsterba@suse.com>` — btrfs maintainer
- **Signed-off-by:** David Sterba `<dsterba@suse.com>`
- No Fixes:, Reported-by:, Link:, Cc: stable, or Tested-by: tags
- Notable: dual maintainer review (Sterba, Qu Wenruo); no syzbot or user
  bug report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Transaction abort is triggered at the wrong points in
  `btrfs_fileattr_set()`.
- **Symptom (false positive):** Aborting when `btrfs_set_prop()` fails
  even though no metadata was changed — unnecessarily puts the
  filesystem into error/RO state.
- **Symptom (false negative):** Not aborting when `btrfs_set_prop()`
  succeeds but `btrfs_update_inode()` fails — leaves on-disk inode state
  inconsistent between the property item and the inode item.
- **Root cause:** Abort logic tied to property-set failure instead of
  tracking whether a property was actually modified, and missing abort
  after a successful property change followed by inode-update failure.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit bug fix, not disguised cleanup. It
corrects two concrete metadata-consistency / over-abort bugs.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/btrfs/ioctl.c` only (~+10/−5 net, ~20 lines touched)
- **Function:** `btrfs_fileattr_set()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Property set (`comp` non-NULL) | `btrfs_set_prop()` failure →
`btrfs_abort_transaction()` | Failure → `goto out_end_trans` (no abort);
success → `prop_set = true` |
| Property delete (`comp` NULL) | Non-`-ENODATA` failure → abort | Same,
but track `prop_set = (ret == 0)`; `-ENODATA` proceeds without abort |
| `btrfs_update_inode()` | No abort on failure | If `ret && prop_set` →
`btrfs_abort_transaction()` |

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness fix — incorrect transaction abort
  policy
- **False positive:** `btrfs_abort_transaction()` on `btrfs_set_prop()`
  failure when `btrfs_set_prop()` made no durable change (see `props.c`:
  returns early on `btrfs_setxattr()` failure; rolls back on `apply()`
  failure)
- **False negative:** Missing abort after partial transaction success —
  property written via `btrfs_setxattr()` in `btrfs_set_prop()`, but
  inode item update via `btrfs_update_inode()` fails; without abort the
  transaction can commit with inconsistent metadata

### Step 2.4: Fix Quality
**Record:** Obviously correct. `prop_set` accurately tracks whether a
property mutation occurred. Minimal scope. Low regression risk — aligns
with btrfs patterns elsewhere (e.g. `d11aefe654a04` for received-subvol
ioctl abort logic). Removing abort on clean `set_prop` failure is
strictly less aggressive; adding abort after successful `set_prop` +
failed `update_inode` is the standard btrfs consistency response.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy abort-on-`set_prop`-failure pattern present since
`97fc297754878` ("btrfs: convert to fileattr", 2021-04-07), inherited
from pre-fileattr `btrfs_ioctl_setflags()` (`ff9fef559babe`,
2019-04-20). `unlikely()` wrappers added in `a929904cf73b6` (2025-09).
Bug has been in this code path for years.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related Changes
**Record:**
- `d11aefe654a04` — same author (Filipe Manana), same file, fixes
  incorrect transaction abort in another ioctl path; was nominated `Cc:
  stable@vger.kernel.org`
- `014a021075c58` — adds missing abort on inode/root update failure in
  received-subvol ioctl
- `a929904cf73b6` — only added `unlikely()` around existing abort
  branches
- Standalone fix; not part of a series

### Step 3.4: Author Context
**Record:** Filipe Manana is an active btrfs developer with multiple
stable-worthy fixes in this tree. David Sterba is btrfs maintainer and
co-signer.

### Step 3.5: Dependencies
**Record:** None. `btrfs_fileattr_set()`, `btrfs_set_prop()`, and
`btrfs_update_inode()` all exist in this tree. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5
**Record:** Commit hash not present in this checkout (candidate under
evaluation). `b4 dig -c` could not be run without hash. `b4 dig -q`
failed (wrong syntax). lore.kernel.org blocked by bot protection.
**UNVERIFIED:** mailing list thread, stable nominations in review,
series revisions. Reviewed-by tags from btrfs maintainers are present in
the commit message itself.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `btrfs_fileattr_set()` (modified)

### Step 5.2: Callers
**Record:**
- `fs/btrfs/inode.c` — `.fileattr_set = btrfs_fileattr_set` on btrfs
  inode ops
- `ioctl_setflags()` → `vfs_fileattr_set()` → `btrfs_fileattr_set()`
  (`fs/file_attr.c`)
- `ioctl_fssetxattr()`, `file_setattr` syscall also reach
  `vfs_fileattr_set()`

### Step 5.3: Callees
**Record:** `btrfs_start_transaction()`, `btrfs_set_prop()` →
`btrfs_setxattr()`, `btrfs_update_inode()` →
`btrfs_delayed_update_inode()`, `btrfs_abort_transaction()` →
`__btrfs_handle_fs_error()`, `btrfs_end_transaction()`

### Step 5.4: Reachability
**Record:** Userspace-reachable via `FS_IOC_SETFLAGS` /
`FS_IOC_FSSETXATTR` / `file_setattr` on files the caller owns
(`inode_owner_or_capable` in `vfs_fileattr_set`). Compression flag
changes (`FS_COMPR_FL` / `FS_NOCOMP_FL`) trigger the
`btrfs_set_prop("btrfs.compression", ...)` path. Unprivileged file
owners can trigger this for their own files.

### Step 5.5: Similar Patterns
**Record:** Same file has related abort-logic fixes (`d11aefe654a04`,
`014a021075c58`). Pattern throughout btrfs: abort only after metadata
has been modified, not on pre-change failures.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **v6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`, Makefile VERSION=6 PATCHLEVEL=18
SUBLEVEL=44). Current `fs/btrfs/ioctl.c` lines 376–401 show the buggy
pattern: abort on `btrfs_set_prop()` failure, no abort on
`btrfs_update_inode()` failure. No `prop_set` variable present (fix not
yet applied).

### Step 6.2: Backport Complications
**Record:** Clean apply expected — minimal diff against current
`btrfs_fileattr_set()`. No conflicting recent churn in this function.

### Step 6.3: Related Fixes Already Present?
**Record:** Related ioctl abort fixes (`d11aefe654a04`, `014a021075c58`)
are in tree, but this specific `btrfs_fileattr_set()` bug is **not**
fixed. `git log -S 'prop_set' -- fs/btrfs/ioctl.c` returns empty.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `fs/btrfs` — btrfs filesystem. **Criticality: IMPORTANT**
(metadata integrity for all btrfs users).

### Step 7.2: Activity
**Record:** Actively maintained; recent commits in `ioctl.c` include
transaction-abort fixes, indicating ongoing attention to this class of
bug.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** All btrfs users who change file flags (especially
compression flags) via `chattr`, `FS_IOC_SETFLAGS`, or related
interfaces.

### Step 8.2: Trigger Conditions
**Record:**
- **False positive (current bug):** Any `btrfs_set_prop()` failure
  during flag change (e.g. `-ENOSPC`, `-ENOMEM`) → full transaction
  abort → filesystem error/RO via `__btrfs_handle_fs_error()`.
  Relatively uncommon but serious when hit.
- **False negative (current bug):** `btrfs_set_prop()` succeeds, then
  `btrfs_update_inode()` fails → transaction ends without abort → risk
  of committed inconsistent metadata (property vs. inode flags). Rare
  but severe.

### Step 8.3: Failure Mode Severity
**Record:**
- False positive: **CRITICAL** — entire filesystem forced into error
  state for a recoverable per-file operation failure
- False negative: **CRITICAL** — on-disk metadata inconsistency (data
  integrity)

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents filesystem-wide abort on benign errors;
  prevents metadata inconsistency on partial failure
- **Risk:** LOW — ~15 lines, single function, reviewed by maintainers,
  follows established btrfs abort patterns
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes two real bugs with severe consequences (filesystem abort,
  metadata inconsistency)
- Small, surgical, obviously correct
- Reviewed by btrfs maintainers (Sterba, Qu Wenruo)
- Buggy code present in v6.18.44 since 2021
- Userspace-reachable on file flag changes
- Same author/file has prior stable-nominated abort-logic fixes
- No dependencies

**AGAINST backport:**
- No user/syzbot report in commit message (weak signal only)
- Mailing list discussion unverified

**UNRESOLVED:**
- Lore review thread and explicit stable nomination in discussion
  (UNVERIFIED)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainer-
   reviewed (no runtime Tested-by)
2. Fixes a real bug affecting users? **PASS**
3. Important issue? **PASS** — filesystem abort + metadata inconsistency
   (CRITICAL)
4. Small and contained? **PASS** — single function, ~20 lines
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   clean apply expected

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not a quirk/ID/DT/build fix.

### Step 9.4: Decision Rationale
This commit corrects inverted transaction-abort logic in a userspace-
reachable metadata path. The current code unnecessarily aborts the
entire filesystem when property setting fails without making changes,
and fails to abort when a property change succeeds but the inode update
fails — leaving persistent metadata inconsistency. The fix is minimal,
maintainer-reviewed, self-contained, and the buggy code is confirmed
present in this v6.18.44 tree.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 2] Diff analysis: `prop_set` tracking, abort moved from
  `set_prop` failure to `update_inode` failure after successful prop
  change
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 3] `git show 97fc297754878`: abort-on-set_prop-failure present
  since fileattr conversion (2021-04-07)
- [Phase 3] `git show ff9fef559babe`: pattern inherited from
  `btrfs_ioctl_setflags()` (2019)
- [Phase 3] `git show d11aefe654a04`: related stable-nominated abort fix
  by same author in same file
- [Phase 3] `git log -S 'prop_set' -- fs/btrfs/ioctl.c`: empty — fix not
  in tree
- [Phase 4] `b4 dig`: failed (no commit hash / syntax error)
- [Phase 4] lore.kernel.org fetch: blocked by bot protection —
  **UNVERIFIED**
- [Phase 5] `grep btrfs_fileattr_set`: registered in `inode.c`, called
  via `vfs_fileattr_set` from `ioctl_setflags`
- [Phase 5] Read `fs/btrfs/props.c` `btrfs_set_prop()`: failure paths
  make no durable change
- [Phase 5] Read `fs/btrfs/transaction.h` `btrfs_abort_transaction`:
  calls `__btrfs_handle_fs_error()`
- [Phase 5] Read `fs/btrfs/transaction.c` `__btrfs_end_transaction()`:
  `TRANS_ABORTED` path returns `trans->aborted`
- [Phase 6] Read `fs/btrfs/ioctl.c` lines 376–401: buggy code confirmed
  in v6.18.44
- [Phase 6] Makefile VERSION/PATCHLEVEL/SUBLEVEL: 6.18.44
- [Phase 8] `vfs_fileattr_set()` requires `inode_owner_or_capable` —
  file owners can trigger

**YES**The background git search finished. It didn’t find the fix commit
in this tree (expected — it’s still a candidate), but it did turn up one
related earlier change: `9b8a233bc294d` (“btrfs: handle transaction
start error in btrfs_fileattr_set”), which only covers transaction
*start* failures, not the abort-on-`set_prop` / missing-abort-
on-`update_inode` logic this patch addresses.

That doesn’t change the earlier conclusion: the buggy code is present in
v6.18.44, and this fix should be backported.

**YES**

 fs/btrfs/ioctl.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3197f61d612b4..8716241bcbd52 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -264,6 +264,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	int ret;
 	const char *comp = NULL;
 	u32 inode_flags;
+	bool prop_set = false;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
@@ -376,16 +377,15 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	if (comp) {
 		ret = btrfs_set_prop(trans, inode, "btrfs.compression",
 				     comp, strlen(comp), 0);
-		if (unlikely(ret)) {
-			btrfs_abort_transaction(trans, ret);
+		if (ret)
 			goto out_end_trans;
-		}
+		prop_set = true;
 	} else {
 		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL, 0, 0);
-		if (unlikely(ret && ret != -ENODATA)) {
-			btrfs_abort_transaction(trans, ret);
+		prop_set = (ret == 0);
+		/* If ret == -ENODATA ignore and proceed to update inode item. */
+		if (ret && ret != -ENODATA)
 			goto out_end_trans;
-		}
 	}
 
 update_flags:
@@ -395,6 +395,12 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_set_ctime_current(&inode->vfs_inode);
 	ret = btrfs_update_inode(trans, inode);
+	/*
+	 * If we set a property or deleted one, we must abort if we fail to
+	 * update the inode, to avoid persisting an inconsistent state.
+	 */
+	if (unlikely(ret && prop_set))
+		btrfs_abort_transaction(trans, ret);
 
  out_end_trans:
 	btrfs_end_transaction(trans);
-- 
2.53.0

