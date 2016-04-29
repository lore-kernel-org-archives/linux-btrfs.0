Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DFF27AD78
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:39 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/16] btrfs: sink gfp parameter to clear_extent_dirty
Date: Fri, 29 Apr 2016 11:20:27 +0200
Message-Id: <af6f8f604d44e05f98ed45a69830547ed133adf8.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Callers pass GFP_NOFS. No need to pass the flags around.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c     | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/extent_io.h   | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3bc88b4b0032..263823f28ba4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4392,7 +4392,7 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 		if (ret)
 			break;
 
-		clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		clear_extent_dirty(unpin, start, end);
 		btrfs_error_unpin_extent_range(root, start, end);
 		cond_resched();
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b1c6d7634e88..61b3dd25ba4c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6408,7 +6408,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			ret = btrfs_discard_extent(root, start,
 						   end + 1 - start, NULL);
 
-		clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		clear_extent_dirty(unpin, start, end);
 		unpin_extent_range(root, start, end, true);
 		mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 		cond_resched();
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b7c258c9fa2d..9e987ee03361 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -279,11 +279,11 @@ static inline int set_extent_dirty(struct extent_io_tree *tree, u64 start,
 }
 
 static inline int clear_extent_dirty(struct extent_io_tree *tree, u64 start,
-		u64 end, gfp_t mask)
+		u64 end)
 {
 	return clear_extent_bit(tree, start, end,
 				EXTENT_DIRTY | EXTENT_DELALLOC |
-				EXTENT_DO_ACCOUNTING, 0, 0, NULL, mask);
+				EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
 }
 
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-- 
2.7.1

