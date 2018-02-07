Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56371 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754377AbeBGP4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D21EACFB
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 01/14] btrfs: Make btrfs_trans_release_metadata private to transaction.c
Date: Wed,  7 Feb 2018 17:55:37 +0200
Message-Id: <1518018950-31456-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is only ever used in __btrfs_end_transaction and
btrfs_commit_transaction so there is no need to export it via header.
Let's move it closer to where it's used, make it static and remove it
from the header. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       |  2 --
 fs/btrfs/extent-tree.c | 18 ------------------
 fs/btrfs/transaction.c | 19 +++++++++++++++++++
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index aee4365e82ba..1cc77c4bf3c3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2748,8 +2748,6 @@ void btrfs_delalloc_release_space(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
 void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 					    u64 len);
-void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info);
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 				  struct btrfs_inode *inode);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cc08e6af3542..b079ebc1f842 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5893,24 +5893,6 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 	WARN_ON(fs_info->delayed_block_rsv.reserved > 0);
 }
 
-void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info)
-{
-	if (!trans->block_rsv) {
-		ASSERT(!trans->bytes_reserved);
-		return;
-	}
-
-	if (!trans->bytes_reserved)
-		return;
-
-	ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
-	trace_btrfs_space_reservation(fs_info, "transaction",
-				      trans->transid, trans->bytes_reserved, 0);
-	btrfs_block_rsv_release(fs_info, trans->block_rsv,
-				trans->bytes_reserved);
-	trans->bytes_reserved = 0;
-}
 
 /*
  * To be called after all the new block groups attached to the transaction
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2141587195d4..beca25635787 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -818,6 +818,25 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 	return should_end_transaction(trans);
 }
 
+static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
+				  struct btrfs_fs_info *fs_info)
+{
+	if (!trans->block_rsv) {
+		ASSERT(!trans->bytes_reserved);
+		return;
+	}
+
+	if (!trans->bytes_reserved)
+		return;
+
+	ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
+	trace_btrfs_space_reservation(fs_info, "transaction",
+				      trans->transid, trans->bytes_reserved, 0);
+	btrfs_block_rsv_release(fs_info, trans->block_rsv,
+				trans->bytes_reserved);
+	trans->bytes_reserved = 0;
+}
+
 static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 				   int throttle)
 {
-- 
2.7.4

