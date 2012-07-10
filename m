Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:59199 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab2GJCWG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 22:22:06 -0400
Message-ID: <4FFB9193.6040306@huawei.com>
Date: Tue, 10 Jul 2012 10:21:07 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: kill free_space pointer from inode structure
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Inodes always allocate free space with BTRFS_BLOCK_GROUP_DATA type,
which means every inode has the same BTRFS_I(inode)->free_space pointer.

This shrinks struct btrfs_inode by 4 bytes (or 8 bytes on 64 bits).

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/btrfs/btrfs_inode.h |    3 ---
 fs/btrfs/ctree.h       |    3 ++-
 fs/btrfs/extent-tree.c |   20 ++++++++------------
 fs/btrfs/inode.c       |    3 ---
 4 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 12394a9..0b18b74 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -87,9 +87,6 @@ struct btrfs_inode {
 	/* node for the red-black tree that links inodes in subvolume root */
 	struct rb_node rb_node;
 
-	/* the space_info for where this inode's data allocations are done */
-	struct btrfs_space_info *space_info;
-
 	unsigned long runtime_flags;
 
 	/* full 64 bit generation number, struct vfs_inode doesn't have a big
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fa5c45b..6761490 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1240,6 +1240,8 @@ struct btrfs_fs_info {
 	 */
 	struct list_head space_info;
 
+	struct btrfs_space_info *data_sinfo;
+
 	struct reloc_control *reloc_ctl;
 
 	spinlock_t delalloc_lock;
@@ -2607,7 +2609,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
-void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bbab3ff..b1336f5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3133,6 +3133,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	init_waitqueue_head(&found->wait);
 	*space_info = found;
 	list_add_rcu(&found->list, &info->space_info);
+	if (flags & BTRFS_BLOCK_GROUP_DATA)
+		info->data_sinfo = found;
 	return 0;
 }
 
@@ -3262,12 +3264,6 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 	return get_alloc_profile(root, flags);
 }
 
-void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *inode)
-{
-	BTRFS_I(inode)->space_info = __find_space_info(root->fs_info,
-						       BTRFS_BLOCK_GROUP_DATA);
-}
-
 /*
  * This will check the space that the inode allocates from to make sure we have
  * enough space for bytes.
@@ -3276,6 +3272,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
 	int ret = 0, committed = 0, alloc_chunk = 1;
 
@@ -3288,7 +3285,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 		committed = 1;
 	}
 
-	data_sinfo = BTRFS_I(inode)->space_info;
+	data_sinfo = fs_info->data_sinfo;
 	if (!data_sinfo)
 		goto alloc;
 
@@ -3329,10 +3326,9 @@ alloc:
 					goto commit_trans;
 			}
 
-			if (!data_sinfo) {
-				btrfs_set_inode_space_info(root, inode);
-				data_sinfo = BTRFS_I(inode)->space_info;
-			}
+			if (!data_sinfo)
+				data_sinfo = fs_info->data_sinfo;
+
 			goto again;
 		}
 
@@ -3379,7 +3375,7 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
-	data_sinfo = BTRFS_I(inode)->space_info;
+	data_sinfo = root->fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
 	data_sinfo->bytes_may_use -= bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0d507e6..b189dd8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4077,7 +4077,6 @@ static int btrfs_init_locked_inode(struct inode *inode, void *p)
 	struct btrfs_iget_args *args = p;
 	inode->i_ino = args->ino;
 	BTRFS_I(inode)->root = args->root;
-	btrfs_set_inode_space_info(args->root, inode);
 	return 0;
 }
 
@@ -4662,7 +4661,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->root = root;
 	BTRFS_I(inode)->generation = trans->transid;
 	inode->i_generation = BTRFS_I(inode)->generation;
-	btrfs_set_inode_space_info(root, inode);
 
 	if (S_ISDIR(mode))
 		owner = 0;
@@ -6939,7 +6937,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	ei->root = NULL;
-	ei->space_info = NULL;
 	ei->generation = 0;
 	ei->last_trans = 0;
 	ei->last_sub_trans = 0;
-- 
1.7.9.7
