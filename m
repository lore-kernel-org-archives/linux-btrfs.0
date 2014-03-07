Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34673 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaCGPtD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Mar 2014 10:49:03 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s27Fn1Oj016316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:49:02 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s27Fn1On006035
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:49:01 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s27Fn1GR010509
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:49:01 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3 RFC] btrfs: show_devname should not consider seed disk
Date: Fri,  7 Mar 2014 23:48:39 +0800
Message-Id: <1394207319-13252-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1394207319-13252-1-git-send-email-Anand.Jain@oracle.com>
References: <1394207319-13252-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

most of the user level scripts uses /proc/self/mounts for the
disk-path to mount-point to fsid mapping. But when seed disk is
present which generally has lowest devid, the /proc/self/mounts
would show the seed disk, but seed disk has different fsid from
the actual fsid that's mounted. Due to this miss match these
scripts fails to work. One such example is btrfs-porgs
check_mounted_where().

The solution here is not to loop into the seed disks, but still
return the lowest devid under the given mount point.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/super.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f3c0247..c023ffa 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1892,15 +1892,12 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	cur_devices = fs_info->fs_devices;
-	while (cur_devices) {
-		head = &cur_devices->devices;
-		list_for_each_entry(dev, head, dev_list) {
-			if (dev->missing)
-				continue;
-			if (!first_dev || dev->devid < first_dev->devid)
-				first_dev = dev;
-		}
-		cur_devices = cur_devices->seed;
+	head = &cur_devices->devices;
+	list_for_each_entry(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
+		if (!first_dev || dev->devid < first_dev->devid)
+			first_dev = dev;
 	}
 
 	if (first_dev) {
-- 
1.8.5.3

