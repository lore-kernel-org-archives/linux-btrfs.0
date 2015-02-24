Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15720 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750955AbbBXV3t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 16:29:49 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t1OLNpbH004312
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 13:29:48 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1ss15bg0sw-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 13:29:48 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make async space flushing suck less when we're full
Date: Tue, 24 Feb 2015 16:29:45 -0500
Message-ID: <1424813385-25945-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We noticed on our gluster boxes that rm's when very full we'd take forever.
This was because the async flusher thread was committing the transaction over
and over because we had no delalloc, no delayed items and no room to allocate
new block groups.  So fix a few things

1) Don't commit the transaction.  If we need to do it we will do it ourselves.
2) Don't requeue ourselves.  Once we stopped committing the transaction we would
end up burning a CPU by just requeueing ourselves over and over again because we
thought we need to flush more.
3) Don't bother doing async reclaim if we're just full.  If we have 98% of our
space actually used then doing things async really isn't going to be helpful, so
skip it.

This patch made the rm's on our extremely full gluster boxes not take all
eternity.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b2f7cf4..2364c5f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4277,8 +4277,13 @@ out:
 static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
 					struct btrfs_fs_info *fs_info, u64 used)
 {
-	return (used >= div_factor_fine(space_info->total_bytes, 98) &&
-		!btrfs_fs_closing(fs_info) &&
+	u64 thresh = div_factor_fine(space_info->total_bytes, 98);
+
+	/* If we're just plain full then async reclaim just slows us down. */
+	if (space_info->bytes_used >= thresh)
+		return 0;
+
+	return (used >= thresh && !btrfs_fs_closing(fs_info) &&
 		!test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state));
 }
 
@@ -4333,10 +4338,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		if (!btrfs_need_do_async_reclaim(space_info, fs_info,
 						 flush_state))
 			return;
-	} while (flush_state <= COMMIT_TRANS);
-
-	if (btrfs_need_do_async_reclaim(space_info, fs_info, flush_state))
-		queue_work(system_unbound_wq, work);
+	} while (flush_state < COMMIT_TRANS);
 }
 
 void btrfs_init_async_reclaim_work(struct work_struct *work)
-- 
1.8.3.1

