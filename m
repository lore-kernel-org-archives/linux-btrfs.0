Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbcFXWP3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0C966AD9C
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:27 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/31] btrfs: introduce BTRFS_MAX_ITEM_SIZE
Date: Fri, 24 Jun 2016 18:15:03 -0400
Message-Id: <1466806524-27508-11-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We use BTRFS_LEAF_DATA_SIZE - sizeof(struct btrfs_item) in
several places.  This introduces a BTRFS_MAX_ITEM_SIZE macro to do the
same.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       | 8 ++++----
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/file-item.c   | 5 ++---
 fs/btrfs/volumes.c     | 3 +--
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bff6ce6..1d3c4b5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -150,13 +150,13 @@ struct btrfs_header {
 				     sizeof(struct btrfs_key_ptr))
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
 #define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->nodesize))
+#define BTRFS_MAX_ITEM_SIZE(r) \
+	(BTRFS_LEAF_DATA_SIZE(r) - sizeof(struct btrfs_item))
 #define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
 		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
-#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
-					sizeof(struct btrfs_item) - \
+#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_MAX_ITEM_SIZE(r) - \
 					BTRFS_FILE_EXTENT_INLINE_DATA_START)
-#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r) - \
-				 sizeof(struct btrfs_item) -\
+#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_MAX_ITEM_SIZE(r) - \
 				 sizeof(struct btrfs_dir_item))
 
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ee8cd29..e4af375 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2769,7 +2769,7 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes)
 	u64 num_csums_per_leaf;
 	u64 num_csums;
 
-	csum_size = BTRFS_LEAF_DATA_SIZE(root) - sizeof(struct btrfs_item);
+	csum_size = BTRFS_MAX_ITEM_SIZE(root);
 	num_csums_per_leaf = div64_u64(csum_size,
 			(u64)btrfs_super_csum_size(root->fs_info->super_copy));
 	num_csums = div64_u64(csum_bytes, root->sectorsize);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 62a81ee..fc6390e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -27,9 +27,8 @@
 #include "print-tree.h"
 #include "compression.h"
 
-#define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
-				   sizeof(struct btrfs_item) * 2) / \
-				  size) - 1))
+#define __MAX_CSUM_ITEMS(r, size) \
+	((unsigned long)(((BTRFS_MAX_ITEM_SIZE(r) * 2) / size) - 1))
 
 #define MAX_CSUM_ITEMS(r, size) (min_t(u32, __MAX_CSUM_ITEMS(r, size), \
 				       PAGE_SIZE))
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ca98cac..49c9851 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4514,8 +4514,7 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 	btrfs_set_fs_incompat(info, RAID56);
 }
 
-#define BTRFS_MAX_DEVS(r) ((BTRFS_LEAF_DATA_SIZE(r)		\
-			- sizeof(struct btrfs_item)		\
+#define BTRFS_MAX_DEVS(r) ((BTRFS_MAX_ITEM_SIZE(r)		\
 			- sizeof(struct btrfs_chunk))		\
 			/ sizeof(struct btrfs_stripe) + 1)
 
-- 
2.7.1

