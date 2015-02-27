Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14543 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755197AbbB0IYf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:24:35 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8NeSZ019776
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:23:41 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/7] btrfs: Update btrfs qgroup status item when rescan is done.
Date: Fri, 27 Feb 2015 16:24:25 +0800
Message-ID: <1425025468-29749-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update qgroup status when rescan is done.

Before this patch, status item is not updated on rescan finish, which
causing the RESCAN and INCONSISTENT flags never cleared.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a48a590..20fe219 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2623,6 +2623,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	struct ulist *tmp = NULL, *qgroups = NULL;
 	struct extent_buffer *scratch_leaf = NULL;
 	int err = -ENOMEM;
+	int ret = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2673,6 +2674,28 @@ out:
 	}
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
+	/*
+	 * only update status, since the previous part has alreay updated the
+	 * qgroup info.
+	 */
+	trans = btrfs_start_transaction(fs_info->quota_root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		btrfs_err(fs_info,
+			  "fail to start transaction for status update: %d\n",
+			  err);
+		goto done;
+	}
+	ret = update_qgroup_status_item(trans, fs_info, fs_info->quota_root);
+	if (ret < 0) {
+		err = ret;
+		btrfs_err(fs_info, "fail to update qgroup status: %d\n",
+			  err);
+		btrfs_abort_transaction(trans, fs_info->quota_root, err);
+		goto done;
+	}
+	btrfs_end_transaction(trans, fs_info->quota_root);
+
 	if (err >= 0) {
 		btrfs_info(fs_info, "qgroup scan completed%s",
 			err > 0 ? " (inconsistency flag cleared)" : "");
@@ -2680,6 +2703,7 @@ out:
 		btrfs_err(fs_info, "qgroup scan failed with %d", err);
 	}
 
+done:
 	complete_all(&fs_info->qgroup_rescan_completion);
 }
 
@@ -2714,7 +2738,6 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 			mutex_unlock(&fs_info->qgroup_rescan_lock);
 			goto err;
 		}
-
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 	}
 
-- 
2.3.0

