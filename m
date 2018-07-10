Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732523AbeGJSTi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 14:19:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6AIJUui062485
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:30 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2k2p7vb3jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:30 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6AIJSmD003625
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:29 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6AIJS1p000332
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:28 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: add helper function check device delete able
Date: Wed, 11 Jul 2018 02:22:41 +0800
Message-Id: <20180710182241.23754-3-anand.jain@oracle.com>
In-Reply-To: <20180710182241.23754-1-anand.jain@oracle.com>
References: <20180710182241.23754-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move the section of the code which performs the check if the device is
indelible, move that into a helper function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 49 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 59a6d8f42c98..feb29c5b44f6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1945,6 +1945,33 @@ static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
 	return num_devices;
 }
 
+static struct btrfs_device *btrfs_device_delete_able(
+				struct btrfs_fs_info *fs_info,
+				const char *device_path, u64 devid)
+{
+	int ret;
+	struct btrfs_device *device;
+
+	ret = btrfs_check_raid_min_devices(fs_info,
+					   btrfs_num_devices(fs_info) - 1);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = btrfs_find_device_by_devspec(fs_info, devid, device_path,
+					   &device);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+		return ERR_PTR(BTRFS_ERROR_DEV_TGT_REPLACE);
+
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
+	    fs_info->fs_devices->rw_devices == 1)
+		return ERR_PTR(BTRFS_ERROR_DEV_ONLY_WRITABLE);
+
+	return device;
+}
+
 int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		u64 devid)
 {
@@ -1958,25 +1985,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	mutex_lock(&uuid_mutex);
 
-	num_devices = btrfs_num_devices(fs_info);
-
-	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
-	if (ret)
-		goto out;
-
-	ret = btrfs_find_device_by_devspec(fs_info, devid, device_path,
-					   &device);
-	if (ret)
-		goto out;
-
-	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
-		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
-		goto out;
-	}
-
-	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
-	    fs_info->fs_devices->rw_devices == 1) {
-		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
+	device = btrfs_device_delete_able(fs_info, device_path, devid);
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
 		goto out;
 	}
 
-- 
2.7.0

