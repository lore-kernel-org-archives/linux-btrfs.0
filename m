Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36125 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab3AHPrl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 10:47:41 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id eDp3wDOtW5jDE99J (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2013 08:47:40 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add orphan before truncating pagecache V2
Date: Tue, 8 Jan 2013 10:54:15 -0500
Message-ID: <1357660455-3748-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running xfstests 83 in a loop would sometimes fail the fsck.  This happens
because if we invalidate a page that already has an ordered extent setup for
it we will complete the ordered extent ourselves, assuming that the truncate
will clean everything up.  The problem with this is there is plenty of time
for the truncate to fail after we've done this work.  So to fix this we need
to add the orphan item first to make sure the cleanup gets done properly,
and then we can truncate the pagecache and all that stuff and be safe.  This
fixes the btrfsck failures I was seeing while running 83 in a loop.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: fix error cleanup if we fail to truncate.

 fs/btrfs/inode.c |   53 ++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3ce93e..e6b4f69 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2484,6 +2484,18 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				continue;
 			}
 			nr_truncate++;
+
+			/* 1 for the orphan item deletion. */
+			trans = btrfs_start_transaction(root, 1);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto out;
+			}
+			ret = btrfs_orphan_add(trans, inode);
+			btrfs_end_transaction(trans, root);
+			if (ret)
+				goto out;
+
 			ret = btrfs_truncate(inode);
 		} else {
 			nr_unlink++;
@@ -3789,9 +3801,34 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 			set_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
 				&BTRFS_I(inode)->runtime_flags);
 
+		/*
+		 * 1 for the orphan item we're going to add
+		 * 1 for the orphan item deletion.
+		 */
+		trans = btrfs_start_transaction(root, 2);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+
+		/*
+		 * We need to do this in case we fail at _any_ point during the
+		 * actual truncate.  Once we do the truncate_setsize we could
+		 * invalidate pages which forces any outstanding ordered io to
+		 * be instantly completed which will give us extents that need
+		 * to be truncated.  If we fail to get an orphan inode down we
+		 * could have left over extents that were never meant to live,
+		 * so we need to garuntee from this point on that everything
+		 * will be consistent.
+		 */
+		ret = btrfs_orphan_add(trans, inode);
+		btrfs_end_transaction(trans, root);
+		if (ret)
+			return ret;
+
 		/* we don't support swapfiles, so vmtruncate shouldn't fail */
 		truncate_setsize(inode, newsize);
 		ret = btrfs_truncate(inode);
+		if (ret && inode->i_nlink)
+			btrfs_orphan_del(NULL, inode);
 	}
 
 	return ret;
@@ -6939,11 +6976,9 @@ static int btrfs_truncate(struct inode *inode)
 
 	/*
 	 * 1 for the truncate slack space
-	 * 1 for the orphan item we're going to add
-	 * 1 for the orphan item deletion
 	 * 1 for updating the inode.
 	 */
-	trans = btrfs_start_transaction(root, 4);
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		goto out;
@@ -6954,12 +6989,6 @@ static int btrfs_truncate(struct inode *inode)
 				      min_size);
 	BUG_ON(ret);
 
-	ret = btrfs_orphan_add(trans, inode);
-	if (ret) {
-		btrfs_end_transaction(trans, root);
-		goto out;
-	}
-
 	/*
 	 * setattr is responsible for setting the ordered_data_close flag,
 	 * but that is only tested during the last file release.  That
@@ -7028,12 +7057,6 @@ static int btrfs_truncate(struct inode *inode)
 		ret = btrfs_orphan_del(trans, inode);
 		if (ret)
 			err = ret;
-	} else if (ret && inode->i_nlink > 0) {
-		/*
-		 * Failed to do the truncate, remove us from the in memory
-		 * orphan list.
-		 */
-		ret = btrfs_orphan_del(NULL, inode);
 	}
 
 	if (trans) {
-- 
1.7.7.6

