Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933335AbeCGP1Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 10:27:16 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, dbueso@suse.com,
        paulmck@linux.vnet.ibm.com, Nikolay Borisov <nborisov@suse.com>
Subject: [RFC PATCH] btrfs: Fix memory ordering of unlocked dio reads vs truncate
Date: Wed,  7 Mar 2018 17:27:09 +0200
Message-Id: <1520436429-8584-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Hello, 

Sending it as an RFC for the time being to see how people are going to react
and also I'd like some feedback on the mb semantics. For this purposed I've 
CC'ed some memory ordering people :) 

 fs/btrfs/btrfs_inode.h | 17 -----------------
 fs/btrfs/inode.c       | 40 +++++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index f527e99c9f8d..3519e49d4ef0 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -329,23 +329,6 @@ struct btrfs_dio_private {
 			blk_status_t);
 };
 
-/*
- * Disable DIO read nolock optimization, so new dio readers will be forced
- * to grab i_mutex. It is used to avoid the endless truncate due to
- * nonlocked dio read.
- */
-static inline void btrfs_inode_block_unlocked_dio(struct btrfs_inode *inode)
-{
-	set_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
-	smp_mb();
-}
-
-static inline void btrfs_inode_resume_unlocked_dio(struct btrfs_inode *inode)
-{
-	smp_mb__before_atomic();
-	clear_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
-}
-
 static inline void btrfs_print_data_csum_error(struct btrfs_inode *inode,
 		u64 logical_start, u32 csum, u32 csum_expected, int mirror_num)
 {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f7aebb8424b1..7ded6808a0f6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5148,10 +5148,28 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		/* we don't support swapfiles, so vmtruncate shouldn't fail */
 		truncate_setsize(inode, newsize);
 
-		/* Disable nonlocked read DIO to avoid the end less truncate */
-		btrfs_inode_block_unlocked_dio(BTRFS_I(inode));
+		/*
+		 * This code is very subtle. It is essentially a lock of its
+		 * own type. BTRFS allows multiple DIO readers to race with
+		 * writers so long as they don't read beyond EOF of an inode.
+		 * However, if we have a pending truncate we'd like to signal
+		 * DIO readers they should fall back to DIO_LOCKING semantics.
+		 * This ensures that multiple aggressive DIO readers cannot
+		 * starve the truncating thread.
+		 *
+		 * This semantics is achieved by the use of the below flag. If
+		 * new readers come after the flag has been cleared then the
+		 * state is still consistent, since the RELEASE semantics of
+		 * clear_bit_unlock ensure the truncate inode size will be
+		 * visible and DIO readers will bail out.
+		 *
+		 * The implied memory barrier by inode_dio_wait is paired with
+		 * smp_mb__before_atomic in btrfs_direct_IO.
+		 */
+		set_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
 		inode_dio_wait(inode);
-		btrfs_inode_resume_unlocked_dio(BTRFS_I(inode));
+		clear_bit_unlock(BTRFS_INODE_READDIO_NEED_LOCK,
+				 &inode->runtime_flags);
 
 		ret = btrfs_truncate(inode, newsize == oldsize);
 		if (ret && inode->i_nlink) {
@@ -8716,11 +8734,19 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		dio_data.unsubmitted_oe_range_end = (u64)offset;
 		current->journal_info = &dio_data;
 		down_read(&BTRFS_I(inode)->dio_sem);
-	} else if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
+	} else {
+		/*
+		 * This barrier is paired with the implied barrier in
+		 * inode_dio_wait. It ensures that READDIO_NEED_LOCK is
+		 * visible if we have a pending truncate.
+		 */
+		smp_mb__before_atomic();
+		if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
 				     &BTRFS_I(inode)->runtime_flags)) {
-		inode_dio_end(inode);
-		flags = DIO_LOCKING | DIO_SKIP_HOLES;
-		wakeup = false;
+			inode_dio_end(inode);
+			flags = DIO_LOCKING | DIO_SKIP_HOLES;
+			wakeup = false;
+		}
 	}
 
 	ret = __blockdev_direct_IO(iocb, inode,
-- 
2.7.4

