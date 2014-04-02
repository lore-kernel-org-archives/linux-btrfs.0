Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19444 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067AbaDBJmk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 05:42:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, wangsl.fnst@cn.fujitsu.com
Subject: [PATCH RFC] Btrfs: device_list_add() should not update list when mounted
Date: Wed,  2 Apr 2014 17:43:33 +0800
Message-Id: <1396431813-24177-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Device list add shouldn't update the list when FS is mounted,
unless the whole loop w.r.t to bringing back the missing disk
is completed. (That is making it to be part of the group profile
and the code for this isn't there yet).

As as of now (without this patch) when device is scanned with
missing disk, it would update in the device list but the disk
is left unused, it won't be opened by the btrfs and won't be
part of the btrfs group profile operation.

reproducer 1:
 mkfs.btrfs -draid1 -mraid1 /dev/sdb /dev/sdc
 modprobe -r btrfs
 mount -o degraded /dev/sdb /btrfs
 btrfs dev scan /dev/sdc

 use btrfs-devlist (or any of your method) to know that
 /dev/sdc isn't actually part of the above FS, (though now
 the missing disk path is updated in the btrfs_fs_devices)
 whats more btrfs kernel didn't open it all.

 And so mkfs.ext4 can be successfully be created on /dev/sdc,
 whereas it fails on /dev/sdb

reproducer 2:
disappear a disk then replace (RAID1) the disappeared disk
and then make the disappeared disk to reappear.

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

btrfs sill unaware of device missing (but thats not the point)
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
it may pair with wrong disk (there will be a new patch
to fix this).

This patch is hand tested with the related device operations
viz device del, device add, replace, device scan, replace missing.

[1] github.com/anajain/devmgt.git

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dbb91f0..59a49b2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -472,9 +472,12 @@ static noinline int device_list_add(const char *path,
 		device = __find_device(&fs_devices->devices, devid,
 				       disk_super->dev_item.uuid);
 	}
+
 	if (!device) {
-		if (fs_devices->opened)
+		if (fs_devices->opened) {
+			printk(KERN_INFO "BTRFS: device list add failed, FS is open");
 			return -EBUSY;
+		}
 
 		device = btrfs_alloc_device(NULL, &devid,
 					    disk_super->dev_item.uuid);
@@ -497,6 +500,26 @@ static noinline int device_list_add(const char *path,
 
 		device->fs_devices = fs_devices;
 	} else if (!device->name || strcmp(device->name->str, path)) {
+		/*
+		* As of now this function doesn't support modifying the
+		* device list when the FS is in operation (mounted/opened)
+		* Also the below code to bring back the missing disk
+		* is incomplete (when fs is mounted) since it doesn't handle
+		* rest of the group profile fixups as part of missing-disk-reappearing,
+		* until we fix that we would return busy, this implies that user
+		* should use operations like '{btrfs} device add',
+		* 'device delete', 'device delete missing' to operate mounted disks,
+		* but they won't be able to use 'device scan' to update the device list
+		* of a mounted btrfs. Further when there are two disks with same devid
+		* and uuid (in some scenario) we want to avoid one of the other disk
+		* to replace the disk in operation using btrfs dev scan.
+		*/
+
+		if (fs_devices->opened) {
+			printk(KERN_INFO "BTRFS: device list update failed, FS is open");
+			return -EBUSY;
+		}
+
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
 			return -ENOMEM;
-- 
1.7.1

