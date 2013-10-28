Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53436 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3J1TFE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 15:05:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6BCBB7C0056
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 13:05:04 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id QAyp6UGGdsj757YU (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 13:05:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make sure the delalloc workers actually flush compressed writes
Date: Mon, 28 Oct 2013 15:05:01 -0400
Message-ID: <1382987101-1290-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using delalloc workers in a non-waiting way (like for enospc handling) we
can end up not actually waiting for the dirty pages to be started if we have
compression.  We need to add an extra filemap flush to make sure any async
extents that have started are actually moved along before returning.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a239de0..0c7212a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8181,18 +8181,24 @@ out_notrans:
 static void btrfs_run_delalloc_work(struct btrfs_work *work)
 {
 	struct btrfs_delalloc_work *delalloc_work;
+	struct inode *inode;
 
 	delalloc_work = container_of(work, struct btrfs_delalloc_work,
 				     work);
-	if (delalloc_work->wait)
-		btrfs_wait_ordered_range(delalloc_work->inode, 0, (u64)-1);
-	else
-		filemap_flush(delalloc_work->inode->i_mapping);
+	inode = delalloc_work->inode;
+	if (delalloc_work->wait) {
+		btrfs_wait_ordered_range(inode, 0, (u64)-1);
+	} else {
+		filemap_flush(inode->i_mapping);
+		if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+			     &BTRFS_I(inode)->runtime_flags))
+			filemap_flush(inode->i_mapping);
+	}
 
 	if (delalloc_work->delay_iput)
-		btrfs_add_delayed_iput(delalloc_work->inode);
+		btrfs_add_delayed_iput(inode);
 	else
-		iput(delalloc_work->inode);
+		iput(inode);
 	complete(&delalloc_work->completion);
 }
 
-- 
1.8.3.1

