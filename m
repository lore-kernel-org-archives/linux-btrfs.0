Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbeDRJy0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 05:54:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I9pujq137239
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:54:26 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2hdrxp1ur2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:54:26 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I9sOe7020115
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:54:25 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I9sOP2020872
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:54:24 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: update uuid_mutex and device_list_mutex comments
Date: Wed, 18 Apr 2018 17:56:31 +0800
Message-Id: <20180418095631.9977-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make the uuid_mutex and device_list_mutex comments inline with
the changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Hi David,

 Can you kindly add this patch to the set: 'Review uuid_mutex usage'

Thanks, Anand

 fs/btrfs/volumes.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6d7f10729713..12617a8a7083 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -155,29 +155,26 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  *
  * uuid_mutex (global lock)
  * ------------------------
- * protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
+ * Protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
  * the SCAN_DEV ioctl registration or from mount either implicitly (the first
- * device) or requested by the device= mount option
- *
- * the mutex can be very coarse and can cover long-running operations
- *
- * protects: updates to fs_devices counters like missing devices, rw devices,
- * seeding, structure cloning, openning/closing devices at mount/umount time
+ * device) or requested by the device= mount option.
  *
  * global::fs_devs - add, remove, updates to the global list
  *
- * does not protect: manipulation of the fs_devices::devices list!
+ * Does not protect: manipulation of the fs_devices::devices list!
  *
  * btrfs_device::name - renames (write side), read is RCU
  *
  * fs_devices::device_list_mutex (per-fs, with RCU)
  * ------------------------------------------------
- * protects updates to fs_devices::devices, ie. adding and deleting
+ * Protects updates to fs_devices::devices, ie. adding and deleting, and its
+ * counters like missing devices, rw devices, seeding, structure cloning,
+ * openning/closing devices at mount/umount time.
  *
- * simple list traversal with read-only actions can be done with RCU protection
+ * Simple list traversal with read-only actions can be done with RCU protection.
  *
- * may be used to exclude some operations from running concurrently without any
- * modifications to the list (see write_all_supers)
+ * May be used to exclude some operations from running concurrently without any
+ * modifications to the list (see write_all_supers).
  *
  * balance_mutex
  * -------------
-- 
2.15.0

