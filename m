Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34398 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcETUur (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 16:50:47 -0400
Received: by mail-pa0-f53.google.com with SMTP id qo8so43138783pab.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 13:50:47 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team@fb.com, Omar Sandoval <osandov@fb.com>
Subject: [PATCH] Btrfs: fix ->iterate_shared() by upgrading i_rwsem for delayed nodes
Date: Fri, 20 May 2016 13:50:33 -0700
Message-Id: <1e937bd41beebb68b1bf1201205059cb8f614dad.1463777299.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Commit fe742fd4f90f ("Revert "btrfs: switch to ->iterate_shared()"")
backed out the conversion to ->iterate_shared() for Btrfs because the
delayed inode handling in btrfs_real_readdir() is racy. However, we can
still do readdir in parallel if there are no delayed nodes.

This is a temporary fix which upgrades the shared inode lock to an
exclusive lock only when we have delayed items until we come up with a
more complete solution. While we're here, rename the
btrfs_{get,put}_delayed_items functions to make it very clear that
they're just for readdir.

Tested with xfstests and by doing a parallel kernel build:

	while make tinyconfig && make -j4 && git clean dqfx; do
		:
	done

along with a bunch of parallel finds in another shell:

	while true; do
		for ((i=0; i<4; i++)); do
			find . >/dev/null &
		done
		wait
	done

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/delayed-inode.c | 27 ++++++++++++++++++++++-----
 fs/btrfs/delayed-inode.h | 10 ++++++----
 fs/btrfs/inode.c         | 10 ++++++----
 3 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 6cef0062f929..d60cd17ea66b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1606,15 +1606,23 @@ int btrfs_inode_delayed_dir_index_count(struct inode *inode)
 	return 0;
 }
 
-void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
-			     struct list_head *del_list)
+bool btrfs_readdir_get_delayed_items(struct inode *inode,
+				     struct list_head *ins_list,
+				     struct list_head *del_list)
 {
 	struct btrfs_delayed_node *delayed_node;
 	struct btrfs_delayed_item *item;
 
 	delayed_node = btrfs_get_delayed_node(inode);
 	if (!delayed_node)
-		return;
+		return false;
+
+	/*
+	 * We can only do one readdir with delayed items at a time because of
+	 * item->readdir_list.
+	 */
+	inode_unlock_shared(inode);
+	inode_lock(inode);
 
 	mutex_lock(&delayed_node->mutex);
 	item = __btrfs_first_delayed_insertion_item(delayed_node);
@@ -1641,10 +1649,13 @@ void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
 	 * requeue or dequeue this delayed node.
 	 */
 	atomic_dec(&delayed_node->refs);
+
+	return true;
 }
 
-void btrfs_put_delayed_items(struct list_head *ins_list,
-			     struct list_head *del_list)
+void btrfs_readdir_put_delayed_items(struct inode *inode,
+				     struct list_head *ins_list,
+				     struct list_head *del_list)
 {
 	struct btrfs_delayed_item *curr, *next;
 
@@ -1659,6 +1670,12 @@ void btrfs_put_delayed_items(struct list_head *ins_list,
 		if (atomic_dec_and_test(&curr->refs))
 			kfree(curr);
 	}
+
+	/*
+	 * The VFS is going to do up_read(), so we need to downgrade back to a
+	 * read lock.
+	 */
+	downgrade_write(&inode->i_rwsem);
 }
 
 int btrfs_should_delete_dir_index(struct list_head *del_list,
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 0167853c84ae..2495b3d4075f 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -137,10 +137,12 @@ void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
 void btrfs_destroy_delayed_inodes(struct btrfs_root *root);
 
 /* Used for readdir() */
-void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
-			     struct list_head *del_list);
-void btrfs_put_delayed_items(struct list_head *ins_list,
-			     struct list_head *del_list);
+bool btrfs_readdir_get_delayed_items(struct inode *inode,
+				     struct list_head *ins_list,
+				     struct list_head *del_list);
+void btrfs_readdir_put_delayed_items(struct inode *inode,
+				     struct list_head *ins_list,
+				     struct list_head *del_list);
 int btrfs_should_delete_dir_index(struct list_head *del_list,
 				  u64 index);
 int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6b7fe291a174..6ab6ca195f2f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5733,6 +5733,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	int name_len;
 	int is_curr = 0;	/* ctx->pos points to the current index? */
 	bool emitted;
+	bool put = false;
 
 	/* FIXME, use a real flag for deciding about the key type */
 	if (root->fs_info->tree_root == root)
@@ -5750,7 +5751,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (key_type == BTRFS_DIR_INDEX_KEY) {
 		INIT_LIST_HEAD(&ins_list);
 		INIT_LIST_HEAD(&del_list);
-		btrfs_get_delayed_items(inode, &ins_list, &del_list);
+		put = btrfs_readdir_get_delayed_items(inode, &ins_list,
+						      &del_list);
 	}
 
 	key.type = key_type;
@@ -5897,8 +5899,8 @@ next:
 nopos:
 	ret = 0;
 err:
-	if (key_type == BTRFS_DIR_INDEX_KEY)
-		btrfs_put_delayed_items(&ins_list, &del_list);
+	if (put)
+		btrfs_readdir_put_delayed_items(inode, &ins_list, &del_list);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -10181,7 +10183,7 @@ static const struct inode_operations btrfs_dir_ro_inode_operations = {
 static const struct file_operations btrfs_dir_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
-	.iterate	= btrfs_real_readdir,
+	.iterate_shared	= btrfs_real_readdir,
 	.unlocked_ioctl	= btrfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= btrfs_ioctl,
-- 
2.8.2

