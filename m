Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51055 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbKIK5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:44 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvhXJ014201
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvhYV012107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:43 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvhDn020389
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/15] btrfs: block incompatible optional features at scan
Date: Mon,  9 Nov 2015 18:56:23 +0800
Message-Id: <1447066589-3835-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the matter of completeness we need to check if the device
being scanned has features that are known to the kernel. As of
now if it doesn't - the mount will fails, then what is the point
in having those devices added to the btrfs_fs_devices list at
device_list_add().

So block those devices at scan. Which means the original block at
open_ctee() won't reach in case of device with unsupported feature.
But I am leaving that code as it is. without deleting.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b52197b..fcc9e57 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -976,6 +976,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	u64 transid;
 	u64 total_devices;
 	u64 bytenr;
+	u64 features;
 
 	/*
 	 * we would like to check all the supers, but that would make
@@ -996,6 +997,15 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
 		goto error_bdev_put;
 
+	features = btrfs_super_incompat_flags(disk_super) &
+				~BTRFS_FEATURE_INCOMPAT_SUPP;
+	if (features) {
+		printk(KERN_ERR \
+			"BTRFS: couldn't scan, unsupported optional features (%Lx)\n",
+			features);
+		ret = -EOPNOTSUPP;
+		goto error_disk_super;
+	}
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
@@ -1010,6 +1020,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (!ret && fs_devices_ret)
 		(*fs_devices_ret)->total_devices = total_devices;
 
+error_disk_super:
 	btrfs_release_disk_super(page);
 
 error_bdev_put:
-- 
2.4.1

