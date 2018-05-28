Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43546 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425226AbeE1PyG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:06 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 556AFAE7C
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 15:54:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/11] btrfs-progs: check: Remove root parameter from btrfs_fix_block_accounting
Date: Mon, 28 May 2018 09:36:41 +0300
Message-Id: <1527489410-3564-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's always set to extent_root and the function already takes a
transaction handle where fs_info could be referenced and in turn
the extent_tree.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c        | 2 +-
 check/mode-lowmem.c | 2 +-
 ctree.h             | 3 +--
 extent-tree.c       | 8 +++-----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/check/main.c b/check/main.c
index 4cf243d9b379..71cc16735443 100644
--- a/check/main.c
+++ b/check/main.c
@@ -7671,7 +7671,7 @@ static int check_extent_refs(struct btrfs_root *root,
 				goto repair_abort;
 			}
 
-			ret = btrfs_fix_block_accounting(trans, root);
+			ret = btrfs_fix_block_accounting(trans);
 			if (ret)
 				goto repair_abort;
 			ret = btrfs_commit_transaction(trans, root);
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 9890180d1d3c..410c5f635d4e 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -556,7 +556,7 @@ static int repair_block_accounting(struct btrfs_fs_info *fs_info)
 		return ret;
 	}
 
-	ret = btrfs_fix_block_accounting(trans, root);
+	ret = btrfs_fix_block_accounting(trans);
 	btrfs_commit_transaction(trans, root);
 	return ret;
 }
diff --git a/ctree.h b/ctree.h
index 697895a9e098..c833ad6998b9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2500,8 +2500,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			 u64 num_bytes, u64 empty_size,
 			 u64 hint_byte, u64 search_end,
 			 struct btrfs_key *ins, bool is_data);
-int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root);
+int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans);
 void btrfs_pin_extent(struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes);
 void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
 			u64 bytenr, u64 num_bytes);
diff --git a/extent-tree.c b/extent-tree.c
index 1b8a4f8cb1c3..3132ccc8d44f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3788,8 +3788,7 @@ int btrfs_free_block_group(struct btrfs_trans_handle *trans,
  * Fixup block accounting. The initial block accounting created by
  * make_block_groups isn't accuracy in this case.
  */
-int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root)
+int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans)
 {
 	int ret = 0;
 	int slot;
@@ -3799,9 +3798,8 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	struct btrfs_block_group_cache *cache;
-	struct btrfs_fs_info *fs_info = root->fs_info;
-
-	root = root->fs_info->extent_root;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *root = fs_info->extent_root;
 
 	while(extent_root_pending_ops(fs_info)) {
 		ret = finish_current_insert(trans, root);
-- 
2.7.4

