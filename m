Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757489AbeD0JWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 05:22:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4C04BAC9E
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 09:22:11 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/5] btrfs: Split btrfs_del_delalloc_inode into 2 functions
Date: Fri, 27 Apr 2018 12:21:51 +0300
Message-Id: <1524820914-30864-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1524820914-30864-1-git-send-email-nborisov@suse.com>
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is in preparation of fixing delalloc inodes leakage on transaction
abort. Also export the new function.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/inode.c | 15 ++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5b7080d2fbff..27aa9b58b001 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3174,6 +3174,8 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
 			      u64 *ram_bytes);
 
+void __btrfs_del_delalloc_inode(struct btrfs_root *root,
+				struct btrfs_inode *inode);
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 078e02c21825..164950d96c8a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1742,12 +1742,12 @@ static void btrfs_add_delalloc_inodes(struct btrfs_root *root,
 	spin_unlock(&root->delalloc_lock);
 }
 
-static void btrfs_del_delalloc_inode(struct btrfs_root *root,
-				     struct btrfs_inode *inode)
+
+void __btrfs_del_delalloc_inode(struct btrfs_root *root,
+				struct btrfs_inode *inode)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 
-	spin_lock(&root->delalloc_lock);
 	if (!list_empty(&inode->delalloc_inodes)) {
 		list_del_init(&inode->delalloc_inodes);
 		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
@@ -1760,6 +1760,15 @@ static void btrfs_del_delalloc_inode(struct btrfs_root *root,
 			spin_unlock(&fs_info->delalloc_root_lock);
 		}
 	}
+}
+
+
+static void btrfs_del_delalloc_inode(struct btrfs_root *root,
+				     struct btrfs_inode *inode)
+{
+
+	spin_lock(&root->delalloc_lock);
+	__btrfs_del_delalloc_inode(root, inode);
 	spin_unlock(&root->delalloc_lock);
 }
 
-- 
2.7.4

