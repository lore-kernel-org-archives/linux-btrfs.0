Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38928 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaJHJnd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Oct 2014 05:43:33 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so8654394pad.8
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Oct 2014 02:43:33 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 1/2] btrfs-progs: don't report internal dev replace result if ioctl failed
Date: Wed,  8 Oct 2014 17:42:28 +0800
Message-Id: <1412761349-32721-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If BTRFS_IOC_DEV_REPLACE ioctl failed, there's no result returned to
fill args.result, it doesn't make sense to report this internal result
to user.

And the arg has been initialized with 0, the result is always 0, which
is BTRFS_IOCTL_DEV_REPLACE_REPLACE_NO_ERROR, and the resulting error
message looks confusing too:

ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/btrfs": No such file or directory, no error

So just skip the internal dev replace result if the whole ioctl failed.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-replace.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 9fe7ad8..51b7aaf 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -187,9 +187,8 @@ static int cmd_start_replace(int argc, char **argv)
 	ret = ioctl(fdmnt, BTRFS_IOC_DEV_REPLACE, &status_args);
 	if (ret) {
 		fprintf(stderr,
-			"ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s, %s\n",
-			path, strerror(errno),
-			replace_dev_result2string(status_args.result));
+			"ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s\n",
+			path, strerror(errno));
 		goto leave_with_error;
 	}
 
@@ -305,9 +304,8 @@ static int cmd_start_replace(int argc, char **argv)
 	if (do_not_background) {
 		if (ret) {
 			fprintf(stderr,
-				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
-				path, strerror(errno),
-				replace_dev_result2string(start_args.result));
+				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s\n",
+				path, strerror(errno));
 
 			if (errno == EOPNOTSUPP)
 				fprintf(stderr,
@@ -404,9 +402,8 @@ static int print_replace_status(int fd, const char *path, int once)
 		args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS;
 		ret = ioctl(fd, BTRFS_IOC_DEV_REPLACE, &args);
 		if (ret) {
-			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s, %s\n",
-				path, strerror(errno),
-				replace_dev_result2string(args.result));
+			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s\n",
+				path, strerror(errno));
 			return ret;
 		}
 
@@ -554,9 +551,8 @@ static int cmd_cancel_replace(int argc, char **argv)
 	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret) {
-		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %s, %s\n",
-			path, strerror(e),
-			replace_dev_result2string(args.result));
+		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %s\n",
+			path, strerror(e));
 		return 1;
 	}
 	if (args.result == BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED) {
-- 
1.8.3.1

