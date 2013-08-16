Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44682 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3HPI2A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 04:28:00 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: pth@suse.de, sf@suse.de, dave@jikos.cz, jeff.liu@oracle.com
Subject: [RFC PATCH] Btrfs: export btrfs space shared info to userspace
Date: Fri, 16 Aug 2013 16:27:28 +0800
Message-Id: <1376641648-25015-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Similar to ocfs2, btrfs also supports that extents can be shared by
different inodes, and there are some userspace tools requesting
for this kind of 'space shared infomation'.[1]

ocfs2 uses flag FIEMAP_EXTENT_SHARED, so does btrfs.

[1]: http://thr3ads.net/ocfs2-devel/2010/09/489052-PATCH-3-3-shared-du-using-fiemap-to-figure-up-the-shared-extents-per-file-and-the-footprint-in

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fe443fe..2b3dd4a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -20,6 +20,7 @@
 #include "check-integrity.h"
 #include "locking.h"
 #include "rcu-string.h"
+#include "backref.h"
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -3957,6 +3958,19 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 	return NULL;
 }
 
+static noinline int count_ext_ref(u64 inum, u64 offset, u64 root_id, void *ctx)
+{
+	int cnt = *((int *)ctx);
+
+	cnt++;
+	*((int *)ctx) = cnt;
+
+	/* Now we're sure that the extent is shared. */
+	if (cnt > 1)
+		return 1;
+	return 0;
+}
+
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent)
 {
@@ -4023,7 +4037,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		last = found_key.offset;
 		last_for_get_extent = last + 1;
 	}
-	btrfs_free_path(path);
+	btrfs_release_path(path);
 
 	/*
 	 * we might have some extents allocated but more delalloc past those
@@ -4093,7 +4107,24 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			flags |= (FIEMAP_EXTENT_DELALLOC |
 				  FIEMAP_EXTENT_UNKNOWN);
 		} else {
+			int ref_cnt = 0;
+
 			disko = em->block_start + offset_in_extent;
+
+			/*
+			 * As btrfs supports shared space, this information
+			 * can be exported to userspace tools via
+			 * flag FIEMAP_EXTENT_SHARED.
+			 */
+			ret = iterate_inodes_from_logical(
+					em->block_start,
+					BTRFS_I(inode)->root->fs_info,
+					path, count_ext_ref, &ref_cnt);
+			if (ret < 0)
+				goto out_free;
+
+			if (ref_cnt > 1)
+				flags |= FIEMAP_EXTENT_SHARED;
 		}
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 			flags |= FIEMAP_EXTENT_ENCODED;
@@ -4127,6 +4158,7 @@ out_free:
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len - 1,
 			     &cached_state, GFP_NOFS);
+	btrfs_free_path(path);
 	return ret;
 }
 
-- 
1.7.7

