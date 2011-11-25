Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45769 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755228Ab1K1Tdu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:50 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWnF8020855
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:59 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWlcc012467
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:48 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWl0d020541
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:47 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWk93020538
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:46 -0200
Message-Id: <3e32802d2e55b6f58e1cc0b7b3f9867b2edf30f6.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Fri, 25 Nov 2011 21:47:13 -0200
Subject: [PATCH 20/20] Btrfs: don't waste metadata block groups for clustered
 allocation
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We try to maintain about 1% of the filesystem space in free space in
data block groups, but we need not do that for metadata, since we only
allocate one block at a time.

This patch also moves the adjustment of flags to account for mixed
data/metadata block groups into the block protected by spin lock, and
before the point in which we now look at flags to decide whether or
not we should keep the free space buffer.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3c649fe..cce452d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3228,7 +3228,7 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
 
 static int should_alloc_chunk(struct btrfs_root *root,
 			      struct btrfs_space_info *sinfo, u64 alloc_bytes,
-			      int force)
+			      u64 flags, int force)
 {
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
@@ -3246,10 +3246,10 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	num_allocated += global_rsv->size;
 
 	/*
-	 * in limited mode, we want to have some free space up to
+	 * in limited mode, we want to have some free data space up to
 	 * about 1% of the FS size.
 	 */
-	if (force == CHUNK_ALLOC_LIMITED) {
+	if (force == CHUNK_ALLOC_LIMITED && (flags & BTRFS_BLOCK_GROUP_DATA)) {
 		thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
 		thresh = max_t(u64, 64 * 1024 * 1024,
 			       div_factor_fine(thresh, 1));
@@ -3310,7 +3310,16 @@ again:
 		return 0;
 	}
 
-	if (!should_alloc_chunk(extent_root, space_info, alloc_bytes, force)) {
+	/*
+	 * If we have mixed data/metadata chunks we want to make sure we keep
+	 * allocating mixed chunks instead of individual chunks.
+	 */
+	if (btrfs_mixed_space_info(space_info))
+		flags |= (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA);
+
+	if (!should_alloc_chunk(extent_root, space_info, alloc_bytes,
+				flags, force)) {
+		space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
 		spin_unlock(&space_info->lock);
 		return 0;
 	} else if (space_info->chunk_alloc) {
@@ -3336,13 +3345,6 @@ again:
 	}
 
 	/*
-	 * If we have mixed data/metadata chunks we want to make sure we keep
-	 * allocating mixed chunks instead of individual chunks.
-	 */
-	if (btrfs_mixed_space_info(space_info))
-		flags |= (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA);
-
-	/*
 	 * if we're doing a data chunk, go ahead and make sure that
 	 * we keep a reasonable number of metadata chunks allocated in the
 	 * FS as well.
-- 
1.7.4.4

