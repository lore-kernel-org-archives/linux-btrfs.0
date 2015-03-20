Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36554 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbbCTKE3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:29 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 18/27] Btrfs: sysfs: make btrfs_sysfs_add_fsid() non static
Date: Fri, 20 Mar 2015 18:01:33 +0800
Message-Id: <1426845702-6298-19-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 2 +-
 fs/btrfs/sysfs.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 5055809..42ed7a7 100644
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

