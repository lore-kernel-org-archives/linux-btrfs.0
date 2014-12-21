Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38933 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaLUSFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 13:05:44 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so8776917wiv.2
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Dec 2014 10:05:43 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH][BTRFS-PROGS][CLEANUP] Remove gotos
Date: Sun, 21 Dec 2014 19:07:18 +0100
Message-Id: <1419185238-4254-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1419185238-4254-1-git-send-email-kreijack@inwind.it>
References: <1419185238-4254-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change a spagetti-style code (there are some "interlaced" gotos) to
a more modern style...

This patch removes also some #define from utils.h, which define
constants used only in cmds-filesystems.c . Instead an enum
is used locally in cmds-filesystems.c .
---
 cmds-filesystem.c | 106 ++++++++++++++++++++++++++++--------------------------
 utils.h           |   3 --
 2 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7eaccb9..08ddb5d 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -40,6 +40,11 @@
 #include "list_sort.h"
 #include "disk-io.h"
 
+enum filesystem_show_scan_method {
+	BTRFS_SCAN_ANY,
+	BTRFS_SCAN_MOUNTED,
+	BTRFS_SCAN_LBLKID
+};
 
 /*
  * for btrfs fi show, we maintain a hash of fsids we've already printed.
@@ -853,7 +858,7 @@ static int cmd_show(int argc, char **argv)
 	char *search = NULL;
 	int ret;
 	/* default, search both kernel and udev */
-	int where = -1;
+	int where = BTRFS_SCAN_ANY;
 	int type = 0;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	char path[PATH_MAX];
@@ -930,61 +935,60 @@ static int cmd_show(int argc, char **argv)
 				uuid_unparse(fsid, uuid_buf);
 				search = uuid_buf;
 				type = BTRFS_ARG_UUID;
-				goto devs_only;
+				where = BTRFS_SCAN_LBLKID;
 			}
 		}
 	}
 
-	if (where == BTRFS_SCAN_LBLKID)
-		goto devs_only;
-
-	/* show mounted btrfs */
-	ret = btrfs_scan_kernel(search);
-	if (search && !ret) {
-		/* since search is found we are done */
-		goto out;
-	}
-
-	/* shows mounted only */
-	if (where == BTRFS_SCAN_MOUNTED)
-		goto out;
-
-devs_only:
-	ret = btrfs_scan_lblkid();
-
-	if (ret) {
-		fprintf(stderr, "ERROR: %d while scanning\n", ret);
-		return 1;
-	}
-
-	found = search_umounted_fs_uuids(&all_uuids, search);
-	if (found < 0) {
-		fprintf(stderr,
-			"ERROR: %d while searching target device\n", ret);
-		return 1;
-	}
-
-	/*
-	 * The seed/sprout mapping are not detected yet,
-	 * do mapping build for all umounted fs
-	 */
-	ret = map_seed_devices(&all_uuids);
-	if (ret) {
-		fprintf(stderr,
-			"ERROR: %d while mapping seed devices\n", ret);
-		return 1;
+	if (where == BTRFS_SCAN_MOUNTED || where == BTRFS_SCAN_ANY) {
+	
+		/* show mounted btrfs */
+		ret = btrfs_scan_kernel(search);
+		if (search && !ret) {
+			/* since search is found we are done */
+			goto out;
+		}
+	
 	}
-
-	list_for_each_entry(fs_devices, &all_uuids, list)
-		print_one_uuid(fs_devices);
-
-	if (search && !found)
-		ret = 1;
-
-	while (!list_empty(&all_uuids)) {
-		fs_devices = list_entry(all_uuids.next,
-					struct btrfs_fs_devices, list);
-		free_fs_devices(fs_devices);
+	
+	if (where == BTRFS_SCAN_LBLKID || where == BTRFS_SCAN_ANY) {
+		
+		ret = btrfs_scan_lblkid();
+	
+		if (ret) {
+			fprintf(stderr, "ERROR: %d while scanning\n", ret);
+			return 1;
+		}
+	
+		found = search_umounted_fs_uuids(&all_uuids, search);
+		if (found < 0) {
+			fprintf(stderr,
+				"ERROR: %d while searching target device\n", ret);
+			return 1;
+		}
+	
+		/*
+		 * The seed/sprout mapping are not detected yet,
+		 * do mapping build for all umounted fs
+		 */
+		ret = map_seed_devices(&all_uuids);
+		if (ret) {
+			fprintf(stderr,
+				"ERROR: %d while mapping seed devices\n", ret);
+			return 1;
+		}
+	
+		list_for_each_entry(fs_devices, &all_uuids, list)
+			print_one_uuid(fs_devices);
+	
+		if (search && !found)
+			ret = 1;
+	
+		while (!list_empty(&all_uuids)) {
+			fs_devices = list_entry(all_uuids.next,
+						struct btrfs_fs_devices, list);
+			free_fs_devices(fs_devices);
+		}
 	}
 out:
 	printf("%s\n", BTRFS_BUILD_VERSION);
diff --git a/utils.h b/utils.h
index 0464c2d..603cdfb 100644
--- a/utils.h
+++ b/utils.h
@@ -26,9 +26,6 @@
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
 
-#define BTRFS_SCAN_MOUNTED	(1ULL << 0)
-#define BTRFS_SCAN_LBLKID	(1ULL << 1)
-
 #define BTRFS_UPDATE_KERNEL	1
 
 #define BTRFS_ARG_UNKNOWN	0
-- 
2.1.4

