Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36068 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbcEJOJq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:09:46 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 08/13] btrfs: support btrfs dev scan for spare device
Date: Tue, 10 May 2016 22:09:27 +0800
Message-Id: <1462889372-5274-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

When the user or system calls the BTRFS_IOC_SCAN_DEV,
ioctl this patch will make sure it is added to the device
list and set it as spare.

This operation will be same when BTRFS_IOC_DEVICES_READY
as well since BTRFS_IOC_DEVICES_READY ioctl has been doing
that by legacy.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Tested-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
 fs/btrfs/volumes.c | 4 ++++
 fs/btrfs/volumes.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cf0d65dd443b..fdbad75506df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -605,6 +605,10 @@ static noinline int device_list_add(const char *path,
 		if (IS_ERR(fs_devices))
 			return PTR_ERR(fs_devices);
 
+		if (btrfs_super_incompat_flags(disk_super) &
+				BTRFS_FEATURE_INCOMPAT_SPARE_DEV)
+			fs_devices->spare = 1;
+
 		list_add(&fs_devices->list, &fs_uuids);
 
 		device = NULL;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 101e5db2dd63..65a1d8a45c2d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -263,6 +263,8 @@ struct btrfs_fs_devices {
 	struct kobject fsid_kobj;
 	struct kobject *device_dir_kobj;
 	struct completion kobj_unregister;
+
+	int spare;
 };
 
 #define BTRFS_BIO_INLINE_CSUM_SIZE	64
-- 
2.7.0

