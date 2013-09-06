Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50446 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3IFJbM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Sep 2013 05:31:12 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs-progs: use btrfs error code for kernel errors
Date: Fri,  6 Sep 2013 17:38:02 +0800
Message-Id: <1378460282-20680-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1376979054-2883-1-git-send-email-anand.jain@oracle.com>
References: <1376979054-2883-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now with the below kernel patch, the excl operations like dev
add/replace/resize and balance returns the btrfs error
code defined in btrfs.h, this patch will help btrfs-progs
(and thus user) to know the error string on the terminal
(instead of /var/log/messages as previously kernel did).

This patch depends on the btrfs kernel patch:
  btrfs: return btrfs error code for dev excl ops err

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-balance.c    |   15 +++++++++++++++
 cmds-device.c     |    7 ++++++-
 cmds-filesystem.c |    6 +++++-
 cmds-replace.c    |    7 ++++++-
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index b7382ef..4407a13 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -316,6 +316,12 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 			if (ret == 0)
 				goto out;
 			e = errno;
+			if (ret > 0) {
+				fprintf(stderr,
+					"ERROR: Balance failed due to - %s\n",
+					btrfs_err_str(ret));
+				goto out;
+			}
 		}
 
 		if (e == ECANCELED) {
@@ -332,6 +338,11 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 					"syslog - try dmesg | tail\n");
 			ret = 19;
 		}
+	} else if (ret > 0) {
+		fprintf(stderr,
+			"ERROR: Balance start failed - %s\n",
+			btrfs_err_str(ret));
+		ret = 1;
 	} else {
 		printf("Done, had to relocate %llu out of %llu chunks\n",
 		       (unsigned long long)args->stat.completed,
@@ -603,6 +614,10 @@ static int cmd_balance_resume(int argc, char **argv)
 "There may be more info in syslog - try dmesg | tail\n", path, strerror(e));
 			return 19;
 		}
+	} else if (ret > 0) {
+		fprintf(stderr,
+			"ERROR: Balance resume failed - %s\n",
+			btrfs_err_str(ret));
 	} else {
 		printf("Done, had to relocate %llu out of %llu chunks\n",
 		       (unsigned long long)args.stat.completed,
diff --git a/cmds-device.c b/cmds-device.c
index f3d4b67..bad4e15 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -111,10 +111,15 @@ static int cmd_add_dev(int argc, char **argv)
 		strncpy_null(ioctl_args.name, argv[i]);
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		e = errno;
-		if(res<0){
+		if (res < 0) {
 			fprintf(stderr, "ERROR: error adding the device '%s' - %s\n",
 				argv[i], strerror(e));
 			ret++;
+		} else if (res > 0) {
+			fprintf(stderr,
+				"ERROR: adding the device '%s' - %s\n",
+				argv[i], btrfs_err_str(res));
+			ret = 1;
 		}
 
 	}
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 21f2096..2cf2228 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -577,10 +577,14 @@ static int cmd_resize(int argc, char **argv)
 	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
 	e = errno;
 	close_file_or_dir(fd, dirstream);
-	if( res < 0 ){
+	if (res < 0) {
 		fprintf(stderr, "ERROR: unable to resize '%s' - %s\n", 
 			path, strerror(e));
 		return 30;
+	} else if (res > 0) {
+		fprintf(stderr, "ERROR: resize failed - %s\n",
+			btrfs_err_str(res));
+		return res;
 	}
 	return 0;
 }
diff --git a/cmds-replace.c b/cmds-replace.c
index 1df719b..e89f8cc 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -297,12 +297,17 @@ static int cmd_start_replace(int argc, char **argv)
 	start_args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_START;
 	ret = ioctl(fdmnt, BTRFS_IOC_DEV_REPLACE, &start_args);
 	if (do_not_background) {
-		if (ret) {
+		if (ret < 0) {
 			fprintf(stderr,
 				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
 				path, strerror(errno),
 				replace_dev_result2string(start_args.result));
 			goto leave_with_error;
+		} else if (ret > 0) {
+			fprintf(stderr,
+				"ERROR: replace start failed on %s - %s\n",
+				path, btrfs_err_str(ret));
+			goto leave_with_error;
 		}
 
 		if (start_args.result !=
-- 
1.7.1

