Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35598 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbEYDUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 May 2015 23:20:49 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t4P3Kmj5017921
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 03:20:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t4P3Kmbo007444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 03:20:48 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t4P3KmHW012625
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 03:20:48 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove csum_bytes_left
Date: Mon, 25 May 2015 11:20:22 +0800
Message-Id: <1432524022-12424-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After commit 8407f553268a
("Btrfs: fix data corruption after fast fsync and writeback error"),
during wait_ordered_extents(), we wait for ordered extent setting
BTRFS_ORDERED_IO_DONE or BTRFS_ORDERED_IOERR, at which point we've
already got checksum information, so we don't need to check
(csum_bytes_left == 0) in the whole logging path.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ordered-data.c | 7 -------
 fs/btrfs/ordered-data.h | 3 ---
 fs/btrfs/tree-log.c     | 6 ------
 3 files changed, 16 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 157cc54..e3c7540 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -198,9 +198,6 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->file_offset = file_offset;
 	entry->start = start;
 	entry->len = len;
-	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) &&
-	    !(type == BTRFS_ORDERED_NOCOW))
-		entry->csum_bytes_left = disk_len;
 	entry->disk_len = disk_len;
 	entry->bytes_left = len;
 	entry->inode = igrab(inode);
@@ -286,10 +283,6 @@ void btrfs_add_ordered_sum(struct inode *inode,
 	tree = &BTRFS_I(inode)->ordered_tree;
 	spin_lock_irq(&tree->lock);
 	list_add_tail(&sum->list, &entry->list);
-	WARN_ON(entry->csum_bytes_left < sum->len);
-	entry->csum_bytes_left -= sum->len;
-	if (entry->csum_bytes_left == 0)
-		wake_up(&entry->wait);
 	spin_unlock_irq(&tree->lock);
 }
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index e96cd4c..a82cd75 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -89,9 +89,6 @@ struct btrfs_ordered_extent {
 	/* number of bytes that still need writing */
 	u64 bytes_left;
 
-	/* number of bytes that still need csumming */
-	u64 csum_bytes_left;
-
 	/*
 	 * the end of the ordered extent which is behind it but
 	 * didn't update disk_i_size. Please see the comment of
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c5b8ba3..6989b42 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3734,12 +3734,6 @@ static int wait_ordered_extents(struct btrfs_trans_handle *trans,
 				     &ordered->flags))
 			continue;
 
-		if (ordered->csum_bytes_left) {
-			btrfs_start_ordered_extent(inode, ordered, 0);
-			wait_event(ordered->wait,
-				   ordered->csum_bytes_left == 0);
-		}
-
 		list_for_each_entry(sum, &ordered->list, list) {
 			ret = btrfs_csum_file_blocks(trans, log, sum);
 			if (ret)
-- 
2.1.0

