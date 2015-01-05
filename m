Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2375 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbbAEG02 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 01:26:28 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t056Psj3007432
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Jan 2015 14:25:54 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Allow debug-tree to be executed on regular file.
Date: Mon, 5 Jan 2015 14:24:27 +0800
Message-ID: <1420439067-27380-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The commit 1bad43fbe002 ("btrfs-progs: refine btrfs-debug-tree error
prompt when a mount point given")
add judgement on btrfs-debug-tree to restrict only block device to be
executed on, but the command can also be used on regular file, so add
regular file support for the judgement.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-debug-tree.c |  5 +++--
 utils.c            | 21 +++++++++++++++++----
 utils.h            |  1 +
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 9cdb35f..0815fe1 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -180,8 +180,9 @@ int main(int ac, char **av)
 		print_usage();
 
 	ret = check_arg_type(av[optind]);
-	if (ret != BTRFS_ARG_BLKDEV) {
-		fprintf(stderr, "'%s' is not a block device\n", av[optind]);
+	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
+		fprintf(stderr, "'%s' is not a block device or regular file\n",
+			av[optind]);
 		exit(1);
 	}
 
diff --git a/utils.c b/utils.c
index af0a8fe..3ca8229 100644
--- a/utils.c
+++ b/utils.c
@@ -854,13 +854,23 @@ int is_mount_point(const char *path)
 	return ret;
 }
 
+static int is_reg_file(const char *path)
+{
+	struct stat statbuf;
+
+	if (stat(path, &statbuf) < 0)
+		return -errno;
+	return S_ISREG(statbuf.st_mode);
+}
+
 /*
  * This function checks if the given input parameter is
  * an uuid or a path
- * return -1: some error in the given input
- * return 0: unknow input
- * return 1: given input is uuid
- * return 2: given input is path
+ * return <0 : some error in the given input
+ * return BTRFS_ARG_UNKNOWN:	unknown input
+ * return BTRFS_ARG_UUID:	given input is uuid
+ * return BTRFS_ARG_MNTPOINT:	given input is path
+ * return BTRFS_ARG_REG:	given input is regular file
  */
 int check_arg_type(const char *input)
 {
@@ -877,6 +887,9 @@ int check_arg_type(const char *input)
 		if (is_mount_point(path) == 1)
 			return BTRFS_ARG_MNTPOINT;
 
+		if (is_reg_file(path))
+			return BTRFS_ARG_REG;
+
 		return BTRFS_ARG_UNKNOWN;
 	}
 
diff --git a/utils.h b/utils.h
index 3950491..142f3f9 100644
--- a/utils.h
+++ b/utils.h
@@ -35,6 +35,7 @@
 #define BTRFS_ARG_MNTPOINT	1
 #define BTRFS_ARG_UUID		2
 #define BTRFS_ARG_BLKDEV	3
+#define BTRFS_ARG_REG		4
 
 #define BTRFS_UUID_UNPARSED_SIZE	37
 
-- 
2.2.1

