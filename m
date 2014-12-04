Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56000 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaLDSju (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:39:50 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so23362025wgh.11
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 10:39:49 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/5] Abort in case of device uuid conflict.
Date: Thu,  4 Dec 2014 19:39:42 +0100
Message-Id: <1417718382-6753-6-git-send-email-kreijack@inwind.it>
In-Reply-To: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a check to ensure that the all devices have differents device uuid.
In case of conflict the program ends.
Pay attention that it is still possible to insert two device with
the same dev uuid via the "btrfs device scan <device>" command.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 volumes.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

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

