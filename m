Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14111 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1032112AbbKEIdQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 03:33:16 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA58WQJp026814
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Nov 2015 16:32:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: debug-tree: Add option to show ondisk block without open_ctree
Date: Thu, 5 Nov 2015 16:33:00 +0800
Message-ID: <1446712380-7654-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1446712380-7654-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1446712380-7654-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new option '-B' to show tree block without calling open_ctree.
It's very useful to debug non-standard super or heavily damaged case.

As it needs nodesize, also adds a new option '-n' to specify nodesize.

Normal user should avoid calling it on random bytes, as it won't check
the validation of the tree block.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-debug-tree.asciidoc | 12 ++++-
 btrfs-debug-tree.c                      | 81 +++++++++++++++++++++++++++++----
 2 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/Documentation/btrfs-debug-tree.asciidoc b/Documentation/btrfs-debug-tree.asciidoc
index 23fc115..a5528cb 100644
--- a/Documentation/btrfs-debug-tree.asciidoc
+++ b/Documentation/btrfs-debug-tree.asciidoc
@@ -25,8 +25,16 @@ Print detailed extents info.
 Print info of btrfs device and root tree dirs only.
 -r::
 Print info of roots only.
--b <block_num>::
-Print info of the specified block only.
+-b <bytenr>::
+Print info of the specified block at logical bytenr.
+-B <bytenr>::
+Print info of the specified block at on-disk bytenr.
+Need to use with '-n <nodesize>' option.
++
+Use with caution, as it won't do normal tree block check.
+
+-n <nodesize>::
+Specify the nodesize for '-B <bytenr>' option.
 
 EXIT STATUS
 -----------
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 8adc39f..52e3de3 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -21,6 +21,8 @@
 #include <unistd.h>
 #include <uuid/uuid.h>
 #include <getopt.h>
+#include <fcntl.h>
+#include <sys/stat.h>
 
 #include "kerncompat.h"
 #include "radix-tree.h"
@@ -41,8 +43,11 @@ static int print_usage(int ret)
 	fprintf(stderr, "\t-r : print info of roots only\n");
 	fprintf(stderr, "\t-R : print info of roots and root backups\n");
 	fprintf(stderr, "\t-u : print info of uuid tree only\n");
-	fprintf(stderr, "\t-b block_num : print info of the specified block"
-                    " only\n");
+	fprintf(stderr, "\t-b bytenr: print info of the specified block"
+                    " at logical bytenr only\n");
+	fprintf(stderr, "\t-B bytenr: print info of the specified block"
+                    " at disk bytenr only, need -n option(use with caution)\n");
+	fprintf(stderr, "\t-n nodesize: specify the nodesize to use with -B\n");
 	fprintf(stderr,
 		"\t-t tree_id : print only the tree with the given id\n");
 	fprintf(stderr, "%s\n", PACKAGE_STRING);
@@ -122,6 +127,41 @@ static void print_old_roots(struct btrfs_super_block *super)
 	}
 }
 
+static int print_ondisk_leaf(const char *device, u64 ondisk_bytenr,
+			     u32 nodesize)
+{
+	struct extent_buffer *buf = NULL;
+	int fd;
+	int ret;
+
+	buf = malloc(sizeof(*buf) + nodesize);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memset(buf, 0, sizeof(buf) + nodesize);
+	buf->start = ondisk_bytenr;
+	buf->len = nodesize;
+	buf->refs = 1;
+	fd = open(device, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		goto out;
+	}
+
+	ret = pread(fd, buf->data, nodesize, ondisk_bytenr);
+	if (ret < nodesize) {
+		ret = (ret < 0 ? ret : -EIO);
+		goto out;
+	}
+
+	/* We don't check anything, user should be responsible for it */
+	btrfs_print_leaf(NULL, buf);
+out:
+	free(buf);
+	return ret;
+}
+
 int main(int ac, char **av)
 {
 	struct btrfs_root *root;
@@ -140,7 +180,9 @@ int main(int ac, char **av)
 	int uuid_tree_only = 0;
 	int roots_only = 0;
 	int root_backups = 0;
-	u64 block_only = 0;
+	u64 logical_only = 0;
+	u64 ondisk_only = 0;
+	u32 nodesize = 0;
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
 
@@ -153,7 +195,7 @@ int main(int ac, char **av)
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(ac, av, "deb:rRut:", long_options, NULL);
+		c = getopt_long(ac, av, "deb:B:rRut:n:", long_options, NULL);
 		if (c < 0)
 			break;
 		switch(c) {
@@ -174,7 +216,13 @@ int main(int ac, char **av)
 				root_backups = 1;
 				break;
 			case 'b':
-				block_only = arg_strtou64(optarg);
+				logical_only = arg_strtou64(optarg);
+				break;
+			case 'B':
+				ondisk_only = arg_strtou64(optarg);
+				break;
+			case 'n':
+				nodesize = arg_strtou64(optarg);
 				break;
 			case 't':
 				tree_id = arg_strtou64(optarg);
@@ -196,6 +244,21 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
+	/* Ondisk_only means we won't need to go through open_ctree */
+	if (ondisk_only) {
+		if (!nodesize) {
+			fprintf(stderr, "-n <nodesize> must be specified\n");
+			exit(1);
+		}
+		ret = print_ondisk_leaf(av[optind], ondisk_only, nodesize);
+		if (ret < 0) {
+			fprintf(stderr,
+				"failed to print leaf at ondisk bytenr: %llu, %s\n",
+				ondisk_only, strerror(-ret));
+			ret = 1;
+		}
+		exit(ret);
+	}
 	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
 	if (!info) {
 		fprintf(stderr, "unable to open %s\n", av[optind]);
@@ -208,9 +271,9 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	if (block_only) {
+	if (logical_only) {
 		leaf = read_tree_block(root,
-				      block_only,
+				      logical_only,
 				      root->leafsize, 0);
 
 		if (extent_buffer_uptodate(leaf) &&
@@ -221,12 +284,12 @@ int main(int ac, char **av)
 
 		if (!leaf) {
 			leaf = read_tree_block(root,
-					      block_only,
+					      logical_only,
 					      root->nodesize, 0);
 		}
 		if (!extent_buffer_uptodate(leaf)) {
 			fprintf(stderr, "failed to read %llu\n",
-				(unsigned long long)block_only);
+				(unsigned long long)logical_only);
 			goto close_root;
 		}
 		btrfs_print_tree(root, leaf, 0);
-- 
2.6.2

