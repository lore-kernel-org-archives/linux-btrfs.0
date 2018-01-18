Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58898 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756420AbeARN7l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 08:59:41 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0IDunJR148291
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:41 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2fjv6988ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:40 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0IDxd67015168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:40 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0IDxd1m002197
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: no need to check for btrfs_fs_devices::seeding
Date: Thu, 18 Jan 2018 22:00:33 +0800
Message-Id: <20180118140037.25158-3-anand.jain@oracle.com>
In-Reply-To: <20180118140037.25158-1-anand.jain@oracle.com>
References: <20180118140037.25158-1-anand.jain@oracle.com>
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

