Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41789 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbaLDSYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:24:46 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so36954258wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 10:24:45 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/5] Abort in case of device uuid conflict.
Date: Thu,  4 Dec 2014 19:24:30 +0100
Message-Id: <1417717470-6298-6-git-send-email-kreijack@inwind.it>
In-Reply-To: <1417717470-6298-1-git-send-email-kreijack@inwind.it>
References: <1417717470-6298-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a check to ensure that the all devices have differents device uuid.
In case of conflict the program ends.
Pay attention that it is still possible to insert two device with
the same dev uuid via the "btrfs device scan <device>" command.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-device.c |  4 ++--
 volumes.c     | 27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 580879c..f6c76e7 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -229,6 +229,7 @@ static int cmd_scan_dev(int argc, char **argv)
 			break;
 		case 's':
 			skip_snapshot = 0;
+			devstart++;
 			break;
 		default:
 			usage(cmd_scan_dev_usage);
@@ -238,7 +239,7 @@ static int cmd_scan_dev(int argc, char **argv)
 	if (all && check_argc_max(argc, 2))
 		usage(cmd_scan_dev_usage);
 
-	if (all || argc == 1) {
+	if (all || argc == devstart) {
 		printf("Scanning for Btrfs filesystems\n");
 		ret = btrfs_scan_lblkid();
 		if (ret)
@@ -266,7 +267,6 @@ static int cmd_scan_dev(int argc, char **argv)
 			ret = 1;
 			goto out;
 		}
-
 		if (skip_snapshot && is_low_priority_device(path)) {
 			fprintf(stderr, "WARNING: skip device '%s' because it is a snapshot\n",
 				argv[i]);
diff --git a/volumes.c b/volumes.c
index 5b007fc..6ff4b4a 100644
--- a/volumes.c
+++ b/volumes.c
@@ -17,6 +17,7 @@
  */
 #define _XOPEN_SOURCE 600
 #define __USE_XOPEN2K
+#define _BSD_SOURCE		/* for minor/major macro */
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
@@ -139,7 +140,31 @@ static int device_list_add(const char *path,
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices = fs_devices;
 	} else if (!device->name || strcmp(device->name, path)) {
-		char *name = strdup(path);
+		char *name;
+		struct stat statbuf1;
+
+		/*
+		 * check if the old device and the new device are differents
+		 * if so abort because we can't say which one is the right one
+		 */
+		if (device->name && !stat(device->name, &statbuf1)) {
+			struct stat statbuf2;
+
+			if (stat(path, &statbuf2))
+				return -ENOENT;
+
+			if (major(statbuf1.st_rdev) != major(statbuf2.st_rdev) ||
+				minor(statbuf1.st_rdev) != minor(statbuf2.st_rdev)) {
+				fprintf(stderr, "ERROR: two devices (%s and %s) have the same dev uuid !!\n",
+					device->name, path);
+				fprintf(stderr, "ERROR: remove one of the device and retry\n");
+				fprintf(stderr, "ERROR: the program will abort now\n");
+
+				exit(100);
+			}
+		}
+
+		name = strdup(path);
                 if (!name)
                         return -ENOMEM;
                 kfree(device->name);
-- 
2.1.3

