Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44384 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3DOGhf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:35 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 06/11, v2] btrfs-progs: check if btrfs kernel module is loaded
Date: Mon, 15 Apr 2013 14:38:12 +0800
Message-Id: <1366007897-26567-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when we have to report no such file error for
/dev/btrfs-control we could confirm if btrfs kernel
is present and report it and skip registration
where appropriate

v1->v2: use /proc/filesystems to check if the btrfs
is present

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 60 ++++++++++++++++++++++++++++++++++++++++++++---------------
 mkfs.c        | 13 +++++++++++--
 utils.c       | 32 +++++++++++++++++++++++++++++++
 utils.h       |  2 +-
 4 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index a90fb67..4a134fa 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -185,9 +185,10 @@ static const char * const cmd_scan_dev_usage[] = {
 
 static int cmd_scan_dev(int argc, char **argv)
 {
-	int	i, fd, e;
+	int	i, fd = -1, e, ret = 0;
 	int	checklist = 1;
 	int	devstart = 1;
+	u64	flag_reg = 0ull;
 
 	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
 		if (check_argc_max(argc, 2))
@@ -197,33 +198,57 @@ static int cmd_scan_dev(int argc, char **argv)
 		devstart += 1;
 	}
 
+	if (is_btrfs_kernel_loaded())
+		flag_reg = BTRFS_SCAN_REGISTER;
+	else
+		fprintf(stderr, "btrfs kernel module is not loaded\n");
+
 	if(argc<=devstart){
 
 		int ret;
 
-		printf("Scanning for Btrfs filesystems\n");
+		printf("Scanning for Btrfs filesystems ");
 		if(checklist)
-			ret = btrfs_scan_block_devices(BTRFS_SCAN_REGISTER);
+			ret = btrfs_scan_block_devices(flag_reg);
 		else
-			ret = btrfs_scan_one_dir("/dev", BTRFS_SCAN_REGISTER);
+			ret = btrfs_scan_one_dir("/dev", flag_reg);
 		if (ret){
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 			return 18;
 		}
+		printf("..done\n");
 		return 0;
 	}
 
-	fd = open("/dev/btrfs-control", O_RDWR);
-	if (fd < 0) {
-		perror("failed to open /dev/btrfs-control");
-		return 10;
+	if (!flag_reg)
+		return -1;
+
+	if ((fd = open("/dev/btrfs-control", O_RDWR)) < 0) {
+		fprintf(stderr, "ERROR: failed to open "\
+			"/dev/btrfs-control - %s\n", strerror(errno));
+		return -1;
 	}
 
+	printf("Scanning for Btrfs in\n");
 	for( i = devstart ; i < argc ; i++ ){
+		int fdt;
 		struct btrfs_ioctl_vol_args args;
-		int ret;
+		printf("  %s ", argv[i]);
+		fflush(stdout);
 
-		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
+		/*
+		 * If for a multipath (mp) disk user provides the
+		 * non-mp path then open with flag O_EXCL will fail,
+		 * (also ioctl opens with O_EXCL), So test it before
+		 * calling ioctl.
+		 */
+		fdt = open(argv[i], O_RDONLY|O_EXCL);
+		if (fdt < 0) {
+			perror("ERROR");
+			ret = -1;
+			continue;
+		}
+		close(fdt);
 
 		strncpy_null(args.name, argv[i]);
 		/*
@@ -235,15 +260,16 @@ static int cmd_scan_dev(int argc, char **argv)
 		e = errno;
 
 		if( ret < 0 ){
-			close(fd);
-			fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
-				argv[i], strerror(e));
-			return 11;
+			fprintf(stderr, "ERROR: unable to scan - %s\n",
+				strerror(e));
+			ret = -1;
+		} else {
+			printf("found\n");
 		}
 	}
 
 	close(fd);
-	return 0;
+	return ret;
 }
 
 static const char * const cmd_ready_dev_usage[] = {
@@ -261,6 +287,10 @@ static int cmd_ready_dev(int argc, char **argv)
 	if (check_argc_min(argc, 2))
 		usage(cmd_ready_dev_usage);
 
+	if (!is_btrfs_kernel_loaded()) {
+		fprintf(stderr, "btrfs kernel module is not loaded\n");
+		return 10;
+	}
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		perror("failed to open /dev/btrfs-control");
diff --git a/mkfs.c b/mkfs.c
index 2eb3087..e8b22cc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1301,6 +1301,7 @@ int main(int ac, char **av)
 	int dev_cnt = 0;
 	int saved_optind;
 	char estr[100];
+	int flag_reg = 1;
 
 	while(1) {
 		int c;
@@ -1391,6 +1392,12 @@ int main(int ac, char **av)
 	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
+	if (!is_btrfs_kernel_loaded()) {
+		printf("btrfs kernel module is not loaded, "
+			"would skip device registration\n");
+		flag_reg = 0;
+	}
+
 	file = av[optind++];
 	dev_cnt--;
 
@@ -1483,7 +1490,8 @@ int main(int ac, char **av)
 	if (dev_cnt == 0)
 		goto raid_groups;
 
-	btrfs_register_one_device(file);
+	if (flag_reg)
+		btrfs_register_one_device(file);
 
 	zero_end = 1;
 	while(dev_cnt-- > 0) {
@@ -1518,7 +1526,8 @@ int main(int ac, char **av)
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
 					sectorsize, sectorsize, sectorsize);
 		BUG_ON(ret);
-		btrfs_register_one_device(file);
+		if (flag_reg)
+			btrfs_register_one_device(file);
 	}
 
 raid_groups:
diff --git a/utils.c b/utils.c
index 53ee919..67419da 100644
--- a/utils.c
+++ b/utils.c
@@ -1017,6 +1017,33 @@ struct pending_dir {
 	char name[PATH_MAX];
 };
 
+/*
+ * return 1 if btrfs kernel is present
+ * return 0 for not
+ */
+int is_btrfs_kernel_loaded()
+{
+	FILE *pfs;
+	char fsname[100];
+	int ret = -1;
+	char line[100];
+
+	pfs = fopen("/proc/filesystems", "r");
+	if (pfs) {
+		ret = 0;
+		while (fgets(line, sizeof(line), pfs)) {
+			if (sscanf(line, "nodev %[^#\n]\n", fsname) == 1) continue;
+			if (sscanf(line, " %[^# \n]\n", fsname) != 1) continue;
+			if (!strcmp(fsname, "btrfs")) {
+				ret = 1;
+				break;
+			}
+		}
+		fclose(pfs);
+	}
+	return ret;
+}
+
 void btrfs_register_one_device(char *fname)
 {
 	struct btrfs_ioctl_vol_args args;
@@ -1024,6 +1051,11 @@ void btrfs_register_one_device(char *fname)
 	int ret;
 	int e;
 
+	if (!is_btrfs_kernel_loaded()) {
+		fprintf(stderr, "btrfs kernel module is not loaded, "
+			"skipping device registration\n");
+		return;
+	}
 	fd = open("/dev/btrfs-control", O_RDONLY);
 	if (fd < 0) {
 		fprintf(stderr, "failed to open /dev/btrfs-control "
diff --git a/utils.h b/utils.h
index 989c4e5..b383057 100644
--- a/utils.h
+++ b/utils.h
@@ -67,5 +67,5 @@ u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
-
+int is_btrfs_kernel_loaded();
 #endif
-- 
1.8.1.227.g44fe835

