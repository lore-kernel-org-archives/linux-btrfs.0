Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:33921 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbeG3Lzw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 07:55:52 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: fix data lose with snapshot when nospace
Date: Mon, 30 Jul 2018 18:21:11 +0800
Message-Id: <1532946072-31011-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Commit e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
modified the nocow writeback mechanism, if you create a snapshot,
it will always switch to cow writeback.

This will cause data loss when there is no space, because
when the space is full, the write will not reserve any space, only
check if it can be nocow write.

So fix this by first flush the nocow data, and then switch to the
cow write.

Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/disk-io.c |  1 +
 fs/btrfs/inode.c   | 26 +++++---------------------
 fs/btrfs/ioctl.c   |  6 ++++++
 4 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 118346a..663ce05 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1277,6 +1277,7 @@ struct btrfs_root {
 	int send_in_progress;
 	struct btrfs_subvolume_writers *subv_writers;
 	atomic_t will_be_snapshotted;
+	atomic_t snapshot_force_cow;
 
 	/* For qgroup metadata reserved space */
 	spinlock_t qgroup_meta_rsv_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 205092d..5573916 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1216,6 +1216,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	atomic_set(&root->log_batch, 0);
 	refcount_set(&root->refs, 1);
 	atomic_set(&root->will_be_snapshotted, 0);
+	atomic_set(&root->snapshot_force_cow, 0);
 	root->log_transid = 0;
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eba61bc..263b852 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1275,7 +1275,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	u64 disk_num_bytes;
 	u64 ram_bytes;
 	int extent_type;
-	int ret, err;
+	int ret;
 	int type;
 	int nocow;
 	int check_prev = 1;
@@ -1407,11 +1407,9 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			 * if there are pending snapshots for this root,
 			 * we fall into common COW way.
 			 */
-			if (!nolock) {
-				err = btrfs_start_write_no_snapshotting(root);
-				if (!err)
-					goto out_check;
-			}
+			if (!nolock &&
+				unlikely(atomic_read(&root->snapshot_force_cow)))
+				goto out_check;
 			/*
 			 * force cow if csum exists in the range.
 			 * this ensure that csum for a given extent are
@@ -1420,9 +1418,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			ret = csum_exist_in_range(fs_info, disk_bytenr,
 						  num_bytes);
 			if (ret) {
-				if (!nolock)
-					btrfs_end_write_no_snapshotting(root);
-
 				/*
 				 * ret could be -EIO if the above fails to read
 				 * metadata.
@@ -1435,11 +1430,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 				WARN_ON_ONCE(nolock);
 				goto out_check;
 			}
-			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
-				if (!nolock)
-					btrfs_end_write_no_snapshotting(root);
+			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr))
 				goto out_check;
-			}
 			nocow = 1;
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = found_key.offset +
@@ -1453,8 +1445,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 out_check:
 		if (extent_end <= start) {
 			path->slots[0]++;
-			if (!nolock && nocow)
-				btrfs_end_write_no_snapshotting(root);
 			if (nocow)
 				btrfs_dec_nocow_writers(fs_info, disk_bytenr);
 			goto next_slot;
@@ -1476,8 +1466,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     end, page_started, nr_written, 1,
 					     NULL);
 			if (ret) {
-				if (!nolock && nocow)
-					btrfs_end_write_no_snapshotting(root);
 				if (nocow)
 					btrfs_dec_nocow_writers(fs_info,
 								disk_bytenr);
@@ -1497,8 +1485,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					  ram_bytes, BTRFS_COMPRESS_NONE,
 					  BTRFS_ORDERED_PREALLOC);
 			if (IS_ERR(em)) {
-				if (!nolock && nocow)
-					btrfs_end_write_no_snapshotting(root);
 				if (nocow)
 					btrfs_dec_nocow_writers(fs_info,
 								disk_bytenr);
@@ -1537,8 +1523,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     EXTENT_CLEAR_DATA_RESV,
 					     PAGE_UNLOCK | PAGE_SET_PRIVATE2);
 
-		if (!nolock && nocow)
-			btrfs_end_write_no_snapshotting(root);
 		cur_offset = extent_end;
 
 		/*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b077544..43674ef 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -761,6 +761,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
 	int ret;
+	bool snapshot_force_cow = false;
 
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return -EINVAL;
@@ -787,6 +788,9 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (ret)
 		goto dec_and_free;
 
+	atomic_inc(&root->snapshot_force_cow);
+	snapshot_force_cow = true;
+
 	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
 
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
@@ -851,6 +855,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 fail:
 	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
 dec_and_free:
+	if (snapshot_force_cow)
+		atomic_dec(&root->snapshot_force_cow);
 	if (atomic_dec_and_test(&root->will_be_snapshotted))
 		wake_up_var(&root->will_be_snapshotted);
 free_pending:
-- 
1.9.1

