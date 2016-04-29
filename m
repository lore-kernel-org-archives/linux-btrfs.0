Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JUr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:47 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9EAFAAD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:46 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 06/16] btrfs: sink gfp parameter to set_extent_defrag
Date: Fri, 29 Apr 2016 11:20:33 +0200
Message-Id: <018ed4f788870fdf6e625d04aa287080bdc8a54f.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Single caller passes GFP_NOFS.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.h | 4 ++--
 fs/btrfs/ioctl.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e99a6befdbf5..a1cf4b1dd290 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -299,11 +299,11 @@ static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
 }
 
 static inline int set_extent_defrag(struct extent_io_tree *tree, u64 start,
-		u64 end, struct extent_state **cached_state, gfp_t mask)
+		u64 end, struct extent_state **cached_state)
 {
 	return set_extent_bit(tree, start, end,
 			      EXTENT_DELALLOC | EXTENT_UPTODATE | EXTENT_DEFRAG,
-			      NULL, cached_state, mask);
+			      NULL, cached_state, GFP_NOFS);
 }
 
 static inline int set_extent_new(struct extent_io_tree *tree, u64 start,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5a23806ae418..72f48252a55d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1228,7 +1228,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 
 	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
-			  &cached_state, GFP_NOFS);
+			  &cached_state);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
-- 
2.7.1

