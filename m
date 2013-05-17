Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25508 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3EQKv4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 06:51:56 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4HAptfK011786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:56 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HApsxj005214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:55 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HApsip006897
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: use /dev/mapper to find the btrfs disks
Date: Fri, 17 May 2013 18:54:41 +0800
Message-Id: <1368788082-12090-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, btrsf fi show uses
/proc/partitions (by default) (with priority given
to dm-<x> over sd<y> paths) and with -d option would scan
/dev only (with /dev/mapper skipped since its a link).

However using /dev/mapper paths are in common practice
with mount, fstab, and lvm, so its better to be consistent
with them.

This patch uses the /dev/mapper on top of scanning
/proc/partitions and updates paths with /dev/mapper
paths where available (which takes care if some of
the disks is under blacklist).

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     | 50 ++++++++++++++++++++++++++++----------------------
 cmds-filesystem.c | 24 ++++++++++++------------
 man/btrfs.8.in    |  5 +++--
 utils.c           | 33 ++++++++++++++++++++++++++++++---
 utils.h           |  1 +
 5 files changed, 74 insertions(+), 39 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..e3b80d6 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -178,50 +178,56 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [<device>...]",
+	"btrfs device scan [-d|<device>...]",
 	"Scan devices for a btrfs filesystem",
+	"\t      -d use /dev to scan (skips /dev/mapper)\n"
+	"\t<device> use only this disk/dev/file to scan for btrfs",
 	NULL
 };
 
 static int cmd_scan_dev(int argc, char **argv)
 {
-	int	i, fd, e;
-	int	checklist = 1;
-	int	devstart = 1;
+	int i, fd, e;
+	int checklist = 0;
+	int searchstart = 1;
+	int ret;
 
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-		if (check_argc_max(argc, 2))
+	optind = 1;
+	while(1) {
+		int c = getopt(argc, argv, "d");
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'd':
+			checklist = 2;
+			searchstart += 1;
+			break;
+		default:
 			usage(cmd_scan_dev_usage);
-
-		checklist = 0;
-		devstart += 1;
+		}
 	}
 
-	if(argc<=devstart){
-
-		int ret;
+	if (argc == searchstart) {
 
-		printf("Scanning for Btrfs filesystems\n");
-		if(checklist)
-			ret = btrfs_scan_block_devices(1);
-		else
-			ret = btrfs_scan_one_dir("/dev", 1);
-		if (ret){
-			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+		ret = scan_devs_for_btrfs(checklist, 1);
+		if (ret) {
+			fprintf(stderr, "ERROR: while scanning - %s\n",
+				strerror(-ret));
 			return 18;
 		}
 		return 0;
 	}
 
+	if (checklist != 0)
+		usage(cmd_scan_dev_usage);
+
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		perror("failed to open /dev/btrfs-control");
 		return 10;
 	}
-
-	for( i = devstart ; i < argc ; i++ ){
+	for (i = searchstart; i < argc; i++) {
 		struct btrfs_ioctl_vol_args args;
-		int ret;
 
 		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 470de31..43a222b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -232,9 +232,12 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [-d] [<uuid>]",
+	"btrfs filesystem show [-d|<fsid>]",
 	"Show the structure of a filesystem",
-	"If no argument is given, structure of all present filesystems is shown.",
+	"\tIf no argument is given, structure of all present filesystems is shown\n"
+	"\tIf no option is given, scans /proc/partitions and /dev/mapper\n"
+	"\t    -d scans /dev only (does not pick /dev/mapper though)\n"
+	"\t<fsid> shows structure of the filesystem",
 	NULL
 };
 
@@ -244,8 +247,8 @@ static int cmd_show(int argc, char **argv)
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
 	char *search = 0;
-	int ret;
-	int checklist = 1;
+	int ret = 0;
+	int checklist = 0;
 	int searchstart = 1;
 
 	optind = 1;
@@ -255,7 +258,7 @@ static int cmd_show(int argc, char **argv)
 			break;
 		switch(c) {
 		case 'd':
-			checklist = 0;
+			checklist = 2;
 			searchstart += 1;
 			break;
 		default:
@@ -266,16 +269,13 @@ static int cmd_show(int argc, char **argv)
 	if (check_argc_max(argc, searchstart + 1))
 		usage(cmd_show_usage);
 
-	if(checklist)
-		ret = btrfs_scan_block_devices(0);
-	else
-		ret = btrfs_scan_one_dir("/dev", 0);
-
+	ret = scan_devs_for_btrfs(checklist, 0);
 	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+		fprintf(stderr, "ERROR: while scanning - %s\n",
+			strerror(-ret));
 		return 18;
 	}
-	
+
 	if(searchstart < argc)
 		search = argv[searchstart];
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 8105019..9a68246 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -282,11 +282,12 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
-\fBfilesystem show\fR [-d] [<uuid>]\fR
+\fBfilesystem show\fR [-d|m] [<uuid>]\fR
 Show the btrfs filesystem with some additional info. If no \fIUUID\fP
 is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 If \fB-d\fP is passed, all the devices under /dev are scanned;
-otherwise the devices list is extracted from the /proc/partitions file.
+otherwise the devices list is extracted from the /proc/partitions
+and /dev/mapper.
 .TP
 
 \fBfilesystem balance\fR \fI<path>\fR
diff --git a/utils.c b/utils.c
index 7b4cd74..663670b 100644
--- a/utils.c
+++ b/utils.c
@@ -1018,6 +1018,7 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 	struct list_head pending_list;
 	struct btrfs_fs_devices *tmp_devices;
 	u64 num_devices;
+	int skip_link = 1;
 
 	INIT_LIST_HEAD(&pending_list);
 
@@ -1026,6 +1027,9 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 		return -ENOMEM;
 	strcpy(pending->name, dirname);
 
+	if (!strncmp(dirname, "/dev/mapper", strlen("/dev/mapper")))
+		skip_link = 0;
+
 again:
 	dirname_len = strlen(pending->name);
 	fullpath = malloc(PATH_MAX);
@@ -1057,7 +1061,7 @@ again:
 			fprintf(stderr, "failed to stat %s\n", fullpath);
 			continue;
 		}
-		if (S_ISLNK(st.st_mode))
+		if (skip_link && S_ISLNK(st.st_mode))
 			continue;
 		if (S_ISDIR(st.st_mode)) {
 			struct pending_dir *next = malloc(sizeof(*next));
@@ -1068,9 +1072,9 @@ again:
 			strcpy(next->name, fullpath);
 			list_add_tail(&next->list, &pending_list);
 		}
-		if (!S_ISBLK(st.st_mode)) {
+		if (skip_link && !S_ISBLK(st.st_mode))
 			continue;
-		}
+
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
 			/* ignore the following errors:
@@ -1807,3 +1811,26 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	close(fd);
 	return 0;
 }
+
+int scan_devs_for_btrfs(int where, int update_kernel)
+{
+	int ret = 0;
+
+	switch (where) {
+	case 0:
+		ret = btrfs_scan_block_devices(update_kernel);
+
+		/* /dev/mapper unified path is most
+		 * prefered if enabled for disks,
+		 * so use it  which would replace the
+		 * disks found in above
+		*/
+		if (!ret)
+			btrfs_scan_one_dir("/dev/mapper", update_kernel);
+		break;
+	case 2:
+		ret = btrfs_scan_one_dir("/dev", update_kernel);
+		break;
+	}
+	return ret;
+}
diff --git a/utils.h b/utils.h
index 3c17e14..375c15a 100644
--- a/utils.h
+++ b/utils.h
@@ -65,5 +65,6 @@ u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
+int scan_devs_for_btrfs(int where, int update_kernel);
 
 #endif
-- 
1.8.1.227.g44fe835

