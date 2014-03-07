Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26300 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaCGPtB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Mar 2014 10:49:01 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s27Fn0Og004030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:49:01 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s27FmxIk010430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:49:00 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s27Fmx6s021736
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:48:59 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3 RFC] btrfs: total_devices should count replacing devices
Date: Fri,  7 Mar 2014 23:48:38 +0800
Message-Id: <1394207319-13252-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1394207319-13252-1-git-send-email-Anand.Jain@oracle.com>
References: <1394207319-13252-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ioctl(BTRFS_IOC_FS_INFO) returns num_devices which does not
count seed device. num_devices is used to calculate
the number of slots during the ioctl(BTRFS_IOC_DEV_INFO)
but ioctl(BTRFS_IOC_DEV_INFO) would count seed devices as well.
Due to this miss match btrfs_progs get_fs_info() hits the bug..
            get_fs_info()
            ::
                    BUG_ON(ndevs >= fi_args->num_devices);

what I notice is total_devices should be returned by the
ioctl(BTRFS_IOC_FS_INFO)), however total_devices does not
count (transient) replacing device but num_devices does.

first, num_devices which appears to be a subset of
total_devices helps to count the number of devices
under a FSID which excludes the seed devices but
includes the transient replacing device.

total_devices which includes seed devices is as of
now does not count the tansient replacing device,
which IMO is a bug or the implementation details
are not clear enough to state the role of num_devices
and total_devices.

The user land on the otherhand would want to know
all the devices that would come out of probe
against a FSID

As of now in this patch I am making the ioctl.c local
changes (instead of asking replace thread to update
total_devices) to  include replacing device.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/ioctl.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5036f9d..ec7d5c6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2510,6 +2510,7 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 	struct btrfs_device *next;
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	int ret = 0;
+	int dev_replace_running = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -2518,8 +2519,18 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 	if (!fi_args)
 		return -ENOMEM;
 
+	btrfs_dev_replace_lock(&root->fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&root->fs_info->dev_replace))
+		dev_replace_running = 1;
+
+	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
+
 	mutex_lock(&fs_devices->device_list_mutex);
-	fi_args->num_devices = fs_devices->num_devices;
+	if (dev_replace_running)
+		fi_args->num_devices = fs_devices->total_devices + 1;
+	else
+		fi_args->num_devices = fs_devices->total_devices;
+
 	memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));
 
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
-- 
1.8.5.3

