Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbbLCQ6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:58:37 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0FC3DADD8
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:58:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/12] btrfs: make extent_clear_unlock_delalloc return void
Date: Thu,  3 Dec 2015 17:56:45 +0100
Message-Id: <2d2099af7656dd745bd2b85f8a20028bee444fc9.1449161602.git.dsterba@suse.com>
In-Reply-To: <cover.1449161602.git.dsterba@suse.com>
References: <cover.1449161602.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does not return any errors, nor anything from the callgraph.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 fs/btrfs/extent_io.h | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d5778e821d60..b7261ea08a87 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1820,7 +1820,7 @@ STATIC u64 find_lock_delalloc_range(struct inode *inode,
 	return found;
 }
 
-int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
+void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 				 struct page *locked_page,
 				 unsigned clear_bits,
 				 unsigned long page_ops)
@@ -1835,7 +1835,7 @@ int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 
 	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
 	if (page_ops == 0)
-		return 0;
+		return;
 
 	if ((page_ops & PAGE_SET_ERROR) && nr_pages > 0)
 		mapping_set_error(inode->i_mapping, -EIO);
@@ -1869,7 +1869,6 @@ int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 		index += ret;
 		cond_resched();
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ad1d28c1cfd4..2d57166e20d0 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -340,7 +340,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 		      unsigned long *map_len);
 int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
 int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
-int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
+void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 				 struct page *locked_page,
 				 unsigned bits_to_clear,
 				 unsigned long page_ops);
-- 
2.6.2

