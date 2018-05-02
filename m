Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49873 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbeEBF2U (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 2 May 2018 01:28:20 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: More meaningful qgroup_rescan_init error message
Date: Wed,  2 May 2018 13:28:03 +0800
Message-Id: <20180502052803.4222-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Error message from qgroup_rescan_init() mostly looks like:

------
BTRFS info (device nvme0n1p1): qgroup_rescan_init failed with -115
------

Which is far from meaningful, and sometimes confusing as for above
-EINPROGRESS it's mostly (despite the init race) harmless, but sometimes
it can also indicates problem if return value is -EINVAL.

Change it to some more meaningful messages like:

------
BTRFS info (device nvme0n1p1): qgroup rescan is already in progress
------

And

------
BTRFS err(device nvme0n1p1): qgroup_rescan_init failed, qgroup is not enabled
------

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ec2339a49ec3..a5742e9e9a14 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2760,26 +2760,37 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 {
 	int ret = 0;
 
-	if (!init_flags &&
-	    (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) ||
-	     !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))) {
-		ret = -EINVAL;
-		goto err;
+	if (!init_flags) {
+		/* we're resuming qgroup rescan at mount time */
+		if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN))
+			btrfs_err(fs_info, "%s failed, qgroup is not enabled",
+				  __func__);
+		else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
+			btrfs_err(fs_info,
+				  "%s failed, qgroup rescan is not queued",
+				  __func__);
+		return -EINVAL;
 	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 	spin_lock(&fs_info->qgroup_lock);
 
 	if (init_flags) {
-		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
+		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+			btrfs_info(fs_info,
+				   "qgroup rescan is already in progress");
 			ret = -EINPROGRESS;
-		else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
+		} else if (!(fs_info->qgroup_flags &
+			     BTRFS_QGROUP_STATUS_FLAG_ON)) {
+			btrfs_err(fs_info, "%s failed, qgroup is not enabled",
+				  __func__);
 			ret = -EINVAL;
+		}
 
 		if (ret) {
 			spin_unlock(&fs_info->qgroup_lock);
 			mutex_unlock(&fs_info->qgroup_rescan_lock);
-			goto err;
+			return ret;
 		}
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 	}
@@ -2798,13 +2809,6 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 	btrfs_init_work(&fs_info->qgroup_rescan_work,
 			btrfs_qgroup_rescan_helper,
 			btrfs_qgroup_rescan_worker, NULL, NULL);
-
-	if (ret) {
-err:
-		btrfs_info(fs_info, "qgroup_rescan_init failed with %d", ret);
-		return ret;
-	}
-
 	return 0;
 }
 
-- 
2.17.0

