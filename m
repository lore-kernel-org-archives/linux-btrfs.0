Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:64476 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751553AbeCWIUq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 04:20:46 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id C4AFAAC047B
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 17:20:40 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: remove BTRFS_CRC32_SIZE definition
Message-ID: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>
Date: Fri, 23 Mar 2018 17:20:07 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel code no longer has BTRFS_CRC32_SIZE and only uses
btrfs_csum_sizes[]. So, update the progs code as well.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 convert/common.c |  2 +-
 convert/main.c   |  2 +-
 ctree.h          |  3 +--
 image/main.c     |  4 ++--
 mkfs/common.c    | 14 +++++++-------
 5 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/convert/common.c b/convert/common.c
index 3860f3b9..2b944fd8 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -219,7 +219,7 @@ static inline int write_temp_extent_buffer(int fd, struct extent_buffer *buf,
 {
 	int ret;
 
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 
 	/* Temporary extent buffer is always mapped 1:1 on disk */
 	ret = pwrite(fd, buf->data, buf->len, bytenr);
diff --git a/convert/main.c b/convert/main.c
index b3ea31d7..6bdfab40 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1026,7 +1026,7 @@ static int migrate_super_block(int fd, u64 old_bytenr)
 	BUG_ON(btrfs_super_bytenr(super) != old_bytenr);
 	btrfs_set_super_bytenr(super, BTRFS_SUPER_INFO_OFFSET);
 
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
 		BTRFS_SUPER_INFO_OFFSET);
 	if (ret != BTRFS_SUPER_INFO_SIZE)
diff --git a/ctree.h b/ctree.h
index 17cdac76..4175cb85 100644
--- a/ctree.h
+++ b/ctree.h
@@ -167,10 +167,9 @@ struct btrfs_free_space_ctl;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
+/* four bytes for CRC32 */
 static int btrfs_csum_sizes[] = { 4 };
 
-/* four bytes for CRC32 */
-#define BTRFS_CRC32_SIZE 4
 #define BTRFS_EMPTY_DIR_SIZE 0
 
 #define BTRFS_FT_UNKNOWN	0
diff --git a/image/main.c b/image/main.c
index 9c75c8b4..5f155c23 100644
--- a/image/main.c
+++ b/image/main.c
@@ -119,11 +119,11 @@ static struct extent_buffer *alloc_dummy_eb(u64 bytenr, u32 size);
 
 static void csum_block(u8 *buf, size_t len)
 {
-	u8 result[BTRFS_CRC32_SIZE];
+	u8 result[btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32]];
 	u32 crc = ~(u32)0;
 	crc = crc32c(crc, buf + BTRFS_CSUM_SIZE, len - BTRFS_CSUM_SIZE);
 	btrfs_csum_final(crc, result);
-	memcpy(buf, result, BTRFS_CRC32_SIZE);
+	memcpy(buf, result, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32]);
 }
 
 static int has_name(struct btrfs_key *key)
diff --git a/mkfs/common.c b/mkfs/common.c
index 16916ca2..50b99639 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -85,7 +85,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	}
 
 	/* generate checksum */
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 
 	/* write back root tree */
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_ROOT_TREE]);
@@ -276,7 +276,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_EXTENT_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_EXTENT_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -364,7 +364,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_CHUNK_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_CHUNK_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -404,7 +404,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_DEV_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_DEV_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_DEV_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -417,7 +417,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_FS_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_FS_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -429,7 +429,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_CSUM_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_CSUM_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_CSUM_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -440,7 +440,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	memset(buf->data, 0, BTRFS_SUPER_INFO_SIZE);
 	memcpy(buf->data, &super, sizeof(super));
 	buf->len = BTRFS_SUPER_INFO_SIZE;
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
 	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
 			cfg->blocks[MKFS_SUPER_BLOCK]);
 	if (ret != BTRFS_SUPER_INFO_SIZE) {
-- 
2.14.3

