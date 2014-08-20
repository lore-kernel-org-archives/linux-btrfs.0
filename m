Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbaHTWWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 18:22:11 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7KMMBXu029598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 18:22:11 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s7KMM9bO011022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 18:22:10 -0400
Message-ID: <53F51F95.8060400@redhat.com>
Date: Wed, 20 Aug 2014 17:22:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: scan /proc/partitions not all of /dev with
 "-d"
References: <53F51F4D.2090203@redhat.com>
In-Reply-To: <53F51F4D.2090203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can scan for btrfs devices in a few ways.  By default
libblkid is used for "device scan" and "filesystem show";
with the -m option only mounted filesystems are scanned,
and with -d we physically read every system device.

But there's no reason for the complexity of a descent through
/dev; /proc/partitions has every device known to the kernel, so
just use that when -d is specified.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
diff --git a/cmds-device.c b/cmds-device.c
index b6772b9..519681a 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -224,7 +224,7 @@ static int cmd_scan_dev(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_DEV;
+			where = BTRFS_SCAN_PROC;
 			all = 1;
 			break;
 		default:
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index bf87bbe..0ad7e8f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -614,7 +614,7 @@ static int cmd_show(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_DEV;
+			where = BTRFS_SCAN_PROC;
 			break;
 		case 'm':
 			where = BTRFS_SCAN_MOUNTED;
@@ -638,7 +638,7 @@ static int cmd_show(int argc, char **argv)
 		 * right away
 		 */
 		if (type == BTRFS_ARG_BLKDEV) {
-			if (where == BTRFS_SCAN_DEV) {
+			if (where == BTRFS_SCAN_PROC) {
 				/* we need to do this because
 				 * legacy BTRFS_SCAN_DEV
 				 * provides /dev/dm-x paths
@@ -681,7 +681,7 @@ static int cmd_show(int argc, char **argv)
 		}
 	}
 
-	if (where == BTRFS_SCAN_DEV)
+	if (where == BTRFS_SCAN_PROC)
 		goto devs_only;
 
 	/* show mounted btrfs */

