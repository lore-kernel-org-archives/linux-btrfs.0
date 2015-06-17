Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24473 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbbFQHzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:55:19 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com
Subject: [RFC PATCH v2 2/2] Btrfs: improve fsync for nocow file
Date: Wed, 17 Jun 2015 15:54:32 +0800
Message-Id: <1434527672-5762-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If  we're overwriting an allocated file without changing timestamp
and inode version, and the file is with NODATACOW, we don't have any metadata to
commit, thus we can just flush the data device cache and go forward.

However, if there's have any change on extents' disk bytenr, inode size,
timestamp or inode version, we need to go through the normal btrfs_log_inode
path.

Test:
----------------------------
1. sysbench test of
"1 file + 1 thread + bs=4k + size=40k + synchronous I/O mode + randomwrite +
fsync_on_each_write",
2. loop device associated with tmpfs file
3.
  - For btrfs, "-o nodatacow" and "-o noi_version" option
  - For ext4 and xfs, no extra mount options
----------------------------

Results:
----------------------------
- btrfs:
w/o: ~30Mb/sec
w:   ~131Mb/sec

- other filesystems: (both don't enable i_version by default)
ext4:  203Mb/sec
xfs:   212Mb/sec
----------------------------

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Catch errors from data writeback and skip barrier if necessary.

 fs/btrfs/btrfs_inode.h |    2 +
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/disk-io.h     |    1 +
 fs/btrfs/file.c        |   54 +++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/inode.c       |    3 ++
 5 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index de5e4f2..f7b99b6 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -44,6 +44,8 @@
 #define BTRFS_INODE_IN_DELALLOC_LIST		9
 #define BTRFS_INODE_READDIO_NEED_LOCK		10
 #define BTRFS_INODE_HAS_PROPS		        11
+#define BTRFS_INODE_NOTIMESTAMP			12
+#define BTRFS_INODE_NOISIZE			13
 /*
  * The following 3 bits are meant only for the btree inode.
  * When any of them is set, it means an error happened while writing an
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 639f266..8a41df1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3299,7 +3299,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
  * send an empty flush down to each device in parallel,
  * then wait for them
  */
-static int barrier_all_devices(struct btrfs_fs_info *info)
+int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 27d44c0..bea982c 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -60,6 +60,7 @@ void close_ctree(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
+int barrier_all_devices(struct btrfs_fs_info *info);
 int btrfs_commit_super(struct btrfs_root *root);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index faa7d39..180a3e1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -523,8 +523,12 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	 * the disk i_size.  There is no need to log the inode
 	 * at this time.
 	 */
-	if (end_pos > isize)
+	if (end_pos > isize) {
 		i_size_write(inode, end_pos);
+		clear_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
+	} else {
+		set_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
+	}
 	return 0;
 }
 
@@ -1715,19 +1719,33 @@ out:
 static void update_time_for_write(struct inode *inode)
 {
 	struct timespec now;
+	int sync_it = 0;
 
-	if (IS_NOCMTIME(inode))
+	if (IS_NOCMTIME(inode)) {
+		set_bit(BTRFS_INODE_NOTIMESTAMP, &BTRFS_I(inode)->runtime_flags);
 		return;
+	}
 
 	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now))
+	if (!timespec_equal(&inode->i_mtime, &now)) {
 		inode->i_mtime = now;
+		sync_it = S_MTIME;
+	}
 
-	if (!timespec_equal(&inode->i_ctime, &now))
+	if (!timespec_equal(&inode->i_ctime, &now)) {
 		inode->i_ctime = now;
+		sync_it |= S_CTIME;
+	}
 
-	if (IS_I_VERSION(inode))
+	if (IS_I_VERSION(inode)) {
 		inode_inc_iversion(inode);
+		sync_it |= S_VERSION;
+	}
+
+	if (!sync_it)
+		set_bit(BTRFS_INODE_NOTIMESTAMP, &BTRFS_I(inode)->runtime_flags);
+	else
+		clear_bit(BTRFS_INODE_NOTIMESTAMP, &BTRFS_I(inode)->runtime_flags);
 }
 
 static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
@@ -1983,6 +2001,32 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) {
+		if (test_and_clear_bit(BTRFS_INODE_NOTIMESTAMP,
+					&BTRFS_I(inode)->runtime_flags) &&
+		    test_and_clear_bit(BTRFS_INODE_NOISIZE,
+					&BTRFS_I(inode)->runtime_flags)) {
+
+			/* make sure data is on disk and catch error */
+			if (!full_sync)
+				ret = filemap_fdatawait_range(inode->i_mapping,
+							      start, end);
+
+			if (!ret && !btrfs_test_opt(root, NOBARRIER)) {
+				mutex_lock(&root->fs_info->
+					   fs_devices->device_list_mutex);
+				ret = barrier_all_devices(root->fs_info);
+				if (ret)
+					btrfs_error(root->fs_info, ret,
+						"errors while submitting device barriers.");	
+				mutex_unlock(&root->fs_info->
+					   fs_devices->device_list_mutex);
+			}
+			mutex_unlock(&inode->i_mutex);
+			goto out;
+		}
+	}
+
 	/*
 	 * ok we haven't committed the transaction yet, lets do a commit
 	 */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 43192e1..e2912c8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1383,6 +1383,7 @@ out_check:
 
 		btrfs_release_path(path);
 		if (cow_start != (u64)-1) {
+			clear_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
 			ret = cow_file_range(inode, locked_page,
 					     cow_start, found_key.offset - 1,
 					     page_started, nr_written, 1);
@@ -1425,6 +1426,7 @@ out_check:
 						em->start + em->len - 1, 0);
 			}
 			type = BTRFS_ORDERED_PREALLOC;
+			clear_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
 		} else {
 			type = BTRFS_ORDERED_NOCOW;
 		}
@@ -1463,6 +1465,7 @@ out_check:
 	}
 
 	if (cow_start != (u64)-1) {
+		clear_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
 		ret = cow_file_range(inode, locked_page, cow_start, end,
 				     page_started, nr_written, 1);
 		if (ret)
-- 
1.7.7.6

