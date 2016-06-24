Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbcFXWPa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1FFD5ADB9
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:27 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/31] btrfs: convert nodesize macros to static inlines
Date: Fri, 24 Jun 2016 18:15:04 -0400
Message-Id: <1466806524-27508-12-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch converts the macros used to calculate various node
size limits to static inlines.  That way we get type checking for free.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1d3c4b5..95fe439 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -145,21 +145,6 @@ struct btrfs_header {
 	u8 level;
 } __attribute__ ((__packed__));
 
-#define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->nodesize - \
-				      sizeof(struct btrfs_header)) / \
-				     sizeof(struct btrfs_key_ptr))
-#define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
-#define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->nodesize))
-#define BTRFS_MAX_ITEM_SIZE(r) \
-	(BTRFS_LEAF_DATA_SIZE(r) - sizeof(struct btrfs_item))
-#define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
-		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
-#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_MAX_ITEM_SIZE(r) - \
-					BTRFS_FILE_EXTENT_INLINE_DATA_START)
-#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_MAX_ITEM_SIZE(r) - \
-				 sizeof(struct btrfs_dir_item))
-
-
 /*
  * this is a very generous portion of the super block, giving us
  * room to translate 14 chunks with 3 stripes each.
@@ -1257,6 +1242,39 @@ struct btrfs_root {
 	atomic_t qgroup_meta_rsv;
 };
 
+static inline u32 __BTRFS_LEAF_DATA_SIZE(u32 blocksize)
+{
+	return blocksize - sizeof(struct btrfs_header);
+}
+
+static inline u32 BTRFS_LEAF_DATA_SIZE(const struct btrfs_root *root)
+{
+	return __BTRFS_LEAF_DATA_SIZE(root->nodesize);
+}
+
+static inline u32 BTRFS_MAX_ITEM_SIZE(const struct btrfs_root *root)
+{
+	return BTRFS_LEAF_DATA_SIZE(root) - sizeof(struct btrfs_item);
+}
+
+static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const struct btrfs_root *root)
+{
+	return BTRFS_LEAF_DATA_SIZE(root) / sizeof(struct btrfs_key_ptr);
+}
+
+#define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
+		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
+static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_root *root)
+{
+	return BTRFS_MAX_ITEM_SIZE(root) -
+	       BTRFS_FILE_EXTENT_INLINE_DATA_START;
+}
+
+static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_root *root)
+{
+	return BTRFS_MAX_ITEM_SIZE(root) - sizeof(struct btrfs_dir_item);
+}
+
 /*
  * Flags for mount options.
  *
-- 
2.7.1

