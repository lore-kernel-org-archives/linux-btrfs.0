Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1345 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab2KZJZ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 04:25:59 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ9Pvnq009834
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 17:25:57 +0800
Message-ID: <50B335BC.7030803@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 17:26:20 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs: restructure btrfs_run_defrag_inodes()
References: <50B32FE7.5080908@cn.fujitsu.com>
In-Reply-To: <50B32FE7.5080908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch restructure btrfs_run_defrag_inodes() and make the code of the auto
defragment more readable.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |   1 +
 fs/btrfs/disk-io.c |   2 +-
 fs/btrfs/file.c    | 197 +++++++++++++++++++++++++++++------------------------
 3 files changed, 109 insertions(+), 91 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fc00ad9..4ce24ce 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3375,6 +3375,7 @@ void btrfs_auto_defrag_exit(void);
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 			   struct inode *inode);
 int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
+void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info);
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
 void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			     int skip_pinned);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7cda519..3e2e6aa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3279,7 +3279,7 @@ int close_ctree(struct btrfs_root *root)
 		   (atomic_read(&fs_info->defrag_running) == 0));
 
 	/* clear out the rbtree of defraggable inodes */
-	btrfs_run_defrag_inodes(fs_info);
+	btrfs_cleanup_defrag_inodes(fs_info);
 
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_commit_super(root);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b59f12ef..6ca2b46 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -216,11 +216,11 @@ out:
 }
 
 /*
- * must be called with the defrag_inodes lock held
+ * pick the defragable inode that we want, if it doesn't exist, we will get
+ * the next one.
  */
-struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info,
-					     u64 root, u64 ino,
-					     struct rb_node **next)
+static struct inode_defrag *
+btrfs_pick_defrag_inode(struct btrfs_fs_info *fs_info, u64 root, u64 ino)
 {
 	struct inode_defrag *entry = NULL;
 	struct inode_defrag tmp;
@@ -231,7 +231,8 @@ struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info,
 	tmp.ino = ino;
 	tmp.root = root;
 
-	p = info->defrag_inodes.rb_node;
+	spin_lock(&fs_info->defrag_inodes_lock);
+	p = fs_info->defrag_inodes.rb_node;
 	while (p) {
 		parent = p;
 		entry = rb_entry(parent, struct inode_defrag, rb_node);
@@ -242,52 +243,128 @@ struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info,
 		else if (ret > 0)
 			p = parent->rb_right;
 		else
-			return entry;
+			goto out;
 	}
 
-	if (next) {
-		while (parent && __compare_inode_defrag(&tmp, entry) > 0) {
-			parent = rb_next(parent);
+	if (parent && __compare_inode_defrag(&tmp, entry) > 0) {
+		parent = rb_next(parent);
+		if (parent)
 			entry = rb_entry(parent, struct inode_defrag, rb_node);
-		}
-		*next = parent;
+		else
+			entry = NULL;
 	}
-	return NULL;
+out:
+	if (entry)
+		rb_erase(parent, &fs_info->defrag_inodes);
+	spin_unlock(&fs_info->defrag_inodes_lock);
+	return entry;
 }
 
-/*
- * run through the list of inodes in the FS that need
- * defragging
- */
-int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
+void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info)
 {
 	struct inode_defrag *defrag;
+	struct rb_node *node;
+
+	spin_lock(&fs_info->defrag_inodes_lock);
+	node = rb_first(&fs_info->defrag_inodes);
+	while (node) {
+		rb_erase(node, &fs_info->defrag_inodes);
+		defrag = rb_entry(node, struct inode_defrag, rb_node);
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+
+		if (need_resched()) {
+			spin_unlock(&fs_info->defrag_inodes_lock);
+			cond_resched();
+			spin_lock(&fs_info->defrag_inodes_lock);
+		}
+
+		node = rb_first(&fs_info->defrag_inodes);
+	}
+	spin_unlock(&fs_info->defrag_inodes_lock);
+}
+
+#define BTRFS_DEFRAG_BATCH	1024
+
+static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
+				    struct inode_defrag *defrag)
+{
 	struct btrfs_root *inode_root;
 	struct inode *inode;
-	struct rb_node *n;
 	struct btrfs_key key;
 	struct btrfs_ioctl_defrag_range_args range;
-	u64 first_ino = 0;
-	u64 root_objectid = 0;
 	int num_defrag;
-	int defrag_batch = 1024;
 
+	/* get the inode */
+	key.objectid = defrag->root;
+	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
+	key.offset = (u64)-1;
+	inode_root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(inode_root)) {
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+		return PTR_ERR(inode_root);
+	}
+
+	key.objectid = defrag->ino;
+	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
+	key.offset = 0;
+	inode = btrfs_iget(fs_info->sb, &key, inode_root, NULL);
+	if (IS_ERR(inode)) {
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+		return PTR_ERR(inode);
+	}
+
+	/* do a chunk of defrag */
+	clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
 	memset(&range, 0, sizeof(range));
 	range.len = (u64)-1;
+	range.start = defrag->last_offset;
+	num_defrag = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
+				       BTRFS_DEFRAG_BATCH);
+	/*
+	 * if we filled the whole defrag batch, there
+	 * must be more work to do.  Queue this defrag
+	 * again
+	 */
+	if (num_defrag == BTRFS_DEFRAG_BATCH) {
+		defrag->last_offset = range.start;
+		btrfs_requeue_inode_defrag(inode, defrag);
+	} else if (defrag->last_offset && !defrag->cycled) {
+		/*
+		 * we didn't fill our defrag batch, but
+		 * we didn't start at zero.  Make sure we loop
+		 * around to the start of the file.
+		 */
+		defrag->last_offset = 0;
+		defrag->cycled = 1;
+		btrfs_requeue_inode_defrag(inode, defrag);
+	} else {
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	}
+
+	iput(inode);
+	return 0;
+}
+
+/*
+ * run through the list of inodes in the FS that need
+ * defragging
+ */
+int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
+{
+	struct inode_defrag *defrag;
+	u64 first_ino = 0;
+	u64 root_objectid = 0;
 
 	atomic_inc(&fs_info->defrag_running);
-	spin_lock(&fs_info->defrag_inodes_lock);
 	while(1) {
-		n = NULL;
+		if (!__need_auto_defrag(fs_info->tree_root))
+			break;
 
 		/* find an inode to defrag */
-		defrag = btrfs_find_defrag_inode(fs_info, root_objectid,
-						 first_ino, &n);
+		defrag = btrfs_pick_defrag_inode(fs_info, root_objectid,
+						 first_ino);
 		if (!defrag) {
-			if (n) {
-				defrag = rb_entry(n, struct inode_defrag,
-						  rb_node);
-			} else if (root_objectid || first_ino) {
+			if (root_objectid || first_ino) {
 				root_objectid = 0;
 				first_ino = 0;
 				continue;
@@ -296,71 +373,11 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 			}
 		}
 
-		/* remove it from the rbtree */
 		first_ino = defrag->ino + 1;
 		root_objectid = defrag->root;
-		rb_erase(&defrag->rb_node, &fs_info->defrag_inodes);
-
-		if (btrfs_fs_closing(fs_info))
-			goto next_free;
 
-		spin_unlock(&fs_info->defrag_inodes_lock);
-
-		/* get the inode */
-		key.objectid = defrag->root;
-		btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
-		key.offset = (u64)-1;
-		inode_root = btrfs_read_fs_root_no_name(fs_info, &key);
-		if (IS_ERR(inode_root))
-			goto next;
-
-		key.objectid = defrag->ino;
-		btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
-		key.offset = 0;
-
-		inode = btrfs_iget(fs_info->sb, &key, inode_root, NULL);
-		if (IS_ERR(inode))
-			goto next;
-
-		/* do a chunk of defrag */
-		clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
-		range.start = defrag->last_offset;
-		num_defrag = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
-					       defrag_batch);
-		/*
-		 * if we filled the whole defrag batch, there
-		 * must be more work to do.  Queue this defrag
-		 * again
-		 */
-		if (num_defrag == defrag_batch) {
-			defrag->last_offset = range.start;
-			btrfs_requeue_inode_defrag(inode, defrag);
-			/*
-			 * we don't want to kfree defrag, we added it back to
-			 * the rbtree
-			 */
-			defrag = NULL;
-		} else if (defrag->last_offset && !defrag->cycled) {
-			/*
-			 * we didn't fill our defrag batch, but
-			 * we didn't start at zero.  Make sure we loop
-			 * around to the start of the file.
-			 */
-			defrag->last_offset = 0;
-			defrag->cycled = 1;
-			btrfs_requeue_inode_defrag(inode, defrag);
-			defrag = NULL;
-		}
-
-		iput(inode);
-next:
-		spin_lock(&fs_info->defrag_inodes_lock);
-next_free:
-		if (defrag)
-			kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+		__btrfs_run_defrag_inode(fs_info, defrag);
 	}
-	spin_unlock(&fs_info->defrag_inodes_lock);
-
 	atomic_dec(&fs_info->defrag_running);
 
 	/*
-- 
1.7.11.7

