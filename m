Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EA932F749;
	Tue,  5 May 2026 09:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974789; cv=none; b=Evkfx0x3b99LixyydQQAnjW8n07Ft5FO+RptVxC585jMa8yZG3NaoTN9SdtLgePHCDtsV6/jZCG6JHeLv+lk2QvYCT3WjJ0uPMprAs7r+RBJCBVuQ6OP0BXV7W4MM+CWewO5fVXuQ3yZOTkgP+GjoTPeVbW2CnJkZx62HCwp2qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974789; c=relaxed/simple;
	bh=0sQg5E72+QtabmX/9fz8doQcyuXGFgL4tMF72in1JlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Td+SB079hGGMuF0C4XU3Y0mcucOnlTJam5waMyjBmXlPdvHyNv3QiLS/ISc5SkR0FJM0mFrgtDtN8oS/e6SJHQ7P/BRIfnX54zXR7aHy6iHaJ2nCsZwNdtkKqdEW5SIJ3SajZ7J9ANzWL2irY3z495JFye/325xWcyQIcThAlK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TU5f765g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TU5f765g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6EBC2BCB4;
	Tue,  5 May 2026 09:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974789;
	bh=0sQg5E72+QtabmX/9fz8doQcyuXGFgL4tMF72in1JlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TU5f765g6kFS25BJOseSiXjXtmtWn2tglL4ZZRJAhrCTZXwuLJEtSD2dO5wOH9D5y
	 IyZcpJLb6/OfUJXcYDiYM8nV4tr81pAff05tj8xN2mSKyIMV7owqb++P7yakO2gx/t
	 nJ3dSGh5cE3PDt8RG7MmUNviYesCvhAKz2Z/X/o+fnf9tk+Q9w51630BeZdAv+A2vE
	 L0831g0EGlfvq6ASj4PvIUf6y7irDC8Wbg3yAecpVTpguvvyQCyNGgP3e+7tHO0kFQ
	 8/ZhQ/tBHe7xM5s/MSmD3k2JPUTd7l2H7nnwu4WdM+AmXqeEk9fNRBl7Zx5lCti9oy
	 PENl+0cs0ilug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: robbieko <robbieko@synology.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] btrfs: fix raid stripe search missing entries at leaf boundaries
Date: Tue,  5 May 2026 05:51:41 -0400
Message-ID: <20260505095149.512052-25-sashal@kernel.org>
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

From: robbieko <robbieko@synology.com>

[ Upstream commit 2aef5cb1dcf9b3e1be3895a6477dc065e618aab8 ]

In btrfs_delete_raid_extent(), the search key uses offset=0. When the
target stripe entry is the first item on a leaf, btrfs_search_slot()
may land on the previous leaf and decrementing the slot from nritems
still points to the wrong entry, causing the stripe extent to be
silently missed.

Fix this by searching with offset=(u64)-1 instead. Since no real stripe
entry has this offset, btrfs_search_slot() always returns 1 with the
slot pointing past the last matching objectid entry. Then unconditionally
decrement the slot with a proper slots[0]==0 early-exit check to handle
the case where no matching entry exists.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: robbieko <robbieko@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Decision Summary
Backport this to stable trees that contain the
`btrfs_delete_raid_extent()` `offset = 0` search logic, verified locally
in `v6.13` through `v7.0`. It is a small Btrfs filesystem metadata
correctness fix: a leaf-boundary search miss can leave a RAID stripe-
tree entry undeleted, and that tree is used later to derive read-side
physical stripe mappings.

The main caveat is scope: RAID stripe tree support is behind
`CONFIG_BTRFS_EXPERIMENTAL`, so the affected population is config and
filesystem-feature specific. Still, for those users, the benefit
outweighs the low patch risk.

## Phase Walkthrough
Phase 1: Commit Message Forensics

- Step 1.1 Record: subsystem `btrfs`; action verb `fix`; intent is to
  prevent RAID stripe-tree deletion from missing entries at B-tree leaf
  boundaries.
- Step 1.2 Record: tags are `Reviewed-by: Johannes Thumshirn
  <johannes.thumshirn@wdc.com>`, `Signed-off-by: robbieko
  <robbieko@synology.com>`, `Signed-off-by: David Sterba
  <dsterba@suse.com>`. No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable`, or `Link:` tags.
- Step 1.3 Record: the described bug is that searching with `offset = 0`
  can land on the previous leaf when the target stripe item is the first
  item in the next leaf; the existing decrement then inspects the wrong
  entry and silently misses the stripe extent. No affected kernel
  versions are stated in the message.
- Step 1.4 Record: this is not hidden cleanup; it is an explicit
  correctness bug fix.

Phase 2: Diff Analysis

- Step 2.1 Record: one file changed, `fs/btrfs/raid-stripe-tree.c`,
  +15/-3 in `btrfs_delete_raid_extent()`. Scope is single-function
  surgical.
- Step 2.2 Record: before, the delete loop searched `(objectid=start,
  type=RAID_STRIPE, offset=0)` and only decremented the slot when the
  slot was at `nritems`. After, it searches with `offset=(u64)-1`,
  checks `slots[0] == 0`, then always decrements to the last candidate
  item.
- Step 2.3 Record: bug category is logic/correctness in B-tree search
  positioning. The fix uses Btrfs key ordering by `objectid`, then
  `type`, then `offset`, and `btrfs_bin_search()` semantics where a
  missing key returns the insertion slot.
- Step 2.4 Record: fix quality is good for valid filesystem state:
  small, local, no API changes. Regression risk is low. One review
  concern exists: David Sterba noted that an exact corrupt
  `offset=(u64)-1` key should ideally be handled as `-EUCLEAN`; that is
  robustness against corrupted/fuzzed images, not the normal valid-state
  bug being fixed.

Phase 3: Git History Investigation

- Step 3.1 Record: blame shows the delete function was introduced by
  `ca41504efda646` in `v6.7`, but the specific `key.offset = 0` logic
  and `nritems` decrement pattern were introduced by `6aea95ee318890`
  (`btrfs: implement partial deletion of RAID stripe extents`), first
  contained in `v6.13`.
- Step 3.2 Record: no `Fixes:` tag, so no tagged original commit to
  follow. Blame nevertheless identifies `6aea95ee318890` as the relevant
  introducer.
- Step 3.3 Record: related recent commits in master are a six-patch
  deletion-path fix series: copy missing devid, this leaf-boundary
  search fix, wrong `btrfs_previous_item()` min objectid, ASSERT-to-
  error handling, `-EAGAIN`/stale leaf handling, and return-value
  checking.
- Step 3.4 Record: author `robbieko` authored all six related RAID
  stripe-tree deletion fixes in that series. I did not verify them as a
  subsystem maintainer; David Sterba committed the series and Johannes
  reviewed this patch.
- Step 3.5 Record: candidate applies standalone to the current `7.0.3`
  worktree via `git apply --check`; companion patches are related fixes
  but not prerequisites for this hunk.

Phase 4: Mailing List And External Research

- Step 4.1 Record: `b4 dig -c 2aef5cb1dcf9b` found the original
  submission at `https://patch.msgid.link/20260413065249.2320122-3-
  robbieko@synology.com`. `b4 dig -a` found only v1 of the six-patch
  series.
- Step 4.2 Record: `b4 dig -w` showed original recipients were
  `robbieko` and `linux-btrfs@vger.kernel.org`. The thread later
  includes Johannes Thumshirn and David Sterba review/maintainer
  feedback.
- Step 4.3 Record: no separate bug report or syzbot report was linked.
- Step 4.4 Record: series context confirms this is patch 2/6 in “fix
  multiple bugs in raid-stripe-tree deletion path.” Johannes asked for
  tests for the conditions; Johannes also gave `Reviewed-by` on this
  patch. David later said the series was added to `for-next`.
- Step 4.5 Record: direct lore stable search was blocked by Anubis; web
  search did not find stable-specific discussion. This remains
  unverified.

Phase 5: Code Semantic Analysis

- Step 5.1 Record: modified function is `btrfs_delete_raid_extent()`.
- Step 5.2 Record: callers are `do_free_extent_accounting()` in
  `fs/btrfs/extent-tree.c` and RAID stripe-tree selftests.
  `do_free_extent_accounting()` is reached when a data extent’s refs
  drop to zero in `__btrfs_free_extent()`.
- Step 5.3 Record: key callees include `btrfs_search_slot()`,
  `btrfs_item_key_to_cpu()`, `btrfs_del_item()`,
  `btrfs_previous_item()`, and partial deletion helpers.
- Step 5.4 Record: user reachability is through Btrfs extent
  deletion/accounting paths; `file.c` calls `btrfs_free_extent()` while
  dropping file extents. Exact VFS entrypoints were not fully traced,
  but the path is filesystem-operation reachable on RST-enabled
  filesystems.
- Step 5.5 Record: similar verified patterns include
  `btrfs_search_prev_slot()` checking `slot == 0` before decrementing.
  `zoned.c` also demonstrates the Btrfs pattern of treating impossible
  exact matches as `-EUCLEAN`, matching David’s review concern.

Phase 6: Stable Tree Analysis

- Step 6.1 Record: `v6.6` lacks this file/feature; `v6.12` has
  `key.offset = length`; `v6.13` through `v7.0` have `key.offset = 0`
  plus the vulnerable `nritems` decrement. Candidate is in `v7.1-rc2`,
  not in `v7.0`.
- Step 6.2 Record: backport difficulty is clean for current `7.0.3` by
  `git apply --check`; older affected trees appear to have the same
  local search pattern, but exact apply was not checked on separate
  worktrees.
- Step 6.3 Record: no alternate stable fix for the same subject was
  found locally; stable-list search was blocked, so external stable
  history is partially unverified.

Phase 7: Subsystem Context

- Step 7.1 Record: subsystem is Btrfs filesystem, specifically RAID
  stripe tree. Criticality is important for users of that filesystem
  feature, but not universal.
- Step 7.2 Record: file history shows active development and several
  recent bug fixes in the same deletion path, indicating this code is
  relatively new and still being hardened.

Phase 8: Impact And Risk

- Step 8.1 Record: affected population is config-specific and feature-
  specific: Btrfs filesystems using `RAID_STRIPE_TREE`, which is
  supported only when `CONFIG_BTRFS_EXPERIMENTAL` is enabled.
- Step 8.2 Record: trigger is deleting/freeing data extents where the
  matching stripe item is first in a leaf. Commonness of the leaf-
  boundary condition is data-layout dependent. User triggering is
  partially verified via file extent deletion paths, subject to
  filesystem permissions and the RST feature being enabled.
- Step 8.3 Record: failure mode is stale/missed RAID stripe-tree
  deletion. Severity is high for affected users because
  `btrfs_get_raid_extent_offset()` is used for read mapping and sets
  `stripe->physical` from stripe-tree contents.
- Step 8.4 Record: benefit is medium-high for affected RST users; risk
  is low because the change is +15/-3, one function, no ABI/API change,
  and accepted by Btrfs maintainers.

Phase 9: Final Synthesis

- Step 9.1 Record: evidence for backporting: real metadata correctness
  bug, verified affected stable code in `v6.13`-`v7.0`, small fix,
  reviewed by Johannes, committed by David, clean apply to current
  stable worktree. Evidence against: experimental/config-specific
  feature, no `Reported-by`/`Tested-by`, no explicit stable nomination,
  companion fixes in same area, and one unaddressed corrupt-image
  robustness comment.
- Step 9.2 Record: stable rules: obviously correct for valid state yes;
  fixes real bug yes; important issue yes for RST metadata/read mapping
  correctness; small and contained yes; no new feature/API yes; applies
  to current stable tree yes.
- Step 9.3 Record: no exception category like device ID, quirk, DT,
  build, or docs applies.
- Step 9.4 Record: decision is YES, limited to stable trees containing
  the `offset = 0` deletion search logic.

## Verification
- Phase 1: Parsed `git show 2aef5cb1dcf9b` and confirmed tags, subject,
  message, and +15/-3 diff.
- Phase 2: Read `fs/btrfs/raid-stripe-tree.c` and confirmed the exact
  modified code in `btrfs_delete_raid_extent()`.
- Phase 3: Ran blame around the changed lines; confirmed
  `6aea95ee318890` introduced `offset = 0`, and tag containment starts
  at `v6.13`.
- Phase 3: Inspected `ca41504efda646` and confirmed the function existed
  earlier with a different `offset = length` search.
- Phase 4: `b4 dig -c 2aef5cb1dcf9b` found the patch thread; `-a` found
  only v1; `-w` showed original recipients.
- Phase 4: Saved and searched the mbox; confirmed Johannes’ `Reviewed-
  by`, test request, David’s `EUCLEAN` robustness comment, and David’s
  “Added to for-next”.
- Phase 5: Used code search and reads to trace
  `btrfs_delete_raid_extent()` from `do_free_extent_accounting()` and
  `__btrfs_free_extent()`, with file deletion paths calling
  `btrfs_free_extent()`.
- Phase 5: Verified read-side RST use: `set_io_stripe()` calls
  `btrfs_get_raid_extent_offset()` for reads, and that function sets
  `stripe->physical` from the stripe-tree item.
- Phase 6: Checked historical tags: `v6.12` uses `offset = length`;
  `v6.13`-`v7.0` use `offset = 0` and the vulnerable slot handling.
- Phase 6: Ran `git apply --check` for the upstream patch against
  current `7.0.3`; it succeeded.
- UNVERIFIED: Direct lore stable search was blocked by Anubis, so
  stable-list discussion could not be confirmed.
- UNVERIFIED: Exact apply status on every older affected stable tree was
  not checked in separate worktrees.

**YES**

 fs/btrfs/raid-stripe-tree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index d2b8995febec9..dd924048c6659 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -95,14 +95,26 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 	while (1) {
 		key.objectid = start;
 		key.type = BTRFS_RAID_STRIPE_KEY;
-		key.offset = 0;
+		key.offset = (u64)-1;
 
 		ret = btrfs_search_slot(trans, stripe_root, &key, path, -1, 1);
 		if (ret < 0)
 			break;
 
-		if (path->slots[0] == btrfs_header_nritems(path->nodes[0]))
-			path->slots[0]--;
+		/*
+		 * Search with offset=(u64)-1 ensures we land on the correct
+		 * leaf even when the target entry is the first item on a leaf.
+		 * Since no real entry has offset=(u64)-1, ret is always 1 and
+		 * slot points past the last entry with objectid==start (or
+		 * past the end of the leaf if that entry is the last item).
+		 * Back up one slot to find the actual entry.
+		 */
+		if (path->slots[0] == 0) {
+			/* No entry with objectid <= start exists. */
+			ret = 0;
+			break;
+		}
+		path->slots[0]--;
 
 		leaf = path->nodes[0];
 		slot = path->slots[0];
-- 
2.53.0

