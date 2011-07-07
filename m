From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix return value check of btrfs_alloc_path()
Date: Thu, 07 Jul 2011 18:31:44 +0900
Message-ID: <201107070931.AA00030@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The return value check of btrfs_alloc_path() in several places is
changed from BUG_ON() to error return.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    3 ++-
 fs/btrfs/extent_io.c   |    9 ++++++---
 fs/btrfs/inode.c       |   15 +++++++++++----
 fs/btrfs/ioctl.c       |    1 +
 4 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71cd456..624ca25 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5494,7 +5494,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b181a94..9703b65 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2222,9 +2222,12 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 				delalloc_start = delalloc_end + 1;
 				continue;
 			}
-			tree->ops->fill_delalloc(inode, page, delalloc_start,
-						 delalloc_end, &page_started,
-						 &nr_written);
+			ret = tree->ops->fill_delalloc(inode, page,
+						       delalloc_start,
+						       delalloc_end,
+						       &page_started,
+						       &nr_written);
+			BUG_ON(ret);
 			/*
 			 * delalloc_end is already one less than the total
 			 * length, so we don't subtract one from
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 447612d..d0dee5e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1070,7 +1070,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	nolock = is_free_space_inode(root, inode);
 
@@ -3711,7 +3712,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	int ret = 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
 				    namelen, 0);
@@ -4436,7 +4438,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	int owner;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return ERR_PTR(-ENOMEM);
 
 	inode = new_inode(root->fs_info->sb);
 	if (!inode) {
@@ -7192,7 +7195,11 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		err = -ENOMEM;
+		drop_inode = 1;
+		goto out_unlock;
+	}
 	key.objectid = btrfs_ino(inode);
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..b12f7fe 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -415,6 +415,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	btrfs_record_root_in_trans(trans, new_root);
 
 	ret = btrfs_create_subvol_root(trans, new_root, new_dirid);
+	BUG_ON(ret);
 	/*
 	 * insert the directory item
 	 */


