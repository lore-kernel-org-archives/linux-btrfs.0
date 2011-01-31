From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: handle errors in btrfs_orphan_cleanup
Date: Mon, 31 Jan 2011 16:29:58 -0500
Message-ID: <1296509398-28054-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we cannot truncate an inode for some reason we will never delete the orphan
item associated with that inode, which means that we will loop forever in
btrfs_orphan_cleanup.  Instead of doing this just return error so we fail to
mount.  It sucks, but hey it's better than hanging.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/disk-io.c     |   14 +++++++++++---
 fs/btrfs/extent-tree.c |    3 ++-
 fs/btrfs/inode.c       |   44 ++++++++++++++++++++++++++++++--------------
 fs/btrfs/ioctl.c       |    4 +++-
 fs/btrfs/relocation.c  |    2 +-
 6 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 94ab217..5be5979 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2517,7 +2517,7 @@ int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct inode *inode);
 int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode);
 int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
-void btrfs_orphan_cleanup(struct btrfs_root *root);
+int btrfs_orphan_cleanup(struct btrfs_root *root);
 void btrfs_orphan_pre_snapshot(struct btrfs_trans_handle *trans,
 				struct btrfs_pending_snapshot *pending,
 				u64 *bytes_to_reserve);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b531c36..5de9950 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2053,8 +2053,12 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_read(&fs_info->cleanup_work_sem);
-		btrfs_orphan_cleanup(fs_info->fs_root);
-		btrfs_orphan_cleanup(fs_info->tree_root);
+		err = btrfs_orphan_cleanup(fs_info->fs_root);
+		if (err)
+			goto fail_trans_kthread;
+		err = btrfs_orphan_cleanup(fs_info->tree_root);
+		if (err)
+			goto fail_trans_kthread;
 		up_read(&fs_info->cleanup_work_sem);
 	}
 
@@ -2430,8 +2434,12 @@ int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 
 		root_objectid = gang[ret - 1]->root_key.objectid + 1;
 		for (i = 0; i < ret; i++) {
+			int err;
+
 			root_objectid = gang[i]->root_key.objectid;
-			btrfs_orphan_cleanup(gang[i]);
+			err = btrfs_orphan_cleanup(gang[i]);
+			if (err)
+				return err;
 		}
 		root_objectid++;
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 77b31f5..727706a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7604,7 +7604,8 @@ int btrfs_cleanup_reloc_trees(struct btrfs_root *root)
 
 	reloc_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
 	BUG_ON(!reloc_root);
-	btrfs_orphan_cleanup(reloc_root);
+	ret = btrfs_orphan_cleanup(reloc_root);
+	BUG_ON(ret);
 	return 0;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5a97e58..43de2b8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2278,7 +2278,7 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
  * this cleans up any orphans that may be left on the list from the last use
  * of this root.
  */
-void btrfs_orphan_cleanup(struct btrfs_root *root)
+int btrfs_orphan_cleanup(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -2288,10 +2288,13 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 	int ret = 0, nr_unlink = 0, nr_truncate = 0;
 
 	if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_CLEANUP_STARTED))
-		return;
+		return 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	path->reada = -1;
 
 	key.objectid = BTRFS_ORPHAN_OBJECTID;
@@ -2300,11 +2303,8 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-		if (ret < 0) {
-			printk(KERN_ERR "Error searching slot for orphan: %d"
-			       "\n", ret);
-			break;
-		}
+		if (ret < 0)
+			goto out;
 
 		/*
 		 * if ret == 0 means we found what we were searching for, which
@@ -2339,7 +2339,10 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 		found_key.type = BTRFS_INODE_ITEM_KEY;
 		found_key.offset = 0;
 		inode = btrfs_iget(root->fs_info->sb, &found_key, root, NULL);
-		BUG_ON(IS_ERR(inode));
+		if (IS_ERR(inode)) {
+			ret = PTR_ERR(inode);
+			goto out;
+		}
 
 		/*
 		 * add this inode to the orphan list so btrfs_orphan_del does
@@ -2357,6 +2360,10 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 		 */
 		if (is_bad_inode(inode)) {
 			trans = btrfs_start_transaction(root, 0);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto out;
+			}
 			btrfs_orphan_del(trans, inode);
 			btrfs_end_transaction(trans, root);
 			iput(inode);
@@ -2371,16 +2378,16 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 				continue;
 			}
 			nr_truncate++;
-			btrfs_truncate(inode);
+			ret = btrfs_truncate(inode);
 		} else {
 			nr_unlink++;
 		}
 
 		/* this will do delete_inode and everything for us */
 		iput(inode);
+		if (ret)
+			goto out;
 	}
-	btrfs_free_path(path);
-
 	root->orphan_cleanup_state = ORPHAN_CLEANUP_DONE;
 
 	if (root->orphan_block_rsv)
@@ -2389,13 +2396,20 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 
 	if (root->orphan_block_rsv || root->orphan_item_inserted) {
 		trans = btrfs_join_transaction(root, 1);
-		btrfs_end_transaction(trans, root);
+		if (!IS_ERR(trans))
+			btrfs_end_transaction(trans, root);
 	}
 
 	if (nr_unlink)
 		printk(KERN_INFO "btrfs: unlinked %d orphans\n", nr_unlink);
 	if (nr_truncate)
 		printk(KERN_INFO "btrfs: truncated %d orphans\n", nr_truncate);
+
+out:
+	if (ret)
+		printk(KERN_CRIT "btrfs: could not do orphan cleanup %d\n", ret);
+	btrfs_free_path(path);
+	return ret;
 }
 
 /*
@@ -4148,8 +4162,10 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	if (root != sub_root) {
 		down_read(&root->fs_info->cleanup_work_sem);
 		if (!(inode->i_sb->s_flags & MS_RDONLY))
-			btrfs_orphan_cleanup(sub_root);
+			ret = btrfs_orphan_cleanup(sub_root);
 		up_read(&root->fs_info->cleanup_work_sem);
+		if (ret)
+			inode = ERR_PTR(ret);
 	}
 
 	return inode;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4d8f342..b72520b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -409,7 +409,9 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	if (ret)
 		goto fail;
 
-	btrfs_orphan_cleanup(pending_snapshot->snap);
+	ret = btrfs_orphan_cleanup(pending_snapshot->snap);
+	if (ret)
+		goto fail;
 
 	parent = dget_parent(dentry);
 	inode = btrfs_lookup_dentry(parent->d_inode, dentry);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 045c9c2..34737a0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4174,7 +4174,7 @@ out:
 		if (IS_ERR(fs_root))
 			err = PTR_ERR(fs_root);
 		else
-			btrfs_orphan_cleanup(fs_root);
+			err = btrfs_orphan_cleanup(fs_root);
 	}
 	return err;
 }
-- 
1.7.2.3

