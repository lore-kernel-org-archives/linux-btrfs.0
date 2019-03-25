Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B263C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A36B20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbfCYSqG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:46:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:38982 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5BEE4AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C4DEEDA98F; Mon, 25 Mar 2019 19:46:36 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 10/30] btrfs: get fs_info from eb in read_node_slot
Date:   Mon, 25 Mar 2019 19:46:36 +0100
Message-Id: <eccec3da9d518475d9222e92d7d0929d467f98ca.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 597337b07afa..3e26254fefe8 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1792,9 +1792,8 @@ static void root_sub_used(struct btrfs_root *root, u32 size)
 /* given a node and slot number, this reads the blocks it points to.  The
  * extent buffer is returned with a reference taken (but unlocked).
  */
-static noinline struct extent_buffer *
-read_node_slot(struct btrfs_fs_info *fs_info, struct extent_buffer *parent,
-	       int slot)
+static noinline struct extent_buffer *read_node_slot(
+				struct extent_buffer *parent, int slot)
 {
 	int level = btrfs_header_level(parent);
 	struct extent_buffer *eb;
@@ -1806,7 +1805,7 @@ read_node_slot(struct btrfs_fs_info *fs_info, struct extent_buffer *parent,
 	BUG_ON(level == 0);
 
 	btrfs_node_key_to_cpu(parent, &first_key, slot);
-	eb = read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
+	eb = read_tree_block(parent->fs_info, btrfs_node_blockptr(parent, slot),
 			     btrfs_node_ptr_generation(parent, slot),
 			     level - 1, &first_key);
 	if (!IS_ERR(eb) && !extent_buffer_uptodate(eb)) {
@@ -1863,7 +1862,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			return 0;
 
 		/* promote the child to a root */
-		child = read_node_slot(fs_info, mid, 0);
+		child = read_node_slot(mid, 0);
 		if (IS_ERR(child)) {
 			ret = PTR_ERR(child);
 			btrfs_handle_fs_error(fs_info, ret, NULL);
@@ -1903,7 +1902,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	    BTRFS_NODEPTRS_PER_BLOCK(fs_info) / 4)
 		return 0;
 
-	left = read_node_slot(fs_info, parent, pslot - 1);
+	left = read_node_slot(parent, pslot - 1);
 	if (IS_ERR(left))
 		left = NULL;
 
@@ -1918,7 +1917,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	right = read_node_slot(fs_info, parent, pslot + 1);
+	right = read_node_slot(parent, pslot + 1);
 	if (IS_ERR(right))
 		right = NULL;
 
@@ -2078,7 +2077,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	if (!parent)
 		return 1;
 
-	left = read_node_slot(fs_info, parent, pslot - 1);
+	left = read_node_slot(parent, pslot - 1);
 	if (IS_ERR(left))
 		left = NULL;
 
@@ -2131,7 +2130,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 		btrfs_tree_unlock(left);
 		free_extent_buffer(left);
 	}
-	right = read_node_slot(fs_info, parent, pslot + 1);
+	right = read_node_slot(parent, pslot + 1);
 	if (IS_ERR(right))
 		right = NULL;
 
@@ -3767,7 +3766,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	btrfs_assert_tree_locked(path->nodes[1]);
 
-	right = read_node_slot(fs_info, upper, slot + 1);
+	right = read_node_slot(upper, slot + 1);
 	/*
 	 * slot + 1 is not valid or we fail to read the right node,
 	 * no big deal, just return.
@@ -4002,7 +4001,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	btrfs_assert_tree_locked(path->nodes[1]);
 
-	left = read_node_slot(fs_info, path->nodes[1], slot - 1);
+	left = read_node_slot(path->nodes[1], slot - 1);
 	/*
 	 * slot - 1 is not valid or we fail to read the left node,
 	 * no big deal, just return.
@@ -5133,7 +5132,6 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 			 struct btrfs_path *path,
 			 u64 min_trans)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *cur;
 	struct btrfs_key found_key;
 	int slot;
@@ -5214,7 +5212,7 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 			goto out;
 		}
 		btrfs_set_path_blocking(path);
-		cur = read_node_slot(fs_info, cur, slot);
+		cur = read_node_slot(cur, slot);
 		if (IS_ERR(cur)) {
 			ret = PTR_ERR(cur);
 			goto out;
@@ -5243,7 +5241,7 @@ static int tree_move_down(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *eb;
 
 	BUG_ON(*level == 0);
-	eb = read_node_slot(fs_info, path->nodes[*level], path->slots[*level]);
+	eb = read_node_slot(path->nodes[*level], path->slots[*level]);
 	if (IS_ERR(eb))
 		return PTR_ERR(eb);
 
-- 
2.21.0

