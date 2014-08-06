Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35415 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbaHFBRL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 21:17:11 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s761H7AN030949
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Aug 2014 09:17:07 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: make 'btrfs replace' signal-handling works.
Date: Wed, 6 Aug 2014 09:17:07 +0800
Message-ID: <1407287827-28694-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current BTRFS_IOC_DEV_REPLACE ioctl is synchronous, and during the ioctl
program is fallen into kernel and unable to handle signal, the original
signal function will never be executed until the dev replace is done.
This is very annoying for someone who wants to stop dev replace by
Ctrl-c (we have to admit that's the most users will do when replacing
dev with nodatacow/nodatasum mount option).

This patch will create a thread to do the ioctl things, making the main
thread able to handle signal correctly.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-replace.c | 46 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 4385d28..9982f52 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -28,6 +28,7 @@
 #include <assert.h>
 #include <inttypes.h>
 #include <sys/wait.h>
+#include <pthread.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -122,10 +123,31 @@ static const char *const cmd_start_replace_usage[] = {
 	NULL
 };
 
+struct ioctl_thread_arg {
+	struct btrfs_ioctl_dev_replace_args *start_args;
+	int fd;
+	int ret;
+};
+
+static void *do_replace_ioctl(void *ptr)
+{
+	struct ioctl_thread_arg *arg = (struct ioctl_thread_arg *) ptr;
+	int ret = 0;
+
+	ret = ioctl(arg->fd, BTRFS_IOC_DEV_REPLACE, arg->start_args);
+	if (ret < 0)
+		ret = -errno;
+	arg->ret = ret;
+	return ptr;
+}
+
 static int cmd_start_replace(int argc, char **argv)
 {
 	struct btrfs_ioctl_dev_replace_args start_args = {0};
 	struct btrfs_ioctl_dev_replace_args status_args = {0};
+	struct ioctl_thread_arg thread_arg = {0};
+	pthread_t ioctl_thread;
+	int join_ret;
 	int ret;
 	int i;
 	int c;
@@ -301,15 +323,31 @@ static int cmd_start_replace(int argc, char **argv)
 	}
 
 	start_args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_START;
-	ret = ioctl(fdmnt, BTRFS_IOC_DEV_REPLACE, &start_args);
+	thread_arg.start_args = &start_args;
+	thread_arg.fd = fdmnt;
+	ret = pthread_create(&ioctl_thread, NULL, do_replace_ioctl,
+			     &thread_arg);
+	if (ret) {
+		fprintf(stderr, "ERROR: fail to create thread: %s\n",
+			strerror(ret));
+		goto leave_with_error;
+	}
+	join_ret = pthread_join(ioctl_thread, NULL);
 	if (do_not_background) {
-		if (ret) {
+		if (join_ret) {
+			fprintf(stderr, "ERROR: fail to join thread: %s\n",
+				strerror(join_ret));
+			goto leave_with_error;
+		}
+
+		ret = thread_arg.ret;
+		if (ret < 0) {
 			fprintf(stderr,
 				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
-				path, strerror(errno),
+				path, strerror(-ret),
 				replace_dev_result2string(start_args.result));
 
-			if (errno == EOPNOTSUPP)
+			if (ret == -EOPNOTSUPP)
 				fprintf(stderr, "WARNING: dev_replace cannot yet handle RAID5/RAID6\n");
 
 			goto leave_with_error;
-- 
2.0.3

