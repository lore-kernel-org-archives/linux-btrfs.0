Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14800 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756150AbaIRP1U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 11:27:20 -0400
Received: from pps.filterd (m0044008 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8IF5doF006508
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 08:27:20 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1pfbgh2e64-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 08:27:19 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't do async reclaim during log replay V2
Date: Thu, 18 Sep 2014 11:27:17 -0400
Message-ID: <1411054037-20136-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Trying to reproduce a log enospc bug I hit a panic in the async reclaim code
during log replay.  This is because we use fs_info->fs_root as our root for
shrinking and such.  Technically we can use whatever root we want, but let's
just not allow async reclaim while we're doing log replay.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: use fs_info->log_root_recovering instead, didn't notice this existed
before.

 fs/btrfs/extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 28a27d5..44d0497 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4513,7 +4513,13 @@ again:
 		space_info->flush = 1;
 	} else if (!ret && space_info->flags & BTRFS_BLOCK_GROUP_METADATA) {
 		used += orig_bytes;
-		if (need_do_async_reclaim(space_info, root->fs_info, used) &&
+		/*
+		 * We will do the space reservation dance during log replay,
+		 * which means we won't have fs_info->fs_root set, so don't do
+		 * the async reclaim as we will panic.
+		 */
+		if (!root->fs_info->log_root_recovering &&
+		    need_do_async_reclaim(space_info, root->fs_info, used) &&
 		    !work_busy(&root->fs_info->async_reclaim_work))
 			queue_work(system_unbound_wq,
 				   &root->fs_info->async_reclaim_work);
-- 
1.8.3.1

