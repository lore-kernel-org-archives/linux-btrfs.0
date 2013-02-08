Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757717Ab3BHHAZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 02:00:25 -0500
Message-ID: <5114A2B4.9040008@cn.fujitsu.com>
Date: Fri, 08 Feb 2013 15:01:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH V2 1/2] Btrfs: serialize unlocked dio reads with truncate
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
truncate. There are two approaches:
- use extent lock to protect the extent that we truncate
- use inode_dio_wait() to make sure the truncating task will wait for
  the read DIO.

If we use the 1st one, we will meet the endless truncation problem due to
the nonlocked read DIO after we implement the nonlocked write DIO. It is
because we still need invoke inode_dio_wait() avoid the race between write
DIO and truncation. By that time, we have to introduce

  btrfs_inode_{block, resume}_nolock_dio()

again. That is we have to implement this patch again, so I choose the 2nd
way to fix the problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changlog v1 -> v2:
- Rebase the patch against the following one:
  [RFC][PATCH] Btrfs: fix deadlock due to unsubmitted
- Modify the changelog to explain why we don't choose the extent lock to
  fix the bug
---
 fs/btrfs/btrfs_inode.h |   19 +++++++++++++++++++
 fs/btrfs/inode.c       |   23 +++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

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
index c5d829d..a49be05 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3832,6 +3832,12 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 
 		/* we don't support swapfiles, so vmtruncate shouldn't fail */
 		truncate_setsize(inode, newsize);
+
+		/* Disable nonlocked read DIO to avoid the end less truncate */
+		btrfs_inode_block_unlocked_dio(inode);
+		inode_dio_wait(inode);
+		btrfs_inode_resume_unlocked_dio(inode);
+
 		ret = btrfs_truncate(inode);
 		if (ret && inode->i_nlink)
 			btrfs_orphan_del(NULL, inode);
@@ -6615,6 +6621,8 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	size_t count = 0;
+	int flags = 0;
+	bool wakeup = false;
 	ssize_t ret;
 
 	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
@@ -6626,13 +6634,22 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		ret = btrfs_delalloc_reserve_space(inode, count);
 		if (ret)
 			return ret;
+	} else {
+		atomic_inc(&inode->i_dio_count);
+		smp_mb__after_atomic_inc();
+		if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
+				      &BTRFS_I(inode)->runtime_flags))) {
+			inode_dio_done(inode);
+			flags = DIO_LOCKING | DIO_SKIP_HOLES;
+		} else {
+			wakeup = true;
+		}
 	}
 
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 			iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-			btrfs_submit_direct, 0);
-
+			btrfs_submit_direct, flags);
 	if (rw & WRITE) {
 		if (ret < 0 && ret != -EIOCBQUEUED)
 			btrfs_delalloc_release_space(inode, count);
@@ -6645,6 +6662,8 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		}
 		btrfs_delalloc_release_metadata(inode, 0);
 	}
+	if (wakeup)
+		inode_dio_done(inode);
 
 	return ret;
 }
-- 
1.6.5.2
