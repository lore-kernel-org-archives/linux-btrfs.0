Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54194 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933206AbdKFTcs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:48 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F2B46ABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:46 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 06/10] btrfs: sink get_extent parameter to get_extent_skip_holes
Date: Mon,  6 Nov 2017 20:30:56 +0100
Message-Id: <dbaaf585f255fae27784989bb5449188ed0c95de.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass btrfs_get_extent_fiemap and get_extent_skip_holes
itself is used only as a fiemap helper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a2815f335d38..c30694f57d02 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4302,9 +4302,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
  * This maps until we find something past 'last'
  */
 static struct extent_map *get_extent_skip_holes(struct inode *inode,
-						u64 offset,
-						u64 last,
-						get_extent_t *get_extent)
+						u64 offset, u64 last)
 {
 	u64 sectorsize = btrfs_inode_sectorsize(inode);
 	struct extent_map *em;
@@ -4318,7 +4316,8 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 		if (len == 0)
 			break;
 		len = ALIGN(len, sectorsize);
-		em = get_extent(BTRFS_I(inode), NULL, 0, offset, len, 0);
+		em = btrfs_get_extent_fiemap(BTRFS_I(inode), NULL, 0, offset,
+				len, 0);
 		if (IS_ERR_OR_NULL(em))
 			return em;
 
@@ -4533,8 +4532,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len - 1,
 			 &cached_state);
 
-	em = get_extent_skip_holes(inode, start, last_for_get_extent,
-				   btrfs_get_extent_fiemap);
+	em = get_extent_skip_holes(inode, start, last_for_get_extent);
 	if (!em)
 		goto out;
 	if (IS_ERR(em)) {
@@ -4622,8 +4620,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		}
 
 		/* now scan forward to see if this is really the last extent. */
-		em = get_extent_skip_holes(inode, off, last_for_get_extent,
-					   btrfs_get_extent_fiemap);
+		em = get_extent_skip_holes(inode, off, last_for_get_extent);
 		if (IS_ERR(em)) {
 			ret = PTR_ERR(em);
 			goto out;
-- 
2.14.3

