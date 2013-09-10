Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3IJCaw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 22:30:52 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 18/20] Btrfs-progs: fix magic return value in cmds-balance.c
Date: Tue, 10 Sep 2013 10:28:29 +0800
Message-Id: <1378780109-8591-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If there is no balance in progress, resume/pause/cancel
will return 2. Usage or syntax errors will return 1.
And 0 means operations return successfully.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2:
	Address comments from Ilya Dryomov.
---
 cmds-balance.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index b7382ef..a151475 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -299,7 +299,7 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_V2, args);
@@ -330,7 +330,7 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 			if (e != EINPROGRESS)
 				fprintf(stderr, "There may be more info in "
 					"syslog - try dmesg | tail\n");
-			ret = 19;
+			ret = 1;
 		}
 	} else {
 		printf("Done, had to relocate %llu out of %llu chunks\n",
@@ -498,7 +498,7 @@ static int cmd_balance_pause(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_PAUSE);
@@ -508,7 +508,10 @@ static int cmd_balance_pause(int argc, char **argv)
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: balance pause on '%s' failed - %s\n",
 			path, (e == ENOTCONN) ? "Not running" : strerror(e));
-		return 19;
+		if (e == ENOTCONN)
+			return 2;
+		else
+			return 1;
 	}
 
 	return 0;
@@ -536,7 +539,7 @@ static int cmd_balance_cancel(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_CANCEL);
@@ -546,7 +549,10 @@ static int cmd_balance_cancel(int argc, char **argv)
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: balance cancel on '%s' failed - %s\n",
 			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
-		return 19;
+		if (e == ENOTCONN)
+			return 2;
+		else
+			return 1;
 	}
 
 	return 0;
@@ -575,7 +581,7 @@ static int cmd_balance_resume(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	memset(&args, 0, sizeof(args));
@@ -596,12 +602,15 @@ static int cmd_balance_resume(int argc, char **argv)
 				"failed - %s\n", path,
 				(e == ENOTCONN) ? "Not in progress" :
 						  "Already running");
-			return 19;
+			if (e == ENOTCONN)
+				return 2;
+			else
+				return 1;
 		} else {
 			fprintf(stderr,
 "ERROR: error during balancing '%s' - %s\n"
 "There may be more info in syslog - try dmesg | tail\n", path, strerror(e));
-			return 19;
+			return 1;
 		}
 	} else {
 		printf("Done, had to relocate %llu out of %llu chunks\n",
-- 
1.8.3.1

