Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:62449 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPW5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:22:57 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so431435pbc.8
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:22:56 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 05/20] Btrfs-progs: fix magic return value in cmds-device.c
Date: Wed,  4 Sep 2013 23:22:22 +0800
Message-Id: <1378308157-4621-6-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-device.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 7524d08..800a050 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -55,7 +55,7 @@ static int cmd_add_dev(int argc, char **argv)
 	fdmnt = open_file_or_dir(mntpnt, &dirstream);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
-		return 12;
+		return 1;
 	}
 
 	for (i = 1; i < argc - 1; i++ ){
@@ -120,10 +120,7 @@ static int cmd_add_dev(int argc, char **argv)
 	}
 
 	close_file_or_dir(fdmnt, dirstream);
-	if (ret)
-		return ret+20;
-	else
-		return 0;
+	return !!ret;
 }
 
 static const char * const cmd_rm_dev_usage[] = {
@@ -146,7 +143,7 @@ static int cmd_rm_dev(int argc, char **argv)
 	fdmnt = open_file_or_dir(mntpnt, &dirstream);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
-		return 12;
+		return 1;
 	}
 
 	for(i=1 ; i < argc - 1; i++ ){
@@ -170,10 +167,7 @@ static int cmd_rm_dev(int argc, char **argv)
 	}
 
 	close_file_or_dir(fdmnt, dirstream);
-	if( ret)
-		return ret+20;
-	else
-		return 0;
+	return !!ret;
 }
 
 static const char * const cmd_scan_dev_usage[] = {
@@ -202,7 +196,7 @@ static int cmd_scan_dev(int argc, char **argv)
 		ret = scan_for_btrfs(where, 1);
 		if (ret){
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
-			return 18;
+			return 1;
 		}
 		return 0;
 	}
@@ -210,7 +204,7 @@ static int cmd_scan_dev(int argc, char **argv)
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		perror("failed to open /dev/btrfs-control");
-		return 10;
+		return 1;
 	}
 
 	for( i = devstart ; i < argc ; i++ ){
@@ -232,7 +226,7 @@ static int cmd_scan_dev(int argc, char **argv)
 			close(fd);
 			fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
 				argv[i], strerror(e));
-			return 11;
+			return 1;
 		}
 	}
 
@@ -258,7 +252,7 @@ static int cmd_ready_dev(int argc, char **argv)
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		perror("failed to open /dev/btrfs-control");
-		return 10;
+		return 1;
 	}
 
 	strncpy(args.name, argv[argc - 1], BTRFS_PATH_NAME_MAX);
@@ -320,7 +314,7 @@ static int cmd_dev_stats(int argc, char **argv)
 
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", dev_path);
-		return 12;
+		return 1;
 	}
 
 	ret = get_fs_info(dev_path, &fi_args, &di_args);
-- 
1.7.11.7

