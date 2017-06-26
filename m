Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63660 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751353AbdFZKTH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 06:19:07 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id B8E5647CA8FD
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jun 2017 18:19:00 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: mkfs: Replace number with a macro
Date: Mon, 26 Jun 2017 18:18:29 +0800
Message-ID: <20170626101829.16021-1-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For code maintainability and scalability,
replace number with a macro of member blocks in btrfs_mkfs_config.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
Changes since v1:
Missing a using place. And modify it.

 mkfs/common.c | 4 ++--
 mkfs/common.h | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mkfs/common.c b/mkfs/common.c
index e4785c5..0d79650 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -94,7 +94,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	uuid_generate(chunk_tree_uuid);
 
 	cfg->blocks[0] = BTRFS_SUPER_INFO_OFFSET;
-	for (i = 1; i < 7; i++) {
+	for (i = 1; i <= BTRFS_MKFS_ROOTS_NR; i++) {
 		cfg->blocks[i] = BTRFS_SUPER_INFO_OFFSET + 1024 * 1024 +
 			cfg->nodesize * i;
 	}
@@ -210,7 +210,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 		cfg->nodesize - sizeof(struct btrfs_header));
 	nritems = 0;
 	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize);
-	for (i = 1; i < 7; i++) {
+	for (i = 1; i <= BTRFS_MKFS_ROOTS_NR; i++) {
 		item_size = sizeof(struct btrfs_extent_item);
 		if (!skinny_metadata)
 			item_size += sizeof(struct btrfs_tree_block_info);
diff --git a/mkfs/common.h b/mkfs/common.h
index 666a75b..e23e79b 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -28,6 +28,9 @@
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE SZ_4M
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE SZ_1G
 
+/* roots: root tree, extent tree, chunk tree, dev tree, fs tree, csum tree */
+#define BTRFS_MKFS_ROOTS_NR 6
+
 struct btrfs_mkfs_config {
 	/* Label of the new filesystem */
 	const char *label;
@@ -43,7 +46,7 @@ struct btrfs_mkfs_config {
 	/* Output fields, set during creation */
 
 	/* Logical addresses of superblock [0] and other tree roots */
-	u64 blocks[8];
+	u64 blocks[BTRFS_MKFS_ROOTS_NR + 1];
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE];
 	char chunk_uuid[BTRFS_UUID_UNPARSED_SIZE];
 
-- 
2.9.4



