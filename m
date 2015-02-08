Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46091 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795AbbBIH6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:58:30 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 14/24] Btrfs: sysfs: provide framework to remove all fsid kobject
Date: Mon,  9 Feb 2015 07:56:15 +0800
Message-Id: <1423439785-10260-15-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4b5bac6..83d7535 100644
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
 	fs_info->fs_devices->fs_info = NULL;
-- 
2.0.0.153.g79dcccc

