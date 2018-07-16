Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53172 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbeGPPWs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:22:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6GErlxI032739
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:01 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2k7a3t4tqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:00 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEt0LZ007657
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:00 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6GEt0M8025613
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:00 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] btrfs: warn for num_devices below 0
Date: Mon, 16 Jul 2018 22:58:10 +0800
Message-Id: <20180716145812.20836-6-anand.jain@oracle.com>
In-Reply-To: <20180716145812.20836-1-anand.jain@oracle.com>
References: <20180716145812.20836-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation to de-duplicate a section of code where we deduce the
num_devices, use warn instead of bug.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7f4973fc2b52..0f4c512aa6b4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3726,7 +3726,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	num_devices = fs_info->fs_devices->num_devices;
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		BUG_ON(num_devices < 1);
+		WARN_ON(num_devices < 1);
 		num_devices--;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
-- 
2.7.0

