Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53006 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaJJNSK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 09:18:10 -0400
Received: by mail-pd0-f176.google.com with SMTP id fp1so1635809pdb.7
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 06:18:09 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2 1/2] btrfs-progs: only report internal dev replace result if there's a result
Date: Fri, 10 Oct 2014 21:16:16 +0800
Message-Id: <1412946976-28364-1-git-send-email-guaneryu@gmail.com>
In-Reply-To: <20141010082023.GF22943@twin.jikos.cz>
References: <20141010082023.GF22943@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If BTRFS_IOC_DEV_REPLACE ioctl failed, args.result usually won't be
updated by the ioctl.

And the arg has been initialized with 0, the result is always 0, which
is BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR, and the resulting error
message looks confusing:

ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/btrfs": No such file or directory, no error

But in case there's an internal result returned in future, don't drop
the result completely, instead print dev replace result message only
if the result is updated by a failed ioctl call.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

I didn't update replace_dev_result2string() function, which seems not
necessary here. And I personally still prefer v1 :)

v2:
- don't drop the result completely but print result if it's got updated

 cmds-replace.c | 44 ++++++++++++++++++++++++++++++++------------
 ioctl.h        |  1 +
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 9fe7ad8..bfcc161 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -184,12 +184,17 @@ static int cmd_start_replace(int argc, char **argv)
 
 	/* check for possible errors before backgrounding */
 	status_args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS;
+	status_args.result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT;
 	ret = ioctl(fdmnt, BTRFS_IOC_DEV_REPLACE, &status_args);
 	if (ret) {
 		fprintf(stderr,
-			"ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s, %s\n",
-			path, strerror(errno),
-			replace_dev_result2string(status_args.result));
+			"ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s",
+			path, strerror(errno));
+		if (status_args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT)
+			fprintf(stderr, ", %s\n",
+				replace_dev_result2string(status_args.result));
+		else
+			fprintf(stderr, "\n");
 		goto leave_with_error;
 	}
 
@@ -301,13 +306,18 @@ static int cmd_start_replace(int argc, char **argv)
 	}
 
 	start_args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_START;
+	start_args.result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT;
 	ret = ioctl(fdmnt, BTRFS_IOC_DEV_REPLACE, &start_args);
 	if (do_not_background) {
 		if (ret) {
 			fprintf(stderr,
-				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
-				path, strerror(errno),
-				replace_dev_result2string(start_args.result));
+				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s",
+				path, strerror(errno));
+			if (start_args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT)
+				fprintf(stderr, ", %s\n",
+					replace_dev_result2string(start_args.result));
+			else
+				fprintf(stderr, "\n");
 
 			if (errno == EOPNOTSUPP)
 				fprintf(stderr,
@@ -402,11 +412,16 @@ static int print_replace_status(int fd, const char *path, int once)
 
 	for (;;) {
 		args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS;
+		args.result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT;
 		ret = ioctl(fd, BTRFS_IOC_DEV_REPLACE, &args);
 		if (ret) {
-			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s, %s\n",
-				path, strerror(errno),
-				replace_dev_result2string(args.result));
+			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s",
+				path, strerror(errno));
+			if (args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT)
+				fprintf(stderr, ", %s\n",
+					replace_dev_result2string(args.result));
+			else
+				fprintf(stderr, "\n");
 			return ret;
 		}
 
@@ -550,13 +565,18 @@ static int cmd_cancel_replace(int argc, char **argv)
 	}
 
 	args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL;
+	args.result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT;
 	ret = ioctl(fd, BTRFS_IOC_DEV_REPLACE, &args);
 	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret) {
-		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %s, %s\n",
-			path, strerror(e),
-			replace_dev_result2string(args.result));
+		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %s",
+			path, strerror(e));
+		if (args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT)
+			fprintf(stderr, ", %s\n",
+				replace_dev_result2string(args.result));
+		else
+			fprintf(stderr, "\n");
 		return 1;
 	}
 	if (args.result == BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED) {
diff --git a/ioctl.h b/ioctl.h
index f0fc060..df9e4b7 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -141,6 +141,7 @@ struct btrfs_ioctl_dev_replace_status_params {
 #define BTRFS_IOCTL_DEV_REPLACE_CMD_START			0
 #define BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS			1
 #define BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL			2
+#define BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT		-1
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR			0
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED		1
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED		2
-- 
1.8.3.1

