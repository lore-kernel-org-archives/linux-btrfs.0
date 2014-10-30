Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48989 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaJ3EA4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 00:00:56 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s9U40tYq016054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 04:00:55 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s9U40sbC028922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 04:00:55 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s9U40sPp028916
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 04:00:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] revert btrfs-progs: do a separate probe for _transient_ replacing device
Date: Thu, 30 Oct 2014 12:43:03 +0800
Message-Id: <1414644183-19189-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1414579862-18951-1-git-send-email-anand.jain@oracle.com>
References: <1414579862-18951-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a compatibility issue with older kernel with the progs commit id as below.

d0588bfa479409b2a0f6243f894338a01a56221a
btrfs-progs: do a separate probe for _transient_ replacing device

So as of now writing to revert the above commit id.
The brewing sysfs interface would help to fix the impending issue, which is
seed device would fail show in 'btrfs fi show' output of a sprout device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: update commit with correct commit which this patch will revert

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

