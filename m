Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35265 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934381AbdBQOn7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:59 -0500
Received: by mail-wm0-f68.google.com with SMTP id u63so2925462wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:59 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 11/38] btrfs: Make btrfs_orphan_release_metadata take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:02 +0200
Message-Id: <1487342609-20652-12-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c | 10 +++++-----
 fs/btrfs/inode.c       |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 52af63e1d9a0..8eb07a9dfa6a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2696,7 +2696,7 @@ void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 				  struct btrfs_inode *inode);
-void btrfs_orphan_release_metadata(struct inode *inode);
+void btrfs_orphan_release_metadata(struct btrfs_inode *inode);
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int nitems,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8ef37c85a601..f3ee86e178bb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5767,14 +5767,14 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 }
 
-void btrfs_orphan_release_metadata(struct inode *inode)
+void btrfs_orphan_release_metadata(struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 
-	trace_btrfs_space_reservation(fs_info, "orphan",
-				      btrfs_ino(BTRFS_I(inode)), num_bytes, 0);
+	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode), 
+			num_bytes, 0);
 	btrfs_block_rsv_release(fs_info, root->orphan_block_rsv, num_bytes);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cb5a4cc069a9..4b8ba233d20e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3243,7 +3243,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 			if (reserve) {
 				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 					  &BTRFS_I(inode)->runtime_flags);
-				btrfs_orphan_release_metadata(inode);
+				btrfs_orphan_release_metadata(BTRFS_I(inode));
 			}
 			if (ret != -EEXIST) {
 				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
@@ -3297,7 +3297,7 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 	}
 
 	if (release_rsv)
-		btrfs_orphan_release_metadata(inode);
+		btrfs_orphan_release_metadata(BTRFS_I(inode));
 
 	return ret;
 }
-- 
2.7.4

