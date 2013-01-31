Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62002 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab3AaJWm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 04:22:42 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0V9Ma5W022155
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 17:22:36 +0800
Message-ID: <510A3807.1040306@cn.fujitsu.com>
Date: Thu, 31 Jan 2013 17:23:19 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: serialize unlocked dio reads with truncate
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, we can do unlocked dio reads, but the following race
is possible:

dio_read_task			truncate_task
				->btrfs_setattr()
->btrfs_direct_IO
    ->__blockdev_direct_IO
      ->btrfs_get_block
				  ->btrfs_truncate()
				 #alloc truncated blocks
				 #to other inode
      ->submit_io()
     #INFORMATION LEAK

In order to avoid this problem, we must serialize unlocked dio reads with
truncate by inode_dio_wait().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h | 19 +++++++++++++++++++
 fs/btrfs/inode.c       | 31 +++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 2a8c242..00e2601 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -40,6 +40,7 @@
 #define BTRFS_INODE_HAS_ASYNC_EXTENT		6
 #define BTRFS_INODE_NEEDS_FULL_SYNC		7
 #define BTRFS_INODE_COPY_EVERYTHING		8
+#define BTRFS_INODE_READDIO_NEED_LOCK		9
 
 /* in memory btrfs inode */
 struct btrfs_inode {
@@ -216,4 +217,22 @@ static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
 	return 0;
 }
 
+/*
+ * Disable DIO read nolock optimization, so new dio readers will be forced
+ * to grab i_mutex. It is used to avoid the endless truncate due to
+ * nonlocked dio read.
+ */
+static inline void btrfs_inode_block_unlocked_dio(struct inode *inode)
+{
+	set_bit(BTRFS_INODE_READDIO_NEED_LOCK, &BTRFS_I(inode)->runtime_flags);
+	smp_mb();
+}
+
+static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
+{
+	smp_mb__before_clear_bit();
+	clear_bit(BTRFS_INODE_READDIO_NEED_LOCK,
+		  &BTRFS_I(inode)->runtime_flags);
+}
+
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 97f4c30..d17a04b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3785,6 +3785,11 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 
 		/* we don't support swapfiles, so vmtruncate shouldn't fail */
 		truncate_setsize(inode, newsize);
+
+		btrfs_inode_block_unlocked_dio(inode);
+		inode_dio_wait(inode);
+		btrfs_inode_resume_unlocked_dio(inode);
+
 		ret = btrfs_truncate(inode);
 	}
 
@@ -6583,15 +6588,33 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	int flags = 0;
+	bool wakeup = false;
+	int ret;
 
 	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
 			    offset, nr_segs))
 		return 0;
 
-	return __blockdev_direct_IO(rw, iocb, inode,
-		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+	if (rw == READ) {
+		atomic_inc(&inode->i_dio_count);
+		smp_mb__after_atomic_inc();
+		if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
+				      &BTRFS_I(inode)->runtime_flags))) {
+			inode_dio_done(inode);
+			flags = DIO_LOCKING | DIO_SKIP_HOLES;
+		} else {
+			wakeup = true;
+		}
+	}
+
+	ret = __blockdev_direct_IO(rw, iocb, inode,
+			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
+			iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
+			btrfs_submit_direct, flags);
+	if (wakeup)
+		inode_dio_done(inode);
+	return ret;
 }
 
 #define BTRFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC)
-- 
1.7.11.7
