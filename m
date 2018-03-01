Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50445 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965487AbeCACsA (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 28 Feb 2018 21:48:00 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, peteryuchuang@gmail.com
Subject: [PATCH 1/4] btrfs-progs: Limit inline extent below page size
Date: Thu,  1 Mar 2018 10:47:44 +0800
Message-Id: <20180301024747.26192-2-wqu@suse.com>
In-Reply-To: <20180301024747.26192-1-wqu@suse.com>
References: <20180301024747.26192-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel doesn't support to drop extent inside an inlined extent.
And kernel tends to limit inline extent just below sectorsize, so also
limit it in btrfs-progs.

This fixes unexpected -EOPNOTSUPP error from __btrfs_drop_extents() on
converted btrfs.

Fixes: 806528b8755f ("Add Yan Zheng's ext3->btrfs conversion program")
Reported-by: Peter Y. Chuang <peteryuchuang@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index 17cdac76c58c..0282deef339b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -20,6 +20,7 @@
 #define __BTRFS_CTREE_H__
 
 #include <stdbool.h>
+#include "internal.h"
 
 #if BTRFS_FLAT_INCLUDES
 #include "list.h"
@@ -1195,8 +1196,14 @@ static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const struct btrfs_fs_info *info)
 	(offsetof(struct btrfs_file_extent_item, disk_bytenr))
 static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_info *info)
 {
-	return BTRFS_MAX_ITEM_SIZE(info) -
-		BTRFS_FILE_EXTENT_INLINE_DATA_START;
+	/*
+	 * Inline extent larger than pagesize could lead to kernel unexpected
+	 * error when dropping extents, so we need to limit the inline extent
+	 * size to less than sectorsize.
+	 */
+	return min_t(u32, info->sectorsize - 1,
+		     BTRFS_MAX_ITEM_SIZE(info) -
+		     BTRFS_FILE_EXTENT_INLINE_DATA_START);
 }
 
 static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
-- 
2.16.2

