Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34040 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934443AbdBQOoD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:03 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so2930827wmi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:03 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/38] btrfs: Make btrfs_orphan_reserve_metadata take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:01 +0200
Message-Id: <1487342609-20652-11-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c | 10 +++++-----
 fs/btrfs/inode.c       |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 76e661d00822..52af63e1d9a0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2695,7 +2695,7 @@ void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				  struct btrfs_fs_info *fs_info);
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
-				  struct inode *inode);
+				  struct btrfs_inode *inode);
 void btrfs_orphan_release_metadata(struct inode *inode);
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 781dfdf5556e..8ef37c85a601 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5742,10 +5742,10 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
 
 /* Can only return 0 or -ENOSPC */
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
-				  struct inode *inode)
+				  struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	/*
 	 * We always use trans->block_rsv here as we will have reserved space
 	 * for our orphan when starting the transaction, using get_block_rsv()
@@ -5762,8 +5762,8 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	 */
 	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 
-	trace_btrfs_space_reservation(fs_info, "orphan",
-				      btrfs_ino(BTRFS_I(inode)), num_bytes, 1);
+	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode), 
+			num_bytes, 1);
 	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fcdff1023718..cb5a4cc069a9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3221,7 +3221,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	/* grab metadata reservation from transaction handle */
 	if (reserve) {
-		ret = btrfs_orphan_reserve_metadata(trans, inode);
+		ret = btrfs_orphan_reserve_metadata(trans, BTRFS_I(inode));
 		ASSERT(!ret);
 		if (ret) {
 			atomic_dec(&root->orphan_inodes);
-- 
2.7.4

