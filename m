Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46994 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbaAFQ41 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 11:56:27 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id s06GuQ1Q003050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 16:56:27 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s06GuPmD016239
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 16:56:26 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s06GuPvg001228
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 16:56:25 GMT
Message-ID: <52CAE033.3020604@oracle.com>
Date: Tue, 07 Jan 2014 00:56:19 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [bug] its messy when missing device reappears after its been replaced
 in RAID1
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


test case:
disappear a disk then replace (RAID1) the disappeared disk
and then make disappeared disk to reappear.

----
  mkfs.btrfs -f -m raid1 -d raid1 /dev/sdc /dev/sdd
  mount /dev/sdc /btrfs
  dd if=/dev/zero of=/btrfs/tf1 count=1
  btrfs fi sync /btrfs
---

devmgt[1] will help to attach or detach a disk easily

--
  devmgt show
  devmgt detach /dev/sdc
--

btrfs sill unaware of device missing.
--
  btrfs fi show -m
Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120
         Total devices 2 FS bytes used 32.00KiB
         devid    1 size 958.94MiB used 115.88MiB path /dev/sdc <--
         devid    2 size 958.94MiB used 103.88MiB path /dev/sdd

  btrfs rep start -f 1 /dev/sde /btrfs
Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120
         Total devices 2 FS bytes used 32.00KiB
         devid    1 size 958.94MiB used 115.88MiB path /dev/sde
         devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
--

so far good. now missing /dev/sdc comes-back.

---
  devmgt attach host2

btrfs fi show -m shows sdc
Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120^M
         Total devices 2 FS bytes used 32.00KiB^M
         devid    1 size 958.94MiB used 115.88MiB path /dev/sdc <- Wrong.
         devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
---

this is wrong it should be sde. this happened because when
disk comes back device_list_add() is called which would invariably
replace the existing disk with the given disk with the same fsid/devid.
But the actual IO is still going to sde not to sdc.

Further when we start fresh with (modprobe -r btrfs)
unless it is carefully managed using btrfs dev scan <dev>
it may pair with wrong disk.

Need your review of the following proposed fix. This patch
will compare the trans id before disk is substituted.

----------------------------------------------------
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2ca91fc..b226284 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -496,14 +496,39 @@ static noinline int device_list_add(const char *path,

                 device->fs_devices = fs_devices;
         } else if (!device->name || strcmp(device->name->str, path)) {
-               name = rcu_string_strdup(path, GFP_NOFS);
-               if (!name)
-                       return -ENOMEM;
-               rcu_string_free(device->name);
-               rcu_assign_pointer(device->name, name);
-               if (device->missing) {
-                       fs_devices->missing_devices--;
-                       device->missing = 0;
+
+               struct buffer_head *bh;
+               struct btrfs_super_block *cur_disk_super;
+               u64 cur_transid;
+
+               if (!device->missing) {
+                       bh = btrfs_read_dev_super(device->bdev);
+                       if (!bh)
+                               return -EINVAL;
+
+                       cur_disk_super = (struct btrfs_super_block *)
+						bh->b_data;
+                       cur_transid = btrfs_super_generation(ds);
+               } else
+                       cur_transid = 0;
+
+               if (found_transid > cur_transid) {
+
+                       name = rcu_string_strdup(path, GFP_NOFS);
+                       if (!name)
+                               return -ENOMEM;
+
+                       rcu_string_free(device->name);
+                       rcu_assign_pointer(device->name, name);
+
+                       if (device->missing) {
+                               fs_devices->missing_devices--;
+                               device->missing = 0;
+                       }
+
+       printk_in_rcu(KERN_INFO "%s tran %llu replaced %s tran %llu\n",
+                               path, found_transid,
+                               rcu_str_deref(device->name), tranid);
                 }
         }

---------------------------------------


Thanks Anand


[1] github.com/anajain/devmgt.git



