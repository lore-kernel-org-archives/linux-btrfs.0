Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46452 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3H3IgP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 04:36:15 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7U8aE3r013700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 08:36:14 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7U8aDea024151
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 08:36:13 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7U8aCXW021277
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 08:36:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: use btrfs error code for kernel errors
Date: Fri, 30 Aug 2013 16:42:51 +0800
Message-Id: <1377852171-4155-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1376657550-15011-1-git-send-email-anand.jain@oracle.com>
References: <1376657550-15011-1-git-send-email-anand.jain@oracle.com>
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
index c78b726..30019be 100644
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
index 833ad30..282590c 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -120,10 +120,15 @@ static int cmd_add_dev(int argc, char **argv)
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
index 412f793..2f6a0ab 100644
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
index 8ed92c4..e3ff695 100644
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

