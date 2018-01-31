Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14550 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752356AbeAaDJd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 22:09:33 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v3 3/7] btrfs-progs: Sync code with kernel for BTRFS_MAX_INLINE_DATA_SIZE
Date: Wed, 31 Jan 2018 11:09:15 +0800
Message-ID: <1517368159-12858-4-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
References: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do a cleanup. Also make it consistent with kernel.
Use fs_info instead of root for BTRFS_MAX_INLINE_DATA_SIZE, since
maybe in some situation we do not know root, but just know fs_info.

Changelog:
v2->v1:
Change macro to inline function to be consistent with kernel.
And change the function body to match kernel.
v3->v2:
Change the title of this commit to make it more exact.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
 convert/source-ext2.c     |  2 +-
 convert/source-reiserfs.c |  2 +-
 ctree.h                   | 17 ++++++++++++++---
 mkfs/main.c               |  4 ++--
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index e5c2a94..f5ecd8c 100644
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
index e3582bd..39d6f07 100644
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
index f3964f1..7be48e2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -359,9 +359,6 @@ struct btrfs_header {
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
 #define BTRFS_LEAF_DATA_SIZE(fs_info) \
 				(__BTRFS_LEAF_DATA_SIZE(fs_info->nodesize))
-#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
-					sizeof(struct btrfs_item) - \
-					sizeof(struct btrfs_file_extent_item))
 #define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
 				 sizeof(struct btrfs_item) -\
 				 sizeof(struct btrfs_dir_item))
@@ -1188,10 +1185,24 @@ struct btrfs_root {
 	struct rb_node rb_node;
 };
 
+static inline u32 BTRFS_MAX_ITEM_SIZE(const struct btrfs_fs_info *info)
+{
+	return BTRFS_LEAF_DATA_SIZE(info) - sizeof(struct btrfs_item);
+}
+
 static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const struct btrfs_fs_info *info)
 {
 	return BTRFS_LEAF_DATA_SIZE(info) / sizeof(struct btrfs_key_ptr);
 }
+
+#define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
+	(offsetof(struct btrfs_file_extent_item, disk_bytenr))
+static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_info *info)
+{
+	return BTRFS_MAX_ITEM_SIZE(info) -
+		BTRFS_FILE_EXTENT_INLINE_DATA_START;
+}
+
 /*
  * inode items have the data typically returned from stat and store other
  * info about object characteristics.  There is one for every file and dir in
diff --git a/mkfs/main.c b/mkfs/main.c
index d817ad8..a301efc 100644
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
1.9.1



