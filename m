Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18789 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaFXMwB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 08:52:01 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s5OCq0Mc001130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 12:52:01 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5OCpxCY014595
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 12:52:00 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5OCpxHI011332
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 12:51:59 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: we are not yet ready if device is missing
Date: Tue, 24 Jun 2014 20:51:43 +0800
Message-Id: <1403614303-4210-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1403614303-4210-1-git-send-email-Anand.Jain@oracle.com>
References: <1403614303-4210-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reproducer:

mkfs.btrfs -f -draid1 -mraid1 /dev/sdf /dev/sdd
modprobe -r btrfs && modprobe btrfs
mount -o degraded /dev/sdd /btrfs  <-- calls add_missing_dev() to add missing btrfs_device
umount /btrfs
btrfs dev ready /dev/sdd
echo $?
0
mount /dev/sdd /btrfs
mount: wrong fs type, bad option, bad superblock on /dev/sdd,
       missing codepage or helper program, or other error

fix this by checking if the device name is present in the BTRFS_IOC_DEVICES_READY
ioctl

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b9efe58..74ef9bf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1857,6 +1857,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	struct btrfs_fs_devices *fs_devices;
 	int ret = -ENOTTY;
 	void __user *argp = (void __user *)arg;
+	struct btrfs_device *dev;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1882,6 +1883,14 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		kfree(vol);
 		if (ret)
 			break;
+
+		list_for_each_entry(dev, &fs_devices->devices, dev_list) {
+			if (dev->name)
+				continue;
+
+			return !0;
+		}
+
 		ret = !(fs_devices->num_devices == fs_devices->total_devices);
 		break;
 	case BTRFS_IOC_GET_FSLIST:
-- 
2.0.0.257.g75cc6c6

