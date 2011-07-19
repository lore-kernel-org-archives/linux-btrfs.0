From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: kill space_info pointer from inode structure
Date: Tue, 19 Jul 2011 14:23:36 +0800
Message-ID: <4E2522E8.5030800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Inodes always allocate from space with BTRFS_BLOCK_GROUP_DATA type,
which means every inode has the same BTRFS_I(inode)->space_info.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    3 ---
 fs/btrfs/ctree.h       |    2 ++
 fs/btrfs/extent-tree.c |   20 ++++++++------------
 fs/btrfs/inode.c       |    3 ---
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 52d7eca..0daab1f 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -69,9 +69,6 @@ struct btrfs_inode {
 	/* node for the red-black tree that links inodes in subvolume root */
 	struct rb_node rb_node;
 
-	/* the space_info for where this inode's data allocations are done */
-	struct btrfs_space_info *space_info;
-
 	/* full 64 bit generation number, struct vfs_inode doesn't have a big
 	 * enough field for this.
 	 */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3998d90..26d2bb9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1068,6 +1068,8 @@ struct btrfs_fs_info {
 	 */
 	struct list_head space_info;
 
+	struct btrfs_space_info *data_sinfo;
+
 	struct reloc_control *reloc_ctl;
 
 	spinlock_t delalloc_lock;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71cd456..39e7bbe 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2935,6 +2935,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	*space_info = found;
 	list_add_rcu(&found->list, &info->space_info);
 	atomic_set(&found->caching_threads, 0);
+	if (flags & BTRFS_BLOCK_GROUP_DATA)
+		info->data_sinfo = found;
 	return 0;
 }
 
@@ -3016,12 +3018,6 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
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
@@ -3030,6 +3026,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
 	int ret = 0, committed = 0, alloc_chunk = 1;
 
@@ -3042,7 +3039,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 		committed = 1;
 	}
 
-	data_sinfo = BTRFS_I(inode)->space_info;
+	data_sinfo = fs_info->data_sinfo;
 	if (!data_sinfo)
 		goto alloc;
 
@@ -3083,10 +3080,9 @@ alloc:
 					goto commit_trans;
 			}
 
-			if (!data_sinfo) {
-				btrfs_set_inode_space_info(root, inode);
-				data_sinfo = BTRFS_I(inode)->space_info;
-			}
+			if (!data_sinfo)
+				data_sinfo = root->fs_info->data_sinfo;
+
 			goto again;
 		}
 
@@ -3134,7 +3130,7 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
-	data_sinfo = BTRFS_I(inode)->space_info;
+	data_sinfo = root->fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
 	data_sinfo->bytes_may_use -= bytes;
 	BTRFS_I(inode)->reserved_bytes -= bytes;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d340f63..af8e14f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3934,7 +3934,6 @@ static int btrfs_init_locked_inode(struct inode *inode, void *p)
 	struct btrfs_iget_args *args = p;
 	inode->i_ino = args->ino;
 	BTRFS_I(inode)->root = args->root;
-	btrfs_set_inode_space_info(args->root, inode);
 	return 0;
 }
 
@@ -4469,7 +4468,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->root = root;
 	BTRFS_I(inode)->generation = trans->transid;
 	inode->i_generation = BTRFS_I(inode)->generation;
-	btrfs_set_inode_space_info(root, inode);
 
 	if (mode & S_IFDIR)
 		owner = 0;
@@ -6720,7 +6718,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	ei->root = NULL;
-	ei->space_info = NULL;
 	ei->generation = 0;
 	ei->sequence = 0;
 	ei->last_trans = 0;
-- 1.7.3.1 
