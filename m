Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbbFVWr4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 18:47:56 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 3/5] btrfs: fix clone / extent-same deadlocks
Date: Mon, 22 Jun 2015 15:47:40 -0700
Message-Id: <1435013262-23252-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
References: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clone and extent same lock their source and target inodes in opposite order.
In addition to this, the range locking in clone doesn't take ordering into
account. Fix this by having clone use the same locking helpers as
btrfs-extent-same.

In addition, I do a small cleanup of the locking helpers, removing a case
(both inodes being the same) which was poorly accounted for and never
actually used by the callers.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.c | 34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b899584..8d6887d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2831,8 +2831,7 @@ static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
 		swap(inode1, inode2);
 
 	mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
-	if (inode1 != inode2)
-		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
+	mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
 }
 
 static void btrfs_double_extent_unlock(struct inode *inode1, u64 loff1,
@@ -2850,8 +2849,7 @@ static void btrfs_double_extent_lock(struct inode *inode1, u64 loff1,
 		swap(loff1, loff2);
 	}
 	lock_extent_range(inode1, loff1, len);
-	if (inode1 != inode2)
-		lock_extent_range(inode2, loff2, len);
+	lock_extent_range(inode2, loff2, len);
 }
 
 struct cmp_pages {
@@ -3713,13 +3711,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		goto out_fput;
 
 	if (!same_inode) {
-		if (inode < src) {
-			mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
-			mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
-		} else {
-			mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
-			mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
-		}
+		btrfs_double_inode_lock(src, inode);
 	} else {
 		mutex_lock(&src->i_mutex);
 	}
@@ -3769,8 +3761,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 		lock_extent_range(src, lock_start, lock_len);
 	} else {
-		lock_extent_range(src, off, len);
-		lock_extent_range(inode, destoff, len);
+		btrfs_double_extent_lock(src, off, inode, destoff, len);
 	}
 
 	ret = btrfs_clone(src, inode, off, olen, len, destoff);
@@ -3781,9 +3772,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 		unlock_extent(&BTRFS_I(src)->io_tree, lock_start, lock_end);
 	} else {
-		unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
-		unlock_extent(&BTRFS_I(inode)->io_tree, destoff,
-			      destoff + len - 1);
+		btrfs_double_extent_unlock(src, off, inode, destoff, len);
 	}
 	/*
 	 * Truncate page cache pages so that future reads will see the cloned
@@ -3792,17 +3781,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	truncate_inode_pages_range(&inode->i_data, destoff,
 				   PAGE_CACHE_ALIGN(destoff + len) - 1);
 out_unlock:
-	if (!same_inode) {
-		if (inode < src) {
-			mutex_unlock(&src->i_mutex);
-			mutex_unlock(&inode->i_mutex);
-		} else {
-			mutex_unlock(&inode->i_mutex);
-			mutex_unlock(&src->i_mutex);
-		}
-	} else {
+	if (!same_inode)
+		btrfs_double_inode_unlock(src, inode);
+	else
 		mutex_unlock(&src->i_mutex);
-	}
 out_fput:
 	fdput(src_file);
 out_drop_write:
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
