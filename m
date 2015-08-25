Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23066 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932409AbbHYOvr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 10:51:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7PEpcf4004382
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 22:51:38 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: unified error handle for print_replace_status
Date: Tue, 25 Aug 2015 22:50:08 +0800
Message-ID: <8ecb18af6cff4e7f413bfeee8d66aa61dc1aa151.1440514191.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code of print_replace_status() mixed stdout and stderr in
error case, output a error string to stderr without "\n", then
output "\n" to stdout to end the line.

This patch fixed above problem by using unified error handle way for 3
type of errors in print_replace_status().

Also include some small logic cleanup.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-replace.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index ce91787..134addf 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -405,7 +405,6 @@ static int print_replace_status(int fd, const char *path, int once)
 			return ret;
 		}
 
-		status = &args.status;
 		if (args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
 			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) on \"%s\" returns error: %s\n",
 				path,
@@ -413,6 +412,8 @@ static int print_replace_status(int fd, const char *path, int once)
 			return -1;
 		}
 
+		status = &args.status;
+
 		skip_stats = 0;
 		num_chars = 0;
 		switch (status->replace_state) {
@@ -457,12 +458,9 @@ static int print_replace_status(int fd, const char *path, int once)
 			printf("Never started");
 			break;
 		default:
-			prevent_loop = 1;
-			fprintf(stderr,
-				"Unknown btrfs dev replace status:%llu",
-				status->replace_state);
-			ret = -EINVAL;
-			break;
+			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) on \"%s\" got unknown status: %llu\n",
+				path, status->replace_state);
+			return -EINVAL;
 		}
 
 		if (!skip_stats)
@@ -471,9 +469,9 @@ static int print_replace_status(int fd, const char *path, int once)
 				(unsigned long long)status->num_write_errors,
 				(unsigned long long)
 				 status->num_uncorrectable_read_errors);
-		if (once || prevent_loop || ret) {
+		if (once || prevent_loop) {
 			printf("\n");
-			return ret;
+			break;
 		}
 
 		fflush(stdout);
-- 
1.8.5.1

