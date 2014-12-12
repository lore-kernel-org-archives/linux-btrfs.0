Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031081AbaLLRgK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 12:36:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5F436ABC6
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 17:36:09 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 7/9] btrfs: use GFP_NOFS in __alloc_extent_buffer directly
Date: Fri, 12 Dec 2014 18:36:08 +0100
Message-Id: <23d79d81b13431756fee428acde49c9b770da132.1418404754.git.dsterba@suse.cz>
In-Reply-To: <cover.1418404754.git.dsterba@suse.cz>
References: <cover.1418404754.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same mask from all callers.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ebabd237153..619592d86c2a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4598,11 +4598,11 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 
 static struct extent_buffer *
 __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
-		      unsigned long len, gfp_t mask)
+		      unsigned long len)
 {
 	struct extent_buffer *eb = NULL;
 
-	eb = kmem_cache_zalloc(extent_buffer_cache, mask);
+	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS);
 	if (eb == NULL)
 		return NULL;
 	eb->start = start;
@@ -4643,7 +4643,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	struct extent_buffer *new;
 	unsigned long num_pages = num_extent_pages(src->start, src->len);
 
-	new = __alloc_extent_buffer(NULL, src->start, src->len, GFP_NOFS);
+	new = __alloc_extent_buffer(NULL, src->start, src->len);
 	if (new == NULL)
 		return NULL;
 
@@ -4672,7 +4672,7 @@ struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len)
 	unsigned long num_pages = num_extent_pages(0, len);
 	unsigned long i;
 
-	eb = __alloc_extent_buffer(NULL, start, len, GFP_NOFS);
+	eb = __alloc_extent_buffer(NULL, start, len);
 	if (!eb)
 		return NULL;
 
@@ -4824,7 +4824,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (eb)
 		return eb;
 
-	eb = __alloc_extent_buffer(fs_info, start, len, GFP_NOFS);
+	eb = __alloc_extent_buffer(fs_info, start, len);
 	if (!eb)
 		return NULL;
 
-- 
2.1.3

