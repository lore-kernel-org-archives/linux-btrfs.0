Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584AbcA0OCQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 09:02:16 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 79242ADC1
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 14:02:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: tweak free space tree bitmap allocation
Date: Wed, 27 Jan 2016 15:02:05 +0100
Message-Id: <79b134a22b6fc45f48bcc1c27d6bf05b3ede5e06.1453902967.git.dsterba@suse.com>
In-Reply-To: <cover.1453902967.git.dsterba@suse.com>
References: <cover.1453902967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The requested bitmap size varies, observed numbers were < 4K up to 16K.
Using vmalloc unconditionally would be too heavy, we'll try contiguous
allocations first and fall back to vmalloc if there's no contig memory.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-tree.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 393e36bd5845..0f33d58cb321 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -153,6 +153,20 @@ static inline u32 free_space_bitmap_size(u64 size, u32 sectorsize)
 
 static unsigned long *alloc_bitmap(u32 bitmap_size)
 {
+	void *mem;
+
+	/*
+	 * The allocation size varies, observed numbers were < 4K up to 16K.
+	 * Using vmalloc unconditionally would be too heavy, we'll try
+	 * contiguous allocations first.
+	 */
+	if  (bitmap_size <= PAGE_SIZE)
+		return kzalloc(bitmap_size, GFP_NOFS);
+
+	mem = kzalloc(bitmap_size, GFP_NOFS | __GFP_HIGHMEM | __GFP_NOWARN);
+	if (mem)
+		return mem;
+
 	return __vmalloc(bitmap_size, GFP_NOFS | __GFP_HIGHMEM | __GFP_ZERO,
 			 PAGE_KERNEL);
 }
@@ -289,7 +303,7 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 
 	ret = 0;
 out:
-	vfree(bitmap);
+	kvfree(bitmap);
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
 	return ret;
@@ -438,7 +452,7 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 
 	ret = 0;
 out:
-	vfree(bitmap);
+	kvfree(bitmap);
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
 	return ret;
-- 
2.6.3

