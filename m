Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40295 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbbDMTXB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 15:23:01 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t3DJIjXe025749
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:23:00 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1trk9x84we-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:23:00 -0700
Received: from facebook.com (2401:db00:20:702c:face:0:2f:0)	by
 mx-out.facebook.com (10.212.236.87) with ESMTP	id
 7e2d4b24e21211e4b36c0002c9521c9e-cbbf72c0 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Apr 2015 12:22:58 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] Btrfs: don't commit the transaction in the async space flushing
Date: Mon, 13 Apr 2015 12:22:51 -0700
Message-ID: <1428952972-1266934-5-git-send-email-clm@fb.com>
In-Reply-To: <1428952972-1266934-1-git-send-email-clm@fb.com>
References: <1428952972-1266934-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We're triggering a huge number of commits from
btrfs_async_reclaim_metadata_space.  These aren't really requried,
because everyone calling the async reclaim code is going to end up
triggering a commit on their own.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/extent-tree.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ae8db3ba..3d4b3d680 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4329,8 +4329,13 @@ out:
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
 
@@ -4385,10 +4390,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
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
1.8.1

