Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55852 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3IDPXm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:42 -0400
Received: by mail-pb0-f44.google.com with SMTP id xa7so445559pbc.31
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:42 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 19/20] Btrfs-progs: fix magic return value in cmds-replace.c
Date: Wed,  4 Sep 2013 23:22:36 +0800
Message-Id: <1378308157-4621-20-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

There are 3 kinds of return values in replace cancel:

0: cancel successfully.
1: usage or syntal errors
2: cancel a not started or finished replacing operations.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-replace.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 1df719b..d9b0940 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -324,7 +324,7 @@ leave_with_error:
 		close(fdsrcdev);
 	if (fddstdev != -1)
 		close(fddstdev);
-	return -1;
+	return 1;
 }
 
 static const char *const cmd_status_replace_usage[] = {
@@ -367,12 +367,12 @@ static int cmd_status_replace(int argc, char **argv)
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
 			path, strerror(e));
-		return -1;
+		return 1;
 	}
 
 	ret = print_replace_status(fd, path, once);
 	close_file_or_dir(fd, dirstream);
-	return ret;
+	return !!ret;
 }
 
 static int print_replace_status(int fd, const char *path, int once)
@@ -530,7 +530,7 @@ static int cmd_cancel_replace(int argc, char **argv)
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
 			path, strerror(errno));
-		return -1;
+		return 1;
 	}
 
 	args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL;
@@ -541,9 +541,13 @@ static int cmd_cancel_replace(int argc, char **argv)
 		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %s, %s\n",
 			path, strerror(e),
 			replace_dev_result2string(args.result));
-		return ret;
+		return 1;
+	}
+	if (args.result == BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED) {
+		printf("INFO: ioctl(DEV_REPLACE_CANCEL)\"%s\": %s\n",
+			path, replace_dev_result2string(args.result));
+		return 2;
 	}
-
 	return 0;
 }
 
-- 
1.7.11.7

