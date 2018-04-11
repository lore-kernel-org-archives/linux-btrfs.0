Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751798AbeDKIVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 04:21:25 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6368AAF54
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 08:21:24 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/4] btrfs: Use while loop instead of labels in __endio_write_update_ordered
Date: Wed, 11 Apr 2018 11:21:17 +0300
Message-Id: <1523434880-7799-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1523434880-7799-1-git-send-email-nborisov@suse.com>
References: <1523434880-7799-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently __endio_write_update_ordered uses labels to implement
what is essentially a simple while loop. This makes the code more
cumbersome to follow than it actually has to be. No functional
changes. No xfstest regressions were found during testing.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 52 +++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ddaed8369874..16f688a4b92d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8159,7 +8159,6 @@ static void __endio_write_update_ordered(struct inode *inode,
 	u64 ordered_offset = offset;
 	u64 ordered_bytes = bytes;
 	u64 last_offset;
-	int ret;
 
 	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
 		wq = fs_info->endio_freespace_worker;
@@ -8169,32 +8168,31 @@ static void __endio_write_update_ordered(struct inode *inode,
 		func = btrfs_endio_write_helper;
 	}
 
-again:
-	last_offset = ordered_offset;
-	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
-						   &ordered_offset,
-						   ordered_bytes,
-						   uptodate);
-	if (!ret)
-		goto out_test;
-
-	btrfs_init_work(&ordered->work, func, finish_ordered_fn, NULL, NULL);
-	btrfs_queue_work(wq, &ordered->work);
-out_test:
-	/*
-	 * If btrfs_dec_test_ordered_pending does not find any ordered extent
-	 * in the range, we can exit.
-	 */
-	if (ordered_offset == last_offset)
-		return;
-	/*
-	 * our bio might span multiple ordered extents.  If we haven't
-	 * completed the accounting for the whole dio, go back and try again
-	 */
-	if (ordered_offset < offset + bytes) {
-		ordered_bytes = offset + bytes - ordered_offset;
-		ordered = NULL;
-		goto again;
+	while (ordered_offset < offset + bytes) {
+		last_offset = ordered_offset;
+		if (btrfs_dec_test_first_ordered_pending(inode, &ordered,
+							   &ordered_offset,
+							   ordered_bytes,
+							   uptodate)) {
+			btrfs_init_work(&ordered->work, func,
+					finish_ordered_fn,
+					NULL, NULL);
+			btrfs_queue_work(wq, &ordered->work);
+		}
+		/*
+		 * If btrfs_dec_test_ordered_pending does not find any ordered
+		 * extent in the range, we can exit.
+		 */
+		if (ordered_offset == last_offset)
+			return;
+		/*
+		 * Our bio might span multiple ordered extents. In this case
+		 * we keep goin until we have accounted the whole dio.
+		 */
+		if (ordered_offset < offset + bytes) {
+			ordered_bytes = offset + bytes - ordered_offset;
+			ordered = NULL;
+		}
 	}
 }
 
-- 
2.7.4

