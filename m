Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:46076 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3AGWAI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 17:00:08 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id fye1cDLhYNMfFn3C (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2013 15:00:07 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add orphan before truncating pagecache
Date: Mon, 7 Jan 2013 17:06:42 -0500
Message-ID: <1357596402-11499-1-git-send-email-jbacik@fusionio.com>
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
 fs/btrfs/inode.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3ce93e..20138b6 100644
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
@@ -3789,6 +3801,29 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
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
@@ -6939,11 +6974,9 @@ static int btrfs_truncate(struct inode *inode)
 
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
@@ -6954,12 +6987,6 @@ static int btrfs_truncate(struct inode *inode)
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
-- 
1.7.7.6

