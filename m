Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28413 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbcEJOCA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:02:00 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 1/1] btrfs: introduce helper functions to perform hot replace
Date: Tue, 10 May 2016 22:01:39 +0800
Message-Id: <1462888911-5227-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
References: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Hot replace / auto replace is important volume manager feature
and is critical to the data center operations, so that the degraded
volume can be brought back to a healthy state at the earliest and
without manual intervention.

This modifies the existing replace code to suite the need of auto
replace, in the long run I hope both the codes to be merged.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
 fs/btrfs/dev-replace.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dev-replace.h |  1 +
 2 files changed, 44 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 5ec7fa860391..83af64907547 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -937,3 +937,46 @@ void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
 				     &fs_info->fs_state));
 	}
 }
+
+int btrfs_auto_replace_start(struct btrfs_root *root, u64 src_devid)
+{
+	int ret;
+	char *tgt_path;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	if (!src_devid)
+		return -EINVAL;
+
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
+		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+		return -EBUSY;
+	}
+	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+
+	if (btrfs_get_spare_device(&tgt_path)) {
+		btrfs_info_rl(root->fs_info,
+			"No spare device found/configured in the kernel");
+		return -EINVAL;
+	}
+
+	if (atomic_xchg(
+		&root->fs_info->mutually_exclusive_operation_running, 1)) {
+		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
+	} else {
+		ret = btrfs_dev_replace_start(root, tgt_path, src_devid, NULL,
+		BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS);
+		atomic_set(
+			&root->fs_info->mutually_exclusive_operation_running, 0);
+	}
+
+	if (ret)
+		btrfs_put_spare_device(tgt_path);
+
+	kfree(tgt_path);
+
+	return ret;
+}
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index e922b42d91df..54b0812c8ba4 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -46,4 +46,5 @@ static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
 {
 	atomic64_inc(stat_value);
 }
+int btrfs_auto_replace_start(struct btrfs_root *root, u64 src_devid);
 #endif
-- 
2.7.0

