Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966656AbaFTLDA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:03:00 -0400
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 7/8] btrfs: clean away stripe_align helper
Date: Fri, 20 Jun 2014 13:02:58 +0200
Message-Id: <dd487512408f76a32ac88dea9abcf49ffa6cddaa.1403260620.git.dsterba@suse.cz>
In-Reply-To: <cover.1403260619.git.dsterba@suse.cz>
References: <cover.1403260619.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only wraps the ALIGN macro.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 177a544630ff..1cfc12f075a3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6271,14 +6271,6 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	return ret;
 }
 
-static u64 stripe_align(struct btrfs_root *root,
-			struct btrfs_block_group_cache *cache,
-			u64 val, u64 num_bytes)
-{
-	u64 ret = ALIGN(val, root->stripesize);
-	return ret;
-}
-
 /*
  * when we wait for progress in the block group caching, its because
  * our allocation attempt failed at least once.  So, we must sleep
@@ -6759,8 +6751,7 @@ unclustered_alloc:
 			goto loop;
 		}
 checks:
-		search_start = stripe_align(root, block_group,
-					    offset, num_bytes);
+		search_start = ALIGN(offset, root->stripesize);
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
-- 
1.7.9

