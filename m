Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25839 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161346Ab3DEFxu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:50 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355rnAQ032426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:50 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355rnsR011996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:49 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355rneI017094
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:49 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs-progs: check if btrfs kernel module is loaded
Date: Fri,  5 Apr 2013 13:54:58 +0800
Message-Id: <1365141303-10571-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when we have to report no such file error for
/dev/btrfs-control we could confirm if btrfs kernel
module is loaded and report it and skip registration
where appropriate

Further this patch pretty prints the dev scan results.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 56 +++++++++++++++++++++++++++++++++++++++++++-------------
 mkfs.c        | 13 +++++++++++--
 utils.c       | 22 ++++++++++++++++++++++
 utils.h       |  1 +
 4 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index a90fb67..0e1e6de 100644
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
@@ -197,11 +198,16 @@ static int cmd_scan_dev(int argc, char **argv)
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
 			ret = btrfs_scan_block_devices(BTRFS_SCAN_REGISTER);
 		else
@@ -210,20 +216,39 @@ static int cmd_scan_dev(int argc, char **argv)
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
index 7d23520..dc4120a 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1420,6 +1420,7 @@ int main(int ac, char **av)
 	u64 flags;
 	int dev_cnt=0;
 	int saved_optind;
+	int flag_reg=1;
 
 	while(1) {
 		int c;
@@ -1508,6 +1509,12 @@ int main(int ac, char **av)
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
 
@@ -1594,7 +1601,8 @@ int main(int ac, char **av)
 	if (dev_cnt == 0)
 		goto raid_groups;
 
-	btrfs_register_one_device(file);
+	if (flag_reg)
+		btrfs_register_one_device(file);
 
 	zero_end = 1;
 	while(dev_cnt-- > 0) {
@@ -1629,7 +1637,8 @@ int main(int ac, char **av)
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
 					sectorsize, sectorsize, sectorsize);
 		BUG_ON(ret);
-		btrfs_register_one_device(file);
+		if (flag_reg)
+			btrfs_register_one_device(file);
 	}
 
 raid_groups:
diff --git a/utils.c b/utils.c
index 27574a0..21483b8 100644
--- a/utils.c
+++ b/utils.c
@@ -1016,6 +1016,23 @@ struct pending_dir {
 	char name[PATH_MAX];
 };
 
+/*
+ * return 1 for btrfs kernel module loaded
+ * return 0 for not
+ */
+int is_btrfs_kernel_loaded()
+{
+	FILE *mfd = popen("lsmod | grep btrfs", "r");
+	char buf[16];
+
+	if (fread (buf, 1, sizeof (buf), mfd) > 0) {
+		pclose(mfd);
+		return 1;
+	}
+	pclose(mfd);
+	return 0;
+}
+
 void btrfs_register_one_device(char *fname)
 {
 	struct btrfs_ioctl_vol_args args;
@@ -1023,6 +1040,11 @@ void btrfs_register_one_device(char *fname)
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
index ab22b02..50957b7 100644
--- a/utils.h
+++ b/utils.h
@@ -64,6 +64,7 @@ int get_btrfs_mount(const char *path, char *mp, size_t mp_size);
 int open_path_or_dev_mnt(const char *path);
 int is_swap_device(const char *file);
 u64 btrfs_device_size(int fd, struct stat *st);
+int is_btrfs_kernel_loaded();
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 
-- 
1.8.1.227.g44fe835

