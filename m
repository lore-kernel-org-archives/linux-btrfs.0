Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49883 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939810AbeE1QNu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:13:50 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 917FEAECB
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 16:13:48 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/11] btrfs-progs: check: Remove unused root argument from btrfs_extent_post_op
Date: Mon, 28 May 2018 09:36:46 +0300
Message-Id: <1527489410-3564-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is no longer used by the callees of that function so remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c  | 2 +-
 ctree.h       | 3 +--
 extent-tree.c | 5 ++---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/check/main.c b/check/main.c
index 71cc16735443..9a7e6b6dbde3 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8626,7 +8626,7 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 			fprintf(stderr, "Error adding block group\n");
 			return ret;
 		}
-		btrfs_extent_post_op(trans, fs_info->extent_root);
+		btrfs_extent_post_op(trans);
 	}
 
 	ret = reset_balance(trans, fs_info);
diff --git a/ctree.h b/ctree.h
index c833ad6998b9..138cd22c6c6e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2504,8 +2504,7 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans);
 void btrfs_pin_extent(struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes);
 void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
 			u64 bytenr, u64 num_bytes);
-int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root);
+int btrfs_extent_post_op(struct btrfs_trans_handle *trans);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(struct
 							 btrfs_fs_info *info,
 							 u64 bytenr);
diff --git a/extent-tree.c b/extent-tree.c
index e06fe56b5ca8..d90eb8139d8b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1426,8 +1426,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	return err;
 }
 
-int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root)
+int btrfs_extent_post_op(struct btrfs_trans_handle *trans)
 {
 	finish_current_insert(trans);
 	del_pending_extents(trans);
@@ -4012,7 +4011,7 @@ static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 		} else if (ret != -EEXIST) {
 			goto fail;
 		}
-		btrfs_extent_post_op(trans, extent_root);
+		btrfs_extent_post_op(trans);
 		extent_bytenr = disk_bytenr;
 		extent_num_bytes = num_bytes;
 		extent_offset = 0;
-- 
2.7.4

