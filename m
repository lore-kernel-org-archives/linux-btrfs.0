Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835AbbBIH6j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:58:39 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 19/24] Btrfs: sysfs: btrfs_sysfs_remove_fsid() make it non static
Date: Mon,  9 Feb 2015 07:56:20 +0800
Message-Id: <1423439785-10260-20-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 2 +-
 fs/btrfs/sysfs.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 2dbb064..ff9e5f6 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -529,7 +529,7 @@ static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 }
 
 /* when fs_devs is NULL it will remove all fsid kobject */
-static void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
+void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 {
 	struct list_head *fs_uuids = btrfs_get_fs_uuids();
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index ac06b5c..2b31f6f 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -77,4 +77,5 @@ int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 				struct kobject *parent);
 int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
+void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
 #endif /* _BTRFS_SYSFS_H_ */
-- 
2.0.0.153.g79dcccc

