From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: add helper for fs_info->closing
Date: Tue, 31 May 2011 18:30:06 +0200
Message-ID: <1306859406-3870-1-git-send-email-dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

wrap checking of filesystem 'closing' flag and fix a few missing memory
barriers.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

based on 'for-linus' branch of mason/btrfs-unstable.git

 fs/btrfs/ctree.h            |    9 +++++++++
 fs/btrfs/extent-tree.c      |    3 +--
 fs/btrfs/file.c             |    4 ++--
 fs/btrfs/free-space-cache.c |   10 ++++------
 fs/btrfs/inode-map.c        |    3 +--
 fs/btrfs/inode.c            |    3 +--
 fs/btrfs/scrub.c            |    2 +-
 fs/btrfs/transaction.c      |    2 +-
 8 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 332323e..07482a47 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2350,6 +2350,15 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct extent_buffer *node,
 			struct extent_buffer *parent);
+static inline int btrfs_fs_closing(struct btrfs_fs_info *fs_info)
+{
+	/*
+	 * Get synced with close_ctree()
+	 */
+	smp_mb();
+	return fs_info->closing;
+}
+
 /* root-item.c */
 int btrfs_find_root_ref(struct btrfs_root *tree_root,
 			struct btrfs_path *path,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 169bd62..ce466da 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -366,8 +366,7 @@ again:
 	nritems = btrfs_header_nritems(leaf);
 
 	while (1) {
-		smp_mb();
-		if (fs_info->closing > 1) {
+		if (btrfs_fs_closing(fs_info) > 1) {
 			last = (u64)-1;
 			break;
 		}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c6a22d7..3ba6d19 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -129,7 +129,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	if (!btrfs_test_opt(root, AUTO_DEFRAG))
 		return 0;
 
-	if (root->fs_info->closing)
+	if (btrfs_fs_closing(root->fs_info))
 		return 0;
 
 	if (BTRFS_I(inode)->in_defrag)
@@ -229,7 +229,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 		first_ino = defrag->ino + 1;
 		rb_erase(&defrag->rb_node, &fs_info->defrag_inodes);
 
-		if (fs_info->closing)
+		if (btrfs_fs_closing(fs_info))
 			goto next_free;
 
 		spin_unlock(&fs_info->defrag_inodes_lock);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 70d4579..e65a8b0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -98,7 +98,7 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 		return inode;
 
 	spin_lock(&block_group->lock);
-	if (!root->fs_info->closing) {
+	if (!btrfs_fs_closing(root->fs_info)) {
 		block_group->inode = igrab(inode);
 		block_group->iref = 1;
 	}
@@ -478,8 +478,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	 * If we're unmounting then just return, since this does a search on the
 	 * normal root and not the commit root and we could deadlock.
 	 */
-	smp_mb();
-	if (fs_info->closing)
+	if (btrfs_fs_closing(fs_info))
 		return 0;
 
 	/*
@@ -2481,7 +2480,7 @@ struct inode *lookup_free_ino_inode(struct btrfs_root *root,
 		return inode;
 
 	spin_lock(&root->cache_lock);
-	if (!root->fs_info->closing)
+	if (!btrfs_fs_closing(root->fs_info))
 		root->cache_inode = igrab(inode);
 	spin_unlock(&root->cache_lock);
 
@@ -2508,8 +2507,7 @@ int load_free_ino_cache(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 	 * If we're unmounting then just return, since this does a search on the
 	 * normal root and not the commit root and we could deadlock.
 	 */
-	smp_mb();
-	if (fs_info->closing)
+	if (btrfs_fs_closing(fs_info))
 		return 0;
 
 	path = btrfs_alloc_path();
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 3262cd1..41359bd 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -59,8 +59,7 @@ again:
 		goto out;
 
 	while (1) {
-		smp_mb();
-		if (fs_info->closing)
+		if (btrfs_fs_closing(fs_info))
 			goto out;
 
 		leaf = path->nodes[0];
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bb51bb1..66c1446 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4268,8 +4268,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	if (BTRFS_I(inode)->dummy_inode)
 		return 0;
 
-	smp_mb();
-	if (root->fs_info->closing && is_free_space_inode(root, inode))
+	if (btrfs_fs_closing(root->fs_info) && is_free_space_inode(root, inode))
 		nolock = true;
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6dfed0c..be69ff1 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1166,7 +1166,7 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 	int ret;
 	struct btrfs_device *dev;
 
-	if (root->fs_info->closing)
+	if (btrfs_fs_closing(root->fs_info))
 		return -EINVAL;
 
 	/*
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dc80f71..c2786da 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -786,7 +786,7 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 		btrfs_btree_balance_dirty(info->tree_root, nr);
 		cond_resched();
 
-		if (root->fs_info->closing || ret != -EAGAIN)
+		if (btrfs_fs_closing(root->fs_info) || ret != -EAGAIN)
 			break;
 	}
 	root->defrag_running = 0;
-- 
1.7.5.2.353.g5df3e

