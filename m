Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17069 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdJXGFG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 02:05:06 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9O654Te014121
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 06:05:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9O654VS017740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 06:05:04 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9O654Wa026147
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 06:05:04 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs: free btrfs_device in place
Date: Mon, 23 Oct 2017 23:02:54 -0600
Message-Id: <20171024050254.32593-1-bo.li.liu@oracle.com>
In-Reply-To: <20171010215103.20828-2-bo.li.liu@oracle.com>
References: <20171010215103.20828-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's pointless to defer it to a kthread helper as we're not under a
special context.

For reference, commit 1f78160ce1b1 ("Btrfs: using rcu lock in the
reader side of devices list") introduced RCU freeing for device
structures.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---

v3: - Enhance changelog with commit id which introduced this for future
      reference.
    - Now we can remove %rcu_work.

v2: - Clarify the lifetime of device and device->bdev respectively and
      clear the concern about raising the 'device is in use' problem.

 fs/btrfs/volumes.c | 14 ++------------
 fs/btrfs/volumes.h |  1 -
 2 files changed, 2 insertions(+), 13 deletions(-)

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
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6108fdf..f60c535 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -133,7 +133,6 @@ struct btrfs_device {
 
 	struct btrfs_work work;
 	struct rcu_head rcu;
-	struct work_struct rcu_work;
 
 	/* readahead state */
 	spinlock_t reada_lock;
-- 
2.9.4

