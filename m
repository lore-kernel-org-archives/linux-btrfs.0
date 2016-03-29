Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46738 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbcC2OXB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:23:01 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 11/12] btrfs: introduce helper functions to perform hot replace
Date: Tue, 29 Mar 2016 22:22:28 +0800
Message-Id: <1459261349-32206-12-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hot replace / auto replace is important volume manager feature
and is critical to the data center operations, so that the degraded
volume can be brought back to a healthy state at the earliest and
without manual intervention.

This modifies the existing replace code to suite the need of auto
replace, in the long run I hope both the codes to be merged.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 24 ++++++++++++++++++++++++
 fs/btrfs/dev-replace.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 2b926867d136..d6b768cf121f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -957,3 +957,27 @@ void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
 				     &fs_info->fs_state));
 	}
 }
+
+int btrfs_auto_replace_start(struct btrfs_root *root,
+				struct btrfs_device *src_device)
+{
+	int ret;
+	char *tgt_path;
+
+	if (btrfs_get_spare_device(&tgt_path)) {
+		btrfs_err(root->fs_info,
+			"No spare device found/configured in the kernel");
+		return -EINVAL;
+	}
+
+	ret = btrfs_dev_replace_start(root, tgt_path,
+					src_device->devid,
+					rcu_str_deref(src_device->name),
+		BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID);
+	if (ret)
+		btrfs_put_spare_device(tgt_path);
+
+	kfree(tgt_path);
+
+	return 0;
+}
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index e922b42d91df..b918b9d6e5df 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -46,4 +46,5 @@ static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
 {
 	atomic64_inc(stat_value);
 }
+int btrfs_auto_replace_start(struct btrfs_root *root, struct btrfs_device *src_device);
 #endif
-- 
2.7.0

