Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F0D31B114;
	Tue,  5 May 2026 09:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974726; cv=none; b=AbqKtqWoACNWJBmENF6zfgMyMgC1FsPFeUBqiI5Rih8G/chWDA9TlixyCDF0wXS6LwOMg1cBI4U3N4F+v49yqcYGLtqYDyev1GCtYzS6iDN4akiC3bT9o4dGbWLnQBHs+OktLxnj3ND3qfouipOKgfo08W9O8SVhlHq/W3iz3zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974726; c=relaxed/simple;
	bh=YWuK856pQAABa+jyruv20DMm0mPytQqeYuxj31H9V5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uL7hl8afnv/iCUZgO2yfYP+x0wZmzu0ng9xSp+LHtEkeDSbLh/N2rs4qYB7VqEJtuLqPfHjRVk2O8f0WUPeNxbJ81pwWj1U8kSVK/dC7DzixKUohGmLuuTY83h7f0h1CV9Q6r96pR/Xy+Z3UHp6sRsNJxCcMmwak09YSXqNEgeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPv/4TiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPv/4TiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4B3C2BCB9;
	Tue,  5 May 2026 09:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974725;
	bh=YWuK856pQAABa+jyruv20DMm0mPytQqeYuxj31H9V5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPv/4TiFSiVs5VL/q/0hWHGpXwdlbrs5YreYrjhSCZ0D/fAOhXC11xyld1zitXMXc
	 ksZ3eY8Ppv6STQYQ1ysw6e3qqiyc7jQMEpoksG6rbXiL8hM9Owq1TogUWzdR/0eYk0
	 l/y1xyLzzpk+LCRXPPDIFoysxkfNRqCEwFo4/hlrhieSPH71xDYQk2OA8yc5l6yiW3
	 JSj1dyAoNiNFBW6lk93yZDpqK9zBuFl3ZhZ7LpQ2eijbwkn20PuLeq8M6unVrxvjVJ
	 oDjLfHd0BBXgreqVoX8bkyM0Adzc+dNNBQaO6AZvBpEuF1NsnM92reO3n+J9hxOBBQ
	 9haTRAkHMZvvw==
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
Subject: [PATCH AUTOSEL 7.0-6.18] btrfs: handle -EAGAIN from btrfs_duplicate_item and refresh stale leaf pointer
Date: Tue,  5 May 2026 05:51:21 -0400
Message-ID: <20260505095149.512052-5-sashal@kernel.org>
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

[ Upstream commit fe0cdfd7118d8b40a21bfac221bb4982c5e10e10 ]

In the 'punch a hole' case of btrfs_delete_raid_extent(),
btrfs_duplicate_item() can return -EAGAIN when the leaf needs to be
split and the path becomes invalid. The old code treats any error as
fatal and breaks out of the loop.

Additionally, btrfs_duplicate_item() may trigger setup_leaf_for_split()
which can reallocate the leaf node. The code continues using the old
leaf pointer, leading to use-after-free or stale data access.

Fix both issues by:

- Handling -EAGAIN specifically: release the path and retry the loop.
- Refreshing leaf = path->nodes[0] after successful duplication.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: robbieko <robbieko@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `btrfs`; action verb `handle` / `refresh`;
claimed intent is to handle `-EAGAIN` from `btrfs_duplicate_item()` and
refresh a stale `leaf` pointer in `btrfs_delete_raid_extent()`.

Step 1.2 Record: Tags present:
- `Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>`
- `Signed-off-by: robbieko <robbieko@synology.com>`
- `Reviewed-by: David Sterba <dsterba@suse.com>`
- `Signed-off-by: David Sterba <dsterba@suse.com>`
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
stable@vger.kernel.org` tag was present.

Step 1.3 Record: The commit describes two bugs in the “punch a hole”
case of `btrfs_delete_raid_extent()`: `btrfs_duplicate_item()` can
return `-EAGAIN`, which old code treats as fatal, and
`btrfs_duplicate_item()` can change the leaf through
`setup_leaf_for_split()`, leaving the caller’s cached `leaf` pointer
stale. Symptom/failure mode: failed deletion path via false fatal error,
plus possible use-after-free or stale metadata access. No affected
kernel version is stated in the commit body.

Step 1.4 Record: This is not hidden; it is explicitly a bug fix. It
fixes memory safety/stale pointer handling and retry handling for a
known nonfatal `-EAGAIN` path.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `fs/btrfs/raid-stripe-tree.c`, 10
insertions, no removals. One function modified:
`btrfs_delete_raid_extent()`. Scope classification: single-file surgical
filesystem metadata fix.

Step 2.2 Record:
- Before: after `btrfs_duplicate_item()`, any nonzero return, including
  `-EAGAIN`, broke out of the loop and returned an error.
- After: `-EAGAIN` releases the path and retries the outer search loop.
- Before: `leaf` was captured before `btrfs_duplicate_item()` and reused
  afterward.
- After: `leaf = path->nodes[0]` is refreshed before item access and
  stripe physical address updates.

Step 2.3 Record: Bug categories are memory safety and logic/correctness.
Verified mechanism: `btrfs_duplicate_item()` calls
`setup_leaf_for_split()`, which can release and re-search the path and
return `-EAGAIN`; after success, `btrfs_duplicate_item()` itself
refreshes its local `leaf`, showing the caller must not assume its
previous `leaf` remains valid.

Step 2.4 Record: The fix is obviously correct by local pattern: existing
`btrfs_duplicate_item()` callers in `fs/btrfs/file.c` already handle
`-EAGAIN` by releasing/retrying and refresh `leaf` after success.
Regression risk is low: no API change, no locking change, no new
feature, and the behavior change is limited to one special-case branch.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the buggy punch-hole code in
`btrfs_delete_raid_extent()` was introduced by `6aa0e7cc569eb` (`btrfs:
implement hole punching for RAID stripe extents`), first contained by
`v6.14-rc1~207^2~7`.

Step 3.2 Record: No `Fixes:` tag exists, so there was no tagged commit
to follow. I independently identified `6aa0e7cc569eb` as the introducer
by blaming the changed lines.

Step 3.3 Record: Recent `fs/btrfs/raid-stripe-tree.c` history shows this
commit is part of a six-patch bug-fix series for RAID stripe tree
deletion. The immediately following commit, `a8d58a7c02009`, fixes
unchecked return values in the same function, but this candidate’s stale
pointer and `-EAGAIN` fix is standalone and applied cleanly to the
current `7.0.y` checkout.

Step 3.4 Record: On `master`, the author has several nearby Btrfs fixes,
including this six-patch RAID stripe tree deletion series and older
Btrfs fixes. The commit was committed and reviewed by David Sterba, the
Btrfs maintainer.

Step 3.5 Record: Dependencies found: the buggy branch requires
`6aa0e7cc569eb`; stable branches without that commit do not need this
fix. No prerequisite commit is needed for the patch hunk itself on
`7.0.y`; `git apply --check` succeeded there.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c fe0cdfd7118d8...` found the original
submission at `https://patch.msgid.link/20260413065249.2320122-6-
robbieko@synology.com`. `b4 dig -a` found only v1 of the series. The
patch was `[PATCH 5/6]`.

Step 4.2 Record: `b4 dig -w -C` showed original recipients were
`robbieko <robbieko@synology.com>` and `linux-btrfs@vger.kernel.org`.
The mbox shows Johannes Thumshirn replied “Looks good” with `Reviewed-
by`, and David Sterba later said the series was “Added to for-next,
thanks.”

Step 4.3 Record: No `Reported-by` or bug-report `Link:` tag exists.
WebFetch to lore was blocked by Anubis, but `b4` successfully downloaded
the mbox.

Step 4.4 Record: The series contains six RAID stripe tree deletion
fixes. This patch is patch 5/6; the following patch is related but not a
prerequisite for this specific retry/stale-pointer fix.

Step 4.5 Record: Web/lore stable searches did not find a stable-specific
request or objection. This is unresolved only for stable-list
discussion; it does not affect the technical decision.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Modified function: `btrfs_delete_raid_extent()`.

Step 5.2 Record: Callers/impact surface verified:
- `do_free_extent_accounting()` calls `btrfs_delete_raid_extent()` for
  data extents.
- `__btrfs_free_extent()` calls `do_free_extent_accounting()` when
  references drop to zero.
- `btrfs_free_extent()` queues data refs from several Btrfs paths,
  including `btrfs_drop_extents()` and `btrfs_mark_extent_written()`.
- `btrfs_punch_hole()` calls `btrfs_replace_file_extents()`, which calls
  `btrfs_drop_extents()`.

Step 5.3 Record: Key callees are `btrfs_search_slot()`,
`btrfs_duplicate_item()`, `btrfs_release_path()`, `btrfs_item_size()`,
`btrfs_item_ptr()`, and `btrfs_partially_delete_raid_extent()`.
`btrfs_duplicate_item()` calls `setup_leaf_for_split()`.

Step 5.4 Record: The path is reachable from normal Btrfs file extent
freeing, including file hole punching through `btrfs_punch_hole()`, but
only when the filesystem has the RAID stripe tree incompat feature and a
supported data profile.

Step 5.5 Record: Similar pattern found in `fs/btrfs/file.c`: callers of
`btrfs_duplicate_item()` handle `-EAGAIN` by releasing/retrying and
refresh `leaf` afterward. This strongly validates the fix pattern.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: The buggy introducer `6aa0e7cc569eb` is present in
`stable/linux-6.14.y` through `stable/linux-7.0.y`; it is absent from
`stable/linux-6.13.y` and older checked LTS branches.
`stable/linux-6.6.y` and `6.12.y` have `raid-stripe-tree.c` but lack
this punch-hole code.

Step 6.2 Record: Expected backport difficulty is clean or minor for
affected newer stable trees. Verified `git apply --check` succeeds on
the current `7.0.y` checkout. The exact affected hunk also exists in
`6.18.y`, `6.19.y`, and `7.0.y`; `6.18.y` differs elsewhere in the file
but not in the relevant hunk.

Step 6.3 Record: No same-title or same “stale leaf pointer” fix exists
in checked stable branches. Related six-patch series fixes are not
present in `7.0.y`.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is Btrfs filesystem metadata, specifically
RAID stripe tree. Criticality: important for users of Btrfs RAID stripe
tree; not universal. It is gated by `RAID_STRIPE_TREE` and supported
data profiles.

Step 7.2 Record: The file is actively developed: recent history shows
several RAID stripe tree fixes and cleanups, including this six-patch
deletion-path series.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: Affected population is Btrfs users with RAID stripe
tree enabled, especially supported data profiles such as
DUP/RAID1/RAID0/RAID10 per `btrfs_need_stripe_tree_update()`.

Step 8.2 Record: Trigger condition is deleting/freeing a data extent
range that falls strictly inside a RAID stripe extent (`found_start <
start && found_end > end`) and then hits either `-EAGAIN` from
`btrfs_duplicate_item()` or a leaf change after duplication. User
reachability is verified through Btrfs file hole-punching and extent
dropping paths, but exact ease of triggering the leaf split was not
runtime-tested.

Step 8.3 Record: Failure mode severity is HIGH: use-after-free/stale
metadata access in filesystem metadata code, plus incorrect fatal
handling of a retryable `-EAGAIN`. The commit body explicitly states
UAF/stale data access; code inspection verifies the stale pointer
mechanism.

Step 8.4 Record: Benefit is high for affected users because it prevents
memory-safety/stale metadata behavior in a filesystem metadata update
path. Risk is low because it adds only 10 lines in one branch and
follows existing Btrfs caller patterns.

## Phase 9: Final Synthesis
Step 9.1 Record:
Evidence for backporting:
- Fixes a real memory-safety/stale pointer bug and incorrect `-EAGAIN`
  handling.
- Small, contained, one-function change.
- Matches established `btrfs_duplicate_item()` caller behavior in
  `fs/btrfs/file.c`.
- Reviewed by Johannes Thumshirn and David Sterba; merged by David
  Sterba.
- Bug exists in newer stable branches from `6.14.y` onward and is absent
  from older checked branches.

Evidence against:
- Affects a narrower, experimental Btrfs RAID stripe tree feature, not
  all Btrfs users.
- No `Reported-by`, reproducer, or `Tested-by` tag.
- It is part of a six-patch series, so adjacent RAID stripe tree
  deletion fixes should also be reviewed.

Unresolved:
- I did not runtime-test the path.
- I could not read lore via WebFetch due Anubis, but `b4` mbox retrieval
  succeeded.
- I did not prove exact clean application for every stable branch, only
  current `7.0.y`; source inspection indicates minor/clean for newer
  affected branches.

Step 9.2 Record:
1. Obviously correct and tested? Obviously correct by code and existing
   Btrfs pattern; no explicit `Tested-by`.
2. Fixes a real bug? Yes, stale `leaf` use and retryable `-EAGAIN`
   mishandling.
3. Important issue? Yes, HIGH severity memory-safety/stale metadata
   access in filesystem metadata code.
4. Small and contained? Yes, 10 insertions in one function.
5. No new features/APIs? Yes.
6. Can apply to stable trees? Yes for `7.0.y` verified; applicable to
   `6.14.y+` trees containing the introducer.

Step 9.3 Record: No automatic exception category applies; this is not a
device ID, quirk, DT, build, or documentation patch.

Step 9.4 Record: The risk-benefit balance favors backporting to stable
trees that contain `6aa0e7cc569eb`. It should not be backported to older
trees that lack the RAID stripe extent hole-punching code.

## Verification
- [Phase 1] Parsed `git show --format=fuller fe0cdfd7118d8`: confirmed
  subject, body, tags, author, committer, and absence of
  `Fixes:`/`Reported-by`/`Tested-by`.
- [Phase 2] Inspected `git diff --function-context fe0cdfd7118d8^
  fe0cdfd7118d8`: confirmed 10 insertions in
  `btrfs_delete_raid_extent()`.
- [Phase 2] Read `fs/btrfs/ctree.c`: confirmed `btrfs_duplicate_item()`
  calls `setup_leaf_for_split()` and refreshes its local `leaf`.
- [Phase 3] Ran `git blame` on affected lines: identified
  `6aa0e7cc569eb` as introducer.
- [Phase 3] Ran `git describe --contains 6aa0e7cc569eb`: first contained
  by `v6.14-rc1~207^2~7`.
- [Phase 3] Checked author history on `master`: found the six related
  Btrfs RAID stripe tree fixes.
- [Phase 4] Ran `b4 dig -c`, `-a`, `-w -C`, and `-m`: found patch URL,
  v1-only series, recipients, mbox, maintainer/reviewer responses.
- [Phase 4] Read mbox: Johannes gave `Reviewed-by`; David said series
  was added to for-next.
- [Phase 5] Used `rg` and source reads to trace `btrfs_punch_hole()` →
  `btrfs_replace_file_extents()` → `btrfs_drop_extents()` →
  `btrfs_free_extent()` → delayed free accounting →
  `btrfs_delete_raid_extent()`.
- [Phase 5] Searched similar patterns: `fs/btrfs/file.c` handles
  `-EAGAIN` and refreshes `leaf` after `btrfs_duplicate_item()`.
- [Phase 6] Checked stable branches with `git merge-base --is-ancestor`:
  `6.14.y` through `7.0.y` contain introducer and lack fix; `6.13.y`
  lacks introducer.
- [Phase 6] Ran `git apply --check` for the candidate patch on current
  `7.0.y`: success.
- [Phase 7] Read `fs/btrfs/Kconfig` and `fs/btrfs/raid-stripe-tree.h`:
  verified RAID stripe tree is feature-gated and profile-limited.
- [Phase 8] Verified failure mode from commit body plus code flow
  through `setup_leaf_for_split()` and stale caller `leaf`.

**YES**

 fs/btrfs/raid-stripe-tree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 86ddc3ecb4060..22327f4833113 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -194,9 +194,19 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 
 			/* The "right" item. */
 			ret = btrfs_duplicate_item(trans, stripe_root, path, &newkey);
+			if (ret == -EAGAIN) {
+				btrfs_release_path(path);
+				continue;
+			}
 			if (ret)
 				break;
 
+			/*
+			 * btrfs_duplicate_item() may have triggered a leaf
+			 * split via setup_leaf_for_split(), so we must refresh
+			 * our leaf pointer from the path.
+			 */
+			leaf = path->nodes[0];
 			item_size = btrfs_item_size(leaf, path->slots[0]);
 			extent = btrfs_item_ptr(leaf, path->slots[0],
 						struct btrfs_stripe_extent);
-- 
2.53.0

