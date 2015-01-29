Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53445 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758222AbbA2JI2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:28 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0T97kaY026090
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 17:07:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 01/10] btrfs-progs: Cleanup check_tree_block() function and split the output to print_tree_block_err() function.
Date: Thu, 29 Jan 2015 17:07:16 +0800
Message-ID: <1422522437-18886-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, check_tree_block() will print error on bytenr
mismatch but don't output error on fsid mismatch.

This patch will modify check_tree_block(), so it will only return errno
but not print error messages.
The error message will be output by print_tree_block_err() function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v3:
  Newly introduced.
---
 disk-io.c | 45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 7f03790..e14a143 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -22,6 +22,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <uuid/uuid.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -33,17 +34,18 @@
 #include "print-tree.h"
 #include "rbtree-utils.h"
 
+/* specified errno for check_tree_block */
+#define EBYTENR		1
+#define EFSID		2
+
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
 
 	struct btrfs_fs_devices *fs_devices;
-	int ret = 1;
+	int ret = -EFSID;
 
-	if (buf->start != btrfs_header_bytenr(buf)) {
-		printk("Check tree block failed, want=%Lu, have=%Lu\n",
-		       buf->start, btrfs_header_bytenr(buf));
-		return ret;
-	}
+	if (buf->start != btrfs_header_bytenr(buf))
+		return -EBYTENR;
 
 	fs_devices = root->fs_info->fs_devices;
 	while (fs_devices) {
@@ -58,6 +60,30 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 	return ret;
 }
 
+static void print_tree_block_err(struct btrfs_root *root,
+				struct extent_buffer *eb,
+				int err)
+{
+	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = {'\0'};
+	char found_uuid[BTRFS_UUID_UNPARSED_SIZE] = {'\0'};
+	u8 buf[BTRFS_UUID_SIZE];
+
+	switch (err) {
+	case -EFSID:
+		read_extent_buffer(eb, buf, btrfs_header_fsid(),
+				   BTRFS_UUID_SIZE);
+		uuid_unparse(buf, found_uuid);
+		uuid_unparse(root->fs_info->fsid, fs_uuid);
+		fprintf(stderr, "fsid mismatch, want=%s, have=%s\n",
+			fs_uuid, found_uuid);
+		break;
+	case -EBYTENR:
+		fprintf(stderr, "bytenr mismatch, want=%llu, have=%llu\n",
+			eb->start, btrfs_header_bytenr(eb));
+		break;
+	}
+}
+
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
 {
 	return crc32c(seed, data, len);
@@ -280,7 +306,8 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 		}
 		if (ignore) {
 			if (check_tree_block(root, eb))
-				printk("read block failed check_tree_block\n");
+				print_tree_block_err(root, eb,
+						check_tree_block(root, eb));
 			else
 				printk("Csum didn't match\n");
 			break;
@@ -342,8 +369,10 @@ static int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct extent_buffer *eb)
 {
-	if (check_tree_block(root, eb))
+	if (check_tree_block(root, eb)) {
+		print_tree_block_err(root, eb, check_tree_block(root, eb));
 		BUG();
+	}
 
 	if (!btrfs_buffer_uptodate(eb, trans->transid))
 		BUG();
-- 
2.2.2

