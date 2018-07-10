Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41986 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732400AbeGJS1a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 14:27:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6AIJAk0093090
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:27:19 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2k2p75u5pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:27:19 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6AIRI8r030247
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:27:19 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6AIRILQ004318
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:27:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2nd try] btrfs: do device clone using the btrfs_scan_one_device
Date: Wed, 11 Jul 2018 02:30:32 +0800
Message-Id: <20180710183032.24439-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we add a device to the RO mounted seed device, it becomes a
RW sprout FS. The following steps are used to hold the seed and
sprout fs_devices.
 (first two steps are not mandatory for the sprouting, they are there
  to ensure the seed device remains in the scanned state)
  . Clone the (mounted) fs_devices, lets call it as old_devices
  . Now add old_devices to fs_uuids (yeah, there is duplicate fsid in the
    list, as we are under uuid_mutex so its fine).

  . Alloc a new fs_devices, lets call it as seed_devices
  . Copy fs_devices into the seed_devices
  . Move fs_devices::devices into seed_devices::devices
  . Bring seed_devices to under fs_devices::seed
    (fs_devices->seed = seed_devices)
  . Assign a new FSID to the fs_devices and add the new writable device
    to the fs_devices.

This patch makes the following changes..
As we clone fs_devices to make sure the device remains scanned after the
sprouting. So use the btrfs_scan_one_device() code instead. And do it
at the end of the sprouting.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---

As I don't this patch in the ML. I am sending this again, with no
change.

 fs/btrfs/volumes.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b63aae267ebe..5bfc3feb715a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2266,7 +2266,7 @@ int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
 static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
-	struct btrfs_fs_devices *old_devices;
+	struct btrfs_fs_devices *old_fs_devices;
 	struct btrfs_fs_devices *seed_devices;
 	struct btrfs_super_block *disk_super = fs_info->super_copy;
 	struct btrfs_device *device;
@@ -2280,14 +2280,6 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	if (IS_ERR(seed_devices))
 		return PTR_ERR(seed_devices);
 
-	old_devices = clone_fs_devices(fs_devices);
-	if (IS_ERR(old_devices)) {
-		kfree(seed_devices);
-		return PTR_ERR(old_devices);
-	}
-
-	list_add(&old_devices->fs_list, &fs_uuids);
-
 	memcpy(seed_devices, fs_devices, sizeof(*seed_devices));
 	seed_devices->opened = 1;
 	INIT_LIST_HEAD(&seed_devices->devices);
@@ -2320,6 +2312,17 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 		      ~BTRFS_SUPER_FLAG_SEEDING;
 	btrfs_set_super_flags(disk_super, super_flags);
 
+	/*
+	 * As the above code hijacked the original seed fs_devices, now
+	 * create a new one for the original seed FSID.
+	 */
+	list_for_each_entry(device, &fs_devices->seed->devices, dev_list) {
+		if (!device->name)
+			continue;
+		btrfs_scan_one_device(device->name->str, FMODE_READ,
+				      fs_info->bdev_holder, &old_fs_devices);
+	}
+
 	return 0;
 }
 
-- 
2.7.0

