Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57548 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752262AbdLLHfF (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 12 Dec 2017 02:35:05 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 12/14] btrfs: qgroup: Use root->qgroup_meta_rsv_* to record qgroup meta reserved space
Date: Tue, 12 Dec 2017 15:34:34 +0800
Message-Id: <20171212073436.16447-13-wqu@suse.com>
In-Reply-To: <20171212073436.16447-1-wqu@suse.com>
References: <20171212073436.16447-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For quota disabled->enable case, it's possible that at reservation time
quota was not enabled so no byte was really reserved, while at release
time, quota is enabled so we will try to release some bytes we didn't
really own.

Such situation can cause metadata reserveation underflow, for both types,
also less possible for per-trans type since quota enable will commit
transaction.

To address this, record qgroup meta reserved bytes into
root->qgroup_meta_rsv_pertrans/prealloc.
So at releasing time we won't free any bytes we didn't reserve.

For DATA, it's already handled by io_tree, so nothing needs to be
worried about.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h   |  5 +++++
 fs/btrfs/disk-io.c |  1 +
 fs/btrfs/qgroup.c  | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 89798c6e6a11..9d5dd3372e7b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1260,6 +1260,11 @@ struct btrfs_root {
 	int send_in_progress;
 	struct btrfs_subvolume_writers *subv_writers;
 	atomic_t will_be_snapshotted;
+
+	/* For qgroup metadata reserved space */
+	spinlock_t qgroup_meta_rsv_lock;
+	u64 qgroup_meta_rsv_pertrans;
+	u64 qgroup_meta_rsv_prealloc;
 };
 
 struct btrfs_file_private {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8f6ce6b02c9b..0eafe17b9a81 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1168,6 +1168,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	spin_lock_init(&root->accounting_lock);
 	spin_lock_init(&root->log_extents_lock[0]);
 	spin_lock_init(&root->log_extents_lock[1]);
+	spin_lock_init(&root->qgroup_meta_rsv_lock);
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
 	mutex_init(&root->ordered_extent_mutex);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 24fc6e46f717..96ed678b3588 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2549,11 +2549,11 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 	if (!qgroup)
 		goto out;
 
-	/*
-	 * We're freeing all pertrans rsv, get current value from level 0
-	 * qgroup as real num_bytes to free.
-	 */
 	if (num_bytes == (u64)-1)
+		/*
+		 * We're freeing all pertrans rsv, get reserved value from
+		 * level 0 qgroup as real num_bytes to free.
+		 */
 		num_bytes = qgroup->rsv.values[type];
 
 	ulist_reinit(fs_info->qgroup_ulist);
@@ -3099,6 +3099,46 @@ int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len)
 	return __btrfs_qgroup_release_data(inode, NULL, start, len, 0);
 }
 
+static void add_root_meta_rsv(struct btrfs_root *root, int num_bytes,
+			      enum btrfs_qgroup_rsv_type type)
+{
+	if (type != BTRFS_QGROUP_RSV_META_PREALLOC &&
+	    type != BTRFS_QGROUP_RSV_META_PERTRANS)
+		return;
+	if (num_bytes == 0)
+		return;
+
+	spin_lock(&root->qgroup_meta_rsv_lock);
+	if (type == BTRFS_QGROUP_RSV_META_PREALLOC)
+		root->qgroup_meta_rsv_prealloc += num_bytes;
+	else
+		root->qgroup_meta_rsv_pertrans += num_bytes;
+	spin_unlock(&root->qgroup_meta_rsv_lock);
+}
+
+static int sub_root_meta_rsv(struct btrfs_root *root, int num_bytes,
+			     enum btrfs_qgroup_rsv_type type)
+{
+	if (type != BTRFS_QGROUP_RSV_META_PREALLOC &&
+	    type != BTRFS_QGROUP_RSV_META_PERTRANS)
+		return 0;
+	if (num_bytes == 0)
+		return 0;
+
+	spin_lock(&root->qgroup_meta_rsv_lock);
+	if (type == BTRFS_QGROUP_RSV_META_PREALLOC) {
+		num_bytes = min_t(u64, root->qgroup_meta_rsv_prealloc,
+				  num_bytes);
+		root->qgroup_meta_rsv_prealloc -= num_bytes;
+	} else {
+		num_bytes = min_t(u64, root->qgroup_meta_rsv_pertrans,
+				  num_bytes);
+		root->qgroup_meta_rsv_pertrans -= num_bytes;
+	}
+	spin_unlock(&root->qgroup_meta_rsv_lock);
+	return num_bytes;
+}
+
 int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 				enum btrfs_qgroup_rsv_type type, bool enforce)
 {
@@ -3114,6 +3154,15 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 	ret = qgroup_reserve(root, num_bytes, enforce, type);
 	if (ret < 0)
 		return ret;
+	/*
+	 * Record what we have reserved into root.
+	 *
+	 * To avoid quota disabled->enabled underflow.
+	 * In that case, we may try to free space we haven't reserved
+	 * (since quota was disabled), so record what we reserved into root.
+	 * And ensure later release won't underflow this number.
+	 */
+	add_root_meta_rsv(root, num_bytes, type);
 	return ret;
 }
 
@@ -3141,6 +3190,12 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
 	    !is_fstree(root->objectid))
 		return;
 
+	/*
+	 * reservation for META_PREALLOC can happen before quota is enabled,
+	 * which can lead to underflow.
+	 * Here ensure we will only free what we really have reserved.
+	 */
+	num_bytes = sub_root_meta_rsv(root, num_bytes, type);
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
 	trace_qgroup_meta_reserve(root, -(s64)num_bytes);
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes, type);
@@ -3199,6 +3254,9 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
 	    !is_fstree(root->objectid))
 		return;
+	/* Same as btrfs_qgroup_free_meta_prealloc() */
+	num_bytes = sub_root_meta_rsv(root, num_bytes,
+				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	qgroup_convert_meta(fs_info, root->objectid, num_bytes);
 }
 
-- 
2.15.1

