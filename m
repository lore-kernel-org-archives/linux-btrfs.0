Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751653AbeCOOAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 10:00:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7F7B0AFD2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 14:00:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/4] btrfs: Drop fs_info parameter from btrfs_finish_extent_commit
Date: Thu, 15 Mar 2018 16:00:26 +0200
Message-Id: <1521122427-25062-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1521122427-25062-1-git-send-email-nborisov@suse.com>
References: <1521122427-25062-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the trans handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/transaction.c | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b037541d393d..fbe51edb9cac 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2682,8 +2682,7 @@ int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
 int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
 				       u64 start, u64 len);
 void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
-int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info);
+int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f931c0d59fd3..71d59ec02f08 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6770,9 +6770,9 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info)
+int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_block_group_cache *block_group, *tmp;
 	struct list_head *deleted_bgs;
 	struct extent_io_tree *unpin;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0a582a1adaf3..d093b13799fc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2272,7 +2272,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (ret)
 		goto scrub_continue;
 
-	btrfs_finish_extent_commit(trans, fs_info);
+	btrfs_finish_extent_commit(trans);
 
 	if (test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &cur_trans->flags))
 		btrfs_clear_space_info_full(fs_info);
-- 
2.7.4

