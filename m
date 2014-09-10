Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48384 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaIJE7A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 00:59:00 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s8A4wxaP032533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 04:59:00 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8A4wwIH006220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 04:58:59 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8A4wwnS018465
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 04:58:58 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix loop writing of async reclaim
Date: Wed, 10 Sep 2014 12:58:50 +0800
Message-Id: <1410325130-12665-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of my tests shows that when we really don't have space to reclaim via
flush_space and also run out of space, this async reclaim work loops on adding
itself into the workqueue and keeps writing something to disk according to
iostat's results, and these writes mainly comes from commit_transaction which
writes super_block.  This's unacceptable as it can be bad to disks, especially
memeory storages.

This adds a check to avoid the above situation.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3efe1c3..e33efbf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4343,11 +4343,21 @@ static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
 }
 
 static int btrfs_need_do_async_reclaim(struct btrfs_space_info *space_info,
-				       struct btrfs_fs_info *fs_info)
+				       struct btrfs_fs_info *fs_info,
+				       int flush_state)
 {
 	u64 used;
 
 	spin_lock(&space_info->lock);
+	/*
+	 * We run out of space and have not got any free space via flush_space,
+	 * so don't bother doing async reclaim.
+	 */
+	if (flush_state > COMMIT_TRANS && space_info->full) {
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+
 	used = space_info->bytes_used + space_info->bytes_reserved +
 	       space_info->bytes_pinned + space_info->bytes_readonly +
 	       space_info->bytes_may_use;
@@ -4380,11 +4390,12 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		flush_space(fs_info->fs_root, space_info, to_reclaim,
 			    to_reclaim, flush_state);
 		flush_state++;
-		if (!btrfs_need_do_async_reclaim(space_info, fs_info))
+		if (!btrfs_need_do_async_reclaim(space_info, fs_info,
+						 flush_state))
 			return;
 	} while (flush_state <= COMMIT_TRANS);
 
-	if (btrfs_need_do_async_reclaim(space_info, fs_info))
+	if (btrfs_need_do_async_reclaim(space_info, fs_info, flush_state))
 		queue_work(system_unbound_wq, work);
 }
 
-- 
1.8.1.4

