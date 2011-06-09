From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: turn to readonly if btrfs_start_transaction() fails
Date: Thu, 09 Jun 2011 18:38:52 +0900
Message-ID: <201106090938.AA00023@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_start_transaction() fails, we should call btrfs_std_error()
properly for filesystem to readonly.
(in this patch, forced readonly framework is used)

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/file.c        |    1 +
 fs/btrfs/inode.c       |   34 +++++++++++++++++++++++++++-------
 fs/btrfs/ioctl.c       |   11 ++++++++++-
 fs/btrfs/relocation.c  |    4 +++-
 fs/btrfs/super.c       |    4 +++-
 fs/btrfs/transaction.c |    4 +++-
 fs/btrfs/transaction.h |    6 ++++++
 fs/btrfs/tree-log.c    |    7 ++++++-
 fs/btrfs/volumes.c     |    3 +++
 fs/btrfs/xattr.c       |    4 +++-
 10 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fa4ef18..bf036f7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1496,6 +1496,7 @@ int btrfs_sync_file(struct file *file, int datasync)
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		btrfs_abort_transaction(root, ret);
 		goto out;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 02ff4a1..ecdc333 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2394,6 +2394,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 			trans = btrfs_start_transaction(root, 0);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
+				btrfs_abort_transaction(root, ret);
 				goto out;
 			}
 			btrfs_orphan_del(trans, inode);
@@ -2848,6 +2849,8 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	u64 dir_ino = btrfs_ino(dir);
 
 	trans = btrfs_start_transaction(root, 10);
+	if (IS_ERR(trans))
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
@@ -2874,6 +2877,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
 		root->fs_info->enospc_unlink = 0;
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return trans;
 	}
 
@@ -3511,6 +3515,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			trans = btrfs_start_transaction(root, 2);
 			if (IS_ERR(trans)) {
 				err = PTR_ERR(trans);
+				btrfs_abort_transaction(root, err);
 				break;
 			}
 
@@ -4312,6 +4317,7 @@ void btrfs_dirty_inode(struct inode *inode)
 				       "dirty  inode %llu error %ld\n",
 				       (unsigned long long)btrfs_ino(inode),
 				       PTR_ERR(trans));
+			btrfs_abort_transaction(root, PTR_ERR(trans));
 			return;
 		}
 
@@ -4618,8 +4624,10 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	 * 1 for xattr if selinux is on
 	 */
 	trans = btrfs_start_transaction(root, 5);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 
 	err = btrfs_find_free_ino(root, &objectid);
 	if (err)
@@ -4676,8 +4684,10 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	 * 1 for xattr if selinux is on
 	 */
 	trans = btrfs_start_transaction(root, 5);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 
 	err = btrfs_find_free_ino(root, &objectid);
 	if (err)
@@ -4748,6 +4758,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	trans = btrfs_start_transaction(root, 5);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
+		btrfs_abort_transaction(root, err);
 		goto fail;
 	}
 
@@ -4795,8 +4806,10 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	 * 1 for xattr if selinux is on
 	 */
 	trans = btrfs_start_transaction(root, 5);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 
 	err = btrfs_find_free_ino(root, &objectid);
 	if (err)
@@ -6542,6 +6555,7 @@ static int btrfs_truncate(struct inode *inode)
 	trans = btrfs_start_transaction(root, 4);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
+		btrfs_abort_transaction(root, err);
 		goto out;
 	}
 
@@ -6569,6 +6583,7 @@ static int btrfs_truncate(struct inode *inode)
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
+		btrfs_abort_transaction(root, err);
 		goto out;
 	}
 	trans->block_rsv = rsv;
@@ -6598,6 +6613,7 @@ static int btrfs_truncate(struct inode *inode)
 			trans = btrfs_start_transaction(root, 3);
 			if (IS_ERR(trans)) {
 				err = PTR_ERR(trans);
+				btrfs_abort_transaction(root, err);
 				goto out;
 			}
 
@@ -6965,9 +6981,10 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 */
 	trans = btrfs_start_transaction(root, 20);
 	if (IS_ERR(trans)) {
-                ret = PTR_ERR(trans);
-                goto out_notrans;
-        }
+		ret = PTR_ERR(trans);
+		btrfs_abort_transaction(root, ret);
+		goto out_notrans;
+	}
 
 	if (dest != root)
 		btrfs_record_root_in_trans(trans, dest);
@@ -7147,8 +7164,10 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	 * 1 item for xattr if selinux is on
 	 */
 	trans = btrfs_start_transaction(root, 5);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 
 	err = btrfs_find_free_ino(root, &objectid);
 	if (err)
@@ -7249,6 +7268,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			trans = btrfs_start_transaction(root, 3);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
+				btrfs_abort_transaction(root, ret);
 				break;
 			}
 		}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ac37040..10f446f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -348,6 +348,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	trans = btrfs_start_transaction(root, 6);
 	if (IS_ERR(trans)) {
 		dput(parent);
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
 	}
 
@@ -476,6 +477,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		btrfs_abort_transaction(root->fs_info->extent_root, ret);
 		goto fail;
 	}
 
@@ -1242,6 +1244,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
+			btrfs_abort_transaction(root, ret);
 			goto out_unlock;
 		}
 		ret = btrfs_grow_device(trans, device, new_size);
@@ -1430,6 +1433,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		btrfs_abort_transaction(root, ret);
 		goto out_reset;
 	}
 
@@ -1898,6 +1902,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
+		btrfs_abort_transaction(root, err);
 		goto out_up_write;
 	}
 	trans->block_rsv = &root->fs_info->global_block_rsv;
@@ -2316,6 +2321,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			trans = btrfs_start_transaction(root, 1);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
+				btrfs_abort_transaction(root, ret);
 				goto out;
 			}
 
@@ -2549,6 +2555,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
 	}
 
@@ -2748,8 +2755,10 @@ static noinline long btrfs_ioctl_start_sync(struct file *file, void __user *argp
 	int ret;
 
 	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 	transid = trans->transid;
 	ret = btrfs_commit_transaction_async(trans, root, 0);
 	if (ret) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f25b10a..d2c2422 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3902,8 +3902,10 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 		return ERR_CAST(root);
 
 	trans = btrfs_start_transaction(root, 6);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return ERR_CAST(trans);
+	}
 
 	err = btrfs_find_free_objectid(root, &objectid);
 	if (err)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3559d0b..1ce61f7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -662,8 +662,10 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	btrfs_wait_ordered_extents(root, 0, 0);
 
 	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 	ret = btrfs_commit_transaction(trans, root);
 	return ret;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dd71966..bb4ddd2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -807,8 +807,10 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
-		if (IS_ERR(trans))
+		if (IS_ERR(trans)) {
+			btrfs_abort_transaction(root, PTR_ERR(trans));
 			return PTR_ERR(trans);
+		}
 
 		ret = btrfs_defrag_leaves(trans, root, cacheonly);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 02564e6..4e193b5 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -76,6 +76,12 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 }
 
+static inline void btrfs_abort_transaction(struct btrfs_root *root, int errno)
+{
+	if (errno != -ENOSPC)
+		btrfs_std_error(root->fs_info, errno);
+}
+
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
 int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 592396c..189a725 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3140,7 +3140,12 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 	fs_info->log_root_recovering = 1;
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		fs_info->log_root_recovering = 0;
+		btrfs_abort_transaction(fs_info->tree_root, PTR_ERR(trans));
+		return PTR_ERR(trans);
+	}
 
 	wc.trans = trans;
 	wc.pin = 1;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index da541df..6a5e996 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1187,6 +1187,7 @@ static int btrfs_rm_dev_item(struct btrfs_root *root,
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
 	}
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
@@ -1610,6 +1611,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		kfree(device->name);
 		kfree(device);
 		ret = PTR_ERR(trans);
+		btrfs_abort_transaction(root, ret);
 		goto error;
 	}
 
@@ -2223,6 +2225,7 @@ again:
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		btrfs_abort_transaction(root, ret);
 		goto done;
 	}
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 5366fe4..048d4cd 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -155,8 +155,10 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 		return do_setxattr(trans, inode, name, value, size, flags);
 
 	trans = btrfs_start_transaction(root, 2);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 
 	ret = do_setxattr(trans, inode, name, value, size, flags);
 	if (ret)


