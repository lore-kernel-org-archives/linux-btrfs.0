Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2461 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754286AbdKGCVQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 21:21:16 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id AF09948089CD
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Nov 2017 10:21:01 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: fi defrag: clean up duplicate code if find errors
Date: Tue, 7 Nov 2017 10:24:30 +0800
Message-ID: <20171107022431.17938-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function cmd_filesystem_defrag(), lines of code for error handling
are duplicate and hard to expand in further.

Create a jump label for errors.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7728430f16a1..0893a44f28fe 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1029,29 +1029,27 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		if (fd < 0) {
 			error("cannot open %s: %s", argv[i],
 					strerror(errno));
-			defrag_global_errors++;
-			close_file_or_dir(fd, dirstream);
-			continue;
+			ret = fd;
+			goto next;
 		}
-		if (fstat(fd, &st)) {
+
+		ret = fstat(fd, &st);
+		if (ret) {
 			error("failed to stat %s: %s",
 					argv[i], strerror(errno));
-			defrag_global_errors++;
-			close_file_or_dir(fd, dirstream);
-			continue;
+			goto next;
 		}
 		if (!(S_ISDIR(st.st_mode) || S_ISREG(st.st_mode))) {
 			error("%s is not a directory or a regular file",
 					argv[i]);
-			defrag_global_errors++;
-			close_file_or_dir(fd, dirstream);
-			continue;
+			ret = -EINVAL;
+			goto next;
 		}
 		if (recursive && S_ISDIR(st.st_mode)) {
 			ret = nftw(argv[i], defrag_callback, 10,
 						FTW_MOUNT | FTW_PHYS);
 			if (ret == ENOTTY)
-				exit(1);
+				break;
 			/* errors are handled in the callback */
 			ret = 0;
 		} else {
@@ -1060,20 +1058,26 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 			ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE,
 					&defrag_global_range);
 			defrag_err = errno;
-		}
-		close_file_or_dir(fd, dirstream);
-		if (ret && defrag_err == ENOTTY) {
-			error(
+			if (ret && defrag_err == ENOTTY) {
+				error(
 "defrag range ioctl not supported in this kernel version, 2.6.33 and newer is required");
-			defrag_global_errors++;
-			break;
+				defrag_global_errors++;
+				close_file_or_dir(fd, dirstream);
+				break;
+			}
+
+			if (ret) {
+				error("defrag failed on %s: %s", argv[i],
+				      strerror(defrag_err));
+				goto next;
+			}
 		}
-		if (ret) {
-			error("defrag failed on %s: %s", argv[i],
-					strerror(defrag_err));
+next:
+		if (ret)
 			defrag_global_errors++;
-		}
+		close_file_or_dir(fd, dirstream);
 	}
+
 	if (defrag_global_errors)
 		fprintf(stderr, "total %d failures\n", defrag_global_errors);
 
-- 
2.15.0



