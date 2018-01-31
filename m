Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38079 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752416AbeAaDJe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 22:09:34 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v3 4/7] btrfs-progs: Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE
Date: Wed, 31 Jan 2018 11:09:16 +0800
Message-ID: <1517368159-12858-5-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
References: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do a cleanup. Also make it consistent with kernel.
Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE, since
maybe in some situation we do not know root, but just know fs_info.

Changelog:
v2->v1:
To be consistent with kernel, change macro to inline function.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h    | 9 +++++----
 dir-item.c | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/ctree.h b/ctree.h
index 7be48e2..679bbc9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -359,10 +359,6 @@ struct btrfs_header {
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
 #define BTRFS_LEAF_DATA_SIZE(fs_info) \
 				(__BTRFS_LEAF_DATA_SIZE(fs_info->nodesize))
-#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
-				 sizeof(struct btrfs_item) -\
-				 sizeof(struct btrfs_dir_item))
-
 
 /*
  * this is a very generous portion of the super block, giving us
@@ -1203,6 +1199,11 @@ static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_info *info)
 		BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
+static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
+{
+	return BTRFS_MAX_ITEM_SIZE(info) - sizeof(struct btrfs_dir_item);
+}
+
 /*
  * inode items have the data typically returned from stat and store other
  * info about object characteristics.  There is one for every file and dir in
diff --git a/dir-item.c b/dir-item.c
index 462546c..0b7250c 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -311,7 +311,8 @@ static int verify_dir_item(struct btrfs_root *root,
 
 	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
 	if ((btrfs_dir_data_len(leaf, dir_item) +
-	     btrfs_dir_name_len(leaf, dir_item)) > BTRFS_MAX_XATTR_SIZE(root)) {
+	     btrfs_dir_name_len(leaf, dir_item)) >
+			BTRFS_MAX_XATTR_SIZE(root->fs_info)) {
 		fprintf(stderr, "invalid dir item name + data len: %u + %u\n",
 		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
-- 
1.9.1



