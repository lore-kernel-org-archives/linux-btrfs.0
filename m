Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B608311975;
	Tue,  5 May 2026 09:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974774; cv=none; b=ASRj2fF0OTBbcrXYAod+nD6JdH08MVnz8kzsGg8PytHAgk038z5X73cM9nSe+Ubebiu2ZEAX9GXlRTgwW3p1Y5ZELMLz5tSSctAXkBU7KIUXTnqj/vidt+QRx+jYZ3//TB5QArQyXWRG+LwU3U9GetF3PrLJRrjaJcCKVB9DAlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974774; c=relaxed/simple;
	bh=vjE4Cv92YHNag8i6JvNnjf69Un/cmZ80a1irNkLp/8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6IhS32/LSReCcdJcTJEt0oY4sSfsCIrRM8jsQNJYsXe27z3UM76kzjHDJTU+xxWUWCd2XumhkUMMhqh80IOL7aw87biaxffdYMq4MWTh/e/Uya+Lc2ZzU/O7Dh6096rSWjPsqHejdBEqYM+214joGD2SvKc3DtCIsnifpsayOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmK62tG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmK62tG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6ACC2BCB9;
	Tue,  5 May 2026 09:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974774;
	bh=vjE4Cv92YHNag8i6JvNnjf69Un/cmZ80a1irNkLp/8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmK62tG7mO/xPEAW8wOz0l0juCpwoQxLe3HVb/q2hz5QRveBZGpbxU1lJIeSNMIhG
	 uydXealE4jy+ADCEdejROLsdzOhI/tkvcxfAZv2V6zzQYmMQhRcJrKWcx3hYKBemRA
	 zNO9NClPJ40lozbj3chei0RYaJzdsRKyY2NMMIswU/pFUd+7mGhlUSjeksIVj3/Bf/
	 XKiSqD5nqSooHedk5Nels80QHh9dNhqdn0Dv+iueOC5LMIx5wA96hoGm7b6N3YpyQG
	 NuEHlxGIDR71+6oDhinoXgskmvKrg7CNKB40zrvTcIz5K93MtA2ouWZSG21BMT9gXE
	 3sMN/BlkXd0xA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] btrfs: apply first key check for readahead when possible
Date: Tue,  5 May 2026 05:51:36 -0400
Message-ID: <20260505095149.512052-20-sashal@kernel.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit a86a283430e1a44907b142c4f53e1f3ad24e87ae ]

Currently for tree block readahead we never pass a
btrfs_tree_parent_check with @has_first_key set.

Without @has_first_key set, btrfs will skip the following extra
checks:

- Header generation check
  This is a minor one.

- Empty leaf/node checks
  This is more serious, for certain trees like the csum tree, they are
  allowed to be empty, thus an empty leaf can pass the tree checker.
  But if there is a parent node for such an empty leaf, it indicates
  corruption.

  Without @has_first_key set, we can no longer detect such a problem.

  In fact there is already a fuzzed image report that a corrupted csum
  leaf which has zero nritems but still has a parent node can trigger
  a BUG_ON() during csum deletion.

However there are only two call sites of btrfs_readahead_tree_block():

- Inside relocate_tree_blocks()
  At this call site we are trying to grab the first key of the tree
  block, thus we are not able to pass a @first_key parameter.

- Inside btrfs_readahead_node_child()
  This is the more common call site, where we have the parent node and
  want to readahead the child tree blocks.

  In this case we can easily grab the node key and pass it for checks.

Add a new parameter @first_key to btrfs_readahead_tree_block() and pass
the node key to it inside btrfs_readahead_node_child().

This should plug the gap in empty leaf detection during readahead.

Link: https://lore.kernel.org/linux-btrfs/20260409071255.3358044-1-gality369@gmail.com/
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record 1.1: Subsystem is `btrfs`; action is `apply` / `pass existing
first key`; intent is to enable existing parent/first-key validation for
tree-block readahead where the parent node is available.

Record 1.2: Tags found:
- `Link: https://lore.kernel.org/linux-
  btrfs/20260409071255.3358044-1-gality369@gmail.com/`
- `Reviewed-by: David Sterba <dsterba@suse.com>`
- `Signed-off-by: Qu Wenruo <wqu@suse.com>`
- `Signed-off-by: David Sterba <dsterba@suse.com>`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, or `Cc:
  stable@vger.kernel.org` tag in the final commit.

Record 1.3: The commit describes a real corruption-detection gap:
readahead builds a `btrfs_tree_parent_check` without `has_first_key`, so
checks that require the parent slot key are skipped. The stated failure
mode is a fuzzed corrupt csum-tree leaf with zero items but a parent
node later reaching csum deletion and triggering a `BUG_ON()`.

Record 1.4: This is a hidden bug fix, not a feature. It adds no new
behavior for valid filesystems; it makes an existing metadata integrity
check run during readahead when the caller already has the parent key.

## Phase 2: Diff Analysis
Record 2.1: Final committed diff changes 3 files: `fs/btrfs/extent_io.c`
+12/-2, `fs/btrfs/extent_io.h` +2/-1, `fs/btrfs/relocation.c` +1/-1;
total +15/-4. Modified functions are `btrfs_readahead_tree_block()`,
`btrfs_readahead_node_child()`, and the call in
`relocate_tree_blocks()`. Scope is small and Btrfs-local.

Record 2.2: Before, `btrfs_readahead_tree_block()` always initialized
parent-check data with level/transid only. After, it optionally copies a
caller-provided `first_key` and sets `has_first_key`.
`btrfs_readahead_node_child()` now derives the key from the parent node
slot and passes it. The relocation caller passes `NULL` because it lacks
the first key at that point.

Record 2.3: Bug category is filesystem metadata validation / corruption
handling. Mechanism: missing parent first-key information let readahead
read and mark a corrupt child block valid under weaker checks. Passing
the parent slot key enables existing first-key/empty-child validation
paths.

Record 2.4: Fix quality is good: small, direct, no locking changes, no
public API changes, no unrelated refactor. Regression risk is low; the
new validation applies only where the parent node already provides the
expected key. Legitimate empty roots are not children of a parent slot
with a first key.

## Phase 3: Git History Investigation
Record 3.1: `git blame` shows the current readahead helper was
introduced by `bfb484d922a3` (`btrfs: cleanup extent buffer readahead`,
described as `v5.11-rc1~144^2~112`), owner/level plumbing by
`3fbaf25817f7`, and the parent-check struct initialization in this
helper by `947a629988f1` (`v6.2-rc1~143^2~39`).
`btrfs_verify_level_key()` empty-child validation exists in the local
stable tags examined, including `v5.15`, `v6.1`, and newer.

Record 3.2: No `Fixes:` tag is present, so there was no direct fixes
target to follow for this commit.

Record 3.3: Recent file history shows related Btrfs metadata/readahead
validation work, including `f04c6475c2db` (`btrfs: revalidate cached
tree blocks on the uptodate path`) and `908ab5634751` (`btrfs: remove
atomic parameter from btrfs_buffer_uptodate()`). The candidate itself is
standalone on `master`, but older stable trees have API differences.

Record 3.4: Qu Wenruo has many recent `fs/btrfs` commits; David Sterba
is listed in `MAINTAINERS` as Btrfs maintainer and reviewed/committed
this patch.

Record 3.5: Dependency/backport finding: the patch applies cleanly to
the current `v7.0.3` working tree with offsets. `v6.6`, `v6.12`, and
`v7.0` have the `btrfs_tree_parent_check` readahead infrastructure.
`v5.15`/`v6.1` have older `read_extent_buffer_pages()` interfaces, so
they would need a tailored backport rather than the exact diff.

## Phase 4: Mailing List And External Research
Record 4.1: `b4 dig -c a86a283430e1a` failed exact patch-id matching,
then found the candidate by author/subject at
`49ae0f6badb787c1111daff252f034b7ae94f257.1775991651.git.wqu@suse.com`.
`b4 am` fetched the candidate patch and showed 3 thread messages.

Record 4.2: `b4 dig -w` mis-associated the related earlier patch thread,
so I did not rely on it for candidate recipients. The candidate mbox
shows it was sent to `linux-btrfs@vger.kernel.org`; David Sterba replied
with `Reviewed-by`.

Record 4.3: The linked bug thread contains a concrete fuzzed-image
crash: `kernel BUG at fs/btrfs/ctree.c:3388`, call chain through
`push_leaf_left()`, `btrfs_del_items()`, `btrfs_del_csums()`, delayed
refs, transaction commit, and `sync`. Qu replied that detecting the
empty non-root leaf earlier during extent-buffer validation was
preferable.

Record 4.4: Related patch context: the linked patch proposed checking
`push_leaf_left()` directly. Qu rejected that as too late and followed
with this broader readahead validation coverage patch. No newer revision
of this candidate was found; the final commit incorporated David’s minor
review by dropping the unnecessary trailing comma from the submitted
diff.

Record 4.5: WebFetch of the stable lore search was blocked by Anubis, so
stable-list discussion could not be verified through WebFetch. No
stable-specific rationale against this patch was found locally.

## Phase 5: Code Semantic Analysis
Record 5.1: Modified functions: `btrfs_readahead_tree_block()` and
`btrfs_readahead_node_child()`.

Record 5.2: Callers of `btrfs_readahead_node_child()` in the local tree
are Btrfs tree search/balance readahead in `ctree.c`, tree deletion
walking in `extent-tree.c`, chunk-tree read at mount in `volumes.c`, and
send-tree traversal in `send.c`. `relocate_tree_blocks()` calls
`btrfs_readahead_tree_block()` directly.

Record 5.3: Key callees are `btrfs_node_key_to_cpu()`,
`btrfs_node_blockptr()`, `btrfs_node_ptr_generation()`,
`btrfs_find_create_tree_block()`, `btrfs_buffer_uptodate()`, and
`read_extent_buffer_pages_nowait()`.

Record 5.4: Reachability is real for Btrfs users: metadata readahead
occurs during tree searches, balancing, send traversal, chunk-tree mount
processing, and snapshot/drop-tree walking. The concrete bug report
reaches a crash via filesystem operation and `sync` on a corrupted
mounted image.

Record 5.5: Similar pattern exists in normal tree reads:
`read_block_for_search()` already builds a parent check with
`has_first_key = true`. This patch aligns readahead with that existing
checked read path.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Record 6.1: The affected readahead helper exists from `v5.11` onward.
Local tags show `v5.15`, `v6.1`, `v6.6`, `v6.12`, and `v7.0` contain the
readahead path; `v6.6+` contain the same parent-check structure in this
area.

Record 6.2: Backport difficulty: clean for current `v7.0.3` by `git
apply --check`; likely minor/manual for `v6.6` and `v6.12`; non-trivial
for `v5.15`/`v6.1` due older metadata read APIs.

Record 6.3: No equivalent fix with the same subject was found in the
checked stable working tree. Related validation infrastructure already
exists, so this patch fills a coverage gap rather than introducing the
checker.

## Phase 7: Subsystem And Maintainer Context
Record 7.1: Subsystem is `fs/btrfs`, a production filesystem.
Criticality is IMPORTANT to CORE for Btrfs users because metadata
corruption handling can mean kernel crash or filesystem transaction
abort behavior.

Record 7.2: Btrfs is actively maintained; recent logs show ongoing Btrfs
commits from Qu Wenruo and David Sterba, and `MAINTAINERS` lists David
Sterba as maintainer.

## Phase 8: Impact And Risk Assessment
Record 8.1: Affected users are Btrfs users, especially systems
encountering corrupted metadata or fuzzed/untrusted images.

Record 8.2: Trigger requires a corrupt tree block with an empty non-root
child reachable through parent-node readahead. The crash report shows a
reachable path through Btrfs csum deletion and `sync`; unprivileged
creation/mounting of such an image was not verified.

Record 8.3: Failure mode is severe: the linked report shows a kernel
`BUG`/Oops during Btrfs metadata operations. Severity: CRITICAL for
affected systems.

Record 8.4: Benefit is high because it turns a missed corruption case
into earlier detection. Risk is low because the patch is small and only
supplies existing verifier data to existing verifier code.

## Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: fixes a real fuzzed corruption
crash path, reviewed by Btrfs maintainer, tiny Btrfs-only diff, no new
feature/API, clean on `v7.0.3`, aligns readahead with normal parent-key
validation. Evidence against: older stable trees need tailored
backports; no `Tested-by`; WebFetch stable-list search was blocked.
Unresolved: exact applicability to every older LTS branch without
writing/testing dedicated backports.

Record 9.2: Stable rules:
1. Obviously correct and tested: mostly yes by inspection and maintainer
   review; no explicit `Tested-by`.
2. Fixes a real bug: yes, linked fuzzed image crash and Btrfs
   corruption-detection gap.
3. Important issue: yes, kernel BUG/Oops on filesystem metadata path.
4. Small and contained: yes, 15 insertions / 4 deletions in Btrfs.
5. No new features/APIs: yes.
6. Can apply to stable: yes for current `v7.0.y`; likely minor/tailored
   for other modern stable trees; older LTS needs more care.

Record 9.3: No automatic exception category such as device ID, quirk,
DT, build, or docs. This is a filesystem bug fix.

Record 9.4: Decision: backport. The benefit of earlier metadata
corruption detection and avoiding a documented Btrfs BUG outweighs the
low risk of passing an existing parent key into existing checks.

## Verification
- Phase 1: Parsed `git show -s a86a283430e1a`; confirmed subject, body,
  tags, author, reviewer, and lack of `Fixes:`/`Tested-by`.
- Phase 2: Used `git show --stat --numstat` and full patch; confirmed
  files, line counts, and function changes.
- Phase 3: Used `git blame -L :btrfs_readahead_tree_block`,
  `:btrfs_readahead_node_child`, and `:btrfs_verify_level_key`;
  confirmed historical origins and validation code.
- Phase 3: Used `git log master --oneline -- fs/btrfs/...` and author
  logs; confirmed related Btrfs history and author activity.
- Phase 4: Used `b4 dig -c`, `b4 dig -a`, `b4 am`, and `b4 mbox`;
  confirmed candidate thread, related bug thread, maintainer review, and
  absence of substantive objections beyond a minor comma cleanup.
- Phase 4: WebFetch of lore pages was blocked by Anubis; b4 mbox
  provided the mailing-list content instead.
- Phase 5: Used `rg` and code reads for callers in `ctree.c`, `extent-
  tree.c`, `volumes.c`, and `send.c`; confirmed reachability through
  Btrfs metadata operations.
- Phase 6: Used `git grep` on `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v7.0`;
  confirmed code presence and API differences.
- Phase 6: Ran `git apply --check` of the candidate diff on current
  `v7.0.3`; patch applies with offsets.
- Phase 7: Checked `MAINTAINERS`; David Sterba is Btrfs maintainer.
- Phase 8: Read the linked bug mbox; confirmed the kernel BUG/Oops stack
  through `btrfs_del_csums()` and `sync`.

**YES**

 fs/btrfs/extent_io.c  | 14 ++++++++++++--
 fs/btrfs/extent_io.h  |  3 ++-
 fs/btrfs/relocation.c |  2 +-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5f97a3d2a8d72..83feb96b82673 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4593,7 +4593,8 @@ int try_release_extent_buffer(struct folio *folio)
  * to read the block we will not block on anything.
  */
 void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
-				u64 bytenr, u64 owner_root, u64 gen, int level)
+				u64 bytenr, u64 owner_root, u64 gen, int level,
+				const struct btrfs_key *first_key)
 {
 	struct btrfs_tree_parent_check check = {
 		.level = level,
@@ -4602,6 +4603,11 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *eb;
 	int ret;
 
+	if (first_key) {
+		memcpy(&check.first_key, first_key, sizeof(struct btrfs_key));
+		check.has_first_key = true;
+	}
+
 	eb = btrfs_find_create_tree_block(fs_info, bytenr, owner_root, level);
 	if (IS_ERR(eb))
 		return;
@@ -4629,9 +4635,13 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
  */
 void btrfs_readahead_node_child(struct extent_buffer *node, int slot)
 {
+	struct btrfs_key node_key;
+
+	btrfs_node_key_to_cpu(node, &node_key, slot);
 	btrfs_readahead_tree_block(node->fs_info,
 				   btrfs_node_blockptr(node, slot),
 				   btrfs_header_owner(node),
 				   btrfs_node_ptr_generation(node, slot),
-				   btrfs_header_level(node) - 1);
+				   btrfs_header_level(node) - 1,
+				   &node_key);
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 8d05f1a58b7c3..6f7e3ead1dbaa 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -264,7 +264,8 @@ static inline void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 }
 
 void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
-				u64 bytenr, u64 owner_root, u64 gen, int level);
+				u64 bytenr, u64 owner_root, u64 gen, int level,
+				const struct btrfs_key *first_key);
 void btrfs_readahead_node_child(struct extent_buffer *node, int slot);
 
 /* Note: this can be used in for loops without caching the value in a variable. */
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2519cdb401eda..ff31266a44a4d 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2610,7 +2610,7 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		if (!block->key_ready)
 			btrfs_readahead_tree_block(fs_info, block->bytenr,
 						   block->owner, 0,
-						   block->level);
+						   block->level, NULL);
 	}
 
 	/* Get first keys */
-- 
2.53.0

