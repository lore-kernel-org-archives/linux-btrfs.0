Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47822 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753939AbeAIOMc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:12:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EBmfm147685
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:31 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2fcsdn1ja9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:12:31 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09ECVOi013384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:31 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09ECVHs027674
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: no need to check for btrfs_fs_devices::seeding
Date: Tue,  9 Jan 2018 22:13:10 +0800
Message-Id: <20180109141314.23795-3-anand.jain@oracle.com>
In-Reply-To: <20180109141314.23795-1-anand.jain@oracle.com>
References: <20180109141314.23795-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no need to check for btrfs_fs_devices::seeding when we
have checked for btrfs_fs_devices::opened, because we can't sprout
without its seed FS being opened.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7e04cd509ab9..ab6ccad08ef7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -619,8 +619,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 
 		if (fs_devs->opened)
 			continue;
-		if (fs_devs->seeding)
-			continue;
 
 		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
 
-- 
2.7.0

