Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36699 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752571AbdIAXQS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 19:16:18 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v81NGGaA006100
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v81NGFw8001936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:16 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v81NGFjX023420
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use wait_event instead of a single function
Date: Fri,  1 Sep 2017 16:14:29 -0600
Message-Id: <20170901221430.10131-4-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since TASK_UNINTERRUPTIBLE has been used here, wait_event() can do the
same job.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 19e4dec..1c8bdde 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -638,23 +638,6 @@ static noinline int create_subvol(struct inode *dir,
 	return ret;
 }
 
-static void btrfs_wait_for_no_snapshoting_writes(struct btrfs_root *root)
-{
-	s64 writers;
-	DEFINE_WAIT(wait);
-
-	do {
-		prepare_to_wait(&root->subv_writers->wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-
-		writers = percpu_counter_sum(&root->subv_writers->counter);
-		if (writers)
-			schedule();
-
-	} while (writers);
-	finish_wait(&root->subv_writers->wait, &wait);
-}
-
 static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 			   struct dentry *dentry,
 			   u64 *async_transid, bool readonly,
@@ -683,7 +666,9 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 
 	atomic_inc(&root->will_be_snapshoted);
 	smp_mb__after_atomic();
-	btrfs_wait_for_no_snapshoting_writes(root);
+	/* wait for no snapshot writes */
+	wait_event(root->subv_writers->wait,
+		   percpu_counter_sum(&root->subv_writers->counter) == 0);
 
 	ret = btrfs_start_delalloc_inodes(root, 0);
 	if (ret)
-- 
2.9.4

