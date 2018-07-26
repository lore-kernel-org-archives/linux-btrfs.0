Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58646 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbeGZIFd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 04:05:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6Q6mnPr128740
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:11 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2kbwfq1m9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:11 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6Q6oAVw009058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:10 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6Q6o9JR002663
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:10 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: bug_on for num_devices below 0
Date: Thu, 26 Jul 2018 14:53:33 +0800
Message-Id: <20180726065334.30594-4-anand.jain@oracle.com>
In-Reply-To: <20180726065334.30594-1-anand.jain@oracle.com>
References: <20180726065334.30594-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation to add helper function to deduce the num_devices with
replace running, use bug_on instead of warn_on. In btrfs_rm_device()
the check for min devices happens in btrfs_check_raid_min_devices()
but its after its been decremented so a check here is better.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c62b5e46792e..fe74fefc75f7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1868,7 +1868,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	num_devices = fs_devices->num_devices;
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		WARN_ON(num_devices < 1);
+		BUG_ON(num_devices < 1);
 		num_devices--;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
-- 
2.7.0

