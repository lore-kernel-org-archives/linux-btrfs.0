Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34915 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdKFIgQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 03:36:16 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA68aF1l014350
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aEH4022567
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:14 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA68aEnl010222
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:14 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/7] btrfs: move user provided string checks outside of volume_mutex
Date: Mon,  6 Nov 2017 16:36:13 +0800
Message-Id: <20171106083618.7617-3-anand.jain@oracle.com>
In-Reply-To: <20171106083618.7617-1-anand.jain@oracle.com>
References: <20171106083618.7617-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do string check for the device's new size before volume_mutex is held.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2eb220213d63..b0465020972a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1445,7 +1445,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	u64 new_size;
+	u64 new_size = 0;
 	u64 old_size;
 	u64 devid = 1;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1494,6 +1494,21 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		btrfs_info(fs_info, "resizing devid %llu", devid);
 	}
 
+	if (strcmp(sizestr, "max")) {
+		if (sizestr[0] == '-') {
+			mod = -1;
+			sizestr++;
+		} else if (sizestr[0] == '+') {
+			mod = 1;
+			sizestr++;
+		}
+		new_size = memparse(sizestr, &retptr);
+		if (*retptr != '\0' || new_size == 0) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+	}
+
 	mutex_lock(&fs_info->volume_mutex);
 	device = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!device) {
@@ -1511,28 +1526,14 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		goto out_mutex;
 	}
 
-	if (!strcmp(sizestr, "max"))
-		new_size = device->bdev->bd_inode->i_size;
-	else {
-		if (sizestr[0] == '-') {
-			mod = -1;
-			sizestr++;
-		} else if (sizestr[0] == '+') {
-			mod = 1;
-			sizestr++;
-		}
-		new_size = memparse(sizestr, &retptr);
-		if (*retptr != '\0' || new_size == 0) {
-			ret = -EINVAL;
-			goto out_mutex;
-		}
-	}
-
 	if (device->is_tgtdev_for_dev_replace) {
 		ret = -EPERM;
 		goto out_mutex;
 	}
 
+	if (!new_size)
+		new_size = device->bdev->bd_inode->i_size;
+
 	old_size = btrfs_device_get_total_bytes(device);
 
 	if (mod < 0) {
-- 
2.13.1

