Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13036 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751531AbeAZDWN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 22:22:13 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 805FB49F19B6
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 11:22:10 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/6] btrfs-progs: Use fs_info instead of root for BTRFS_MAX_INLINE_DATA_SIZE
Date: Fri, 26 Jan 2018 11:22:03 +0800
Message-ID: <1516936926-18707-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do a cleanup. Also make it consistent with kernel.
Use fs_info instead of root for BTRFS_MAX_INLINE_DATA_SIZE, since
maybe in some situation we do not know root, but just know fs_info.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 convert/source-ext2.c     | 2 +-
 convert/source-reiserfs.c | 2 +-
 ctree.h                   | 2 +-
 mkfs/main.c               | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index e5c2a943..f5ecd8cf 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -309,7 +309,7 @@ static int ext2_create_file_extents(struct btrfs_trans_handle *trans,
 		goto fail;
 	if ((convert_flags & CONVERT_FLAG_INLINE_DATA) && data.first_block == 0
 	    && data.num_blocks > 0
-	    && inode_size <= BTRFS_MAX_INLINE_DATA_SIZE(root)) {
+	    && inode_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
 		u64 num_bytes = data.num_blocks * sectorsize;
 		u64 disk_bytenr = data.disk_block * sectorsize;
 		u64 nbytes;
diff --git a/convert/source-reiserfs.c b/convert/source-reiserfs.c
index e3582bda..39d6f072 100644
--- a/convert/source-reiserfs.c
+++ b/convert/source-reiserfs.c
@@ -376,7 +376,7 @@ static int reiserfs_convert_tail(struct btrfs_trans_handle *trans,
 	u64 isize;
 	int ret;
 
-	if (length >= BTRFS_MAX_INLINE_DATA_SIZE(root))
+	if (length >= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
 		return convert_direct(trans, root, objectid, inode, body,
 				      length, offset, convert_flags);
 
diff --git a/ctree.h b/ctree.h
index 9e9d3d22..ace93cc3 100644
--- a/ctree.h
+++ b/ctree.h
@@ -361,7 +361,7 @@ struct btrfs_header {
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
 #define BTRFS_LEAF_DATA_SIZE(fs_info) \
 				(__BTRFS_LEAF_DATA_SIZE(fs_info->nodesize))
-#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
+#define BTRFS_MAX_INLINE_DATA_SIZE(fs_info) (BTRFS_LEAF_DATA_SIZE(fs_info) - \
 					sizeof(struct btrfs_item) - \
 					sizeof(struct btrfs_file_extent_item))
 #define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
diff --git a/mkfs/main.c b/mkfs/main.c
index d817ad8d..a301efc3 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -498,7 +498,7 @@ static int fill_inode_item(struct btrfs_trans_handle *trans,
 	}
 	if (S_ISREG(src->st_mode)) {
 		btrfs_set_stack_inode_size(dst, (u64)src->st_size);
-		if (src->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root))
+		if (src->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
 			btrfs_set_stack_inode_nbytes(dst, src->st_size);
 		else {
 			blocks = src->st_size / sectorsize;
@@ -686,7 +686,7 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 	if (st->st_size % sectorsize)
 		blocks += 1;
 
-	if (st->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root)) {
+	if (st->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
 		char *buffer = malloc(st->st_size);
 
 		if (!buffer) {
-- 
2.14.3



