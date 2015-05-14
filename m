Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7072 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933286AbbENDI2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 23:08:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lukas.lueg@gmail.com>
Subject: [PATCH] btrfs-progs: Enhance read_tree_block to avoid memory corruption.
Date: Thu, 14 May 2015 11:06:24 +0800
Message-ID: <1431572784-32124-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the following tree_block check to avoid memory corruption or hostile
image:
1) Check level.
Level >= BTRFS_MAX_LEVEL won't be read out.

2) Nritems.
For nritems == 0 or nr_items > max_nritems, the tree_block won't be read
out.
Max nritems is calculated in a easy method.
For node, it's straightforward, just (nodesize - header size) /
(btrfs_key_ptr)
For leaf, (nodesize - header size) / (btrfs_item), assume btrfs support
item size == 0;

This fixes 3 kernel bugs: BZ#97171, BZ#97191, BZ#97271.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index bf796c6..356150a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -37,8 +37,22 @@
 /* specified errno for check_tree_block */
 #define BTRFS_BAD_BYTENR		(-1)
 #define BTRFS_BAD_FSID			(-2)
+#define BTRFS_BAD_LEVEL			(-3)
+#define BTRFS_BAD_NRITEMS		(-4)
 
 #define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)
+
+/* Calculate max possible nritems for a leaf/node */
+static u32 max_nritems(u8 level, u32 nodesize)
+{
+
+	if (level == 0)
+		return ((nodesize - sizeof(struct btrfs_header)) /
+			sizeof(struct btrfs_item));
+	return ((nodesize - sizeof(struct btrfs_header)) /
+		sizeof(struct btrfs_key_ptr));
+}
+
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
 
@@ -47,6 +61,12 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 
 	if (buf->start != btrfs_header_bytenr(buf))
 		return BTRFS_BAD_BYTENR;
+	if (btrfs_header_level(buf) >= BTRFS_MAX_LEVEL)
+		return BTRFS_BAD_LEVEL;
+	if (btrfs_header_nritems(buf) == 0 ||
+	    btrfs_header_nritems(buf) > max_nritems(btrfs_header_level(buf),
+						    root->nodesize))
+		return BTRFS_BAD_NRITEMS;
 
 	fs_devices = root->fs_info->fs_devices;
 	while (fs_devices) {
@@ -82,6 +102,14 @@ static void print_tree_block_error(struct btrfs_root *root,
 		fprintf(stderr, "bytenr mismatch, want=%llu, have=%llu\n",
 			eb->start, btrfs_header_bytenr(eb));
 		break;
+	case BTRFS_BAD_LEVEL:
+		fprintf(stderr, "bad level, %u > %u\n",
+			btrfs_header_level(eb), BTRFS_MAX_LEVEL);
+		break;
+	case BTRFS_BAD_NRITEMS:
+		fprintf(stderr, "invalid nr_items: %u\n",
+			btrfs_header_nritems(eb));
+		break;
 	}
 }
 
-- 
2.4.0

