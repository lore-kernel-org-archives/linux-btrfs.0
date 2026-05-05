Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044423783CB;
	Tue,  5 May 2026 09:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974787; cv=none; b=uqpsJBYhsjasOMbgua/wczJFHYn4TkF1TSwVYs2MAJzX+IpRSxFyJ7Mi9fmLlLLa+HlR85Hcltbnmn1csKBTLKvrSOQUVgPRSWWmdgyfratWd81LPT+ae9c1YpaRJjj2Jm2jiIGgR/FAHFtia/12wZIipNkDgXaB8SVIVVyBd6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974787; c=relaxed/simple;
	bh=A/TJ23ruxktp6tGrqMbRgFaDXiu8Md0lq6atQ5BTMPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RRAi/fRvncsfkwe8XIXHrPBaj3N2e/+e1lDjO6iW6tQUUfXaOFSMVdfXZlW1iDqaDNXlxdxrWeZXx/Eg7QNxZiF5jqouZSfRquQPlblEbxwFU2f59jH/hTApn/k73X4hehR6/8JqZQakA1Bbo48EAiG7tqpHz+rxFrxTTCstBHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qn1outTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qn1outTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6396FC2BCB4;
	Tue,  5 May 2026 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974786;
	bh=A/TJ23ruxktp6tGrqMbRgFaDXiu8Md0lq6atQ5BTMPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qn1outTk7EaSpgjzOyW6GPhPh5TVskDsX29N3cg2S998JyL+FMVlqUUyJW86TfWa1
	 fEJHMEqm7O9rXaCTG6twMJ4O/Z0Nx/+k8g4pJCZwERro07AH7/Ipp4CVKpZUayRfEx
	 OPf6Q4zCj3assPS2xr+SAMLmvxNwRX9BCj1+d2ZMI7XgUMELVIXIw7paJ//0efTZT6
	 qCfuDe8GO30morMAWOPrqx7RLgg98+2HnrJ9FQEOWTNSZ30ZqTXBdVyyOO6xYXNSOr
	 3Et0DZ16anQxJ3DGlSVIKtzHqi8tzbh+mvWVizAngaYS9OidMsTSOvM0AGQIE6dR1q
	 pCLSMtQaTTjwA==
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
Subject: [PATCH AUTOSEL 7.0-6.18] btrfs: check return value of btrfs_partially_delete_raid_extent()
Date: Tue,  5 May 2026 05:51:40 -0400
Message-ID: <20260505095149.512052-24-sashal@kernel.org>
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

[ Upstream commit a8d58a7c0200904ff24ca7f0d7c147017e25aa99 ]

btrfs_partially_delete_raid_extent() returns an error code (e.g.
-ENOMEM from kzalloc(), or errors from btrfs_del_item/btrfs_insert_item()),
but all three call sites in btrfs_delete_raid_extent() discard the
return value, silently losing errors and potentially leaving the stripe
tree in an inconsistent state.

Fix by capturing the return value into ret at all three call sites and
breaking out of the loop on error where appropriate.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: robbieko <robbieko@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis

### Phase 1: Commit Message Forensics
Record 1.1: Subsystem `btrfs`; action verb `check`; intent is to
propagate errors from `btrfs_partially_delete_raid_extent()` instead of
silently treating failed stripe-tree updates as success.

Record 1.2: Tags present: `Reviewed-by: Johannes Thumshirn
<johannes.thumshirn@wdc.com>`, `Signed-off-by: robbieko
<robbieko@synology.com>`, `Signed-off-by: David Sterba
<dsterba@suse.com>`. No `Fixes:`, no `Cc: stable`, no `Reported-by`.

Record 1.3: The body describes ignored `-ENOMEM`, `btrfs_del_item()`,
and `btrfs_insert_item()` errors, with the failure mode being silently
lost errors and possible RAID stripe tree inconsistency.

Record 1.4: This is a hidden bug fix despite the “check return value”
wording: it fixes error propagation and prevents filesystem metadata
update failures from being reported as success.

### Phase 2: Diff Analysis
Record 2.1: One file changed: `fs/btrfs/raid-stripe-tree.c`, 12
additions and 7 deletions. Modified function:
`btrfs_delete_raid_extent()`. Scope: single-file surgical error-handling
fix.

Record 2.2: Before, three calls to
`btrfs_partially_delete_raid_extent()` discarded the return value.
After, all three store it in `ret`; the middle loop case additionally
breaks immediately on error before advancing `start`/`length`.

Record 2.3: Bug category: error-path/correctness fix. The helper can
fail before modifying the tree (`kzalloc()`), during deletion, or during
insertion; ignoring those failures can leave the caller deleting more
extents or returning success after a failed partial update.

Record 2.4: Fix quality is high: it only propagates existing errors
through the existing `ret` path. Regression risk is low; the behavior
change is that real failures now abort/return instead of being hidden.

### Phase 3: Git History
Record 3.1: `git blame` shows `btrfs_partially_delete_raid_extent()` was
introduced by `6aea95ee318890` and changed to return errors by
`dc14ba10781bd`. The ignored call sites come from the partial
deletion/hole-punching work around `a678543e609df`, `50cae2ca69561`, and
`6aa0e7cc569eb`.

Record 3.2: No `Fixes:` tag is present, so there was no tagged
introducer to follow. History shows the relevant bug only exists once
`dc14ba10781bd` made the helper return `int`.

Record 3.3: Recent master history shows this is patch 6 of a six-patch
RAID stripe tree deletion bug-fix series. The candidate applies cleanly
to the current 7.0.y checkout without requiring the preceding five
patches for context.

Record 3.4: The author has multiple adjacent btrfs RAID stripe tree
fixes in master; David Sterba committed the patch, and Johannes
Thumshirn reviewed it.

Record 3.5: Dependency: target tree must have the `int`-returning helper
from `dc14ba10781bd`. Verified present in v6.14+ and absent in
v6.12/v6.13, so older trees without that helper form are not applicable.

### Phase 4: Mailing List And External Research
Record 4.1: `b4 dig -c a8d58a7c02009` found the original submission at `
https://patch.msgid.link/20260413065249.2320122-7-
robbieko@synology.com`. `b4 dig -a` found a single v1 series.

Record 4.2: `b4 dig -w` showed the patch was sent to `linux-
btrfs@vger.kernel.org`; direct recipients were limited, but the
subsystem list was included.

Record 4.3: No external bug report or syzbot link exists for this
specific patch.

Record 4.4: The cover letter states all six patches fix bugs in RAID
stripe tree deletion paths. Johannes requested tests for the series;
patch 6 itself received “Looks good” and `Reviewed-by`.

Record 4.5: Lore `WebFetch` was blocked by Anubis, but the yhbt mirror
and local `b4` mbox were readable. I found no stable-specific discussion
or explicit stable nomination.

### Phase 5: Code Semantic Analysis
Record 5.1: Modified function: `btrfs_delete_raid_extent()`.

Record 5.2: Callers found: `do_free_extent_accounting()` calls
`btrfs_delete_raid_extent()` for data extents; btrfs sanity tests also
call it.

Record 5.3: Key callees: `btrfs_partially_delete_raid_extent()` calls
`kzalloc()`, `btrfs_del_item()`, and `btrfs_insert_item()`.
`btrfs_delete_raid_extent()` also uses B-tree search/delete helpers.

Record 5.4: Reachability verified through delayed reference processing:
`run_one_delayed_ref()` -> `run_delayed_data_ref()` ->
`__btrfs_free_extent()` -> `do_free_extent_accounting()` ->
`btrfs_delete_raid_extent()`. This is reachable from normal Btrfs extent
freeing and transaction commit paths.

Record 5.5: Similar pattern search found only these three helper call
sites, and the patch fixes all of them.

### Phase 6: Stable Tree Analysis
Record 6.1: The buggy code exists in trees containing `dc14ba10781bd`:
verified v6.14, v6.15, v6.16, v6.17, v6.18, v6.19, and current 7.0.y
lineage. It is not applicable to v6.12/v6.13 as checked.

Record 6.2: Backport difficulty is low for the current 7.0.y checkout:
`git apply --check` for the candidate patch succeeded cleanly.

Record 6.3: Searches for this subject and “silently losing errors”
between v6.14 and v6.19 found no already-applied equivalent fix.

### Phase 7: Subsystem Context
Record 7.1: Subsystem is Btrfs filesystem metadata, specifically RAID
stripe tree support. Criticality: important to critical for users of
Btrfs filesystems with `RAID_STRIPE_TREE` enabled.

Record 7.2: The file has active recent maintenance and multiple bug
fixes, which indicates the area is actively being stabilized rather than
being a feature-only churn area.

### Phase 8: Impact And Risk
Record 8.1: Affected users are Btrfs users with the RAID stripe tree
incompat feature and supported RAID/DUP data profiles.

Record 8.2: Trigger is extent deletion/freeing where a stripe extent is
partially deleted and the helper hits allocation or B-tree operation
failure. User reachability depends on write access to such a mounted
filesystem; I verified ordinary filesystem extent-freeing paths, not a
standalone reproducer.

Record 8.3: Failure mode is hidden filesystem metadata update failure
and possible RAID stripe tree inconsistency. Severity: HIGH, with
data/metadata integrity risk.

Record 8.4: Benefit is high because errors propagate to transaction
abort handling instead of being hidden. Risk is low because the patch is
small, local, and only changes failure handling.

### Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: real error propagation bug;
filesystem metadata consistency impact; small single-file patch; all
call sites fixed; reviewed by Johannes Thumshirn; committed by David
Sterba; applies cleanly to current 7.0.y. Evidence against: no explicit
stable tag, no external bug report, no direct test tag, and only
relevant to RAID stripe tree users.

Record 9.2: Stable checklist: obviously correct, yes; fixes a real bug,
yes; important issue, yes due filesystem metadata consistency; small and
contained, yes; no new features/APIs, yes; can apply to stable, yes for
current 7.0.y and likely v6.14+ trees with the helper.

Record 9.3: No special exception category applies; this is a normal bug
fix.

Record 9.4: The technical merit supports backporting to stable trees
that contain the `int`-returning `btrfs_partially_delete_raid_extent()`
implementation. Do not backport to trees where the helper is still
`void`.

## Verification
- Phase 1: Parsed `git show --format=fuller --stat --patch
  a8d58a7c02009`; confirmed tags and message.
- Phase 2: Inspected the diff; confirmed one file, `12+ / 7-`, and three
  ignored return values fixed.
- Phase 3: Ran `git blame` on helper and call-site ranges; identified
  relevant introducer/history commits.
- Phase 3: Checked related file history on current tree and master;
  found the six-patch deletion-path series.
- Phase 3/6: Ran `git apply --check` with the candidate patch against
  current checkout; it applies cleanly.
- Phase 4: Ran `b4 dig -c`, `-a`, `-w`, and saved/read the mbox;
  verified v1 submission, review, and no patch-specific objections.
- Phase 4: WebFetch to lore was blocked by Anubis; yhbt mirror fetch
  succeeded and matched the b4 thread.
- Phase 5: Used code search and file reads to trace
  `btrfs_delete_raid_extent()` through `do_free_extent_accounting()` and
  delayed refs.
- Phase 6: Used `git merge-base --is-ancestor` to verify v6.14+ contains
  the helper returning errors; v6.12/v6.13 do not.
- Phase 8: Verified `do_free_extent_accounting()` aborts the transaction
  on nonzero return from `btrfs_delete_raid_extent()`.

**YES**

 fs/btrfs/raid-stripe-tree.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 5909ad35a1b07..86ddc3ecb4060 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -213,8 +213,9 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 			/* The "left" item. */
 			path->slots[0]--;
 			btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-			btrfs_partially_delete_raid_extent(trans, path, &key,
-							   diff_start, 0);
+			ret = btrfs_partially_delete_raid_extent(trans, path,
+								 &key,
+								 diff_start, 0);
 			break;
 		}
 
@@ -230,8 +231,11 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 		if (found_start < start) {
 			u64 diff_start = start - found_start;
 
-			btrfs_partially_delete_raid_extent(trans, path, &key,
-							   diff_start, 0);
+			ret = btrfs_partially_delete_raid_extent(trans, path,
+								 &key,
+								 diff_start, 0);
+			if (ret)
+				break;
 
 			start += (key.offset - diff_start);
 			length -= (key.offset - diff_start);
@@ -254,9 +258,10 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 		if (found_end > end) {
 			u64 diff_end = found_end - end;
 
-			btrfs_partially_delete_raid_extent(trans, path, &key,
-							   key.offset - length,
-							   length);
+			ret = btrfs_partially_delete_raid_extent(trans, path,
+								 &key,
+								 key.offset - length,
+								 length);
 			ASSERT(key.offset - diff_end == length);
 			break;
 		}
-- 
2.53.0

