Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49815 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936494AbeE1QNt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:13:49 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4828BAE88
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 16:13:47 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 11/11] btrfs-progs: Remove fs_info argument from write_ctree_super
Date: Mon, 28 May 2018 09:36:50 +0300
Message-Id: <1527489410-3564-12-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes a transaction handle which has a reference
to the fs_info, so use that to obtain it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 disk-io.c     | 6 +++---
 disk-io.h     | 3 +--
 transaction.c | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 456b354cb727..4a609a892be7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1606,10 +1606,10 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
-int write_ctree_super(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info)
+int write_ctree_super(struct btrfs_trans_handle *trans)
 {
 	int ret;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *chunk_root = fs_info->chunk_root;
 
@@ -1657,7 +1657,7 @@ int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
 		BUG_ON(ret);
 		ret = __commit_transaction(trans, root);
 		BUG_ON(ret);
-		write_ctree_super(trans, fs_info);
+		write_ctree_super(trans);
 		kfree(trans);
 	}
 
diff --git a/disk-io.h b/disk-io.h
index 36fb68cdb86a..fefdb0a75d07 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -164,8 +164,7 @@ static inline int close_ctree(struct btrfs_root *root)
 }
 
 int write_all_supers(struct btrfs_fs_info *fs_info);
-int write_ctree_super(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info);
+int write_ctree_super(struct btrfs_trans_handle *trans);
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		unsigned sbflags);
 int btrfs_map_bh_to_logical(struct btrfs_root *root, struct extent_buffer *bh,
diff --git a/transaction.c b/transaction.c
index ad70572838c1..9619265ef6e8 100644
--- a/transaction.c
+++ b/transaction.c
@@ -168,7 +168,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 	ret = __commit_transaction(trans, root);
 	BUG_ON(ret);
-	write_ctree_super(trans, fs_info);
+	write_ctree_super(trans);
 	btrfs_finish_extent_commit(trans, fs_info->extent_root,
 			           &fs_info->pinned_extents);
 	kfree(trans);
-- 
2.7.4

