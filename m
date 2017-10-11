Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28027 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753309AbdJKTP3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 15:15:29 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9BJFTjG019682
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 19:15:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9BJFSAD018618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 19:15:28 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9BJFSwA013938
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 19:15:28 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: free btrfs_device in place
Date: Wed, 11 Oct 2017 12:13:30 -0600
Message-Id: <20171011181330.17015-1-bo.li.liu@oracle.com>
In-Reply-To: <20171010215103.20828-2-bo.li.liu@oracle.com>
References: <20171010215103.20828-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's pointless to defer it to a kthread helper as we're not under any
special context.

A bit more about device's lifetime, filesystems use an exclusive way
to access devices and hold a reference count on the devices in use.
Now that we've run blkdev_put() in btrfs_close_bdev(), device->bdev's
lifetime ends at btrfs_close_bdev(), not free_device(), and %bdev is
the only thing that others who need to access it really care about.

Since free_device() only frees the resources of 'struct btrfs_device',
this change won't result in the problem, ie. others like mkfs and md
are unable to access the device immediately after we do umount.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---

v2: Clarify the lifetime of device and device->bdev respectively and
    clear the concern about raising the 'device is in use' problem.

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

