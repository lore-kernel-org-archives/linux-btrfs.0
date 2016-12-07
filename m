Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43340 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932887AbcLGVhg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 16:37:36 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/6] Btrfs: set single device limit for dax usecase
Date: Wed,  7 Dec 2016 13:45:06 -0800
Message-Id: <1481147110-20048-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dax on btrfs is not ready for multiple device.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 6 ++++++
 fs/btrfs/super.c | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7acbd2c..ab30d88 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2663,6 +2663,12 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (btrfs_test_opt(root->fs_info, DAX)) {
+		btrfs_info(root->fs_info,
+			   "dax doesn't support multiple devices\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
 		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9b18f3d..8cb94ab 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -475,6 +475,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 #ifdef CONFIG_FS_DAX
 		case Opt_dax:
 			btrfs_set_and_info(info, DAX, "setting dax");
+			if (btrfs_super_num_devices(info->super_copy) > 1) {
+				btrfs_info(info,
+					  "dax doesn't support multiple devices(%llu)\n",
+					   btrfs_super_num_devices(info->super_copy));
+				ret = -EOPNOTSUPP;
+				goto out;
+			}
 			/*
 			 * sb->s_blocksize is set to root->sectorsize
 			 * sb->s_bdev is required, but btrfs doesn't set it
-- 
2.5.5

