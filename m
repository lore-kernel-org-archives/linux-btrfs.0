Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:35869 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbdLLHfF (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 12 Dec 2017 02:35:05 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 08/14] btrfs: qgroup: Don't use root->qgroup_meta_rsv for qgroup
Date: Tue, 12 Dec 2017 15:34:30 +0800
Message-Id: <20171212073436.16447-9-wqu@suse.com>
In-Reply-To: <20171212073436.16447-1-wqu@suse.com>
References: <20171212073436.16447-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since qgroup has seperate metadata reservation types now, we can
completely get rid of the old root->qgroup_meta_rsv, which mostly acts
as current META_PERTRANS reservation type.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h   |  3 ---
 fs/btrfs/disk-io.c |  1 -
 fs/btrfs/qgroup.c  | 34 +++++++++++++++++++++++++---------
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 72dcbf19f6ce..9a2c038767ba 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1260,9 +1260,6 @@ struct btrfs_root {
 	int send_in_progress;
 	struct btrfs_subvolume_writers *subv_writers;
 	atomic_t will_be_snapshotted;
-
-	/* For qgroup metadata space reserve */
-	atomic64_t qgroup_meta_rsv;
 };
 
 struct btrfs_file_private {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 10a2a579cc7f..8f6ce6b02c9b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1184,7 +1184,6 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	atomic_set(&root->orphan_inodes, 0);
 	refcount_set(&root->refs, 1);
 	atomic_set(&root->will_be_snapshotted, 0);
-	atomic64_set(&root->qgroup_meta_rsv, 0);
 	root->log_transid = 0;
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0b85ec21ac1d..ce3d6c95d297 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2509,6 +2509,16 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 	return ret;
 }
 
+/*
+ * Free @num_bytes of reserved space with @type for qgroup.
+ * (normally level 0 qgroup).
+ *
+ * Will handle all higher level qgroup either.
+ *
+ * NOTE: If @num_bytes is (u64)-1, this means to free all bytes of
+ * this qgroup.
+ * This special case is only used for META_PERTRANS type.
+ */
 void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 			       u64 ref_root, u64 num_bytes,
 			       enum btrfs_qgroup_rsv_type type)
@@ -2525,6 +2535,10 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 	if (num_bytes == 0)
 		return;
 
+	if (num_bytes == (u64)-1 && type != BTRFS_QGROUP_RSV_META_PERTRANS) {
+		WARN(1, "%s: Invalid type to free", __func__);
+		return;
+	}
 	spin_lock(&fs_info->qgroup_lock);
 
 	quota_root = fs_info->quota_root;
@@ -2535,6 +2549,13 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 	if (!qgroup)
 		goto out;
 
+	/*
+	 * We're freeing all pertrans rsv, get current value from level 0
+	 * qgroup as real num_bytes to free.
+	 */
+	if (num_bytes == (u64)-1)
+		num_bytes = qgroup->rsv.values[type];
+
 	ulist_reinit(fs_info->qgroup_ulist);
 	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
 			(uintptr_t)qgroup, GFP_ATOMIC);
@@ -3093,24 +3114,21 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 	ret = qgroup_reserve(root, num_bytes, enforce, type);
 	if (ret < 0)
 		return ret;
-	atomic64_add(num_bytes, &root->qgroup_meta_rsv);
 	return ret;
 }
 
 void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	u64 reserved;
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
 	    !is_fstree(root->objectid))
 		return;
 
-	reserved = atomic64_xchg(&root->qgroup_meta_rsv, 0);
-	if (reserved == 0)
-		return;
-	trace_qgroup_meta_reserve(root, -(s64)reserved);
-	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved,
+	/* TODO: Update trace point to handle such free */
+	trace_qgroup_meta_reserve(root, 0);
+	/* Special value -1 means to free all reserved space */
+	btrfs_qgroup_free_refroot(fs_info, root->objectid, (u64)-1,
 				  BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
@@ -3124,8 +3142,6 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
 		return;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	WARN_ON(atomic64_read(&root->qgroup_meta_rsv) < num_bytes);
-	atomic64_sub(num_bytes, &root->qgroup_meta_rsv);
 	trace_qgroup_meta_reserve(root, -(s64)num_bytes);
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes, type);
 }
-- 
2.15.1

