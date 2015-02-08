Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40822 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828AbbBIH6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:58:35 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 17/24] Btrfs: sysfs: make btrfs_sysfs_add_fsid() non static
Date: Mon,  9 Feb 2015 07:56:18 +0800
Message-Id: <1423439785-10260-18-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 2 +-
 fs/btrfs/sysfs.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4c86e62..2dbb064 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -727,7 +727,7 @@ u64 btrfs_debugfs_test;
  * Can be called by the device discovery thread.
  * And parent can be specified for seed device
  */
-static int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
+int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 				struct kobject *parent)
 {
 	int error;
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 3938ac1..aaff124 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -74,4 +74,6 @@ int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device);
 int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
                 struct btrfs_device *one_device);
+int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
+				struct kobject *parent);
 #endif /* _BTRFS_SYSFS_H_ */
-- 
2.0.0.153.g79dcccc

