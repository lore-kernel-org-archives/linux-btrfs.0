Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32006 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbbKIK5u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:50 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvnYa015166
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avn0K004942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:49 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvniD003544
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:49 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/15] btrfs: introduce helper functions to perform hot replace
Date: Mon,  9 Nov 2015 18:56:28 +0800
Message-Id: <1447066589-3835-15-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
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
 fs/btrfs/dev-replace.c | 116 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dev-replace.h |   1 +
 2 files changed, 117 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 02df419..3294b33 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -914,3 +914,119 @@ void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
 				     &fs_info->fs_state));
 	}
 }
+
+int btrfs_dev_replace_start_v2(struct btrfs_root *root, char *tgt_path,
+					struct btrfs_device *src_device)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	int ret;
+	struct btrfs_device *tgt_device = NULL;
+
+	/*
+	 * proceure here is the same as in the replace triggered from the
+	 * user land, some day we could merg this with it
+	 */
+	WARN_ON(!src_device);
+	mutex_lock(&fs_info->volume_mutex);
+	ret = btrfs_init_dev_replace_tgtdev(root, tgt_path,
+					    src_device, &tgt_device);
+	mutex_unlock(&fs_info->volume_mutex);
+	if (ret)
+		return ret;
+	WARN_ON(!tgt_device);
+
+	trans = btrfs_attach_transaction(root);
+	if (!IS_ERR(trans)) {
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret)
+			return ret;
+	} else if (PTR_ERR(trans) != -ENOENT) {
+		return PTR_ERR(trans);
+	}
+
+	btrfs_dev_replace_lock(dev_replace);
+	if (dev_replace->replace_state ==
+		BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED ||
+		dev_replace->replace_state ==
+		BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED)
+		goto leave;
+
+	dev_replace->cont_reading_from_srcdev_mode =
+		BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID;
+	dev_replace->srcdev = src_device;
+	dev_replace->tgtdev = tgt_device;
+
+	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED;
+	dev_replace->time_started = get_seconds();
+	dev_replace->cursor_left = 0;
+	dev_replace->committed_cursor_left = 0;
+	dev_replace->cursor_left_last_write_of_item = 0;
+	dev_replace->cursor_right = 0;
+	dev_replace->is_valid = 1;
+	dev_replace->item_needs_writeback = 1;
+
+	printk_in_rcu(KERN_INFO
+		"BTRFS: auto replace from %s (devid %llu) to %s started\n",
+		rcu_str_deref(src_device->name),
+		src_device->devid,
+		rcu_str_deref(tgt_device->name));
+
+	btrfs_dev_replace_unlock(dev_replace);
+
+	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device, 0);
+	if (ret)
+		btrfs_err(fs_info, "kobj add dev failed %d\n", ret);
+
+	btrfs_wait_ordered_roots(fs_info, -1);
+
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		btrfs_dev_replace_lock(dev_replace);
+		goto leave;
+	}
+	ret = btrfs_commit_transaction(trans, root);
+	WARN_ON(ret);
+
+	ret = btrfs_scrub_dev(fs_info, src_device->devid, 0,
+			      btrfs_device_get_total_bytes(src_device),
+			      &dev_replace->scrub_progress, 0, 1);
+
+	ret = btrfs_dev_replace_finishing(fs_info, ret);
+	if (ret == -EINPROGRESS)
+		ret = 0;
+	else
+		WARN_ON(ret);
+
+	return ret;
+
+leave:
+	dev_replace->srcdev = NULL;
+	dev_replace->tgtdev = NULL;
+	btrfs_dev_replace_unlock(dev_replace);
+	btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
+	return ret;
+}
+
+int btrfs_auto_replace_start(struct btrfs_root *root,
+				struct btrfs_device *src_device)
+{
+	char *tgt_path;
+	int ret;
+
+	if (btrfs_get_spare_device(&tgt_path)) {
+		btrfs_err(root->fs_info,
+			"No spare device found/configured in the kernel");
+		return -EINVAL;
+	}
+
+	ret = btrfs_dev_replace_start_v2(root, tgt_path, src_device);
+	if (ret)
+		btrfs_put_spare_device(tgt_path);
+
+	kfree(tgt_path);
+
+	return 0;
+}
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 20035cb..2ead9a6 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -41,4 +41,5 @@ static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
 {
 	atomic64_inc(stat_value);
 }
+int btrfs_auto_replace_start(struct btrfs_root *root, struct btrfs_device *src_device);
 #endif
-- 
2.4.1

