Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50705 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaBXLoZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 06:44:25 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1OBiN2f000450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:24 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1OBiM6L017497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:23 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1OBiM41026229
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:22 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: latest_devid is not always the probed devid
Date: Mon, 24 Feb 2014 19:43:38 +0800
Message-Id: <1393242219-18525-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1393242219-18525-1-git-send-email-Anand.Jain@oracle.com>
References: <1393242219-18525-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs picks the latest_dev based on first probed
greatest trans-id. However below test case proofs that
approach is wrong.

$ mkfs.btrfs -d raid1 -m raid1 /dev/sde /dev/sdf
$ modprobe -r btrfs && modprobe btrfs
$ mount -o degraded /dev/sde /btrfs
$ touch /btrfs/testfile && btrfs fi sync /btrfs

The above steps will make /dev/sdf not part of the btrfs.

and as below when you use /dev/sdf the btrfs dev stat
and dev scrub picks up wrong disk

$ btrfs dev stat /dev/sdf
[/dev/sde].write_io_errs   0
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   0
[/dev/sde].corruption_errs 0
[/dev/sde].generation_errs 0

$ btrfs scrub start -B /dev/sdf
scrub done for 2e99c881-6abd-4f8a-8290-e2f8d0acc575
 scrub started at Mon Feb 24 14:45:06 2014 and finished after 0 seconds
 total bytes scrubbed: 256.00KiB with 0 errors

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 utils.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index e0c750d..231031e 100644
--- a/utils.c
+++ b/utils.c
@@ -1646,6 +1646,11 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	memset(fi_args, 0, sizeof(*fi_args));
 
 	if (is_block_device(path)) {
+
+		struct btrfs_super_block *disk_super;
+		char *buf;
+		u64 devid;
+
 		/* Ensure it's mounted, then set path to the mountpoint */
 		fd = open(path, O_RDONLY);
 		if (fd < 0) {
@@ -1665,8 +1670,23 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		path = mp;
 		/* Only fill in this one device */
 		fi_args->num_devices = 1;
-		fi_args->max_id = fs_devices_mnt->latest_devid;
-		i = fs_devices_mnt->latest_devid;
+
+		buf = malloc(4096);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		disk_super = (struct btrfs_super_block *)buf;
+		ret = btrfs_read_dev_super(fd, disk_super, BTRFS_SUPER_INFO_OFFSET);
+		if (ret < 0) {
+			ret = -EIO;
+			goto out;
+		}
+		devid = btrfs_stack_device_id(&disk_super->dev_item);
+
+		fi_args->max_id = devid;
+		i = devid;
+
 		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
 		close(fd);
 	}
-- 
1.8.4.2

