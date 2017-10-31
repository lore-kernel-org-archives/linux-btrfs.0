Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932374AbdJaRtu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:49:50 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B9D2DAD88
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:49:49 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: sink gfp parameter to clear_extent_uptodate
Date: Tue, 31 Oct 2017 18:48:00 +0100
Message-Id: <1c4cbe1d75f5a59e41ac345967ccda81cde1a1c7.1509471989.git.dsterba@suse.com>
In-Reply-To: <cover.1509471989.git.dsterba@suse.com>
References: <cover.1509471989.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's only one callsite with GFP_NOFS.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.h | 4 ++--
 fs/btrfs/inode.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index bc9ebc858fae..e6987b050964 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -341,10 +341,10 @@ static inline int set_extent_bits(struct extent_io_tree *tree, u64 start,
 }
 
 static inline int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
-		u64 end, struct extent_state **cached_state, gfp_t mask)
+		u64 end, struct extent_state **cached_state)
 {
 	return __clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
-				cached_state, mask, NULL);
+				cached_state, GFP_NOFS, NULL);
 }
 
 static inline int set_extent_dirty(struct extent_io_tree *tree, u64 start,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c6d2798b5f67..8de8b38ee22f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3067,7 +3067,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		else
 			start = ordered_extent->file_offset;
 		end = ordered_extent->file_offset + ordered_extent->len - 1;
-		clear_extent_uptodate(io_tree, start, end, NULL, GFP_NOFS);
+		clear_extent_uptodate(io_tree, start, end, NULL);
 
 		/* Drop the cache for the part of the extent we didn't write. */
 		btrfs_drop_extent_cache(BTRFS_I(inode), start, end, 0);
-- 
2.14.0

