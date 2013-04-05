Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:16494 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3DELie (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Apr 2013 07:38:34 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: rescan for qgroups
Date: Fri,  5 Apr 2013 13:38:16 +0200
Message-Id: <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If qgroup tracking is out of sync, a rescan operation can be started to
iterate the extent tree and recalculate all qgroup tracking data.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.h           |   17 ++-
 fs/btrfs/disk-io.c         |    6 +
 fs/btrfs/ioctl.c           |   83 +++++++++++---
 fs/btrfs/qgroup.c          |  271 +++++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/btrfs.h |   11 ++-
 5 files changed, 354 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d82922..bd4e2a7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1019,9 +1019,9 @@ struct btrfs_block_group_item {
  */
 #define BTRFS_QGROUP_STATUS_FLAG_ON		(1ULL << 0)
 /*
- * SCANNING is set during the initialization phase
+ * RESCAN is set during the initialization phase
  */
-#define BTRFS_QGROUP_STATUS_FLAG_SCANNING	(1ULL << 1)
+#define BTRFS_QGROUP_STATUS_FLAG_RESCAN		(1ULL << 1)
 /*
  * Some qgroup entries are known to be out of date,
  * either because the configuration has changed in a way that
@@ -1050,7 +1050,7 @@ struct btrfs_qgroup_status_item {
 	 * only used during scanning to record the progress
 	 * of the scan. It contains a logical address
 	 */
-	__le64 scan;
+	__le64 rescan;
 } __attribute__ ((__packed__));
 
 struct btrfs_qgroup_info_item {
@@ -1587,6 +1587,11 @@ struct btrfs_fs_info {
 	/* used by btrfs_qgroup_record_ref for an efficient tree traversal */
 	u64 qgroup_seq;
 
+	/* qgroup rescan items */
+	struct mutex qgroup_rescan_lock; /* protects the progress item */
+	struct btrfs_key qgroup_rescan_progress;
+	struct btrfs_workers qgroup_rescan_workers;
+
 	/* filesystem state */
 	unsigned long fs_state;
 
@@ -2864,8 +2869,8 @@ BTRFS_SETGET_FUNCS(qgroup_status_version, struct btrfs_qgroup_status_item,
 		   version, 64);
 BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
 		   flags, 64);
-BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
-		   scan, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_rescan, struct btrfs_qgroup_status_item,
+		   rescan, 64);
 
 /* btrfs_qgroup_info_item */
 BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
@@ -3784,7 +3789,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info);
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
-int btrfs_quota_rescan(struct btrfs_fs_info *fs_info);
+int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
 int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d19a0a..60d15fe 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2192,6 +2192,7 @@ int open_ctree(struct super_block *sb,
 	fs_info->qgroup_seq = 1;
 	fs_info->quota_enabled = 0;
 	fs_info->pending_quota_state = 0;
+	mutex_init(&fs_info->qgroup_rescan_lock);
 
 	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
 	btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
@@ -2394,6 +2395,8 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
+	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
+			   &fs_info->generic_worker);
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -2428,6 +2431,7 @@ int open_ctree(struct super_block *sb,
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
 	ret |= btrfs_start_workers(&fs_info->flush_workers);
+	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
@@ -2773,6 +2777,7 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->flush_workers);
+	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
 fail_alloc:
 fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
@@ -3463,6 +3468,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
 	btrfs_stop_workers(&fs_info->flush_workers);
+	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY))
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 898c572..a4681fb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3693,12 +3693,10 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
-	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
-		trans = btrfs_start_transaction(root, 2);
-		if (IS_ERR(trans)) {
-			ret = PTR_ERR(trans);
-			goto out;
-		}
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
 	}
 
 	switch (sa->cmd) {
@@ -3708,9 +3706,6 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	case BTRFS_QUOTA_CTL_DISABLE:
 		ret = btrfs_quota_disable(trans, root->fs_info);
 		break;
-	case BTRFS_QUOTA_CTL_RESCAN:
-		ret = btrfs_quota_rescan(root->fs_info);
-		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -3719,11 +3714,9 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	if (copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
 
-	if (trans) {
-		err = btrfs_commit_transaction(trans, root);
-		if (err && !ret)
-			ret = err;
-	}
+	err = btrfs_commit_transaction(trans, root);
+	if (err && !ret)
+		ret = err;
 out:
 	kfree(sa);
 drop_write:
@@ -3877,6 +3870,64 @@ drop_write:
 	return ret;
 }
 
+static long btrfs_ioctl_quota_rescan(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
+	struct btrfs_ioctl_quota_rescan_args *qsa;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	qsa = memdup_user(arg, sizeof(*qsa));
+	if (IS_ERR(qsa)) {
+		ret = PTR_ERR(qsa);
+		goto drop_write;
+	}
+
+	if (qsa->flags) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = btrfs_qgroup_rescan(root->fs_info);
+
+out:
+	kfree(qsa);
+drop_write:
+	mnt_drop_write_file(file);
+	return ret;
+}
+
+static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
+	struct btrfs_ioctl_quota_rescan_args *qsa;
+	int ret = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	qsa = kzalloc(sizeof(*qsa), GFP_NOFS);
+	if (IS_ERR(qsa))
+		return PTR_ERR(qsa);
+
+	if (root->fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+		qsa->flags = 1;
+		qsa->progress = root->fs_info->qgroup_rescan_progress.objectid;
+	}
+
+	if (copy_to_user(arg, qsa, sizeof(*qsa)))
+		ret = -EFAULT;
+
+	kfree(qsa);
+	return ret;
+}
+
 static long btrfs_ioctl_set_received_subvol(struct file *file,
 					    void __user *arg)
 {
@@ -4115,6 +4166,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_create(file, argp);
 	case BTRFS_IOC_QGROUP_LIMIT:
 		return btrfs_ioctl_qgroup_limit(file, argp);
+	case BTRFS_IOC_QUOTA_RESCAN:
+		return btrfs_ioctl_quota_rescan(file, argp);
+	case BTRFS_IOC_QUOTA_RESCAN_STATUS:
+		return btrfs_ioctl_quota_rescan_status(file, argp);
 	case BTRFS_IOC_DEV_REPLACE:
 		return btrfs_ioctl_dev_replace(root, argp);
 	case BTRFS_IOC_GET_FSLABEL:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b44124d..e0d9cf8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -31,13 +31,13 @@
 #include "locking.h"
 #include "ulist.h"
 #include "backref.h"
+#include "extent_io.h"
 
 /* TODO XXX FIXME
  *  - subvol delete -> delete when ref goes to 0? delete limits also?
  *  - reorganize keys
  *  - compressed
  *  - sync
- *  - rescan
  *  - copy also limits on subvol creation
  *  - limit
  *  - caches fuer ulists
@@ -98,6 +98,14 @@ struct btrfs_qgroup_list {
 	struct btrfs_qgroup *member;
 };
 
+struct qgroup_rescan {
+	struct btrfs_work	work;
+	struct btrfs_fs_info	*fs_info;
+};
+
+static void qgroup_rescan_start(struct btrfs_fs_info *fs_info,
+				struct qgroup_rescan *qscan);
+
 /* must be called with qgroup_lock held */
 static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
 					   u64 qgroupid)
@@ -298,7 +306,20 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			}
 			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
 									  ptr);
-			/* FIXME read scan element */
+			fs_info->qgroup_rescan_progress.objectid =
+					btrfs_qgroup_status_rescan(l, ptr);
+			if (fs_info->qgroup_flags &
+			    BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+				struct qgroup_rescan *qscan =
+					kmalloc(sizeof(*qscan), GFP_NOFS);
+				if (!qscan) {
+					ret = -ENOMEM;
+					goto out;
+				}
+				fs_info->qgroup_rescan_progress.type = 0;
+				fs_info->qgroup_rescan_progress.offset = 0;
+				qgroup_rescan_start(fs_info, qscan);
+			}
 			goto next1;
 		}
 
@@ -719,9 +740,12 @@ static int update_qgroup_status_item(struct btrfs_trans_handle *trans,
 	l = path->nodes[0];
 	slot = path->slots[0];
 	ptr = btrfs_item_ptr(l, slot, struct btrfs_qgroup_status_item);
+	spin_lock(&fs_info->qgroup_lock);
 	btrfs_set_qgroup_status_flags(l, ptr, fs_info->qgroup_flags);
 	btrfs_set_qgroup_status_generation(l, ptr, trans->transid);
-	/* XXX scan */
+	btrfs_set_qgroup_status_rescan(l, ptr,
+				fs_info->qgroup_rescan_progress.objectid);
+	spin_unlock(&fs_info->qgroup_lock);
 
 	btrfs_mark_buffer_dirty(l);
 
@@ -830,7 +854,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	fs_info->qgroup_flags = BTRFS_QGROUP_STATUS_FLAG_ON |
 				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	btrfs_set_qgroup_status_flags(leaf, ptr, fs_info->qgroup_flags);
-	btrfs_set_qgroup_status_scan(leaf, ptr, 0);
+	btrfs_set_qgroup_status_rescan(leaf, ptr, 0);
 
 	btrfs_mark_buffer_dirty(leaf);
 
@@ -894,9 +918,218 @@ out:
 	return ret;
 }
 
-int btrfs_quota_rescan(struct btrfs_fs_info *fs_info)
+static void qgroup_dirty(struct btrfs_fs_info *fs_info,
+			 struct btrfs_qgroup *qgroup)
+{
+	if (list_empty(&qgroup->dirty))
+		list_add(&qgroup->dirty, &fs_info->dirty_qgroups);
+}
+
+/*
+ * returns < 0 on error, 0 when more leafs are to be scanned.
+ * returns 1 when done, 2 when done and FLAG_INCONSISTENT was cleared.
+ */
+static int
+qgroup_rescan_leaf(struct qgroup_rescan *qscan, struct btrfs_path *path,
+		   struct btrfs_trans_handle *trans, struct ulist *tmp,
+		   struct extent_buffer *scratch_leaf)
+{
+	struct btrfs_key found;
+	struct btrfs_fs_info *fs_info = qscan->fs_info;
+	struct ulist *roots = NULL;
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct seq_list tree_mod_seq_elem = {};
+	int slot;
+	int ret;
+
+	path->leave_spinning = 1;
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	ret = btrfs_search_slot_for_read(fs_info->extent_root,
+					 &fs_info->qgroup_rescan_progress,
+					 path, 1, 0);
+	if (ret == 1) {
+		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+		if (fs_info->qgroup_flags &
+		    BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
+			fs_info->qgroup_flags &=
+					~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+			ret = 2;
+		}
+	} else if (ret == 0) {
+		btrfs_item_key_to_cpu(path->nodes[0], &found,
+				      btrfs_header_nritems(path->nodes[0]) - 1);
+		fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
+	}
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
+	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
+		 fs_info->qgroup_rescan_progress.objectid,
+		 fs_info->qgroup_rescan_progress.type,
+		 fs_info->qgroup_rescan_progress.offset, ret);
+
+	if (ret) {
+		btrfs_release_path(path);
+		return ret;
+	}
+
+	btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
+	memcpy(scratch_leaf, path->nodes[0], sizeof(*scratch_leaf));
+	slot = path->slots[0];
+	btrfs_release_path(path);
+
+	for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
+		btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
+		if (found.type != BTRFS_EXTENT_ITEM_KEY)
+			continue;
+		ret = btrfs_find_all_roots(trans, fs_info, found.objectid,
+					   tree_mod_seq_elem.seq, &roots);
+		if (ret < 0)
+			break;
+		spin_lock(&fs_info->qgroup_lock);
+		ULIST_ITER_INIT(&uiter);
+		while ((unode = ulist_next(roots, &uiter))) {
+			struct btrfs_qgroup *qg;
+			struct ulist_node *tmp_unode;
+			struct ulist_iterator tmp_uiter;
+
+			qg = find_qgroup_rb(fs_info, unode->val);
+			if (!qg)
+				continue;
+
+			ulist_reinit(tmp);
+			ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
+			ULIST_ITER_INIT(&tmp_uiter);
+			while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
+				struct btrfs_qgroup_list *glist;
+
+				qg = (struct btrfs_qgroup *)(uintptr_t)
+								tmp_unode->aux;
+
+				qg->rfer += found.offset;
+				qg->rfer_cmpr += found.offset;
+				if (roots->nnodes == 1) {
+					qg->excl += found.offset;
+					qg->excl_cmpr += found.offset;
+				}
+				qgroup_dirty(fs_info, qg);
+
+				list_for_each_entry(glist, &qg->groups,
+						    next_group) {
+					ulist_add(tmp, glist->group->qgroupid,
+						  (uintptr_t)glist->group,
+						  GFP_ATOMIC);
+				}
+			}
+		}
+		spin_unlock(&fs_info->qgroup_lock);
+		ulist_free(roots);
+	}
+
+	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
+
+	return ret;
+}
+
+static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 {
-	/* FIXME */
+	struct qgroup_rescan *qscan = container_of(work, struct qgroup_rescan,
+						   work);
+	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_fs_info *fs_info = qscan->fs_info;
+	struct ulist *tmp = NULL;
+	struct extent_buffer *scratch_leaf = NULL;
+	int err = -ENOMEM;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		goto out;
+	tmp = ulist_alloc(GFP_NOFS);
+	if (!tmp)
+		goto out;
+	scratch_leaf = kmalloc(sizeof(*scratch_leaf), GFP_NOFS);
+	if (!scratch_leaf)
+		goto out;
+
+	err = 0;
+	while (!err) {
+		trans = btrfs_start_transaction(fs_info->fs_root, 0);
+		if (IS_ERR(trans)) {
+			err = PTR_ERR(trans);
+			break;
+		}
+		err = qgroup_rescan_leaf(qscan, path, trans, tmp, scratch_leaf);
+		if (err > 0)
+			btrfs_commit_transaction(trans, fs_info->fs_root);
+		else
+			btrfs_end_transaction(trans, fs_info->fs_root);
+	}
+
+out:
+	kfree(scratch_leaf);
+	ulist_free(tmp);
+	btrfs_free_path(path);
+	kfree(qscan);
+
+	if (err < 0)
+		pr_err("btrfs: qgroup scan failed with %d\n", err);
+	else
+		pr_info("btrfs: qgroup scan completed%s\n",
+			err == 2 ? " (inconsistency flag cleared)" : "");
+}
+
+static void
+qgroup_rescan_start(struct btrfs_fs_info *fs_info, struct qgroup_rescan *qscan)
+{
+	qscan->work.func = btrfs_qgroup_rescan_worker;
+	qscan->fs_info = fs_info;
+
+	pr_info("btrfs: qgroup scan started\n");
+	btrfs_queue_worker(&fs_info->qgroup_rescan_workers, &qscan->work);
+}
+
+int
+btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
+{
+	int ret = 0;
+	struct rb_node *n;
+	struct btrfs_qgroup *qgroup;
+	struct qgroup_rescan *qscan = kmalloc(sizeof(*qscan), GFP_NOFS);
+
+	if (!qscan)
+		return -ENOMEM;
+
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	spin_lock(&fs_info->qgroup_lock);
+	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
+		ret = -EINPROGRESS;
+	else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
+		ret = -EINVAL;
+	if (ret) {
+		spin_unlock(&fs_info->qgroup_lock);
+		mutex_unlock(&fs_info->qgroup_rescan_lock);
+		kfree(qscan);
+		return ret;
+	}
+
+	fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+	memset(&fs_info->qgroup_rescan_progress, 0,
+		sizeof(fs_info->qgroup_rescan_progress));
+
+	/* clear all current qgroup tracking information */
+	for (n = rb_first(&fs_info->qgroup_tree); n; n = rb_next(n)) {
+		qgroup = rb_entry(n, struct btrfs_qgroup, node);
+		qgroup->rfer = 0;
+		qgroup->rfer_cmpr = 0;
+		qgroup->excl = 0;
+		qgroup->excl_cmpr = 0;
+	}
+	spin_unlock(&fs_info->qgroup_lock);
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
+	qgroup_rescan_start(fs_info, qscan);
+
 	return 0;
 }
 
@@ -1045,13 +1278,6 @@ unlock:
 	return ret;
 }
 
-static void qgroup_dirty(struct btrfs_fs_info *fs_info,
-			 struct btrfs_qgroup *qgroup)
-{
-	if (list_empty(&qgroup->dirty))
-		list_add(&qgroup->dirty, &fs_info->dirty_qgroups);
-}
-
 /*
  * btrfs_qgroup_record_ref is called when the ref is added or deleted. it puts
  * the modification into a list that's later used by btrfs_end_transaction to
@@ -1142,6 +1368,15 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 		BUG();
 	}
 
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
+			mutex_unlock(&fs_info->qgroup_rescan_lock);
+			return 0;
+		}
+	}
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
 	/*
 	 * the delayed ref sequence number we pass depends on the direction of
 	 * the operation. for add operations, we pass (node->seq - 1) to skip
@@ -1155,7 +1390,17 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		return ret;
 
+	mutex_lock(&fs_info->qgroup_rescan_lock);
 	spin_lock(&fs_info->qgroup_lock);
+	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
+			ret = 0;
+			mutex_unlock(&fs_info->qgroup_rescan_lock);
+			goto unlock;
+		}
+	}
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
 	quota_root = fs_info->quota_root;
 	if (!quota_root)
 		goto unlock;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index fa3a5f9..eff1ab9 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -376,12 +376,17 @@ struct btrfs_ioctl_get_dev_stats {
 
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
-#define BTRFS_QUOTA_CTL_RESCAN	3
+/* 3 has formerly been reserved for BTRFS_QUOTA_CTL_RESCAN */
 struct btrfs_ioctl_quota_ctl_args {
 	__u64 cmd;
 	__u64 status;
 };
 
+struct btrfs_ioctl_quota_rescan_args {
+	__u64	flags;
+	__u64   progress;
+};
+
 struct btrfs_ioctl_qgroup_assign_args {
 	__u64 assign;
 	__u64 src;
@@ -502,6 +507,10 @@ struct btrfs_ioctl_send_args {
 			       struct btrfs_ioctl_qgroup_create_args)
 #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
 			       struct btrfs_ioctl_qgroup_limit_args)
+#define BTRFS_IOC_QUOTA_RESCAN _IOW(BTRFS_IOCTL_MAGIC, 44, \
+			       struct btrfs_ioctl_quota_rescan_args)
+#define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
+			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
 				   char[BTRFS_LABEL_SIZE])
 #define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
-- 
1.7.1

