Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbcGNM30 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 08:29:26 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: chandan@linux.vnet.ibm.com, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: allocate exact page array size in extent_buffer
Date: Thu, 14 Jul 2016 14:29:32 +0200
Message-Id: <1468499372-24687-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The calculation of extent_buffer::pages size was done for 4k PAGE_SIZE,
but this wastes 15 unused pointers on arches with large page size. Eg.
on ppc64 this gives 15 * 8 = 120 bytes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h     | 6 ------
 fs/btrfs/extent_io.c | 2 ++
 fs/btrfs/extent_io.h | 8 +++++++-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4274a7bfdaed..f914f6187753 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -66,12 +66,6 @@ struct btrfs_ordered_sum;
 #define BTRFS_COMPAT_EXTENT_TREE_V0
 
 /*
- * the max metadata block size.  This limit is somewhat artificial,
- * but the memmove costs go through the roof for larger blocks.
- */
-#define BTRFS_MAX_METADATA_BLOCKSIZE 65536
-
-/*
  * we can actually store much bigger names, but lets not confuse the rest
  * of linux
  */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 75533adef998..6f468a1842e6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4660,6 +4660,8 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	/*
 	 * Sanity checks, currently the maximum is 64k covered by 16x 4k pages
 	 */
+	BUILD_BUG_ON(INLINE_EXTENT_BUFFER_PAGES * PAGE_SIZE
+		!= BTRFS_MAX_METADATA_BLOCKSIZE);
 	BUILD_BUG_ON(BTRFS_MAX_METADATA_BLOCKSIZE
 		> MAX_INLINE_EXTENT_BUFFER_SIZE);
 	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c0c1c4fef6ce..edfa1a0ab82b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -4,6 +4,12 @@
 #include <linux/rbtree.h>
 #include "ulist.h"
 
+/*
+ * The maximum metadata block size.  This limit is somewhat artificial,
+ * but the memmove costs go through the roof for larger blocks.
+ */
+#define BTRFS_MAX_METADATA_BLOCKSIZE (65536U)
+
 /* bits for the extent state */
 #define EXTENT_DIRTY		(1U << 0)
 #define EXTENT_WRITEBACK	(1U << 1)
@@ -118,7 +124,7 @@ struct extent_state {
 #endif
 };
 
-#define INLINE_EXTENT_BUFFER_PAGES 16
+#define INLINE_EXTENT_BUFFER_PAGES    (BTRFS_MAX_METADATA_BLOCKSIZE / PAGE_SIZE)
 #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_SIZE)
 struct extent_buffer {
 	u64 start;
-- 
2.7.1

