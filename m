Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754382AbeBGP4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 70425ADCB
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/14] btrfs: Open code btrfs_write_and_wait_marked_extents
Date: Wed,  7 Feb 2018 17:55:38 +0200
Message-Id: <1518018950-31456-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_write_and_wait_transaction is essentially a wrapper of
btrfs_write_and_wait_marked_extents with the addition of calling
clear_btree_io_tree. Having the code split doesn't really bring any
benefit. Open code the later into the former and add proper
documentation header.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index beca25635787..5ca4302c136c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1082,41 +1082,33 @@ int btrfs_wait_tree_log_extents(struct btrfs_root *log_root, int mark)
 	return err;
 }
 
-/*
- * when btree blocks are allocated, they have some corresponding bits set for
- * them in one of two extent_io trees.  This is used to make sure all of
- * those extents are on disk for transaction or log commit
+
+/* btrfs_write_and_wait_transaction - When btree blocks are allocated the
+ * corresponding extents are marked dirty. This function ensures such extents
+ * are persisted on disk for  * transaction or log commit.
+ *
+ * @trans: transaction whose dirty pages we'd like to write
  */
-static int btrfs_write_and_wait_marked_extents(struct btrfs_fs_info *fs_info,
-				struct extent_io_tree *dirty_pages, int mark)
+static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
+					    struct btrfs_fs_info *fs_info)
 {
-	int ret;
-	int ret2;
+	struct extent_io_tree *dirty_pages = &trans->transaction->dirty_pages;
 	struct blk_plug plug;
+	int ret, ret2;
 
 	blk_start_plug(&plug);
-	ret = btrfs_write_marked_extents(fs_info, dirty_pages, mark);
+	ret = btrfs_write_marked_extents(fs_info, dirty_pages, EXTENT_DIRTY);
 	blk_finish_plug(&plug);
 	ret2 = btrfs_wait_extents(fs_info, dirty_pages);
 
+	clear_btree_io_tree(&trans->transaction->dirty_pages);
+
 	if (ret)
 		return ret;
-	if (ret2)
+	else if (ret2)
 		return ret2;
-	return 0;
-}
-
-static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-					    struct btrfs_fs_info *fs_info)
-{
-	int ret;
-
-	ret = btrfs_write_and_wait_marked_extents(fs_info,
-					   &trans->transaction->dirty_pages,
-					   EXTENT_DIRTY);
-	clear_btree_io_tree(&trans->transaction->dirty_pages);
-
-	return ret;
+	else
+		return 0;
 }
 
 /*
-- 
2.7.4

