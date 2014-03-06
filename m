Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33940 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbaCFDky (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 22:40:54 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s263ep7x002083
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 11:40:52 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: make the device scan logic more clear
Date: Thu, 6 Mar 2014 11:36:48 +0800
Message-Id: <1394077008-3568-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1394077008-3568-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1394077008-3568-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1. Use long option to replace the original strcmp() to parse
the "--all-devices".
2. the "int ret" is defined in 2 places, just define it once
and make the return pattern into "goto + single return".

This does not change the actual scan procedure and return values.
Just make it clear, the original seems a little confusing.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-device.c | 61 ++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 5009d9a..d79732f 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -188,51 +188,67 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [<--all-devices>|<device> [<device>...]]",
+	"btrfs device scan [options] [<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
+	"-d|--all-devices    scan all devices under /dev",
 	NULL
 };
 
 static int cmd_scan_dev(int argc, char **argv)
 {
-	int	i, fd, e;
-	int	where = BTRFS_SCAN_LBLKID;
-	int	devstart = 1;
+	int i, fd, e;
+	int where = BTRFS_SCAN_LBLKID;
+	int devstart = 1;
+	int all = 0;
+	int ret = 0;
 
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-		if (check_argc_max(argc, 2))
+	optind = 1;
+	while (1) {
+		int long_index;
+		static struct option long_options[] = {
+			{ "all-devices", no_argument, NULL, 'd' },
+			{ 0, 0, 0, 0 },
+		};
+		int c = getopt_long(argc, argv, "d", long_options,
+				    &long_index);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'd':
+			where = BTRFS_SCAN_DEV;
+			all = 1;
+			break;
+		default:
 			usage(cmd_scan_dev_usage);
-
-		where = BTRFS_SCAN_DEV;
-		devstart += 1;
+		}
 	}
 
-	if(argc<=devstart){
-		int ret;
+	if (all && check_argc_max(argc, 2))
+		usage(cmd_scan_dev_usage);
+
+	if (all || argc == 1) {
 		printf("Scanning for Btrfs filesystems\n");
 		ret = scan_for_btrfs(where, BTRFS_UPDATE_KERNEL);
-		if (ret){
+		if (ret)
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
-			return 1;
-		}
-		return 0;
+		goto out;
 	}
 
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		perror("failed to open /dev/btrfs-control");
-		return 1;
+		ret = 1;
+		goto out;
 	}
 
 	for( i = devstart ; i < argc ; i++ ){
 		struct btrfs_ioctl_vol_args args;
-		int ret;
 
 		if (!is_block_device(argv[i])) {
 			fprintf(stderr,
 				"ERROR: %s is not a block device\n", argv[i]);
-			close(fd);
-			return 1;
+			ret = 1;
+			goto close_out;
 		}
 		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
 
@@ -246,15 +262,16 @@ static int cmd_scan_dev(int argc, char **argv)
 		e = errno;
 
 		if( ret < 0 ){
-			close(fd);
 			fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
 				argv[i], strerror(e));
-			return 1;
+			goto close_out;
 		}
 	}
 
+close_out:
 	close(fd);
-	return 0;
+out:
+	return !!ret;
 }
 
 static const char * const cmd_ready_dev_usage[] = {
-- 
1.8.1.4

