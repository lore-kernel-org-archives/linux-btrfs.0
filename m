Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49343 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754698AbdGNRgo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 13:36:44 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8DD27AB1E
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 17:36:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/5] btrfs: factor reading progress out of btrfs_dev_replace_status
Date: Fri, 14 Jul 2017 19:35:25 +0200
Message-Id: <0a4f491b4ee37baba237ebe72123213019a97e87.1500053599.git.dsterba@suse.com>
In-Reply-To: <cover.1500053599.git.dsterba@suse.com>
References: <cover.1500053599.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We'll want to read the percentage value from dev_replace elsewhere, move
the logic to a separate helper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index bee3edeea7a3..31d01eefecd0 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -639,11 +639,39 @@ static void btrfs_dev_replace_update_device_in_mapping_tree(
 	write_unlock(&em_tree->lock);
 }
 
+/*
+ * Read progress of device replace status according to the state and last
+ * stored position. The value format is the same as for
+ * btrfs_dev_replace::progress_1000
+ */
+static u64 btrfs_dev_replace_progress(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	u64 ret = 0;
+
+	switch (dev_replace->replace_state) {
+	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
+	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
+		ret = 0;
+		break;
+	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
+		ret = 1000;
+		break;
+	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
+	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
+		ret = div64_u64(dev_replace->cursor_left,
+				div_u64(btrfs_device_get_total_bytes(
+						dev_replace->srcdev), 1000));
+		break;
+	}
+
+	return ret;
+}
+
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args)
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
-	struct btrfs_device *srcdev;
 
 	btrfs_dev_replace_lock(dev_replace, 0);
 	/* even if !dev_replace_is_valid, the values are good enough for
@@ -656,21 +684,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 		atomic64_read(&dev_replace->num_write_errors);
 	args->status.num_uncorrectable_read_errors =
 		atomic64_read(&dev_replace->num_uncorrectable_read_errors);
-	switch (dev_replace->replace_state) {
-	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
-	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
-		args->status.progress_1000 = 0;
-		break;
-	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
-		args->status.progress_1000 = 1000;
-		break;
-	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
-	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
-		srcdev = dev_replace->srcdev;
-		args->status.progress_1000 = div64_u64(dev_replace->cursor_left,
-			div_u64(btrfs_device_get_total_bytes(srcdev), 1000));
-		break;
-	}
+	args->status.progress_1000 = btrfs_dev_replace_progress(fs_info);
 	btrfs_dev_replace_unlock(dev_replace, 0);
 }
 
-- 
2.13.0

