Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51324 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbBAIDJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 03:03:09 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 08/12] Btrfs: sysfs: introduce function btrfs_sysfs_add_fsid() to create sysfs fsid
Date: Sun,  1 Feb 2015 16:01:38 +0800
Message-Id: <1422777702-12584-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
 <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need it in a seperate function so that it can be called from the
device discovery thread as well.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c923e8b..f42d8fd 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -690,7 +690,12 @@ static struct dentry *btrfs_debugfs_root_dentry;
 /* Debugging tunables and exported data */
 u64 btrfs_debugfs_test;
 
-int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
+/*
+ * Can be called by the device discovery thread.
+ * And parent can be specified for seed device
+ */
+int btrfs_sysfs_add_fsid(struct btrfs_fs_info *fs_info,
+				struct kobject *parent)
 {
 	int error;
 
@@ -698,6 +703,14 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	fs_info->super_kobj.kset = btrfs_kset;
 	error = kobject_init_and_add(&fs_info->super_kobj, &btrfs_ktype, NULL,
 				     "%pU", fs_info->fsid);
+	return error;
+}
+
+int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
+{
+	int error;
+
+	error = btrfs_sysfs_add_fsid(fs_info, NULL);
 	if (error)
 		return error;
 
-- 
1.9.1

