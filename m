Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34069 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753115AbdGXSAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 14:00:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2BBF3AB43
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 18:00:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: fix spelling of snapshotting
Date: Mon, 24 Jul 2017 19:59:07 +0200
Message-Id: <17902036d038664e677d1e5d670d273d308233d1.1500919093.git.dsterba@suse.com>
In-Reply-To: <cover.1500919093.git.dsterba@suse.com>
References: <cover.1500919093.git.dsterba@suse.com>
In-Reply-To: <cover.1500919093.git.dsterba@suse.com>
References: <cover.1500919093.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       |  6 +++---
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent-tree.c | 22 +++++++++++-----------
 fs/btrfs/file.c        | 10 +++++-----
 fs/btrfs/inode.c       | 22 +++++++++++-----------
 fs/btrfs/ioctl.c       | 10 +++++-----
 6 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5bdd36664421..c651fb0034ec 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1261,7 +1261,7 @@ struct btrfs_root {
 	 */
 	int send_in_progress;
 	struct btrfs_subvolume_writers *subv_writers;
-	atomic_t will_be_snapshoted;
+	atomic_t will_be_snapshotted;
 
 	/* For qgroup metadata space reserve */
 	atomic64_t qgroup_meta_rsv;
@@ -2772,8 +2772,8 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
 int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
 int __get_raid_index(u64 flags);
-int btrfs_start_write_no_snapshoting(struct btrfs_root *root);
-void btrfs_end_write_no_snapshoting(struct btrfs_root *root);
+int btrfs_start_write_no_snapshotting(struct btrfs_root *root);
+void btrfs_end_write_no_snapshotting(struct btrfs_root *root);
 void btrfs_wait_for_snapshot_creation(struct btrfs_root *root);
 void check_system_chunk(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, const u64 type);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 075beedb4352..8a1cb2ad6d19 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1343,7 +1343,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	atomic_set(&root->log_batch, 0);
 	atomic_set(&root->orphan_inodes, 0);
 	refcount_set(&root->refs, 1);
-	atomic_set(&root->will_be_snapshoted, 0);
+	atomic_set(&root->will_be_snapshotted, 0);
 	atomic64_set(&root->qgroup_meta_rsv, 0);
 	root->log_transid = 0;
 	root->log_transid_committed = -1;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 375f8c728d91..26b518164a93 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11002,14 +11002,14 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 }
 
 /*
- * btrfs_{start,end}_write_no_snapshoting() are similar to
+ * btrfs_{start,end}_write_no_snapshotting() are similar to
  * mnt_{want,drop}_write(), they are used to prevent some tasks from writing
  * data into the page cache through nocow before the subvolume is snapshoted,
  * but flush the data into disk after the snapshot creation, or to prevent
- * operations while snapshoting is ongoing and that cause the snapshot to be
+ * operations while snapshotting is ongoing and that cause the snapshot to be
  * inconsistent (writes followed by expanding truncates for example).
  */
-void btrfs_end_write_no_snapshoting(struct btrfs_root *root)
+void btrfs_end_write_no_snapshotting(struct btrfs_root *root)
 {
 	percpu_counter_dec(&root->subv_writers->counter);
 	/*
@@ -11020,9 +11020,9 @@ void btrfs_end_write_no_snapshoting(struct btrfs_root *root)
 		wake_up(&root->subv_writers->wait);
 }
 
-int btrfs_start_write_no_snapshoting(struct btrfs_root *root)
+int btrfs_start_write_no_snapshotting(struct btrfs_root *root)
 {
-	if (atomic_read(&root->will_be_snapshoted))
+	if (atomic_read(&root->will_be_snapshotted))
 		return 0;
 
 	percpu_counter_inc(&root->subv_writers->counter);
@@ -11030,14 +11030,14 @@ int btrfs_start_write_no_snapshoting(struct btrfs_root *root)
 	 * Make sure counter is updated before we check for snapshot creation.
 	 */
 	smp_mb();
-	if (atomic_read(&root->will_be_snapshoted)) {
-		btrfs_end_write_no_snapshoting(root);
+	if (atomic_read(&root->will_be_snapshotted)) {
+		btrfs_end_write_no_snapshotting(root);
 		return 0;
 	}
 	return 1;
 }
 
-static int wait_snapshoting_atomic_t(atomic_t *a)
+static int wait_snapshotting_atomic_t(atomic_t *a)
 {
 	schedule();
 	return 0;
@@ -11048,11 +11048,11 @@ void btrfs_wait_for_snapshot_creation(struct btrfs_root *root)
 	while (true) {
 		int ret;
 
-		ret = btrfs_start_write_no_snapshoting(root);
+		ret = btrfs_start_write_no_snapshotting(root);
 		if (ret)
 			break;
-		wait_on_atomic_t(&root->will_be_snapshoted,
-				 wait_snapshoting_atomic_t,
+		wait_on_atomic_t(&root->will_be_snapshotted,
+				 wait_snapshotting_atomic_t,
 				 TASK_UNINTERRUPTIBLE);
 	}
 }
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0f102a1b851f..40316fd151ba 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1536,7 +1536,7 @@ static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
 	u64 num_bytes;
 	int ret;
 
-	ret = btrfs_start_write_no_snapshoting(root);
+	ret = btrfs_start_write_no_snapshotting(root);
 	if (!ret)
 		return -ENOSPC;
 
@@ -1561,7 +1561,7 @@ static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
 			NULL, NULL, NULL);
 	if (ret <= 0) {
 		ret = 0;
-		btrfs_end_write_no_snapshoting(root);
+		btrfs_end_write_no_snapshotting(root);
 	} else {
 		*write_bytes = min_t(size_t, *write_bytes ,
 				     num_bytes - pos + lockstart);
@@ -1664,7 +1664,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 						data_reserved, pos,
 						write_bytes);
 			else
-				btrfs_end_write_no_snapshoting(root);
+				btrfs_end_write_no_snapshotting(root);
 			break;
 		}
 
@@ -1767,7 +1767,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 		release_bytes = 0;
 		if (only_release_metadata)
-			btrfs_end_write_no_snapshoting(root);
+			btrfs_end_write_no_snapshotting(root);
 
 		if (only_release_metadata && copied > 0) {
 			lockstart = round_down(pos,
@@ -1797,7 +1797,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	if (release_bytes) {
 		if (only_release_metadata) {
-			btrfs_end_write_no_snapshoting(root);
+			btrfs_end_write_no_snapshotting(root);
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
 					release_bytes);
 		} else {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eb495e956d53..db86359f91f2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1382,7 +1382,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			 * we fall into common COW way.
 			 */
 			if (!nolock) {
-				err = btrfs_start_write_no_snapshoting(root);
+				err = btrfs_start_write_no_snapshotting(root);
 				if (!err)
 					goto out_check;
 			}
@@ -1394,12 +1394,12 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			if (csum_exist_in_range(fs_info, disk_bytenr,
 						num_bytes)) {
 				if (!nolock)
-					btrfs_end_write_no_snapshoting(root);
+					btrfs_end_write_no_snapshotting(root);
 				goto out_check;
 			}
 			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
 				if (!nolock)
-					btrfs_end_write_no_snapshoting(root);
+					btrfs_end_write_no_snapshotting(root);
 				goto out_check;
 			}
 			nocow = 1;
@@ -1416,7 +1416,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		if (extent_end <= start) {
 			path->slots[0]++;
 			if (!nolock && nocow)
-				btrfs_end_write_no_snapshoting(root);
+				btrfs_end_write_no_snapshotting(root);
 			if (nocow)
 				btrfs_dec_nocow_writers(fs_info, disk_bytenr);
 			goto next_slot;
@@ -1439,7 +1439,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     NULL);
 			if (ret) {
 				if (!nolock && nocow)
-					btrfs_end_write_no_snapshoting(root);
+					btrfs_end_write_no_snapshotting(root);
 				if (nocow)
 					btrfs_dec_nocow_writers(fs_info,
 								disk_bytenr);
@@ -1460,7 +1460,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					  BTRFS_ORDERED_PREALLOC);
 			if (IS_ERR(em)) {
 				if (!nolock && nocow)
-					btrfs_end_write_no_snapshoting(root);
+					btrfs_end_write_no_snapshotting(root);
 				if (nocow)
 					btrfs_dec_nocow_writers(fs_info,
 								disk_bytenr);
@@ -1500,7 +1500,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     PAGE_UNLOCK | PAGE_SET_PRIVATE2);
 
 		if (!nolock && nocow)
-			btrfs_end_write_no_snapshoting(root);
+			btrfs_end_write_no_snapshotting(root);
 		cur_offset = extent_end;
 
 		/*
@@ -5056,7 +5056,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 
 	if (newsize > oldsize) {
 		/*
-		 * Don't do an expanding truncate while snapshoting is ongoing.
+		 * Don't do an expanding truncate while snapshotting is ongoing.
 		 * This is to ensure the snapshot captures a fully consistent
 		 * state of this file - if the snapshot captures this expanding
 		 * truncation, it must capture all writes that happened before
@@ -5065,13 +5065,13 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		btrfs_wait_for_snapshot_creation(root);
 		ret = btrfs_cont_expand(inode, oldsize, newsize);
 		if (ret) {
-			btrfs_end_write_no_snapshoting(root);
+			btrfs_end_write_no_snapshotting(root);
 			return ret;
 		}
 
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
-			btrfs_end_write_no_snapshoting(root);
+			btrfs_end_write_no_snapshotting(root);
 			return PTR_ERR(trans);
 		}
 
@@ -5079,7 +5079,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
 		pagecache_isize_extended(inode, oldsize, newsize);
 		ret = btrfs_update_inode(trans, root, inode);
-		btrfs_end_write_no_snapshoting(root);
+		btrfs_end_write_no_snapshotting(root);
 		btrfs_end_transaction(trans);
 	} else {
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78cf25f6..f321e3b32737 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -638,7 +638,7 @@ static noinline int create_subvol(struct inode *dir,
 	return ret;
 }
 
-static void btrfs_wait_for_no_snapshoting_writes(struct btrfs_root *root)
+static void btrfs_wait_for_no_snapshotting_writes(struct btrfs_root *root)
 {
 	s64 writers;
 	DEFINE_WAIT(wait);
@@ -681,9 +681,9 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		goto free_pending;
 	}
 
-	atomic_inc(&root->will_be_snapshoted);
+	atomic_inc(&root->will_be_snapshotted);
 	smp_mb__after_atomic();
-	btrfs_wait_for_no_snapshoting_writes(root);
+	btrfs_wait_for_no_snapshotting_writes(root);
 
 	ret = btrfs_start_delalloc_inodes(root, 0);
 	if (ret)
@@ -754,8 +754,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 fail:
 	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
 dec_and_free:
-	if (atomic_dec_and_test(&root->will_be_snapshoted))
-		wake_up_atomic_t(&root->will_be_snapshoted);
+	if (atomic_dec_and_test(&root->will_be_snapshotted))
+		wake_up_atomic_t(&root->will_be_snapshotted);
 free_pending:
 	kfree(pending_snapshot->root_item);
 	btrfs_free_path(pending_snapshot->path);
-- 
2.13.0

