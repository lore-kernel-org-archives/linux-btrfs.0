Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29632 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbaHRIQg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 04:16:36 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com, lists@colorremedies.com
Subject: [PATCH] btrfs-progs: do a separate probe for _transient_ replacing device As mentioned in the kernel patch   btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO miss-matched with slots
Date: Sat, 16 Aug 2014 11:08:08 +0800
Message-Id: <1408158488-4316-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1408158488-4316-1-git-send-email-anand.jain@oracle.com>
References: <1408158488-4316-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The count as returned by BTRFS_IOC_FS_INFO is the number of slots that
btrfs-progs would allocate for the BTRFS_IOC_DEV_INFO ioctl. Since
BTRFS_IOC_DEV_INFO would loop across the seed devices, So its better
ioctl BTRFS_IOC_FS_INFO returns the total_devices instead of num_devices.

The above mentioned patch just does that. That is, it returns
total_devices instead of num_devices.

Which means we need to probe for the replacing device separately.

This patch will probe for the replacing device separately.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 8bdc2a7..fa837b9 100644
--- a/utils.c
+++ b/utils.c
@@ -1929,12 +1929,29 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	if (!fi_args->num_devices)
 		goto out;
 
-	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
+	/*
+	 * with kernel patch
+	 * btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO miss-matched with slots
+	 * the kernel now returns total_devices which does not include
+	 * replacing device if running.
+	 * As we need to get dev info of the replace device if it is running,
+	 * so just add one to fi_args->num_devices.
+	 */
+
+	di_args = *di_ret = malloc((fi_args->num_devices + 1) * sizeof(*di_args));
 	if (!di_args) {
 		ret = -errno;
 		goto out;
 	}
 
+	/* get the replace target device if it is there */
+	ret = get_device_info(fd, i, &di_args[ndevs]);
+	if (!ret) {
+		ndevs++;
+		fi_args->num_devices++;
+	}
+	i++;
+
 	for (; i <= fi_args->max_id; ++i) {
 		BUG_ON(ndevs >= fi_args->num_devices);
 		ret = get_device_info(fd, i, &di_args[ndevs]);
-- 
2.0.0.153.g79dcccc

