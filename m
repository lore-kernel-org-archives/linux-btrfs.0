Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63526 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750829AbdK1JLK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 04:11:10 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 1/3] btrfs-progs: fi defrag: clean up duplicate code if find errors
Date: Tue, 28 Nov 2017 17:14:48 +0800
Message-ID: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function cmd_filesystem_defrag(), lines of code for error handling
are duplicate and hard to expand in further.

Create a jump label for errors.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2:	Record -errno to return value if open() and fstat() failed.
	Move change "do no exit if defrag range ioctl is unsupported"
	to another patch.
	Suggested by David.
---
 cmds-filesystem.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7728430f16a1..17d399d58adf 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1029,23 +1029,22 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		if (fd < 0) {
 			error("cannot open %s: %s", argv[i],
 					strerror(errno));
-			defrag_global_errors++;
-			close_file_or_dir(fd, dirstream);
-			continue;
+			ret = -errno;
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
+			ret = -errno;
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
@@ -1060,20 +1059,25 @@ static int cmd_filesystem_defrag(int argc, char **argv)
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



