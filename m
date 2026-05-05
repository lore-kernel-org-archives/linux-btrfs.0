Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC12330328;
	Tue,  5 May 2026 09:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974784; cv=none; b=YFYUl4NT4P+XOty2MdJge+VW9YBxfC8l93RhD0bHzrPvsdtf/vLrbfZFpk/ts/IY+Pw4JBrUyFrXn0J+yOqcuwaTYBlGu+0CY2gpC0fn11iSmM4tLGjIPz+VsIk3EbBwC2sUw7f5z/NwB1JrmDg+gnkNmPYnfTsG3mPRvZhlLqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974784; c=relaxed/simple;
	bh=YGyJee4nHJTP0aRV/HB+3B9mVK/Bc/Xm9kvgxU2pFIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5Hxk0zgtrTFMFPhGQjBeC+VeTiCzKvfV7PcYi881OJ/GfGyVfCHVM9oUdRgbLx8oTQrus+BfFYs3RZh4QylQOnsDjGuVB0AS2NqZOufx9HQmiXk0dDTos8McYstkerm/8X20gtOKyo7iVFXS043nRyvQ2YG889wYxwjEjeJAxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utowI3sY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utowI3sY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96028C2BCB4;
	Tue,  5 May 2026 09:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974783;
	bh=YGyJee4nHJTP0aRV/HB+3B9mVK/Bc/Xm9kvgxU2pFIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utowI3sYlqk/k2tLQwMAKsOPQHQFa+d3C6r3OQO1di5fZ0LCjaCXA/lez/ihtm2Wh
	 u5mrZ2jm+4NoaCTVwZ6GZwA3G16fQqDgwfuQnfILNAsb5ODVR3FBSCOGaQDPMDw5/9
	 JtN+HTLflY2aU4L1IERHXUIXs7hHMiTE9Tb60JNSYhDvJxanTWCkBK1nhcfykuyKbN
	 MB9Y2azkFG34+qXLJD5WwZx/cfVoUXzpcNOSkQbIt/wLPIebjOfd1K6wUUXuGmr+0K
	 8ZKrkaN2/F0x30x9xzhltI+ePY8qbATZw3licYugVv92l3TgewNu5JWien+K2c1qp8
	 0VIymaEMfc9XA==
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
Subject: [PATCH AUTOSEL 7.0-6.18] btrfs: fix wrong min_objectid in btrfs_previous_item() call
Date: Tue,  5 May 2026 05:51:39 -0400
Message-ID: <20260505095149.512052-23-sashal@kernel.org>
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

[ Upstream commit 1871ae78ffa5ce7c0458e9ba5867958c1753e425 ]

When found_start > start and slot == 0, btrfs_previous_item() is called
with min_objectid=start to find the previous stripe extent. However, the
previous stripe extent we are looking for has objectid < start (it starts
before our deletion range), so passing start as min_objectid prevents
finding it.

Fix by passing 0 as min_objectid to allow finding any preceding stripe
extent regardless of its objectid.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: robbieko <robbieko@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record 1.1: Subsystem `btrfs`; action verb `fix`; claimed intent is
correcting the `min_objectid` argument to `btrfs_previous_item()` in the
RAID stripe-tree deletion path.

Record 1.2: Tags found: `Reviewed-by: Johannes Thumshirn
<johannes.thumshirn@wdc.com>`, `Signed-off-by: robbieko
<robbieko@synology.com>`, `Reviewed-by: David Sterba
<dsterba@suse.com>`, `Signed-off-by: David Sterba <dsterba@suse.com>`.
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
stable@vger.kernel.org` tags were present.

Record 1.3: The commit describes a real lookup bug: when `found_start >
start` and `slot == 0`, the code tries to find the previous RAID stripe
extent, but passes `min_objectid=start`. `btrfs_previous_item()` stops
when it sees an item with `objectid < min_objectid`, so it cannot return
the previous extent that starts before `start`.

Record 1.4: This is not hidden cleanup. It is an explicit
logic/correctness fix for a failed previous-item lookup.

## Phase 2: Diff Analysis
Record 2.1: One file changed: `fs/btrfs/raid-stripe-tree.c`, 1 insertion
and 1 deletion. Modified function: `btrfs_delete_raid_extent()`. Scope:
single-file, one-line surgical fix.

Record 2.2: Before: `btrfs_previous_item(stripe_root, path, start,
BTRFS_RAID_STRIPE_KEY)` would reject any candidate with `objectid <
start`. After: `min_objectid=0` allows searching back to earlier stripe
extents.

Record 2.3: Bug category: logic/correctness bug in B-tree item lookup.
Mechanism verified in `btrfs_previous_item()`: it breaks when
`found_key.objectid < min_objectid` before returning a matching type, so
`min_objectid=start` prevents the intended previous extent from being
found.

Record 2.4: Fix quality is high: one argument change, no API changes, no
new feature. Regression risk is low, but not zero: the same series has
the immediately following patch `653361585d251` adding a proper overlap
check after this fallback, so stable backports should consider the
surrounding RAID stripe-tree deletion fixes too.

## Phase 3: Git History Investigation
Record 3.1: `git blame` shows the buggy call was introduced by
`76643119045ee` (`btrfs: fix deletion of a range spanning parts two RAID
stripe extents`), first contained around `v6.14-rc1`. The broader RAID
stripe tree code was introduced by `ca41504efda6`, first contained
around `v6.7-rc1`.

Record 3.2: No `Fixes:` tag is present, so there was no tag target to
follow.

Record 3.3: Recent file history shows this commit is patch 3 in a six-
patch RAID stripe-tree deletion bugfix series: `513f8a52eed88`,
`2aef5cb1dcf9b`, `1871ae78ffa5c`, `653361585d251`, `fe0cdfd7118d8`, and
`a8d58a7c02009`. This commit applies standalone to `v7.0.3`, but it is
part of a related correctness series.

Record 3.4: Author `robbieko` had several same-day Btrfs RAID stripe-
tree fixes in `fs/btrfs`. Committer/reviewer David Sterba is the Btrfs
maintainer.

Record 3.5: No hard prerequisite is needed for this one-line change to
apply. `git apply --check` against the current `stable/linux-7.0.y`
checkout succeeded. Semantic companion patches exist and should be
considered, especially the next ASSERT-to-error-handling fix.

## Phase 4: Mailing List And External Research
Record 4.1: `b4 dig -c 1871ae78ffa5c` found the original submission at `
https://patch.msgid.link/20260413065249.2320122-4-
robbieko@synology.com`, titled `[PATCH 3/6] btrfs: fix wrong
min_objectid in btrfs_previous_item() call`.

Record 4.2: `b4 dig -w` showed original recipients: `robbieko
<robbieko@synology.com>` and `linux-btrfs@vger.kernel.org`. The mbox
shows Johannes Thumshirn reviewed patch 3 with “Looks good” and
`Reviewed-by`.

Record 4.3: No external bug report, syzbot report, or user report was
linked.

Record 4.4: The cover letter says the series fixes six bugs in
`fs/btrfs/raid-stripe-tree.c`, all in stripe extent deletion and partial
deletion paths. Patch 3 is specifically this wrong `min_objectid` fix.

Record 4.5: `WebFetch` for lore and stable searches was blocked by
Anubis. Local `b4` mbox inspection found no stable-specific nomination
or objection.

## Phase 5: Code Semantic Analysis
Record 5.1: Modified function: `btrfs_delete_raid_extent()`.

Record 5.2: Verified callers: production caller is
`do_free_extent_accounting()` in `fs/btrfs/extent-tree.c`; tests also
call it from `fs/btrfs/tests/raid-stripe-tree-tests.c`.

Record 5.3: Key callees include `btrfs_search_slot()`,
`btrfs_previous_item()`, `btrfs_partially_delete_raid_extent()`, and
`btrfs_del_item()`. The affected path is the stripe extent deletion path
for Btrfs RAID stripe tree.

Record 5.4: Verified call chain: `__btrfs_free_extent()` calls
`do_free_extent_accounting()` when data extent refs drop to zero; that
calls `btrfs_delete_raid_extent()`. If `btrfs_delete_raid_extent()`
returns an error, `do_free_extent_accounting()` aborts the transaction.
I did not fully trace from VFS syscall entry, so unprivileged
triggerability is not relied on for the decision.

Record 5.5: Similar nearby bugfixes were found in the same series,
indicating this area had multiple deletion-path correctness bugs.

## Phase 6: Stable Tree Analysis
Record 6.1: The buggy `btrfs_previous_item(..., start, ...)` call exists
in release tags `v6.14`, `v6.14.11`, `v6.15`, `v6.15.11`, `v6.16`,
`v6.17`, `v6.18`, `v6.19`, `v7.0`, and current `v7.0.3`. It is absent
from `v6.13`, `v6.12`, `v6.6`, and `v6.1`.

Record 6.2: Backport difficulty is low for `v7.0.3`; `git apply --check`
succeeded. Older affected stable trees likely need only minor context
adjustment if their surrounding code differs.

Record 6.3: I did not find an alternate already-applied fix in the
checked release tags; `master` contains the corrected `min_objectid=0`
call.

## Phase 7: Subsystem And Maintainer Context
Record 7.1: Subsystem: Btrfs filesystem, specifically RAID stripe-tree
support. Criticality: important but feature-specific, not universal.

Record 7.2: `fs/btrfs` is actively maintained. Recent history shows
multiple April 2026 Btrfs fixes and the RAID stripe-tree deletion series
merged by David Sterba.

## Phase 8: Impact And Risk
Record 8.1: Affected users are Btrfs users with the `RAID_STRIPE_TREE`
incompat feature enabled and data block group profiles covered by
`BTRFS_RST_SUPP_BLOCK_GROUP_MASK` (`DUP`, `RAID0`, `RAID1` variants,
`RAID10`).

Record 8.2: Trigger condition is freeing/deleting a data extent range
that spans stripe extents where the next found stripe extent is at slot
0 and the needed previous stripe extent starts before `start`. Verified
from code flow; frequency in real workloads is not quantified.

Record 8.3: Failure mode: the old code can fail to find the needed
previous stripe extent, return `-ENOENT`, and cause
`do_free_extent_accounting()` to abort the transaction. Severity: high
for affected filesystems, because transaction abort is a serious
filesystem failure.

Record 8.4: Benefit is high for affected Btrfs RAID stripe-tree users.
Risk is low: one-line contained fix, reviewed by Btrfs developers, no
API change. Main concern is that this is part of a six-patch correctness
series, so stable maintainers should evaluate adjacent fixes as well.

## Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: real Btrfs deletion-path bug;
verified wrong argument against `btrfs_previous_item()` semantics; bug
exists in `v6.14+` release lines; failure can abort Btrfs transactions;
fix is one line and reviewed by Johannes Thumshirn and David Sterba.
Evidence against: no reported user/syzbot case and feature-specific
impact; companion patches in same area should be considered. Unresolved:
exact real-world frequency and exact backport conflicts for every
affected stable branch were not fully checked.

Record 9.2 stable rules: obviously correct: yes, verified by code
semantics and reviews. Fixes a real bug: yes, incorrect lookup bound.
Important issue: yes for affected Btrfs filesystems, because it can
abort transactions. Small and contained: yes, one line in one function.
No new features/APIs: yes. Applies to stable: verified clean on current
`v7.0.3`; likely low difficulty for affected `v6.14+`.

Record 9.3: No exception category applies; this is a filesystem bug fix,
not a device ID, quirk, DT, build, or documentation change.

Record 9.4: Decision: backport. The patch is small, technically
justified, and fixes a serious correctness problem in a stable-visible
Btrfs feature. Prefer reviewing/backporting the surrounding RAID stripe-
tree deletion fixes too, but this commit itself is stable material.

## Verification
- Phase 1: Parsed commit `1871ae78ffa5c`; confirmed tags and absence of
  `Fixes:`, `Reported-by:`, `Tested-by`, `Link`, and stable Cc.
- Phase 2: Inspected diff; confirmed exactly 1-line argument change in
  `btrfs_delete_raid_extent()`.
- Phase 2: Read `btrfs_previous_item()`; confirmed it stops once
  `found_key.objectid < min_objectid`.
- Phase 3: Ran `git blame`; confirmed buggy call introduced by
  `76643119045ee`.
- Phase 3: Ran `git describe --contains`; confirmed `76643119045ee` is
  first contained around `v6.14-rc1`.
- Phase 3: Reviewed recent file history; confirmed this commit is part
  of a six-patch RAID stripe-tree deletion fix series.
- Phase 3: Ran `git apply --check`; confirmed the patch applies to
  current `v7.0.3` checkout.
- Phase 4: Ran `b4 dig -c`, `-a`, and `-w`; confirmed lore message ID,
  series context, and original recipients.
- Phase 4: Saved/read the `b4` mbox; confirmed cover letter says six
  bugs are fixed and patch 3 fixes this `min_objectid` issue.
- Phase 4: Read mbox reply; confirmed Johannes Thumshirn gave `Reviewed-
  by` for patch 3.
- Phase 4: `WebFetch` to lore/stable was blocked by Anubis; no web-
  search result was used as evidence.
- Phase 5: Searched callers; confirmed production caller path through
  `do_free_extent_accounting()` and tests.
- Phase 5: Read `do_free_extent_accounting()`; confirmed nonzero return
  from `btrfs_delete_raid_extent()` aborts the transaction.
- Phase 6: Checked release tags; confirmed buggy code exists in `v6.14+`
  through `v7.0.3`, absent in `v6.13`, `v6.12`, `v6.6`, and `v6.1`.
- Phase 7: Reviewed `fs/btrfs` recent history; confirmed active
  subsystem and maintainer merge context.
- Phase 8: Read `btrfs_need_stripe_tree_update()`; confirmed affected
  configurations are RAID stripe-tree data block groups with supported
  profiles.
- UNVERIFIED: Exact real-world frequency of the trigger.
- UNVERIFIED: Full VFS syscall-to-trigger trace and unprivileged
  triggerability.
- UNVERIFIED: Clean application to every affected stable branch older
  than current `v7.0.3`.

**YES**

 fs/btrfs/raid-stripe-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 2987cb7c686ea..d2b8995febec9 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -123,7 +123,7 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 		 */
 		if (found_start > start) {
 			if (slot == 0) {
-				ret = btrfs_previous_item(stripe_root, path, start,
+				ret = btrfs_previous_item(stripe_root, path, 0,
 							  BTRFS_RAID_STRIPE_KEY);
 				if (ret) {
 					if (ret > 0)
-- 
2.53.0

