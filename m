Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF9F331A76;
	Tue,  5 May 2026 09:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974768; cv=none; b=oq4hAphmYDjWPTUk3wBhwgM6cblz+OS6LwwOMXYQxcnbS9fcNUinIz1SWbA9ZNV7I8MD6HBm38f+GD/ZKULCKZuOT8MhTR6y2aQOnFjKwWc8yXjH91S15xE8HAbWPvf046ti7PbVHxUIUN67nudmb9Htoe0fbiSF0/Dfw/JmNPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974768; c=relaxed/simple;
	bh=3Jwe2AH1ArwNGNZIXmG5PPYRAW7osNQaKvrALtPm2m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drk5uNxUb6xzL5kSo80PJPeT98cOnxWXVO4YDrs8Moov5R43tuE2K2DP9pleBH0SPDNgsp5QI8+0cbn+VD+t3/DxKz7EauNCZ7pGQfkT4iCEcjpGtPeDgUsiHNWMgHXl8p5Mh4//Ojg2/QzSuQpi8T+A2Dtf6cCuVuMLQ24ASQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MneIq/gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MneIq/gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64796C2BCB9;
	Tue,  5 May 2026 09:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974768;
	bh=3Jwe2AH1ArwNGNZIXmG5PPYRAW7osNQaKvrALtPm2m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MneIq/gcYKZBjAWGM88A3JE36mGcG2/VNBNTzNwTUXDAjv7T6gJ+zCkEoek3vheTk
	 t4oJbBi745pLs31o+Gu+CuTwBlR3C4ZLKsGnZS0phCc7MNBlzV3EE07KqNwYFOuXzW
	 XqkLVGgYV710shPTlxgTN3Eqx7lIuSafLlSyXUu9tKVSt4bnWQUYoQUtvmIXcxo42y
	 TUBr5/rZ1/n3mi5SEDpAfgy0Ozxj4cr2najX3XNN0DGhpt0pDCBL2ALysaLlseB21k
	 YQy8uNzM+JfTxIjkwuPtXKa5Yf6ive4wpUJdOH60mEVgD4Uzn00Za0XPJkWg/Ky7Nu
	 GvEgy4Ti+fJkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] btrfs: handle unexpected free-space-tree key types
Date: Tue,  5 May 2026 05:51:34 -0400
Message-ID: <20260505095149.512052-18-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Sterba <dsterba@suse.com>

[ Upstream commit 4d95b9efd783adca472e957b2f576983e789b839 ]

Replace the conditional assertions with proper error handling and
transaction abort if we find an unexpected key type in the free space
tree.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `btrfs`, action verb `handle`, intent:
replace assertions with real error handling for unexpected free-space-
tree key types.

Step 1.2 Record: tags found: `Reviewed-by: Johannes Thumshirn
<johannes.thumshirn@wdc.com>`, `Signed-off-by: David Sterba
<dsterba@suse.com>`. No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`,
or `Cc: stable`.

Step 1.3 Record: the commit says unexpected free-space-tree key types
currently hit conditional assertions; the fix logs an error, returns
`-EUCLEAN`, and aborts the transaction. No user report, stack trace, or
affected version is stated.

Step 1.4 Record: yes, this is a hidden bug fix. `ASSERT(0)` is not
runtime handling in normal non-`CONFIG_BTRFS_ASSERT` builds, so the
unexpected-key branch previously did not return an error or advance
iteration.

## Phase 2: Diff Analysis
Step 2.1 Record: one file changed: `fs/btrfs/free-space-tree.c`, 15
insertions and 3 deletions. Modified functions:
`btrfs_convert_free_space_to_bitmaps()`,
`btrfs_convert_free_space_to_extents()`,
`btrfs_remove_block_group_free_space()`. Scope: single-file surgical
fix.

Step 2.2 Record: each hunk changes `else { ASSERT(0); }` after
recognized free-space-tree item types into `btrfs_err()`, `ret =
-EUCLEAN`, `btrfs_abort_transaction()`, and exit. Affected paths are
transaction-time conversion between free-space extents/bitmaps and
block-group free-space removal.

Step 2.3 Record: bug category is logic/corruption error handling. With
assertions disabled, the unexpected branch leaves `path->slots[0]`
unchanged and continues the inner `while (path->slots[0] > 0)`, which
can loop indefinitely. With assertions enabled, it can `BUG()`. The fix
converts both cases to a controlled filesystem-corruption error and
transaction abort.

Step 2.4 Record: fix quality is high: minimal, consistent with
surrounding transaction-abort handling, no new API, no data structure
change. Regression risk is low; the only changed behavior is for
unexpected on-disk key types.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the affected `ASSERT(0)` branches
were introduced by `a5ed91828518ab` (“Btrfs: implement the free space
B-tree”), first contained in `v4.5-rc1`. Later nearby lines changed, but
the bad branches are old.

Step 3.2 Record: no `Fixes:` tag, so no tagged introducing commit to
follow. Blame identifies `a5ed91828518ab` as the source of these
branches.

Step 3.3 Record: recent file history shows related free-space-tree
churn, but this patch is standalone. The current stable `7.0` tree
accepts the patch with `git apply --check`. Older stable tags contain
the same logical branches but may need context/name adjustment.

Step 3.4 Record: author David Sterba is listed as a Btrfs maintainer in
`MAINTAINERS`; recent history shows many Btrfs commits from him.

Step 3.5 Record: no functional prerequisite was found. The patch uses
existing `btrfs_err()`, `-EUCLEAN`, and `btrfs_abort_transaction()`
paths.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 4d95b9efd783a` found the lore submission at
`https://patch.msgid.link/23bf53315a59a3acc0abdf4f4d8f4c9336c936e1.17761
80388.git.dsterba@suse.com`. It was `v1`, patch `3/6`.

Step 4.2 Record: `b4 dig -w` shows original recipients were David Sterba
and `linux-btrfs@vger.kernel.org`. The saved mbox contains Johannes
Thumshirn’s “Looks good to me” and `Reviewed-by`.

Step 4.3 Record: no reporter or bug-report link exists in the commit or
thread.

Step 4.4 Record: series title was “Debugging macro and kmalloc_obj*
cleanups”. Cover letter explicitly says this patch “updates error
handling” for “impossible” conditions. No dependency on other patches
was found.

Step 4.5 Record: stable lore WebFetch was blocked by Anubis. Web search
found the original patch discussion, but no stable-specific request or
rejection.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified functions:
`btrfs_convert_free_space_to_bitmaps()`,
`btrfs_convert_free_space_to_extents()`,
`btrfs_remove_block_group_free_space()`.

Step 5.2 Record: conversion functions are called from
`update_free_space_extent_count()`, which is reached by free-space-tree
add/remove operations. `btrfs_remove_block_group_free_space()` is called
from block-group removal and relocation paths.

Step 5.3 Record: key callees include `btrfs_search_prev_slot()`,
`btrfs_item_key_to_cpu()`, `btrfs_del_items()`,
`btrfs_search_free_space_info()`, and now `btrfs_abort_transaction()`.

Step 5.4 Record: the affected paths are reachable during Btrfs
allocation/freeing, relocation, balance/remap, and block-group removal.
Trigger requires an unexpected free-space-tree key type in the relevant
block-group key range; I did not verify an unprivileged direct trigger.

Step 5.5 Record: similar `ASSERT(0)` patterns exist elsewhere in older
Btrfs free-space-tree code, but this patch specifically fixes the three
branches where the loop otherwise makes no progress.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: the affected logic exists in stable-era tags checked:
`v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.19`, and `v7.0`. It originated in
`v4.5-rc1`.

Step 6.2 Record: clean apply verified on current `stable/linux-7.0.y`.
For older stable trees, function names differ before `v6.19`
(`convert_free_space_to_bitmaps()` etc.), so minor backport adjustment
is expected.

Step 6.3 Record: current branch search found no existing fix with the
same “unexpected free space tree key type” message.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: subsystem is Btrfs filesystem, criticality IMPORTANT
because it affects users of a production filesystem and can impact
transaction progress and filesystem integrity handling.

Step 7.2 Record: Btrfs is active; recent `fs/btrfs` history includes
multiple fixes and the candidate was merged via the Btrfs maintainer
tree.

## Phase 8: Impact And Risk
Step 8.1 Record: affected users are Btrfs users with the free-space-tree
feature enabled and malformed/unexpected free-space-tree entries.

Step 8.2 Record: trigger is not every boot or every operation; it
requires unexpected free-space-tree key types encountered during
conversion/removal. It can be hit by mounted filesystem state or
corruption; unprivileged trigger was not verified.

Step 8.3 Record: failure mode is severe: non-assert builds can spin in
the inner loop because the slot is not decremented; assert builds can
`BUG()`. Severity: HIGH to CRITICAL depending on build/configuration.

Step 8.4 Record: benefit is high for affected systems because it
prevents a hang/BUG and cleanly aborts a corrupt transaction. Risk is
low because the patch only affects an invalid/corrupt branch and is 15
added lines in one file.

## Phase 9: Final Synthesis
Step 9.1 Record: evidence for backporting: old bug present since
`v4.5-rc1`, affects active stable trees, fixes hang/BUG behavior, small
and contained, authored by Btrfs maintainer, reviewed. Evidence against:
no user report, no `Fixes:` or stable tag, trigger appears to require
corrupted/unexpected on-disk state, older trees need minor backport
context adjustment.

Step 9.2 Record: stable checklist: obviously correct: yes by code
inspection; tested: no explicit `Tested-by`. Real bug: yes, verified
non-progress branch. Important issue: yes, possible hang/BUG.
Small/contained: yes. No new features/APIs: yes. Applies to stable:
clean on `7.0`, minor adjustments likely for older trees.

Step 9.3 Record: no automatic exception category applies; this is not a
device ID, quirk, DT, build, or documentation change.

Step 9.4 Record: decision is YES. The key technical point is that this
is not just replacing a debug assertion: in production builds the
assertion compiles away, leaving a no-progress loop on unexpected free-
space-tree item types. The fix is small and turns a hang/BUG into normal
Btrfs corruption handling.

## Verification
- Phase 1: Parsed `git show --format=fuller` for commit
  `4d95b9efd783adca472e957b2f576983e789b839`; confirmed tags and absence
  of reporter/fixes/stable tags.
- Phase 2: Inspected full diff; confirmed 15 insertions, 3 deletions,
  one file, three functions.
- Phase 2: Read `fs/btrfs/messages.h`; confirmed `ASSERT()` calls
  `BUG()` only under `CONFIG_BTRFS_ASSERT`, otherwise compiles away via
  `BUILD_BUG_ON_INVALID()`.
- Phase 3: Ran `git blame` on all three changed regions; confirmed
  `ASSERT(0)` branches came from `a5ed91828518ab`.
- Phase 3: Ran `git describe --contains a5ed91828518ab`; confirmed first
  contained around `v4.5-rc1`.
- Phase 3: Checked `MAINTAINERS`; confirmed David Sterba is Btrfs
  maintainer.
- Phase 4: Ran `b4 dig -c`, `-a`, `-w`; confirmed v1 patch 3/6,
  recipients, and lore URL.
- Phase 4: Saved and read mbox; confirmed patch text, cover-letter
  context, and Johannes Thumshirn `Reviewed-by`.
- Phase 4: WebFetch to lore/stable was blocked by Anubis; WebSearch
  found original patch mirror and no stable-specific discussion.
- Phase 5: Used `rg` and file reads to trace callers through
  `update_free_space_extent_count()`, free-space add/remove, block-group
  removal, relocation, and extent-tree allocation/freeing paths.
- Phase 6: Scripted checks against `v5.15`, `v6.1`, `v6.6`, `v6.12`,
  `v6.19`, `v7.0`, and `master`; confirmed the affected assertions exist
  in stable-era code and the fix message only in `master`.
- Phase 6: Ran `git apply --check` for the candidate patch on current
  `stable/linux-7.0.y`; it applies cleanly.
- Phase 8: Verified `EUCLEAN` maps to filesystem corruption via
  `include/uapi/asm-generic/errno.h` (`EFSCORRUPTED EUCLEAN`).
- Unverified: no runtime test, no kernel build, no proof of unprivileged
  trigger, and no direct check that every older stable branch applies
  without manual adjustment.

**YES**

 fs/btrfs/free-space-tree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 9efd1ec90f031..472b3060e5ac3 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -259,7 +259,11 @@ int btrfs_convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 				nr++;
 				path->slots[0]--;
 			} else {
-				ASSERT(0);
+				btrfs_err(fs_info, "unexpected free space tree key type %u",
+					  found_key.type);
+				ret = -EUCLEAN;
+				btrfs_abort_transaction(trans, ret);
+				goto out;
 			}
 		}
 
@@ -405,7 +409,11 @@ int btrfs_convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 
 				nr++;
 			} else {
-				ASSERT(0);
+				btrfs_err(fs_info, "unexpected free space tree key type %u",
+					  found_key.type);
+				ret = -EUCLEAN;
+				btrfs_abort_transaction(trans, ret);
+				goto out;
 			}
 		}
 
@@ -1518,7 +1526,11 @@ int btrfs_remove_block_group_free_space(struct btrfs_trans_handle *trans,
 				nr++;
 				path->slots[0]--;
 			} else {
-				ASSERT(0);
+				btrfs_err(trans->fs_info, "unexpected free space tree key type %u",
+					  found_key.type);
+				ret = -EUCLEAN;
+				btrfs_abort_transaction(trans, ret);
+				return ret;
 			}
 		}
 
-- 
2.53.0

