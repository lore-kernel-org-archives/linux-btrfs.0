Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2604EC649;
	Mon, 31 Aug 2026 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183631; cv=none; b=ueXs2SOgMnl2G58SQo5iS7N52OL6b+kq0LKkKI6UoR3DGh1Lm/CAI7a4JL2LIPF29sSW8Vge0h8F+//Ggoy9ECjF+EEjtvvoX8jMB6qvugMfZLuabC+BkTyMYUGBSIObs2W00y1bA2XqWJQ8DdQFwuHdsdzvETAKylwk6QcmBDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183631; c=relaxed/simple;
	bh=1QTdkGRsu4TQo6/22XFFDcWYbo90ssYkpYX7MmqmHAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdF+TFskTtffytgBaUY8rVNFPYpngMa6Xqb7AlEy24CHkwz8fxh6G2p11dummNPsAiLrtw1fCaD51ELS/earw9Lwx2LDSwRqKlBTlhuWsePl4EgNdUDm6E7VopGoKwekyTE1d1WtABVrZaqqY9EG5BagOTT0j8kQXaPExDGQAf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7ebLtqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7ebLtqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07541F00A3E;
	Mon, 31 Aug 2026 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183629;
	bh=NDPNcSd/zbqvcrVkjrg4815wY35+/5n8NPS4WoxgLSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7ebLtqt99ilU9utRK4prwAimb/1rjzXHn0z8wlcZjJ7+Dyf3EBE4afGBGmXSj8sp
	 1mxc9eBLHguwJIXyKN4XfRnYzr155ETeLGKW84OrLepRGxOzl6qiKFmluCmDZDeKOh
	 mR8r7OZzRDJx8B4d1l+Gk2t65Pzc5CWvuXse+UrGRxHREOD1Cf45rWDgmeXzXT9BAy
	 LqOKGi/qV5tIaicuxmqvOyx7wjdvR6zzV8BiKt+l/vBgOo3WtOZhW8qu3ZvYft7Dl2
	 Bz9ahb6ww0rirPoks2C1pyUf7ZniJhmjQE3el5JvYwrTbj+qo8Os89miDNuYKUMtVw
	 vpyL9OLeY6h4w==
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
Subject: [PATCH AUTOSEL 6.18] btrfs: validate properties before setting them
Date: Mon, 31 Aug 2026 09:23:56 -0400
Message-ID: <20260831133314.4125787-208-sashal@kernel.org>
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

[ Upstream commit cf1afec09e9f004a62c54c471863209ed249fca7 ]

We set the xattr and then attempt to apply the property. If the apply
fails we then attempt to delete the xattr to avoid an inconsistency.
However we don't verify if the deletion succeed, so if it fails we
leave an inconsistency between the state in the btree and the in-memory
inode.

Address this by validating first if we can apply the property, then set
the xattr, then apply the property, and this last step should not fail
since the validation succeeded before - assert that it does not fail but
leave code to attempt to delete the xattr if it happens, and then abort
the transaction only if the xattr delete failed.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `btrfs: validate properties before setting
them`

**Local tree:** `v6.18.44` (`6.18.44`) — checked-out stable tree, not
mainline.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[btrfs] [validate] validate properties before setting them`
— btrfs filesystem property handling; action is validation/reordering of
set path to prevent inconsistency.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Reviewed-by:** Qu Wenruo `<wqu@suse.com>`
- **Reviewed-by:** David Sterba `<dsterba@suse.com>` (btrfs maintainer)
- **Signed-off-by:** Filipe Manana `<fdmanana@suse.com>` (author)
- **Signed-off-by:** David Sterba `<dsterba@suse.com>`
- **No** `Fixes:` tag
- **No** `Reported-by:` tag
- **No** `Cc: stable@vger.kernel.org`
- **No** syzbot / sanitizer links

Notable: dual maintainer review (Qu Wenruo + David Sterba); no
user/fuzzer report.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `btrfs_set_prop()` writes the xattr to the btree first, then
  calls `handler->apply()`. On apply failure it attempts to delete the
  xattr, but ignores whether deletion succeeded.
- **Symptom:** If rollback deletion fails, the on-disk btree has the
  xattr while the in-memory inode state was not updated by `apply()` —
  metadata inconsistency.
- **Fix approach:** Validate first (`handler->validate()`), then set
  xattr, then apply (should not fail after validation). On unexpected
  apply failure, try xattr delete; if delete also fails, call
  `btrfs_abort_transaction()`.
- **Version info:** None stated in message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit correctness/consistency
bug fix in error handling, though it also restores validate-before-
setxattr ordering that existed in the original 2014 property code.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `fs/btrfs/props.c` only (+13 / −3 lines)
- **Function modified:** `btrfs_set_prop()`
- **Scope:** Single-file, surgical fix in one function's non-zero-value
  path.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Hunk 1 (validate before xattr):**
- **Before:** Set xattr → apply → on failure, attempt xattr delete
  (ignore result).
- **After:** Validate → set xattr → apply → on failure, attempt delete
  and abort transaction if delete fails.

**Record:** Normal property-set path for `value_len > 0`; error path
improved. The `value_len == 0` (property removal) path is unchanged.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Logic/correctness fix + error-path resource/state
  consistency fix.
- **Mechanism:** Incomplete rollback on apply failure leaves btree xattr
  present while in-memory inode property state is stale. Fix validates
  early (reducing apply failures), and escalates to
  `btrfs_abort_transaction()` when rollback cannot complete.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is minimal and obviously correct.
- Restores validate-before-setxattr ordering that existed in the
  original 2014 `__btrfs_set_prop()` before validation was moved
  external in 2019 (`f22125e5d8ae1`).
- `ASSERT(ret == 0)` matches existing pattern in the `value_len == 0`
  branch.
- `btrfs_abort_transaction()` on failed cleanup is consistent with
  `xattr.c` and `ioctl.c` error handling.
- **Regression risk:** Very low. Duplicate validation on the xattr path
  is harmless. Abort-on-failed-rollback is conservative but appropriate
  for metadata inconsistency.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- Core `btrfs_set_prop()` logic dates to **2014** (`63541927c8d11d` —
  Filipe Manana, "Btrfs: add support for inode properties").
- Original 2014 code **did** call `handler->validate()` before
  `setxattr`.
- The rollback-without-checking-delete pattern has existed since 2014.
- Validation was **removed** from inside `btrfs_set_prop()` in **2019**
  (`f22125e5d8ae1` — "refactor btrfs_set_props to validate externally").
- Recent `props.c` changes (2022–2025) are struct/type refactors, not
  related to this bug.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present — N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Related historical fix: `3763771cf6023` (2019) — different issue
  (fsync/log persistence of compression xattr deletion).
- Patch is **1/3** of series "[PATCH 0/3] btrfs: fixes and cleanups
  setting/clearing properties".
- Patches 2/3 and 3/3 touch `ioctl.c` (`btrfs_fileattr_set()`), not
  `props.c` — **this patch is standalone**.
- Commit is **not yet present** in this tree (`git log --grep` found
  nothing).

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Filipe Manana is an active btrfs developer with multiple
btrfs fixes in history. David Sterba is btrfs maintainer and signed off.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:**
- `handler->validate` callback exists in `prop_handler` struct in this
  tree.
- `prop_compression_validate()` exists and is wired up.
- `btrfs_abort_transaction()` is available via existing includes.
- **No prerequisites** — patch applies cleanly (`git apply --check`
  succeeded).
- Patches 2/3 and 3/3 are independent ioctl cleanups.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- **URL:** https://www.spinics.net/lists/linux-btrfs/msg166052.html
- **Series cover:** https://www.spinics.net/lists/linux-
  btrfs/msg166051.html
- **Date:** Mon, 8 Jun 2026
- **Series:** v1, 3 patches; patch 1 is this commit.
- `b4 dig` could not be used (commit not in local tree).
- No explicit stable nomination found in fetched thread snippets.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** Author Filipe Manana; Reviewed-by Qu Wenruo and David Sterba
(maintainer). Appropriate reviewers for btrfs properties code.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No `Reported-by:` or `Link:` tags. Bug identified by code
analysis, not a user crash report or syzbot hit.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:**
- Patch 2/3: `btrfs: don't over reserve metadata space for property in
  btrfs_fileattr_set()` — ioctl.c only.
- Patch 3/3: `btrfs: fix transaction abort logic in
  btrfs_fileattr_set()` — ioctl.c only.
- This patch is self-contained for the `btrfs_set_prop()` inconsistency.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** lore.kernel.org blocked by bot protection; no stable-list
discussion verified. Not a negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `btrfs_set_prop()` — only function modified.

### Step 5.2: TRACE CALLERS
**Record:**
1. **`btrfs_xattr_handler_set_prop()`** (`xattr.c:451`) — userspace
   `setfattr` / `setxattr` on `btrfs.compression`. Already calls
   `btrfs_validate_prop()` first (line 440). Reachable from userspace.
2. **`btrfs_fileattr_set()`** (`ioctl.c:377,384`) — `FS_IOC_SETFLAGS` /
   file attributes ioctl path. Calls `btrfs_set_prop()` **without**
   prior `btrfs_validate_prop()`, but passes known-good strings from
   `btrfs_compress_type2str()`. Reachable from userspace.

### Step 5.3: TRACE CALLEES
**Record:** `handler->validate()`, `btrfs_setxattr()`,
`handler->apply()`, `btrfs_abort_transaction()`,
`set_bit(BTRFS_INODE_HAS_PROPS)`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Userspace sets btrfs inode properties via xattr or ioctl →
transaction started → `btrfs_set_prop()` → btree xattr + in-memory inode
flags. Buggy path is reachable from unprivileged userspace (with write
access to the file/inode).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `btrfs_inode_inherit_props()` (`props.c:440–446`) has the
same unchecked-rollback pattern (`apply` fails → `btrfs_setxattr` delete
without checking result). **Not fixed by this commit.** Separate issue;
does not block this fix.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** Current `fs/btrfs/props.c` lines 130–138 show
setxattr → apply → unchecked rollback delete. Bug present since property
support was added; validate-before-setxattr was removed in 2019 refactor
still present in 6.18.44.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply** — `git apply --check` passed with no
conflicts. No structural divergence from patch context.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No equivalent fix found (`git log --grep` for subject
returned empty). Bug remains unfixed in v6.18.44.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Filesystem — btrfs** (`fs/btrfs/`). **Criticality:
IMPORTANT** — btrfs metadata consistency affects data integrity for all
btrfs users.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** `props.c` actively maintained (refactors in 2022–2025).
Property code is mature but still receiving correctness fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users setting btrfs inode properties (compression xattr via
`setfattr`/`setxattr`, or compression flags via ioctl). **CONFIG_BTRFS**
users.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
1. `handler->apply()` fails after xattr was written (more likely on
   ioctl path without internal validate; rare on xattr path where
   external validate already ran).
2. Rollback `btrfs_setxattr(..., NULL, 0)` also fails (e.g., metadata
   ENOSPC, transaction error).
- **Likelihood:** Low but realistic on error paths (space pressure, I/O
  errors).
- **Userspace triggerable:** Yes, with write permission on the inode.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **Metadata inconsistency** — on-disk compression xattr
present but in-memory inode compression state not updated (or vice versa
after partial failure). Can cause incorrect compression behavior and
inconsistent state across remounts/replays. **Severity: HIGH** (metadata
integrity; corruption-class issue, not a simple WARN).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Prevents silent btree/in-memory desync; escalates to
  transaction abort when cleanup impossible. Restores internal
  validation defense-in-depth.
- **Risk:** Very low — 16-line change, one function, reviewed by btrfs
  maintainers, applies cleanly.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Fixes real metadata inconsistency bug in `btrfs_set_prop()`.
- Affects userspace-reachable property-set paths.
- Small, surgical, maintainer-reviewed fix.
- Applies cleanly to v6.18.44.
- Buggy code confirmed present in this tree.
- `btrfs_abort_transaction()` on failed rollback prevents silent
  corruption.
- Restores validate-before-setxattr ordering (original 2014 design).

**AGAINST backport:**
- No user crash report or syzbot reproduction.
- Trigger requires apply failure **and** rollback delete failure (narrow
  window).
- xattr path already validates externally (main value is rollback abort
  + ioctl-path internal validate).
- Related pattern in `btrfs_inode_inherit_props()` remains unfixed
  (separate issue).

**Unresolved:**
- Whether commit has landed in mainline yet (not in this v6.18.44
  checkout; expected for candidate evaluation).
- No stable-list nomination verified (lore blocked).

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic is clear; reviewed by
   Qu Wenruo and David Sterba.
2. Fixes a real bug affecting users? **PASS** — metadata inconsistency
   on property set error path.
3. Important issue? **PASS** — metadata integrity / corruption-class
   inconsistency.
4. Small and contained? **PASS** — 16 lines, one file.
5. No new features or APIs? **PASS** — error-handling reorder only.
6. Can apply to local tree? **PASS** — clean apply verified.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies on metadata integrity grounds.

### Step 9.4: DECISION RATIONALE

For **v6.18.44**, the buggy code is present, the fix is small and self-
contained, btrfs maintainers reviewed it, and it addresses a real
metadata consistency failure mode on a userspace-reachable path. The
failure mode — silent desync between btree xattrs and in-memory inode
state — is exactly the class of issue stable btrfs trees should fix.
Patches 2/3 and 3/3 are not prerequisites.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message.
- **[Phase 1]** No Fixes:/Reported-by:/Cc: stable tags found.
- **[Phase 2]** Read current `fs/btrfs/props.c` lines 107–144; confirmed
  pre-fix code matches described bug.
- **[Phase 2]** Diff is +13/−3 in `btrfs_set_prop()` only.
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`.
- **[Phase 3]** `git blame -L 107,145 fs/btrfs/props.c` → core logic
  from 2014 (`63541927c8d11d`).
- **[Phase 3]** `git show 63541927c8d11d` → original code had validate-
  before-setxattr.
- **[Phase 3]** `git show f22125e5d8ae1` → 2019 refactor moved
  validation external.
- **[Phase 3]** `git log --grep="validate properties"` → empty (commit
  not in tree).
- **[Phase 3]** `git apply --check` on provided diff → clean apply.
- **[Phase 4]** curl spinics msg166051 (cover), msg166052 (patch 1/3) →
  series context, standalone patch 1.
- **[Phase 4]** curl spinics msg166053, msg166054 → patches 2/3 and 3/3
  are ioctl.c only.
- **[Phase 4]** `b4 dig` not usable — commit hash not in local tree.
- **[Phase 4]** lore.kernel.org fetch blocked by Anubis — stable-list
  search unverified.
- **[Phase 5]** `grep btrfs_set_prop` → callers in `xattr.c:451`,
  `ioctl.c:377,384`.
- **[Phase 5]** Read `xattr.c:429–462` → external
  `btrfs_validate_prop()` before `btrfs_set_prop()`.
- **[Phase 5]** Read `ioctl.c:256–401` → `btrfs_fileattr_set()` calls
  `btrfs_set_prop()` without validate.
- **[Phase 5]** Read `prop_compression_validate()` /
  `prop_compression_apply()` → validate is stricter (checks
  `btrfs_inode_can_compress`).
- **[Phase 5]** Found similar unchecked rollback in
  `btrfs_inode_inherit_props()` lines 440–446 (not fixed here).
- **[Phase 6]** Buggy code confirmed at `props.c:130–138` in v6.18.44.
- **[Phase 6]** `git apply --check` → applies cleanly.
- **[Phase 8]** Failure mode: btree/in-memory metadata inconsistency;
  severity HIGH.

**YES**

 fs/btrfs/props.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index adc956432d2f1..bb77d46376d4b 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -127,14 +127,24 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct btrfs_inode *inode,
 		return ret;
 	}
 
+	ret = handler->validate(inode, value, value_len);
+	if (ret)
+		return ret;
 	ret = btrfs_setxattr(trans, &inode->vfs_inode, handler->xattr_name, value,
 			     value_len, flags);
 	if (ret)
 		return ret;
 	ret = handler->apply(inode, value, value_len);
-	if (ret) {
-		btrfs_setxattr(trans, &inode->vfs_inode, handler->xattr_name, NULL,
-			       0, flags);
+	/* We validated before, so it should not fail here. */
+	ASSERT(ret == 0);
+	if (unlikely(ret)) {
+		int ret2;
+
+		/* Try to delete xattr, if not possible abort transaction. */
+		ret2 = btrfs_setxattr(trans, &inode->vfs_inode, handler->xattr_name,
+				      NULL, 0, flags);
+		if (unlikely(ret2))
+			btrfs_abort_transaction(trans, ret2);
 		return ret;
 	}
 
-- 
2.53.0

