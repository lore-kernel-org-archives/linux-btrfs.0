Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42150 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbeAJFOc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 00:14:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A5CPja000884
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:31 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2fd8jn0ftm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:31 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5EVVF023036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:31 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5EUGY019352
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: no need to check for btrfs_fs_devices::seeding
Date: Wed, 10 Jan 2018 13:15:19 +0800
Message-Id: <20180110051523.3681-3-anand.jain@oracle.com>
In-Reply-To: <20180110051523.3681-1-anand.jain@oracle.com>
References: <20180110051523.3681-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no need to check for btrfs_fs_devices::seeding when we
have checked for btrfs_fs_devices::opened, because we can't sprout
without its seed FS being opened.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 25b91776d036..3f481da9cae7 100644
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

