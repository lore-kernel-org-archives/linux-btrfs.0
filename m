Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:50334 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3HTLUa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 07/12] Btrfs: Make btrfs_dev_extent_chunk_tree_uuid() return unsigned long
Date: Tue, 20 Aug 2013 13:20:13 +0200
Message-Id: <1376997618-13573-8-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Internally, btrfs_dev_extent_chunk_tree_uuid() calculates an unsigned long,
but casts it to a pointer, while all callers cast it to unsigned long
again.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/ctree.h   |    4 ++--
 fs/btrfs/volumes.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 641a29a..21f9632 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2277,10 +2277,10 @@ BTRFS_SETGET_FUNCS(dev_extent_chunk_offset, struct btrfs_dev_extent,
 		   chunk_offset, 64);
 BTRFS_SETGET_FUNCS(dev_extent_length, struct btrfs_dev_extent, length, 64);
 
-static inline u8 *btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
+static inline unsigned long btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
 {
 	unsigned long ptr = offsetof(struct btrfs_dev_extent, chunk_tree_uuid);
-	return (u8 *)((unsigned long)dev + ptr);
+	return (unsigned long)dev + ptr;
 }
 
 BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 64);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b05dbb6..15a0a4e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1277,8 +1277,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
 
 	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
-		    (unsigned long)btrfs_dev_extent_chunk_tree_uuid(extent),
-		    BTRFS_UUID_SIZE);
+		    btrfs_dev_extent_chunk_tree_uuid(extent), BTRFS_UUID_SIZE);
 
 	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
 	btrfs_mark_buffer_dirty(leaf);
-- 
1.7.9.5

