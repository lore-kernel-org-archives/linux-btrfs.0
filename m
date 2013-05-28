Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:34986 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934599Ab3E1Prq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 11:47:46 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp2) (RZmta 31.27 OK)
	with ESMTP id g03fe4p4S3rldU for <linux-btrfs@vger.kernel.org>;
	Tue, 28 May 2013 17:47:44 +0200 (CEST)
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: fix qgroup rescan resume on mount
Date: Tue, 28 May 2013 17:47:24 +0200
Message-Id: <1369756044-17194-4-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When called during mount, we cannot start the rescan worker thread until
open_ctree is done. This commit restuctures the qgroup rescan internals to
enable a clean deferral of the rescan resume operation.

First of all, the struct qgroup_rescan is removed, saving us a malloc and
some initialization synchronizations problems. Its only element (the worker
struct) now lives within fs_info just as the rest of the rescan code.

Then setting up a rescan worker is split into several reusable stages.
Currently we have three different rescan startup scenarios:
	(A) rescan ioctl
	(B) rescan resume by mount
	(C) rescan by quota enable

Each case needs its own combination of the four following steps:
	(1) set the progress [A, C: zero; B: state of umount]
	(2) commit the transaction [A]
	(3) set the counters [A, C: zero; B: state of umount]
	(4) start worker [A, B, C]

qgroup_rescan_init does step (1). There's no extra function added to commit
a transaction, we've got that already. qgroup_rescan_zero_tracking does
step (3). Step (4) is nothing more than a call to the generic
btrfs_queue_worker.

We also get rid of a double check for the rescan progress during
btrfs_qgroup_account_ref, which is no longer required due to having step 2
from the list above.

As a side effect, this commit prepares to move the rescan start code from
btrfs_run_qgroups (which is run during commit) to a less time critical
section.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.h   |    2 +
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/qgroup.c  |  190 +++++++++++++++++++++++++++++++++-------------------
 3 files changed, 125 insertions(+), 69 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fd62aa8..8ac8d52 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1610,6 +1610,7 @@ struct btrfs_fs_info {
 	struct btrfs_key qgroup_rescan_progress;
 	struct btrfs_workers qgroup_rescan_workers;
 	struct completion qgroup_rescan_completion;
+	struct btrfs_work qgroup_rescan_work;
 
 	/* filesystem state */
 	unsigned long fs_state;
@@ -3856,6 +3857,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
+void btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info);
 int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d7b46c6..da4a10c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2879,6 +2879,8 @@ retry_root_backup:
 		return ret;
 	}
 
+	btrfs_qgroup_rescan_resume(fs_info);
+
 	return 0;
 
 fail_qgroup:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c6ce642..1280eff 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -98,13 +98,10 @@ struct btrfs_qgroup_list {
 	struct btrfs_qgroup *member;
 };
 
-struct qgroup_rescan {
-	struct btrfs_work	work;
-	struct btrfs_fs_info	*fs_info;
-};
-
-static void qgroup_rescan_start(struct btrfs_fs_info *fs_info,
-				struct qgroup_rescan *qscan);
+static int
+qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
+		   int init_flags);
+static void qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info);
 
 /* must be called with qgroup_ioctl_lock held */
 static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
@@ -255,6 +252,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 	int slot;
 	int ret = 0;
 	u64 flags = 0;
+	u64 rescan_progress = 0;
 
 	if (!fs_info->quota_enabled)
 		return 0;
@@ -312,20 +310,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			}
 			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
 									  ptr);
-			fs_info->qgroup_rescan_progress.objectid =
-					btrfs_qgroup_status_rescan(l, ptr);
-			if (fs_info->qgroup_flags &
-			    BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
-				struct qgroup_rescan *qscan =
-					kmalloc(sizeof(*qscan), GFP_NOFS);
-				if (!qscan) {
-					ret = -ENOMEM;
-					goto out;
-				}
-				fs_info->qgroup_rescan_progress.type = 0;
-				fs_info->qgroup_rescan_progress.offset = 0;
-				qgroup_rescan_start(fs_info, qscan);
-			}
+			rescan_progress = btrfs_qgroup_status_rescan(l, ptr);
 			goto next1;
 		}
 
@@ -427,12 +412,16 @@ out:
 	if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON)) {
 		fs_info->quota_enabled = 0;
 		fs_info->pending_quota_state = 0;
+	} else if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN &&
+		   ret >= 0) {
+		ret = qgroup_rescan_init(fs_info, rescan_progress, 0);
 	}
 	btrfs_free_path(path);
 
 	if (ret < 0) {
 		ulist_free(fs_info->qgroup_ulist);
 		fs_info->qgroup_ulist = NULL;
+		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 	}
 
 	return ret < 0 ? ret : 0;
@@ -1449,14 +1438,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		return ret;
 
-	mutex_lock(&fs_info->qgroup_rescan_lock);
 	spin_lock(&fs_info->qgroup_lock);
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
-		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
-			ret = 0;
-			goto unlock;
-		}
-	}
 
 	quota_root = fs_info->quota_root;
 	if (!quota_root)
@@ -1496,7 +1478,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
-	mutex_unlock(&fs_info->qgroup_rescan_lock);
 	ulist_free(roots);
 
 	return ret;
@@ -1544,9 +1525,12 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 
 	if (!ret && start_rescan_worker) {
-		ret = btrfs_qgroup_rescan(fs_info);
-		if (ret)
-			pr_err("btrfs: start rescan quota failed: %d\n", ret);
+		ret = qgroup_rescan_init(fs_info, 0, 1);
+		if (!ret) {
+			qgroup_rescan_zero_tracking(fs_info);
+			btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
+					   &fs_info->qgroup_rescan_work);
+		}
 		ret = 0;
 	}
 
@@ -1880,12 +1864,11 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
  * returns 1 when done, 2 when done and FLAG_INCONSISTENT was cleared.
  */
 static int
-qgroup_rescan_leaf(struct qgroup_rescan *qscan, struct btrfs_path *path,
+qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		   struct btrfs_trans_handle *trans, struct ulist *tmp,
 		   struct extent_buffer *scratch_leaf)
 {
 	struct btrfs_key found;
-	struct btrfs_fs_info *fs_info = qscan->fs_info;
 	struct ulist *roots = NULL;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -2013,11 +1996,10 @@ out:
 
 static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 {
-	struct qgroup_rescan *qscan = container_of(work, struct qgroup_rescan,
-						   work);
+	struct btrfs_fs_info *fs_info = container_of(work, struct btrfs_fs_info,
+						     qgroup_rescan_work);
 	struct btrfs_path *path;
 	struct btrfs_trans_handle *trans = NULL;
-	struct btrfs_fs_info *fs_info = qscan->fs_info;
 	struct ulist *tmp = NULL;
 	struct extent_buffer *scratch_leaf = NULL;
 	int err = -ENOMEM;
@@ -2042,7 +2024,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		if (!fs_info->quota_enabled) {
 			err = -EINTR;
 		} else {
-			err = qgroup_rescan_leaf(qscan, path, trans,
+			err = qgroup_rescan_leaf(fs_info, path, trans,
 						 tmp, scratch_leaf);
 		}
 		if (err > 0)
@@ -2055,7 +2037,6 @@ out:
 	kfree(scratch_leaf);
 	ulist_free(tmp);
 	btrfs_free_path(path);
-	kfree(qscan);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
@@ -2078,46 +2059,70 @@ out:
 	complete_all(&fs_info->qgroup_rescan_completion);
 }
 
-static void
-qgroup_rescan_start(struct btrfs_fs_info *fs_info, struct qgroup_rescan *qscan)
-{
-	memset(&qscan->work, 0, sizeof(qscan->work));
-	qscan->work.func = btrfs_qgroup_rescan_worker;
-	qscan->fs_info = fs_info;
-
-	pr_info("btrfs: qgroup scan started\n");
-	btrfs_queue_worker(&fs_info->qgroup_rescan_workers, &qscan->work);
-}
-
-int
-btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
+/*
+ * Checks that (a) no rescan is running and (b) quota is enabled. Allocates all
+ * memory required for the rescan context.
+ */
+static int
+qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
+		   int init_flags)
 {
 	int ret = 0;
-	struct rb_node *n;
-	struct btrfs_qgroup *qgroup;
-	struct qgroup_rescan *qscan = kmalloc(sizeof(*qscan), GFP_NOFS);
 
-	if (!qscan)
-		return -ENOMEM;
+	if (!init_flags &&
+	    (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) ||
+	     !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 	spin_lock(&fs_info->qgroup_lock);
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
-		ret = -EINPROGRESS;
-	else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
-		ret = -EINVAL;
-	if (ret) {
-		spin_unlock(&fs_info->qgroup_lock);
-		mutex_unlock(&fs_info->qgroup_rescan_lock);
-		kfree(qscan);
-		return ret;
+
+	if (init_flags) {
+		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
+			ret = -EINPROGRESS;
+		else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
+			ret = -EINVAL;
+
+		if (ret) {
+			spin_unlock(&fs_info->qgroup_lock);
+			mutex_unlock(&fs_info->qgroup_rescan_lock);
+			goto err;
+		}
+
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 	}
 
-	fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 	memset(&fs_info->qgroup_rescan_progress, 0,
 		sizeof(fs_info->qgroup_rescan_progress));
+	fs_info->qgroup_rescan_progress.objectid = progress_objectid;
+
+	spin_unlock(&fs_info->qgroup_lock);
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
 	init_completion(&fs_info->qgroup_rescan_completion);
 
+	memset(&fs_info->qgroup_rescan_work, 0,
+	       sizeof(fs_info->qgroup_rescan_work));
+	fs_info->qgroup_rescan_work.func = btrfs_qgroup_rescan_worker;
+
+	if (ret) {
+err:
+		pr_info("btrfs: qgroup_rescan_init failed with %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void
+qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info)
+{
+	struct rb_node *n;
+	struct btrfs_qgroup *qgroup;
+
+	spin_lock(&fs_info->qgroup_lock);
 	/* clear all current qgroup tracking information */
 	for (n = rb_first(&fs_info->qgroup_tree); n; n = rb_next(n)) {
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
@@ -2127,9 +2132,44 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 		qgroup->excl_cmpr = 0;
 	}
 	spin_unlock(&fs_info->qgroup_lock);
-	mutex_unlock(&fs_info->qgroup_rescan_lock);
+}
 
-	qgroup_rescan_start(fs_info, qscan);
+int
+btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
+{
+	int ret = 0;
+	struct btrfs_trans_handle *trans;
+
+	ret = qgroup_rescan_init(fs_info, 0, 1);
+	if (ret)
+		return ret;
+
+	/*
+	 * We have set the rescan_progress to 0, which means no more
+	 * delayed refs will be accounted by btrfs_qgroup_account_ref.
+	 * However, btrfs_qgroup_account_ref may be right after its call
+	 * to btrfs_find_all_roots, in which case it would still do the
+	 * accounting.
+	 * To solve this, we're committing the transaction, which will
+	 * ensure we run all delayed refs and only after that, we are
+	 * going to clear all tracking information for a clean start.
+	 */
+
+	trans = btrfs_join_transaction(fs_info->fs_root);
+	if (IS_ERR(trans)) {
+		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+		return PTR_ERR(trans);
+	}
+	ret = btrfs_commit_transaction(trans, fs_info->fs_root);
+	if (ret) {
+		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+		return ret;
+	}
+
+	qgroup_rescan_zero_tracking(fs_info);
+
+	btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
+			   &fs_info->qgroup_rescan_work);
 
 	return 0;
 }
@@ -2151,3 +2191,15 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info)
 
 	return ret;
 }
+
+/*
+ * this is only called from open_ctree where we're still single threaded, thus
+ * locking is omitted here.
+ */
+void
+btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
+{
+	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
+		btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
+				   &fs_info->qgroup_rescan_work);
+}
-- 
1.7.1

