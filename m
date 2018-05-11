Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44585 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbeEKFfc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 01:35:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 55793AD4D
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 05:35:31 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] btrfs: Refactor btrfs_check_super_valid()
Date: Fri, 11 May 2018 13:35:26 +0800
Message-Id: <20180511053527.28378-3-wqu@suse.com>
In-Reply-To: <20180511053527.28378-1-wqu@suse.com>
References: <20180511053527.28378-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Refactor btrfs_check_super_valid() by the ways:

1) Rename it to btrfs_validate_mount_super()
   Now it's more obvious when the function should be called.

2) Extract core check routine into __validate_super()
   So later write time check can reuse it, and if needed, we could also
   use __validate_super() to check each super block.

3) Add more comment about btrfs_validate_mount_super()
   Mostly of what it doesn't check and when it should be called.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 13c5f90995aa..b981ecc4b6f9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2440,9 +2440,19 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
+/*
+ * Real super block validation check
+ * NOTE: super csum type and incompat features will not be checked here.
+ *
+ * @sb:		super block to check
+ * @mirror_num:	the super block number to check its bytenr:
+ * 		0 means the primary (1st) sb,
+ * 		1 and 2 means 2nd and 3rd backup copy
+ * 		-1 means to skip bytenr check
+ */
+static int __validate_super(struct btrfs_fs_info *fs_info,
+			    struct btrfs_super_block *sb, int mirror_num)
 {
-	struct btrfs_super_block *sb = fs_info->super_copy;
 	u64 nodesize = btrfs_super_nodesize(sb);
 	u64 sectorsize = btrfs_super_sectorsize(sb);
 	int ret = 0;
@@ -2545,7 +2555,8 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 		ret = -EINVAL;
 	}
 
-	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
+	if (mirror_num >= 0 &&
+	    btrfs_super_bytenr(sb) != btrfs_sb_offset(mirror_num)) {
 		btrfs_err(fs_info, "super offset mismatch %llu != %u",
 			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
 		ret = -EINVAL;
@@ -2589,6 +2600,16 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * Check the validation of super block at mount time.
+ * Some checks already done by early mount, like csum type and incompat flags
+ * will be skipped.
+ */
+static int btrfs_validate_mount_super(struct btrfs_fs_info *fs_info)
+{
+	return __validate_super(fs_info, fs_info->super_copy, 0);
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2814,7 +2835,7 @@ int open_ctree(struct super_block *sb,
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_super_valid(fs_info);
+	ret = btrfs_validate_mount_super(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "superblock contains fatal errors");
 		err = -EINVAL;
-- 
2.17.0

