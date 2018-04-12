Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43120 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbeDLC1k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2Remn007412
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:40 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2h6ne7hxxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:39 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rda8001257
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:39 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rcb1006837
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/15] btrfs: cleanup __btrfs_open_devices() drop head pointer
Date: Thu, 12 Apr 2018 10:29:26 +0800
Message-Id: <20180412022938.8257-4-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_open_devices() declares struct list_head *head, however head is
used only once, instead use btrfs_fs_devices::devices directly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index aacaf6c9feb7..793471eb3f51 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1074,14 +1074,13 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 				fmode_t flags, void *holder)
 {
-	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *device;
 	struct btrfs_device *latest_dev = NULL;
 	int ret = 0;
 
 	flags |= FMODE_EXCL;
 
-	list_for_each_entry(device, head, dev_list) {
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		/* Just open everything we can; ignore failures here */
 		if (btrfs_open_one_device(fs_devices, device, flags, holder))
 			continue;
-- 
2.7.0

