Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57184 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754766AbdLODyk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 22:54:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF3qD2V185950
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:54:39 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2ev6fp0268-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:54:39 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3lAvB031510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:10 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3lAwC024168
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:10 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: no need to check for btrfs_fs_devices::seeding
Date: Fri, 15 Dec 2017 11:47:35 +0800
Message-Id: <20171215034739.26090-3-anand.jain@oracle.com>
In-Reply-To: <20171215034739.26090-1-anand.jain@oracle.com>
References: <20171215034739.26090-1-anand.jain@oracle.com>
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
index 6317a3561ae1..0e89409112d5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -621,8 +621,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 
 		if (fs_devs->opened)
 			continue;
-		if (fs_devs->seeding)
-			continue;
 
 		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
 
-- 
2.7.0

