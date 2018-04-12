Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37372 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752755AbeDLC1o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2Q79n099047
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:43 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2h6ny3hwh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:43 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rghx004039
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:42 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RgKL006851
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/15] btrfs: cleanup find_device() drop list_head pointer
Date: Thu, 12 Apr 2018 10:29:29 +0800
Message-Id: <20180412022938.8257-7-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_device() declares struct list_head *head pointer and used only once,
instead just use it directly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9ed670ffa6a5..5714cdaf9c03 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -332,10 +332,9 @@ static struct btrfs_device *__alloc_device(void)
 static struct btrfs_device *find_device(struct btrfs_fs_devices *fs_devices,
 		u64 devid, const u8 *uuid)
 {
-	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *dev;
 
-	list_for_each_entry(dev, head, dev_list) {
+	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
 		if (dev->devid == devid &&
 		    (!uuid || !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE))) {
 			return dev;
-- 
2.7.0

