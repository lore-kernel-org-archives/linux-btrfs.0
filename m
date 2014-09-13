Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39268 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaIMJLs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 05:11:48 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s8D9Bl3j032580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:47 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8D9Bk3O002928
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:47 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s8D9BjGn004721
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:46 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs-progs: scan /proc/partitions not all of /dev with "-d"
Date: Sat, 13 Sep 2014 09:21:18 +0800
Message-Id: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

We can scan for btrfs devices in a few ways.  By default
libblkid is used for "device scan" and "filesystem show";
with the -m option only mounted filesystems are scanned,
and with -d we physically read every system device.

But there's no reason for the complexity of a descent through
/dev; /proc/partitions has every device known to the kernel, so
just use that when -d is specified.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     | 2 +-
 cmds-filesystem.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index d7af090..ad0bd35 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -223,7 +223,7 @@ static int cmd_scan_dev(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_DEV;
+			where = BTRFS_SCAN_PROC;
 			all = 1;
 			break;
 		default:
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index d8b6938..818e05f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -563,7 +563,7 @@ static int cmd_show(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_DEV;
+			where = BTRFS_SCAN_PROC;
 			break;
 		case 'm':
 			where = BTRFS_SCAN_MOUNTED;
@@ -587,7 +587,7 @@ static int cmd_show(int argc, char **argv)
 		 * right away
 		 */
 		if (type == BTRFS_ARG_BLKDEV) {
-			if (where == BTRFS_SCAN_DEV) {
+			if (where == BTRFS_SCAN_PROC) {
 				/* we need to do this because
 				 * legacy BTRFS_SCAN_DEV
 				 * provides /dev/dm-x paths
@@ -618,7 +618,7 @@ static int cmd_show(int argc, char **argv)
 		}
 	}
 
-	if (where == BTRFS_SCAN_DEV)
+	if (where == BTRFS_SCAN_PROC)
 		goto devs_only;
 
 	/* show mounted btrfs */
-- 
2.0.0.153.g79dcccc

