Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:42725 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab3BAJ7x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 04:59:53 -0500
Received: by mail-wg0-f54.google.com with SMTP id fm10so2819340wgb.9
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Feb 2013 01:59:52 -0800 (PST)
Date: Fri, 1 Feb 2013 09:59:49 +0000
From: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add '-b' option to filesystem df and show
Message-ID: <20130201095947.GA32445@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add '-b' and '--bytes' options to btrfs filesystem df and show, for easier
integration with scripts. This causes all sizes to be displayed in decimal
bytes instead of pretty-printed with human-readable suffices KB, MB, etc.

Signed-off-by: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>
---
 cmds-filesystem.c |   93 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 68 insertions(+), 25 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 507239a..9392209 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -40,7 +40,7 @@ static const char * const filesystem_cmd_group_usage[] = {
 };
 
 static const char * const cmd_df_usage[] = {
-	"btrfs filesystem df <path>",
+	"btrfs filesystem df [-b|--bytes] <path>",
 	"Show space usage information for a mount point",
 	NULL
 };
@@ -53,11 +53,23 @@ static int cmd_df(int argc, char **argv)
 	int fd;
 	int e;
 	char *path;
+	int start = 1;
+	int rawbytes = 0;
+
+	while (argc > start) {
+		if (!strcmp(argv[start], "--bytes") ||
+		    !strcmp(argv[start], "-b")) {
+			rawbytes = 1;
+			start += 1;
+		} else {
+			break;
+		}
+	}
 
-	if (check_argc_exact(argc, 2))
+	if (check_argc_exact(argc, start + 1))
 		usage(cmd_df_usage);
 
-	path = argv[1];
+	path = argv[start];
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -150,10 +162,18 @@ static int cmd_df(int argc, char **argv)
 			written += 8;
 		}
 
-		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
-		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
-		printf("%s: total=%s, used=%s\n", description, total_bytes,
-		       used_bytes);
+		if (rawbytes) {
+			printf("%s: total=%llu, used=%llu\n", description,
+			       (unsigned long long)sargs->spaces[i].total_bytes,
+			       (unsigned long long)sargs->spaces[i].used_bytes);
+		} else {
+			total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
+			used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
+			printf("%s: total=%s, used=%s\n", description, total_bytes,
+			       used_bytes);
+			free(total_bytes);
+			free(bytes_used);
+		}
 	}
 	close(fd);
 	free(sargs);
@@ -182,7 +202,7 @@ static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
 	return 0;
 }
 
-static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
+static void print_one_uuid(struct btrfs_fs_devices *fs_devices, int rawbytes)
 {
 	char uuidbuf[37];
 	struct list_head *cur;
@@ -199,25 +219,39 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	else
 		printf("Label: none ");
 
-	super_bytes_used = pretty_sizes(device->super_bytes_used);
-
 	total = device->total_devs;
-	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
-	       (unsigned long long)total, super_bytes_used);
 
-	free(super_bytes_used);
+	if (rawbytes) {
+		printf(" uuid: %s\n\tTotal devices %llu FS bytes used %llu\n",
+		       uuidbuf, (unsigned long long)total,
+		       (unsigned long long)device->super_bytes_used);
+	} else {
+		super_bytes_used = pretty_sizes(device->super_bytes_used);
+		printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n",
+		       uuidbuf, (unsigned long long)total, super_bytes_used);
+		free(super_bytes_used);
+	}
 
 	list_for_each(cur, &fs_devices->devices) {
 		char *total_bytes;
 		char *bytes_used;
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes);
-		bytes_used = pretty_sizes(device->bytes_used);
-		printf("\tdevid %4llu size %s used %s path %s\n",
-		       (unsigned long long)device->devid,
-		       total_bytes, bytes_used, device->name);
-		free(total_bytes);
-		free(bytes_used);
+		if (rawbytes) {
+			printf("\tdevid %4llu size %llu used %llu path %s\n",
+			       (unsigned long long)device->devid,
+			       (unsigned long long)device->total_bytes,
+			       (unsigned long long)device->bytes_used,
+			       device->name);
+		}
+		else {
+			total_bytes = pretty_sizes(device->total_bytes);
+			bytes_used = pretty_sizes(device->bytes_used);
+			printf("\tdevid %4llu size %s used %s path %s\n",
+			       (unsigned long long)device->devid,
+			       total_bytes, bytes_used, device->name);
+			free(total_bytes);
+			free(bytes_used);
+		}
 		devs_found++;
 	}
 	if (devs_found < total) {
@@ -227,7 +261,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices] [<uuid>|<label>]",
+	"btrfs filesystem show [--all-devices] [-b|--bytes] [<uuid>|<label>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -240,12 +274,21 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *cur_uuid;
 	char *search = 0;
 	int ret;
+	int rawbytes = 0;
 	int checklist = 1;
 	int searchstart = 1;
 
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-		checklist = 0;
-		searchstart += 1;
+	while (argc > searchstart) {
+		if (!strcmp(argv[searchstart], "--all-devices")) {
+			checklist = 0;
+			searchstart += 1;
+		} else if (!strcmp(argv[searchstart], "--bytes") ||
+			    !strcmp(argv[searchstart], "-b")) {
+			rawbytes = 1;
+			searchstart += 1;
+		} else {
+			break;
+		}
 	}
 
 	if (check_argc_max(argc, searchstart + 1))
@@ -270,7 +313,7 @@ static int cmd_show(int argc, char **argv)
 					list);
 		if (search && uuid_search(fs_devices, search) == 0)
 			continue;
-		print_one_uuid(fs_devices);
+		print_one_uuid(fs_devices, rawbytes);
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;
-- 
1.7.10.4

