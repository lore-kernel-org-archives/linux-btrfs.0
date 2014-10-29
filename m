Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40097 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaJ2KzN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 06:55:13 -0400
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] revert btrfs-progs: do a separate probe for _transient_ replacing device
Date: Wed, 29 Oct 2014 18:51:02 +0800
Message-Id: <1414579862-18951-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a compatibility issue with older kernel with the progs commit id as below.

05cd2907557ba627cfb86e60b214ea6228613a84

So as of now writing to revert the above commit id.
The brewing sysfs interface would help to fix the impending issue, which is
seed device would fail show in 'btrfs fi show' output of a sprout device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/utils.c b/utils.c
index a8691fe..1d1cc77 100644
--- a/utils.c
+++ b/utils.c
@@ -1869,29 +1869,12 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	if (!fi_args->num_devices)
 		goto out;
 
-	/*
-	 * with kernel patch
-	 * btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO miss-matched with slots
-	 * the kernel now returns total_devices which does not include
-	 * replacing device if running.
-	 * As we need to get dev info of the replace device if it is running,
-	 * so just add one to fi_args->num_devices.
-	 */
-
-	di_args = *di_ret = malloc((fi_args->num_devices + 1) * sizeof(*di_args));
+	di_args = *di_ret = malloc((fi_args->num_devices) * sizeof(*di_args));
 	if (!di_args) {
 		ret = -errno;
 		goto out;
 	}
 
-	/* get the replace target device if it is there */
-	ret = get_device_info(fd, i, &di_args[ndevs]);
-	if (!ret) {
-		ndevs++;
-		fi_args->num_devices++;
-	}
-	i++;
-
 	for (; i <= fi_args->max_id; ++i) {
 		BUG_ON(ndevs >= fi_args->num_devices);
 		ret = get_device_info(fd, i, &di_args[ndevs]);
-- 
2.0.0.153.g79dcccc

