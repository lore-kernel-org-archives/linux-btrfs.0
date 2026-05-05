Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB07F32A3C9;
	Tue,  5 May 2026 09:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974798; cv=none; b=jQc5T7YektekDgzHcZhzlBERofWBL8HG5zy24rxKRntOvSdzUeB+HflLC4sw3UM+hz3DUryj2c5u06JkFMNNfcgV1igAwTG1TwBMq96ogAuMQ1lh1pRdLCSsyLIPG7zgRGjfs57uABURgpGgn67sgDwGu5A24zSaXm/LudwmS+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974798; c=relaxed/simple;
	bh=Bd++74L1nurtM3unMBgw66nx9YWWxLmwNbphN6HBMQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGDnteH8WNW0xXKmr0V/ECXN2Xl/NDEz/mXrODJU+m1bCPgJhZYHFcn/M9RsU/uzSB63Wfl/yD7kfUGgXqU49NimL+7I5vlz9el+TjNtpBDaJQIXoid1p5/FldZVLedC1VPk56S1264DpO1a5tMtJT1FYVlSpSNeD9uZ5LQUTzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpZX6xpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpZX6xpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239D9C2BCB4;
	Tue,  5 May 2026 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974798;
	bh=Bd++74L1nurtM3unMBgw66nx9YWWxLmwNbphN6HBMQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpZX6xpL4gTYOloqMi6PEno1y3YLjm38V9EujW59BmemHMvRSHyji4LhIR9Ugb6zl
	 wY94aFTwRkCjZcgxjVHUsnoyNQvMGP3sRFfJfGvnjObJ1frc/9apW27hOUdtoZAXvI
	 Rr9XUlYKbUKO8rtw8L+nWrT3NWuyULwDIu4WpP+3Ya7FZiyFNvx1vtecHcuuVF+yfP
	 fmaIR3DSYalltmlcD5iM9wtYRQTR6EGTTRFlnWyBdYIF21yz6SahZCjdkjCz96eaM8
	 ZUw+cOOJhSyDTlU6I2TrpG4uAvgr/IPG3NFTQAjf5tmQtXDYlz6sz67FnswH3MAYXP
	 ALfNawpTV3x+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] btrfs: abort transaction in do_remap_reloc_trans() on failure
Date: Tue,  5 May 2026 05:51:44 -0400
Message-ID: <20260505095149.512052-28-sashal@kernel.org>
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

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 73db0fad673af844772de964eebecae60eda0496 ]

If one of the calls made by do_remap_reloc_trans() fails, we can leave
the remap tree in an inconsistent state. Abort the transaction if this
happens, to prevent the corrupt state from reaching the disk.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: subsystem `btrfs`; action verb `abort`; claimed intent
is to abort the transaction from `do_remap_reloc_trans()` failure paths
so an inconsistent remap tree cannot be committed.

Step 1.2 Record: tags found in the actual public patch are `Reviewed-by:
Johannes Thumshirn`, `Signed-off-by: Mark Harmstone`, and `Signed-off-
by: David Sterba`. No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`,
or `Cc: stable` tag was present in the fetched patch. Notable pattern:
reviewed by a Btrfs developer and committed by David Sterba.

Step 1.3 Record: the body describes a real corruption-prevention bug:
failures in `do_remap_reloc_trans()` can leave the remap tree
inconsistent, and aborting the transaction prevents that state from
reaching disk. No stack trace, reproducer, or explicit affected versions
were in the message. Root cause, as verified from code, is that the
function can return through `fail` after transactional remap/free-space
mutations without marking the transaction aborted.

Step 1.4 Record: this is not a hidden cleanup; it is an explicit
filesystem consistency fix. The subject and body both describe
preventing corrupt on-disk state.

## Phase 2: Diff Analysis

Step 2.1 Record: one file changed, `fs/btrfs/relocation.c`, with +10/-4.
One function modified: `do_remap_reloc_trans()`. Scope is a single-
function surgical filesystem fix.

Step 2.2 Record: before the patch, four failure paths jumped to `fail`,
released local references, freed the reserved extent, unlocked
`remap_mutex`, and ended the transaction without aborting it. After the
patch, those paths call `btrfs_abort_transaction(trans, ret)` before
cleanup. The `add_remap_entry()` failure path also stops attempting
`btrfs_add_to_free_space_tree()` recovery and aborts instead.

Step 2.3 Record: bug category is filesystem metadata consistency / data
corruption prevention. `add_remap_entry()` was verified to delete or
shorten identity remap entries before adding new remap and backref
items; if a later insertion fails, returning normally can leave a
partially updated remap tree. `btrfs_abort_transaction()` was verified
to mark the transaction aborted and set filesystem error state,
preventing normal commit of that partial state.

Step 2.4 Record: the fix is minimal and consistent with Btrfs
transaction rules. `transaction.c` says after abort, call-site recovery
should be limited to freeing local allocations and passing the error up;
the patch does exactly that. Regression risk is low but not zero: the
filesystem will now abort/remount error on these rare failures instead
of attempting to continue, but that is the correct trade-off for
avoiding persistent metadata corruption.

## Phase 3: Git History Investigation

Step 3.1 Record: `git blame` shows the changed error paths were
introduced by `fd6594b1446cc` (`btrfs: replace identity remaps with
actual remaps when doing relocations`), authored by Mark Harmstone in
Jan 2026 and merged for the 7.0 cycle. First containing tag verified as
`v7.0-rc1~232^2~74`.

Step 3.2 Record: no `Fixes:` tag is present, so there was no explicit
tag to follow. Independent blame identifies `fd6594b1446cc` as the
introducer, and that commit exists in `stable/linux-7.0.y` but not older
checked stable branches.

Step 3.3 Record: recent local history for `fs/btrfs/relocation.c` shows
several remap-tree fixes around the same code, including block-group
reference, NULL root checks, transaction handle leak, and remap-tree
setup fixes. The candidate itself is standalone; no prerequisite was
found for the shown hunk to apply to `stable/linux-7.0.y`.

Step 3.4 Record: the author, Mark Harmstone, authored the remap-tree
relocation code and several nearby Btrfs fixes. David Sterba committed
both the introducer and the candidate in the Btrfs development tree.

Step 3.5 Record: related nearby commit `942bcf6d1884` fixes a separate
`bytes_may_use` leak in the same function. It is not a prerequisite for
this abort fix; the candidate patch applies cleanly to current
`stable/linux-7.0.y` in a dry-run.

## Phase 4: Mailing List And External Research

Step 4.1 Record: `b4 dig -c a41c84ba2f51303b7dca2ccf426d99c4a3a757b3`
failed because the commit object is not present in this local clone. Web
research found the original v2 thread at `https://yhbt.net/lore/linux-
btrfs/3a0c1b94-4404-4726-aafe-809c425707fc@wdc.com/T/`. The thread shows
v2 and notes the change from aborting at the end to aborting in place so
line numbers are logged properly.

Step 4.2 Record: `b4 dig -w` also failed for the same nonlocal commit
reason. The fetched lore mirror shows recipients `linux-btrfs` and Boris
Burkov, and a review reply from Johannes Thumshirn with `Reviewed-by`.

Step 4.3 Record: no separate bug report, syzbot report, or Bugzilla link
was found in the commit or lore thread. Severity comes from the patch
description and verified code mechanism: possible persistent remap-tree
inconsistency.

Step 4.4 Record: lore shows this patch as a standalone `[PATCH v2]`, not
a numbered multi-patch series. Web search found a separate same-function
accounting leak fix, but no dependency relationship.

Step 4.5 Record: stable-specific search did not find a usable stable
discussion; direct lore stable fetches were blocked by Anubis. No
evidence of a known objection or rejection was found.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: modified function is `do_remap_reloc_trans()`.

Step 5.2 Record: caller chain verified as `btrfs_ioctl_balance()` ->
`btrfs_balance()` -> `__btrfs_balance()` -> `btrfs_relocate_chunk()` ->
`btrfs_relocate_block_group()` -> `do_remap_reloc()` ->
`do_remap_reloc_trans()`. Other verified callers of
`btrfs_relocate_chunk()` include device shrink, block-group reclaim, and
zoned repair paths. Balance ioctl requires `CAP_SYS_ADMIN`.

Step 5.3 Record: key callees include
`btrfs_add_block_group_free_space()`, `copy_remapped_data()`,
`btrfs_remove_from_free_space_tree()`, `add_remap_entry()`,
`btrfs_free_reserved_extent()`, and `btrfs_end_transaction()`.
`add_remap_entry()` calls `btrfs_del_item()`,
`btrfs_set_item_key_safe()`, `add_remap_item()`,
`btrfs_insert_empty_item()`, and `add_remap_backref_item()`.

Step 5.4 Record: the buggy path is reachable from privileged userspace
via Btrfs balance and from kernel maintenance paths such as
reclaim/shrink. It is only active when
`should_relocate_using_remap_tree()` is true: filesystem has the
`REMAP_TREE` incompat feature and the block group is not system or
metadata-remap.

Step 5.5 Record: similar local patterns support aborting.
`move_existing_remap()` aborts the transaction on error before
ending/committing, and `start_block_group_remapping()` aborts on remap-
tree setup failures. `transaction.h` explicitly says to call
`btrfs_abort_transaction()` as early as possible.

## Phase 6: Cross-Referencing And Stable Tree Analysis

Step 6.1 Record: `stable/linux-7.0.y` contains `do_remap_reloc_trans()`.
`stable/linux-6.19.y`, `stable/linux-6.18.y`, `stable/linux-6.12.y`, and
`stable/linux-6.6.y` do not contain this function or remap-tree support
in the checked paths. The bug is therefore relevant to 7.0.y, not older
stable branches checked.

Step 6.2 Record: dry-run `git apply --check` of the candidate hunk
succeeded against current `stable/linux-7.0.y`, so expected backport
difficulty is clean for 7.0.y.

Step 6.3 Record: local `stable/linux-7.0.y` does not already contain the
candidate subject, and the current file still has the pre-fix failure
paths.

## Phase 7: Subsystem And Maintainer Context

Step 7.1 Record: subsystem is Btrfs filesystem code under `fs/btrfs`,
criticality IMPORTANT. It is not universal core code, but filesystem
metadata corruption is a high-severity stable concern for affected Btrfs
users.

Step 7.2 Record: subsystem activity is high in this area; local history
shows many Btrfs remap-tree commits and fixes in the 7.0 cycle. This is
recently introduced code, but it is already present in the 7.0 stable
tree.

## Phase 8: Impact And Risk Assessment

Step 8.1 Record: affected population is config/filesystem-specific:
users running kernels with Btrfs experimental/remap-tree support and
filesystems using the `REMAP_TREE` incompat feature, during
relocation/balance/shrink/reclaim paths.

Step 8.2 Record: trigger conditions are failures from the remap
relocation sequence after reservation and during free-space/remap-
tree/data-copy operations. Verified user trigger via balance requires
`CAP_SYS_ADMIN`; unprivileged trigger was not verified.

Step 8.3 Record: failure mode is potential persistent filesystem
metadata inconsistency / corruption of the remap tree. Severity is
CRITICAL for affected users because the commit’s stated goal is to
prevent corrupt state from reaching disk and code inspection confirms
partial remap-tree mutations can occur before error returns.

Step 8.4 Record: benefit is high for affected 7.0.y users because it
prevents committing inconsistent filesystem metadata. Risk is low: one
function, 10 additions and 4 removals, no API changes, and behavior only
changes rare error paths to abort the transaction.

## Phase 9: Final Synthesis

Step 9.1 Record: evidence for backporting is strong: real filesystem
consistency bug, verified partial transactional mutations in
`add_remap_entry()`, small single-function fix, reviewed on linux-btrfs,
clean dry-run apply to `stable/linux-7.0.y`, and Btrfs transaction
documentation supports early abort. Evidence against is limited to scope
of affected users: remap-tree is experimental/config-specific and the
bug only exists in 7.0.y among checked stable branches. Unresolved: no
independent reproducer or user report was found, and direct lore/stable
search was partially blocked.

Step 9.2 Record: stable rules checklist:
1. Obviously correct and tested: yes for correctness by inspection;
   reviewed by Johannes Thumshirn. No `Tested-by` found.
2. Fixes a real bug: yes, prevents inconsistent remap-tree state after
   transactional failure paths.
3. Important issue: yes, potential on-disk filesystem corruption.
4. Small and contained: yes, one function in one file, +10/-4.
5. No new features/APIs: yes.
6. Can apply to stable: yes for `stable/linux-7.0.y`; not applicable to
   older checked stable branches lacking the code.

Step 9.3 Record: no exception category like device ID, quirk, DT, build,
or docs applies. This is a normal serious filesystem bug fix.

Step 9.4 Decision: backport to stable trees that contain the remap-tree
relocation code, specifically 7.0.y based on the checked branches. Do
not try to apply it to older stable trees that lack
`do_remap_reloc_trans()`.

## Verification

- [Phase 1] Fetched public patch from GitHub commit
  `a41c84ba2f51303b7dca2ccf426d99c4a3a757b3`; confirmed subject, body,
  tags, and +10/-4 diff.
- [Phase 2] Read `fs/btrfs/relocation.c`; confirmed old failure paths
  end the transaction without aborting.
- [Phase 2] Read `add_remap_entry()`; confirmed it can delete/shorten
  identity remap state before later operations fail.
- [Phase 2] Read `transaction.h` and `transaction.c`; confirmed
  `btrfs_abort_transaction()` records abort state and transaction abort
  rules favor local cleanup only.
- [Phase 3] `git blame -L 5032,5049 -- fs/btrfs/relocation.c`: changed
  lines introduced by `fd6594b1446cc`.
- [Phase 3] `git show --stat --format=fuller fd6594b1446cc --
  fs/btrfs/relocation.c`: introducer is `btrfs: replace identity remaps
  with actual remaps when doing relocations`, +326 lines.
- [Phase 3] `git describe --contains fd6594b1446cc`: first containing
  point reported in the 7.0-rc1 range.
- [Phase 3] `git log --author='Mark Harmstone' -10 -- fs/btrfs`: author
  has multiple nearby Btrfs/remap fixes.
- [Phase 4] `b4 dig -c`, `-a`, and `-w` failed because the candidate
  commit object is not in this local clone.
- [Phase 4] Fetched lore mirror thread; confirmed `[PATCH v2]`, v2
  change note, and `Reviewed-by` reply from Johannes Thumshirn.
- [Phase 4] Web searches found no usable stable-specific discussion;
  direct lore stable fetch was blocked by Anubis.
- [Phase 5] `rg` and file reads traced callers from balance ioctl and
  maintenance paths to `do_remap_reloc_trans()`.
- [Phase 5] Read `relocation.h`; confirmed remap-tree relocation
  condition.
- [Phase 6] `git grep` on stable branches: function exists in
  `stable/linux-7.0.y`; not found in checked `6.19.y`, `6.18.y`,
  `6.12.y`, or `6.6.y`.
- [Phase 6] `git apply --check` of the candidate hunk succeeded against
  current `stable/linux-7.0.y`.
- [Phase 6] `git log --grep` in `stable/linux-7.0.y` found no existing
  candidate commit.
- UNVERIFIED: no runtime test, fstest, or reproducer was run.
- UNVERIFIED: direct canonical lore.kernel.org pages were blocked by
  Anubis, so I used the available lore mirror and GitHub commit content.

The risk-benefit balance is clearly favorable for affected stable trees:
this is a small, reviewed, error-path-only Btrfs fix that prevents
potentially persistent filesystem metadata corruption.

**YES**

 fs/btrfs/relocation.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 033f74fd6225c..2519cdb401eda 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5031,21 +5031,27 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 
 	if (bg_needs_free_space) {
 		ret = btrfs_add_block_group_free_space(trans, dest_bg);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
 			goto fail;
+		}
 	}
 
 	ret = copy_remapped_data(fs_info, start, new_addr, length);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		goto fail;
+	}
 
 	ret = btrfs_remove_from_free_space_tree(trans, new_addr, length);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		goto fail;
+	}
 
 	ret = add_remap_entry(trans, path, src_bg, start, new_addr, length);
 	if (ret) {
-		btrfs_add_to_free_space_tree(trans, new_addr, length);
+		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
 
-- 
2.53.0

