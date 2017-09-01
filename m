Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36700 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdIAXQS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 19:16:18 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v81NGGGq006103
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v81NGG2r008011
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:16 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v81NGFh9023427
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: protect conditions within root->log_mutex while waiting
Date: Fri,  1 Sep 2017 16:14:30 -0600
Message-Id: <20170901221430.10131-5-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both wait_for_commit() and wait_for_writer() are checking the
condition out of the mutex lock.

This refactors code a bit to be lock safe.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-log.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3a11ae6..434dcd5 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2701,34 +2701,36 @@ static void wait_log_commit(struct btrfs_root *root, int transid)
 	 * so we know that if ours is more than 2 older than the
 	 * current transaction, we're done
 	 */
-	do {
+	for (;;) {
 		prepare_to_wait(&root->log_commit_wait[index],
 				&wait, TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&root->log_mutex);
 
-		if (root->log_transid_committed < transid &&
-		    atomic_read(&root->log_commit[index]))
-			schedule();
+		if (!(root->log_transid_committed < transid &&
+		      atomic_read(&root->log_commit[index])))
+			break;
 
-		finish_wait(&root->log_commit_wait[index], &wait);
+		mutex_unlock(&root->log_mutex);
+		schedule();
 		mutex_lock(&root->log_mutex);
-	} while (root->log_transid_committed < transid &&
-		 atomic_read(&root->log_commit[index]));
+	}
+	finish_wait(&root->log_commit_wait[index], &wait);
 }
 
 static void wait_for_writer(struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
 
-	while (atomic_read(&root->log_writers)) {
-		prepare_to_wait(&root->log_writer_wait,
-				&wait, TASK_UNINTERRUPTIBLE);
+	for (;;) {
+		prepare_to_wait(&root->log_writer_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (!atomic_read(&root->log_writers))
+			break;
+
 		mutex_unlock(&root->log_mutex);
-		if (atomic_read(&root->log_writers))
-			schedule();
-		finish_wait(&root->log_writer_wait, &wait);
+		schedule();
 		mutex_lock(&root->log_mutex);
 	}
+	finish_wait(&root->log_writer_wait, &wait);
 }
 
 static inline void btrfs_remove_log_ctx(struct btrfs_root *root,
-- 
2.9.4

