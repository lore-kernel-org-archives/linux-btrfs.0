Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27075 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932304AbdJJWxF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 18:53:05 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9AMr4JN013783
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Oct 2017 22:53:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9AMr3DQ024877
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Oct 2017 22:53:03 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9AMr3Or011891
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Oct 2017 22:53:03 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: free btrfs_device in place
Date: Tue, 10 Oct 2017 15:51:03 -0600
Message-Id: <20171010215103.20828-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's pointless to defer it to a kthread helper as we're not under any
special context.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d983cea..4a72c45 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -836,26 +836,16 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 	mutex_unlock(&uuid_mutex);
 }
 
-static void __free_device(struct work_struct *work)
+static void free_device(struct rcu_head *head)
 {
 	struct btrfs_device *device;
 
-	device = container_of(work, struct btrfs_device, rcu_work);
+	device = container_of(head, struct btrfs_device, rcu);
 	rcu_string_free(device->name);
 	bio_put(device->flush_bio);
 	kfree(device);
 }
 
-static void free_device(struct rcu_head *head)
-{
-	struct btrfs_device *device;
-
-	device = container_of(head, struct btrfs_device, rcu);
-
-	INIT_WORK(&device->rcu_work, __free_device);
-	schedule_work(&device->rcu_work);
-}
-
 static void btrfs_close_bdev(struct btrfs_device *device)
 {
 	if (device->bdev && device->writeable) {
-- 
2.9.4

