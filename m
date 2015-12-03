Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbbLCQ6u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:58:50 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3509FADDA
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:58:49 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 12/12] btrfs: make set_range_writeback return void
Date: Thu,  3 Dec 2015 17:56:59 +0100
Message-Id: <bb45445ab63fcd83950180c8d17833ca0216da64.1449161602.git.dsterba@suse.com>
In-Reply-To: <cover.1449161602.git.dsterba@suse.com>
References: <cover.1449161602.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does not return any errors, nor anything from the callgraph. There's a
BUG_ON but it's a sanity check and not an error condition we could
recover from.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f06800e48f97..efe6ac627be9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1485,7 +1485,7 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
 /*
  * helper function to set both pages and extents in the tree writeback
  */
-static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
+static void set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
@@ -1498,7 +1498,6 @@ static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 		page_cache_release(page);
 		index++;
 	}
-	return 0;
 }
 
 /* find the first state struct with 'bits' set after 'start', and
-- 
2.6.2

