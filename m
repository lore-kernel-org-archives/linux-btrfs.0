Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51516 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbeEPFKN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 01:10:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G57LZ2084102
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 05:10:12 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2hx29w330s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 05:10:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4G5ACwd009256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 05:10:12 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4G5ABVV005041
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 05:10:11 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: update uuid_mutex and device_list_mutex comments
Date: Wed, 16 May 2018 13:12:39 +0800
Message-Id: <20180516051239.18861-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make the uuid_mutex and device_list_mutex comments inline with
the changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Fix typo. fs_devs -> fs_uuids

 fs/btrfs/volumes.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9dbc5b97fd94..81fb38884cac 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -147,16 +147,11 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  *
  * uuid_mutex (global lock)
  * ------------------------
- * protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
+ * Protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
  * the SCAN_DEV ioctl registration or from mount either implicitly (the first
- * device) or requested by the device= mount option
+ * device) or requested by the device= mount option.
  *
- * the mutex can be very coarse and can cover long-running operations
- *
- * protects: updates to fs_devices counters like missing devices, rw devices,
- * seeding, structure cloning, openning/closing devices at mount/umount time
- *
- * global::fs_devs - add, remove, updates to the global list
+ * global::fs_uuids - add, remove, updates to the global list.
  *
  * does not protect: manipulation of the fs_devices::devices list!
  *
@@ -164,12 +159,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  *
  * fs_devices::device_list_mutex (per-fs, with RCU)
  * ------------------------------------------------
- * protects updates to fs_devices::devices, ie. adding and deleting
+ * Protects updates to fs_devices::devices, ie. adding and deleting , and its
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

