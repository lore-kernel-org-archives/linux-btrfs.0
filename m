Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:48983 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729615AbeHCLJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 07:09:22 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: optimization to avoid ENOSPC for nocow writes after snapshot when low on data space
Date: Fri,  3 Aug 2018 17:13:43 +0800
Message-Id: <1533287623-2720-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Commit e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
forced writeback fallback to COW when subvolume is snapshotted.

1. When the space is full, write syscall will check if can
nocow, and space reservation will not happen.

2. Then snapshot happens before flushing IO (running dealloc),
we will increase will_be_snapshotted, and then when running
dealloc we fallback to COW and fail (ENOSPC).

Although write syscall does not return an error, the writeback
will fail, but subsequent fsync on the file will return an
error (ENOSPC) because the writeback sets the inode mapping error,
so it is not completely silent data loss.

So fix this by we add a snapshot_force_cow, this is used to
distinguish between write and writeback.

1. Increase will_be_snapshotted, so that write force to the cow,
always need space reservation.

2. Flushing all dirty pages (running dealloc), then now writeback
is still flushed in nocow mode, make sure all ditry pages that might
not reserve space previously have flushed this time otherwise they
will fallback to cow mode and fail due to no space.

3. Increase snapshot_force_cow, since all new dirty pages are
guaranteed space reservation, when running dealloc we can safely
fallback to COW.

Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/disk-io.c |  1 +
 fs/btrfs/inode.c   | 26 +++++---------------------
 fs/btrfs/ioctl.c   | 14 ++++++++++++++
 4 files changed, 21 insertions(+), 21 deletions(-)

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
index b077544..42af06b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -761,6 +761,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
 	int ret;
+	bool snapshot_force_cow = false;
 
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return -EINVAL;
@@ -777,6 +778,10 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		goto free_pending;
 	}
 
+	/*
+	 * We force a new write to reserve space to
+	 * avoid the space being full since they'll fallback to cow.
+	 */
 	atomic_inc(&root->will_be_snapshotted);
 	smp_mb__after_atomic();
 	/* wait for no snapshot writes */
@@ -787,6 +792,13 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (ret)
 		goto dec_and_free;
 
+	/*
+	 * When all previous writes are finished,
+	 * we can safely convert writeback to cow.
+	 */
+	atomic_inc(&root->snapshot_force_cow);
+	snapshot_force_cow = true;
+
 	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
 
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
@@ -851,6 +863,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
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

