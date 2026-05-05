Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168EF3385A5;
	Tue,  5 May 2026 09:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974766; cv=none; b=kX8le6me5JaPf2pf29AT8hCfeDP2PIWbF6RZfuw+zQq16g7yCX1v29vYelyex4+3jaCcjhRa3QOFMGYQqcFe4++rkB8S33ATg79MkydlYf3lGWR1AUToOs2/Z9U9PG1SV9r7tYNdoiD9ORC2OTLkbAWZ+pxmmM09605oXNTZuR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974766; c=relaxed/simple;
	bh=PmLrTQYoQyN/06svqv2yf8qx5jcP8KOUQprgToXZCsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4Pv/RMeaj575FIzuxgG7dUJdZmzzFSBDaSYPN2A+o34FgOHko+8k7iDytYlL3XfkyGV9/znKd5gIvsIskaHrBNaYadstOl2/mr6ngNRTbwifO92Nx+ZOmMQYk9E4I7369kyv3UZ+2JxdK+I/CMH1WnrzXraUoXR2Rsocfbj7I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SkX1x9wU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SkX1x9wU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECA7C2BCB9;
	Tue,  5 May 2026 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974765;
	bh=PmLrTQYoQyN/06svqv2yf8qx5jcP8KOUQprgToXZCsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkX1x9wU8himDqjLvIURq8trE8tUO0m6QZHeME90GWna4iWsiHKSHkvo+hpB612EG
	 LUbC+ANMW/WRLMmCv9TJ+O2ROnQkb6wUlEfX95K0ttoFGbDo4kytZCQkcL+CZGyLeh
	 Z3fiTWn4pbhsD2XZyXo1UDHAZ+/lNqCopSB7uKkLmKuAw5j2SeGNxpLC6/BdFfNCzV
	 9s+FPCnyQkpelb1MBoGNm2Epibr4zLjj10zYwjNEDcPdKA2WWjBSE2flJ7Yh2V+6Xs
	 6T84lCb+bxJ1fecQS9DtsLYPxyh+e00GI55xtM8MzsImg5z7v69Q/XY8OdjUen9NDd
	 ZPqgxUSMOibeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: robbieko <robbieko@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] btrfs: replace ASSERT with proper error handling in stripe lookup fallback
Date: Tue,  5 May 2026 05:51:33 -0400
Message-ID: <20260505095149.512052-17-sashal@kernel.org>
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

[ Upstream commit 653361585d251fbca0e19ac58b04ba95dd01e378 ]

After falling back to the previous item in btrfs_delete_raid_extent(),
the code uses ASSERT(found_start <= start) to verify the found extent
actually precedes our target range. If the B-tree state is unexpected
(e.g. no overlapping extent exists), this triggers a kernel BUG/panic
in debug builds, or silently continues with wrong data otherwise.

Replace the ASSERT with a proper bounds check that returns -ENOENT if
the found extent does not actually overlap with the start position.

Signed-off-by: robbieko <robbieko@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `btrfs`; action verb `replace`; intent is to
replace an assertion in `btrfs_delete_raid_extent()` with real error
handling for stripe lookup fallback.

Step 1.2 Record: Tags in commit
`653361585d251fbca0e19ac58b04ba95dd01e378`: `Signed-off-by: robbieko
<robbieko@synology.com>`, `Reviewed-by: David Sterba
<dsterba@suse.com>`, `Signed-off-by: David Sterba <dsterba@suse.com>`.
No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Link:`, no `Cc:
stable`.

Step 1.3 Record: The commit says that after fallback to the previous
item, `ASSERT(found_start <= start)` can BUG/panic when B-tree state is
unexpected, and non-assert builds can continue with wrong stripe data.
Root cause described: the previous item found may not actually overlap
the requested deletion range.

Step 1.4 Record: This is not hidden cleanup. It is explicitly a bug fix:
it converts an invariant-only check into a runtime bounds check
returning `-ENOENT`.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `fs/btrfs/raid-stripe-tree.c`, 4
insertions, 1 deletion. One function changed:
`btrfs_delete_raid_extent()`. Scope: single-file surgical fix.

Step 2.2 Record: Before, fallback loaded the previous key, computed
`found_start` and `found_end`, then asserted only `found_start <=
start`. After, it returns `-ENOENT` and exits the delete loop if
`found_start > start` or `found_end <= start`. This affects the stripe
extent deletion lookup path after `btrfs_search_slot()` chooses an item
after the deletion start and the code backs up to a candidate previous
item.

Step 2.3 Record: Bug category is logic/correctness with data-integrity
implications. Broken mechanism: the fallback candidate was assumed to
overlap the deletion start. The fix verifies both start and end bounds
before later code can truncate, split, or delete a stripe extent.

Step 2.4 Record: Fix quality is high: the check is local, easy to reason
about, and preserves existing error propagation. Regression risk is low,
but not zero: returning `-ENOENT` changes a previous silent/no-op path
into transaction abort at the caller. That is appropriate because the
caller already aborts on `btrfs_delete_raid_extent()` errors and the
condition means the stripe mapping lookup is inconsistent for the
deletion being performed.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the fallback block and
`ASSERT(found_start <= start)` were introduced by `76643119045eed`
(`btrfs: fix deletion of a range spanning parts two RAID stripe
extents`), first contained in `v6.14-rc1`. The broader partial deletion
machinery was introduced by `6aea95ee318890`, first contained in
`v6.13-rc1`.

Step 3.2 Record: No `Fixes:` tag is present, so there was no tagged
introducer to follow. Blame identifies the direct introducer.

Step 3.3 Record: Recent `master` history shows this was patch 4 in a
six-patch raid-stripe-tree deletion fix set: preceding fixes include
copying `devid`, fixing leaf-boundary lookup, and fixing
`btrfs_previous_item()` `min_objectid`; following fixes handle `-EAGAIN`
and missing return checks. The commit applies cleanly to the current
`stable/linux-7.0.y` checkout by itself, but it is best considered with
the neighboring raid-stripe-tree deletion fixes.

Step 3.4 Record: Author `robbieko` has multiple adjacent `fs/btrfs/raid-
stripe-tree.c` fixes in `master`. Reviewer/committer David Sterba is
listed as Btrfs maintainer in `MAINTAINERS`. Johannes Thumshirn, who
reviewed other patches in the series, has substantial prior raid-stripe-
tree history in the same file.

Step 3.5 Record: No new helper, structure, API, or external dependency
is introduced. Syntactically standalone: `git apply --check` of the
candidate patch succeeded on the current `stable/linux-7.0.y` checkout.
Semantically, it complements the surrounding lookup fixes.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 653361585d251...` found the original
submission at `https://patch.msgid.link/20260413065249.2320122-5-
robbieko@synology.com`. `b4 dig -a -C` showed only v1. The thread was a
six-patch series titled `btrfs: fix multiple bugs in raid-stripe-tree
deletion path`.

Step 4.2 Record: `b4 dig -w` showed the original recipients were
`robbieko` and `linux-btrfs@vger.kernel.org`. In-thread
review/maintainer discussion involved David Sterba and Johannes
Thumshirn. David added the series to `for-next`.

Step 4.3 Record: No `Reported-by:` or `Link:` tag exists for an external
bug report. No syzbot or bugzilla report was present in the commit or
mbox.

Step 4.4 Record: Related patches found in the same series:
`513f8a52eed88`, `2aef5cb1dcf9b`, `1871ae78ffa5c`, `fe0cdfd7118d8`, and
`a8d58a7c02009`. The cover letter states all six fix bugs in raid-
stripe-tree deletion/partial deletion paths.

Step 4.5 Record: No stable-specific nomination was found in the mbox.
WebFetch attempts to lore/stable and lore/all were blocked by Anubis, so
external stable-list search could not be independently verified.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Modified function: `btrfs_delete_raid_extent()`.

Step 5.2 Record: Callers found by search: production caller
`do_free_extent_accounting()` in `fs/btrfs/extent-tree.c`, plus Btrfs
raid-stripe-tree selftests. `do_free_extent_accounting()` calls
`btrfs_delete_raid_extent()` for data extents and aborts the transaction
on error.

Step 5.3 Record: Key callees in `btrfs_delete_raid_extent()` include
`btrfs_find_chunk_map()`, `btrfs_need_stripe_tree_update()`,
`btrfs_search_slot()`, `btrfs_previous_item()`, `btrfs_del_item()`,
`btrfs_duplicate_item()`, and `btrfs_partially_delete_raid_extent()`.

Step 5.4 Record: Reachability verified: file extent removal paths call
`btrfs_free_extent()`, delayed refs call `__btrfs_free_extent()`, and
when refs reach zero `do_free_extent_accounting()` calls
`btrfs_delete_raid_extent()`. `btrfs_fallocate()` calls
`btrfs_punch_hole()` for `FALLOC_FL_PUNCH_HOLE`, which calls
`btrfs_replace_file_extents()`, which calls `btrfs_drop_extents()`,
which calls `btrfs_free_extent()`. So users with write access to files
on an affected Btrfs filesystem can reach this path via hole punching;
other data extent deletion paths also reach it.

Step 5.5 Record: Similar nearby issue pattern found in the same series:
multiple small fixes to `btrfs_delete_raid_extent()` and
`btrfs_partially_delete_raid_extent()` addressing missed entries, wrong
previous-item bounds, stale leaf pointer, missing `devid`, and unchecked
return values.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: The directly blamed fallback code is first in
`v6.14-rc1`; merge-base checks show it is not in `v6.13`, but is in
`v6.14`, `v6.15`, `v6.16`, and `v7.0`. It is therefore relevant to
stable trees based on `v6.14+`, including the current
`stable/linux-7.0.y` checkout.

Step 6.2 Record: Backport difficulty is low. `git apply --check` of the
candidate patch onto current `stable/linux-7.0.y` succeeded. Neighboring
series patches also applied cleanly in the same check.

Step 6.3 Record: Local stable refs `stable/linux-6.16.y` and
`stable/linux-7.0.y` do not contain the candidate or the adjacent April
2026 raid-stripe-tree deletion fixes checked by subject/ancestor tests.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is Btrfs filesystem, specifically raid-
stripe-tree. Criticality: important, because it is filesystem
data/extent mapping code, but affected population is feature-specific
rather than universal.

Step 7.2 Record: Subsystem activity is high. Recent history in
`fs/btrfs/raid-stripe-tree.c` shows many fixes and follow-up selftests.
The feature is also exposed only under `CONFIG_BTRFS_EXPERIMENTAL` sysfs
feature attributes in this tree, so impact is limited to systems using
that feature.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: Affected users are Btrfs users with `RAID_STRIPE_TREE`
enabled and stripe-tree updates needed for data block group profiles
covered by `BTRFS_RST_SUPP_BLOCK_GROUP_MASK`.

Step 8.2 Record: Trigger conditions: deleting/freeing data extents on
such filesystems when stripe lookup fallback selects a non-overlapping
candidate. Verified reachable through file hole punching and delayed-ref
extent free paths. I did not verify a concrete reproducer for the exact
bad B-tree state.

Step 8.3 Record: Failure mode severity is high. With
`CONFIG_BTRFS_ASSERT`, `ASSERT()` calls `BUG()`, so this can crash the
kernel. Without that assertion code generated, the later deletion logic
can operate on a non-overlapping stripe extent, which is a filesystem
mapping corruption risk. If the previous candidate ends before the
target, the old code could also silently stop with success.

Step 8.4 Record: Benefit is high for affected users because it prevents
panic or wrong stripe-tree mutation in filesystem deletion code. Risk is
low because the patch is a four-line validation check in one function
and changes invalid lookup state into an error returned to an existing
transaction-abort path.

## Phase 9: Final Synthesis
Step 9.1 Record: Evidence for backporting: real filesystem correctness
bug, possible kernel BUG in assert builds, possible wrong stripe mapping
mutation in non-assert builds, one-file minimal patch, maintainer review
by David Sterba, merged by Linus via Btrfs fixes pull, applies cleanly
to current stable checkout, affected code exists in `v6.14+`. Evidence
against: feature-specific and experimental; no concrete external bug
report or reproducer found; part of a six-patch series, so stable
maintainers should consider taking the nearby deletion fixes too.
Unresolved: no successful WebFetch of lore/stable search due Anubis;
exact real-world frequency not verified.

Step 9.2 Record: Stable rules checklist:
1. Obviously correct and tested: mostly yes by inspection and maintainer
   review; no explicit `Tested-by`.
2. Fixes a real bug: yes, invalid stripe lookup fallback handling in
   deletion path.
3. Important issue: yes for affected users, because panic and filesystem
   mapping corruption are serious.
4. Small and contained: yes, 4 insertions/1 deletion in one function.
5. No new features/APIs: yes.
6. Can apply to stable: yes on current `stable/linux-7.0.y`; relevant
   for `v6.14+` trees.

Step 9.3 Record: No exception category applies. This is not a device ID,
quirk, DT, build, or documentation patch.

Step 9.4 Record: Decision is to backport. The limited affected
population does not outweigh the severity and low risk: this is a tiny
filesystem correctness fix for code already present in recent stable
trees.

## Verification
- [Phase 1] `git show --format=fuller --stat 653361585d251...`:
  confirmed subject, message, tags, reviewer, and 4 insertions/1
  deletion.
- [Phase 2] `git show 653361585d251... -- fs/btrfs/raid-stripe-tree.c`:
  confirmed exact hunk replacing `ASSERT(found_start <= start)` with
  `found_start > start || found_end <= start` check returning `-ENOENT`.
- [Phase 3] `git blame -L 114,146 -- fs/btrfs/raid-stripe-tree.c`:
  confirmed fallback block introduced by `76643119045eed`.
- [Phase 3] `git show 76643119045eed`: confirmed it added the range-
  spanning fallback logic.
- [Phase 3] `git describe --contains 76643119045eed`: confirmed first
  containment at `v6.14-rc1`.
- [Phase 3] `git show 6aea95ee318890`: confirmed earlier partial
  deletion implementation and its ASSERT-related context.
- [Phase 3] `git log master --oneline -30 -- fs/btrfs/raid-stripe-
  tree.c`: confirmed related series commits before and after candidate.
- [Phase 3] `git apply --check` using the candidate diff: confirmed
  clean application on current `stable/linux-7.0.y`.
- [Phase 4] `b4 dig -c 653361585d251...`: found original lore patch URL.
- [Phase 4] `b4 dig -a -C`: found v1 only.
- [Phase 4] `b4 dig -w`: confirmed original recipients.
- [Phase 4] Saved and read b4 mbox: confirmed six-patch series, David
  Sterba maintainer discussion, David’s “Added to for-next”, Johannes’
  question about `ENOENT` vs `EUCLEAN`, and David’s acceptance of
  `ENOENT`.
- [Phase 5] `rg btrfs_delete_raid_extent`: confirmed production caller
  in `do_free_extent_accounting()` and selftests.
- [Phase 5] Read `fs/btrfs/extent-tree.c`: confirmed errors from
  `btrfs_delete_raid_extent()` abort transaction.
- [Phase 5] Read `fs/btrfs/file.c`: confirmed `btrfs_fallocate()` hole
  punching can reach extent replacement/drop code and
  `btrfs_free_extent()`.
- [Phase 5] Read `fs/btrfs/messages.h`: confirmed `ASSERT()` calls
  `BUG()` when `CONFIG_BTRFS_ASSERT` is enabled and compiles away
  otherwise.
- [Phase 6] `git merge-base --is-ancestor` checks: confirmed blamed code
  is in `v6.14+` and candidate is not in local stable refs checked.
- [Phase 7] `rg MAINTAINERS`: confirmed David Sterba is a Btrfs
  maintainer.
- [Phase 7] `rg RAID_STRIPE_TREE fs/btrfs/sysfs.c`: confirmed raid-
  stripe-tree feature attribute is under `CONFIG_BTRFS_EXPERIMENTAL`.
- [Phase 8] Read `fs/btrfs/raid-stripe-tree.h`: confirmed
  `btrfs_need_stripe_tree_update()` limits affected data profiles and
  requires `RAID_STRIPE_TREE`.
- UNVERIFIED: exact real-world frequency and a concrete reproducer for
  the bad fallback state.
- UNVERIFIED: lore/stable search results, because WebFetch was blocked
  by Anubis.

**YES**

 fs/btrfs/raid-stripe-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index dd924048c6659..a2e9ac2d97988 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -151,7 +151,10 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 			btrfs_item_key_to_cpu(leaf, &key, slot);
 			found_start = key.objectid;
 			found_end = found_start + key.offset;
-			ASSERT(found_start <= start);
+			if (found_start > start || found_end <= start) {
+				ret = -ENOENT;
+				break;
+			}
 		}
 
 		if (key.type != BTRFS_RAID_STRIPE_KEY)
-- 
2.53.0

