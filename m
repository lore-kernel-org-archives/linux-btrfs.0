Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754554AbeBGP4F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:05 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 39E62ADD3
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 05/14] btrfs: Don't pass fs_info arg to btrfs_start_dirty_block_groups
Date: Wed,  7 Feb 2018 17:55:41 +0200
Message-Id: <1518018950-31456-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction so no point in passing
it as a function argument. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/transaction.c | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9963b6caadeb..f929685b80e2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2690,8 +2690,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner, u64 offset);
 
-int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info);
+int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				   struct btrfs_fs_info *fs_info);
 int btrfs_setup_space_cache(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 99bfc628ab89..47c27fc403b9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3660,9 +3660,9 @@ int btrfs_setup_space_cache(struct btrfs_trans_handle *trans,
  * the commit latency by getting rid of the easy block groups while
  * we're still allowing others to join the commit.
  */
-int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info)
+int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	int ret = 0;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 82b7e5855119..aef311531ab2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2014,7 +2014,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		mutex_unlock(&fs_info->ro_block_group_mutex);
 
 		if (run_it)
-			ret = btrfs_start_dirty_block_groups(trans, fs_info);
+			ret = btrfs_start_dirty_block_groups(trans);
 	}
 	if (ret) {
 		btrfs_end_transaction(trans);
-- 
2.7.4

