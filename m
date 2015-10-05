Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44903 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbbJEIt1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 04:49:27 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t958nOvt009124
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t958nOCr025523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:24 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t958nO1I000716
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:24 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 2/3] btrfs: maintain consistency in logging to help debugging
Date: Mon,  5 Oct 2015 16:48:09 +0800
Message-Id: <1444034890-9353-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444034890-9353-1-git-send-email-anand.jain@oracle.com>
References: <1444034890-9353-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Optional Label may or may not be set, or it might be set at
some time later. However while debugging to search
through the kernel logs the scripts would need the logs to
be consistent, so logs search key words shouldn't depend on the
optional variables, instead fsid is better.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
V2: commit corrected

 fs/btrfs/volumes.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8f1d175..e76cad3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1033,13 +1033,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 	if (ret > 0) {
-		if (disk_super->label[0]) {
-			printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
-		} else {
-			printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
-		}
-
-		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
+		printk(KERN_INFO "BTRFS: device fsid %pU devid %llu transid %llu %s\n",
+						disk_super->fsid, devid, transid, path);
 		ret = 0;
 	}
 	if (!ret && fs_devices_ret)
-- 
2.4.1

