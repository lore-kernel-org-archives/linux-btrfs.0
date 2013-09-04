Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36482 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:22:59 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so574261pab.35
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:22:59 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 06/20] Btrfs-progs: fix magic return value in cmds-filesystem.c
Date: Wed,  4 Sep 2013 23:22:23 +0800
Message-Id: <1378308157-4621-7-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index ca0855b..815d59a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -62,12 +62,14 @@ static int cmd_df(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
-	if (!sargs)
-		return -ENOMEM;
+	if (!sargs) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	sargs->space_slots = 0;
 	sargs->total_spaces = 0;
@@ -157,7 +159,7 @@ out:
 	close_file_or_dir(fd, dirstream);
 	free(sargs);
 
-	return 0;
+	return !!ret;
 }
 
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
@@ -248,7 +250,7 @@ static int cmd_show(int argc, char **argv)
 
 	if (ret){
 		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
-		return 18;
+		return 1;
 	}
 	
 	if(searchstart < argc)
@@ -286,7 +288,7 @@ static int cmd_sync(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	printf("FSSync '%s'\n", path);
@@ -296,7 +298,7 @@ static int cmd_sync(int argc, char **argv)
 	if( res < 0 ){
 		fprintf(stderr, "ERROR: unable to fs-syncing '%s' - %s\n", 
 			path, strerror(e));
-		return 16;
+		return 1;
 	}
 
 	return 0;
@@ -429,12 +431,10 @@ static int cmd_defrag(int argc, char **argv)
 	}
 	if (verbose)
 		printf("%s\n", BTRFS_BUILD_VERSION);
-	if (errors) {
+	if (errors)
 		fprintf(stderr, "total %d failures\n", errors);
-		exit(1);
-	}
 
-	return errors;
+	return !!errors;
 }
 
 static const char * const cmd_resize_usage[] = {
@@ -462,13 +462,13 @@ static int cmd_resize(int argc, char **argv)
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 		fprintf(stderr, "ERROR: size value too long ('%s)\n",
 			amount);
-		return 14;
+		return 1;
 	}
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	printf("Resize '%s' of '%s'\n", path, amount);
@@ -479,7 +479,7 @@ static int cmd_resize(int argc, char **argv)
 	if( res < 0 ){
 		fprintf(stderr, "ERROR: unable to resize '%s' - %s\n", 
 			path, strerror(e));
-		return 30;
+		return 1;
 	}
 	return 0;
 }
-- 
1.7.11.7

