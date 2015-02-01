Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbBAIDI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 03:03:08 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 07/12] Btrfs: sysfs: rename __btrfs_sysfs_remove_one to btrfs_sysfs_remove_fsid
Date: Sun,  1 Feb 2015 16:01:37 +0800
Message-Id: <1422777702-12584-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
 <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c3e7f06..c923e8b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -508,7 +508,7 @@ static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
 	return 0;
 }
 
-static void __btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
+static void btrfs_sysfs_remove_fsid(struct btrfs_fs_info *fs_info)
 {
 	if (fs_info->device_dir_kobj) {
 		btrfs_kobj_rm_device(fs_info, NULL);
@@ -531,7 +531,7 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 	}
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
-	__btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_fsid(fs_info);
 }
 
 const char * const btrfs_feature_set_names[3] = {
@@ -703,14 +703,14 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 
 	error = btrfs_kobj_add_device(fs_info, NULL);
 	if (error) {
-		__btrfs_sysfs_remove_one(fs_info);
+		btrfs_sysfs_remove_fsid(fs_info);
 		return error;
 	}
 
 	error = sysfs_create_group(&fs_info->super_kobj,
 				   &btrfs_feature_attr_group);
 	if (error) {
-		__btrfs_sysfs_remove_one(fs_info);
+		btrfs_sysfs_remove_fsid(fs_info);
 		return error;
 	}
 
-- 
1.9.1

