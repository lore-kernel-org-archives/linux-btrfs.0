Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58630 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbeDLC1i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2QaJT171049
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:37 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2h6kgtj0uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:37 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RbH3001188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:37 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Ra8a021304
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:36 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/15] btrfs: optimize move uuid_mutex closer to the critical section
Date: Thu, 12 Apr 2018 10:29:24 +0800
Message-Id: <20180412022938.8257-2-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move uuid_mutex closer to the exclusion section.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1d9f20fc3392..7ccd1a38c634 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1206,31 +1206,29 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	 */
 	bytenr = btrfs_sb_offset(0);
 	flags |= FMODE_EXCL;
-	mutex_lock(&uuid_mutex);
 
 	bdev = blkdev_get_by_path(path, flags, holder);
-	if (IS_ERR(bdev)) {
-		ret = PTR_ERR(bdev);
-		goto error;
-	}
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
 
 	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
 		ret = -EINVAL;
 		goto error_bdev_put;
 	}
 
+	mutex_lock(&uuid_mutex);
 	device = device_list_add(path, disk_super);
 	if (IS_ERR(device))
 		ret = PTR_ERR(device);
 	else
 		*fs_devices_ret = device->fs_devices;
+	mutex_unlock(&uuid_mutex);
 
 	btrfs_release_disk_super(page);
 
 error_bdev_put:
 	blkdev_put(bdev, flags);
-error:
-	mutex_unlock(&uuid_mutex);
+
 	return ret;
 }
 
-- 
2.7.0

