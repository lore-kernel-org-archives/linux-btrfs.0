Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E278CC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 11:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B934F20830
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 11:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfDCL72 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 07:59:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:36394 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbfDCL72 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 07:59:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1D68ABD4
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 11:59:26 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: tree-checker: Remove comprehensive root owner check
Date:   Wed,  3 Apr 2019 19:59:19 +0800
Message-Id: <20190403115919.17049-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190403115919.17049-1-wqu@suse.com>
References: <20190403115919.17049-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 1ba98d086fe3 ("Btrfs: detect corruption when non-root leaf has
zero item") introduced comprehensive root owner checker.

However it's pretty expensive tree search to locate the owner root,
especially when it get reused by mandatory read and write time
tree-checker.

This patch will remove that check, and completely rely on owner based
empty leaf check, which is much faster and still works fine for most
case.

And since we skip the old root owner check, now write time tree check
can be merged with btrfs_check_leaf_full().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c      |  2 +-
 fs/btrfs/tree-checker.c | 51 +++--------------------------------------
 fs/btrfs/tree-checker.h |  2 --
 3 files changed, 4 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c3b89584dad6..fddcf7d7c30c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -539,7 +539,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	if (btrfs_header_level(eb))
 		err = btrfs_check_node(fs_info, eb);
 	else
-		err = btrfs_check_leaf_write(fs_info, eb);
+		err = btrfs_check_leaf_full(fs_info, eb);
 
 	if (err < 0) {
 		btrfs_err(fs_info,
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 204fe53c90aa..e325d4df5c23 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -812,8 +812,7 @@ static int check_leaf_item(struct extent_buffer *leaf,
 	return ret;
 }
 
-static int check_leaf(struct extent_buffer *leaf, bool check_item_data,
-		      bool check_empty_leaf)
+static int check_leaf(struct extent_buffer *leaf, bool check_item_data)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	/* No valid key type is 0, so all key should be larger than this key */
@@ -839,7 +838,6 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data,
 	 */
 	if (nritems == 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)) {
 		u64 owner = btrfs_header_owner(leaf);
-		struct btrfs_root *check_root;
 
 		/* These trees must never be empty */
 		if (owner == BTRFS_ROOT_TREE_OBJECTID ||
@@ -853,38 +851,6 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data,
 				    owner);
 			return -EUCLEAN;
 		}
-
-		/*
-		 * Don't check empty leaves at write time for trees where we
-		 * can't use @owner to indicate the right owner. This happens
-		 * for reloc trees or for a new commit root.
-		 */
-		if (!check_empty_leaf)
-			return 0;
-
-		key.objectid = owner;
-		key.type = BTRFS_ROOT_ITEM_KEY;
-		key.offset = (u64)-1;
-
-		check_root = btrfs_get_fs_root(fs_info, &key, false);
-		/*
-		 * The only reason we also check NULL here is that during
-		 * open_ctree() some roots has not yet been set up.
-		 */
-		if (!IS_ERR_OR_NULL(check_root)) {
-			struct extent_buffer *eb;
-
-			eb = btrfs_root_node(check_root);
-			/* if leaf is the root, then it's fine */
-			if (leaf != eb) {
-				generic_err(leaf, 0,
-		"invalid nritems, have %u should not be 0 for non-root leaf",
-					nritems);
-				free_extent_buffer(eb);
-				return -EUCLEAN;
-			}
-			free_extent_buffer(eb);
-		}
 		return 0;
 	}
 
@@ -982,24 +948,13 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data,
 int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
 			  struct extent_buffer *leaf)
 {
-	return check_leaf(leaf, true, true);
+	return check_leaf(leaf, true);
 }
 
 int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
 			     struct extent_buffer *leaf)
 {
-	return check_leaf(leaf, false, true);
-}
-
-/*
- * Write time specific leaf checker.
- * Don't check if the empty leaf belongs to a tree root. Mostly for balance
- * and new tree created in current transaction.
- */
-int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *leaf)
-{
-	return check_leaf(leaf, true, false);
+	return check_leaf(leaf, false);
 }
 
 int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index 281eb7136bc1..4df45e8a6659 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -23,8 +23,6 @@ int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
  */
 int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
 			     struct extent_buffer *leaf);
-int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *leaf);
 int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
 
 int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
-- 
2.21.0

