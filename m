Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56594 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbeHCOiK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2018 10:38:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w73Ce78U041223
        for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2018 12:42:00 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2kma04j6qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Aug 2018 12:42:00 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w73CfxT3005417
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2018 12:41:59 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w73CfxLG016884
        for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2018 12:41:59 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: handle the BUG_ON in btrfs_num_devices()
Date: Fri,  3 Aug 2018 20:45:26 +0800
Message-Id: <20180803124526.18497-2-anand.jain@oracle.com>
In-Reply-To: <20180803124526.18497-1-anand.jain@oracle.com>
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180803124526.18497-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Its a logical bug if we hit fs_devices::num_devices == 1 and if the
replace is running because, as fs_devices::num_devices counts the in memory
devices, so it should include the replace target which is running as
indicated by the flag. If this happens return the -EINVAL back.

Suggested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Hi,
 As it fixes the BUG_ON I have spun a new patch for this.
 Instead of -EINVAL should we use ASSERT?

 fs/btrfs/volumes.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7359596ac8eb..ed2399caff80 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1855,9 +1855,11 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
 }
 
 /* Returns btrfs_fs_devices::num_devices minus replace device if any */
-static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
+static int btrfs_num_devices(struct btrfs_fs_info *fs_info, u64 *num_devices)
 {
-	u64 num_devices = fs_info->fs_devices->num_devices;
+	int ret = 0;
+
+	*num_devices = fs_info->fs_devices->num_devices;
 
 	/*
 	 * balance and replace co-exists in a scenario as below..
@@ -1867,12 +1869,13 @@ static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
 	 */
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		BUG_ON(num_devices < 1);
-		num_devices--;
+		if (*num_devices < 1)
+			ret = -EINVAL;
+		(*num_devices)--;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 
-	return num_devices;
+	return ret;
 }
 
 int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
@@ -1886,7 +1889,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	mutex_lock(&uuid_mutex);
 
-	num_devices = btrfs_num_devices(fs_info);
+	ret = btrfs_num_devices(fs_info, &num_devices);
+	if (ret) {
+		btrfs_err(fs_info, "logical bug num_devices %llu < 0",
+			  num_devices);
+		return ret;
+	}
 
 	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
 	if (ret)
@@ -3755,7 +3763,12 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	num_devices = btrfs_num_devices(fs_info);
+	ret = btrfs_num_devices(fs_info, &num_devices);
+	if (ret) {
+		btrfs_err(fs_info, "hits a logical bug num_devices %llu < 0",
+			  num_devices);
+		return ret;
+	}
 
 	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
 	if (num_devices > 1)
-- 
2.7.0

