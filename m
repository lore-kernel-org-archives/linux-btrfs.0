Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25601 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3DEFxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:08 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355r6iw031962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:07 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355r5nP003234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:06 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355r5rE014723
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:05 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] btrfs-progs: btrfs-find-root should scan backup-sb
Date: Fri,  5 Apr 2013 13:54:19 +0800
Message-Id: <1365141259-10529-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
References: <5127022B.6070200@oracle.com>
 <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

since idea is to scan and report all the sb in the
dev, we should let it so look for backup SB by setting
the flag BTRFS_SCAN_BACKUP_SB

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 find-root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/find-root.c b/find-root.c
index 27512df..e4ad6ac 100644
--- a/find-root.c
+++ b/find-root.c
@@ -103,7 +103,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 
 	ret = btrfs_scan_one_device(fd, device, &fs_devices,
 				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
-				    0ull);
+				    BTRFS_SCAN_BACKUP_SB);
 
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", device);
@@ -153,7 +153,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, BTRFS_SUPER_INFO_OFFSET,
-				   0ull);
+				   BTRFS_SCAN_BACKUP_SB);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
-- 
1.8.1.227.g44fe835

