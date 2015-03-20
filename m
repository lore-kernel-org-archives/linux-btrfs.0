Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36519 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbbCTKEY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:24 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 15/27] Btrfs: sysfs: provide framework to remove all fsid sysfs kobject
Date: Fri, 20 Mar 2015 18:01:30 +0800
Message-Id: <1426845702-6298-16-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

just a helper function to clean up the sysfs fsid kobjects

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 95d6257..a8ee136 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -515,7 +515,7 @@ static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
 	return 0;
 }
 
-static void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
+static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 {
 	if (fs_devs->device_dir_kobj) {
 		kobject_del(fs_devs->device_dir_kobj);
@@ -528,6 +528,21 @@ static void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 	wait_for_completion(&fs_devs->kobj_unregister);
 }
 
+/* when fs_devs is NULL it will remove all fsid kobject */
+static void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
+{
+	struct list_head *fs_uuids = btrfs_get_fs_uuids();
+
+	if (fs_devs) {
+		__btrfs_sysfs_remove_fsid(fs_devs);
+		return;
+	}
+
+	list_for_each_entry(fs_devs, fs_uuids, list) {
+		__btrfs_sysfs_remove_fsid(fs_devs);
+	}
+}
+
 void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 {
 	btrfs_reset_fs_info_ptr(fs_info);
-- 
2.0.0.153.g79dcccc

