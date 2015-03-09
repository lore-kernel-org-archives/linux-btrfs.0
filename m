Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20616 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbbCIRKa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:10:30 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 05/26] Btrfc: sysfs: fix, check if device_dir_kobj is init before destroy
Date: Tue, 10 Mar 2015 06:38:23 +0800
Message-Id: <1425940724-7744-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Since the failure code in the btrfs_sysfs_add_one() can
call btrfs_sysfs_remove_one() even before device_dir_kobj
has been created we need to check if its null.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 15fead2..506f7e4 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -522,10 +522,12 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 		kobject_del(fs_info->space_info_kobj);
 		kobject_put(fs_info->space_info_kobj);
 	}
-	btrfs_kobj_rm_device(fs_info, NULL);
-	kobject_del(fs_info->device_dir_kobj);
-	kobject_put(fs_info->device_dir_kobj);
-	fs_info->device_dir_kobj = NULL;
+	if (fs_info->device_dir_kobj) {
+		btrfs_kobj_rm_device(fs_info, NULL);
+		kobject_del(fs_info->device_dir_kobj);
+		kobject_put(fs_info->device_dir_kobj);
+		fs_info->device_dir_kobj = NULL;
+	}
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
 	__btrfs_sysfs_remove_one(fs_info);
-- 
2.0.0.153.g79dcccc

