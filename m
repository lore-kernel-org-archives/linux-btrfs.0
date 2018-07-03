Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932302AbeGCH5w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 03:57:52 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9253B00F
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 07:57:51 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: Detect invalid empty essential tree
Date: Tue,  3 Jul 2018 15:57:40 +0800
Message-Id: <20180703075740.6028-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199847, where
the crafted image has empty root tree block, which will cause later NULL
pointer dereference.

The following trees should never be empty:
1) Tree root
   Must contain at least root items for extent tree, device tree and fs
   tree

2) Chunk tree
   Or we can't even bootstrap.

3) Fs tree
   At least inode item for top level inode (.).

4) Device tree
   Dev extents for chunks

5) Extent tree
   Must has corresponding extent for each chunk.

If any is empty, we are sure the fs is corrupted and no need to mount
it.

Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1cd735b099df..3a307efab46b 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -497,8 +497,20 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 	 * skip this check for relocation trees.
 	 */
 	if (nritems == 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)) {
+		u64 owner = btrfs_header_owner(leaf);
 		struct btrfs_root *check_root;
 
+		/* These trees should never be empty */
+		if (owner == BTRFS_ROOT_TREE_OBJECTID ||
+		    owner == BTRFS_CHUNK_TREE_OBJECTID ||
+		    owner == BTRFS_EXTENT_TREE_OBJECTID ||
+		    owner == BTRFS_DEV_TREE_OBJECTID ||
+		    owner == BTRFS_FS_TREE_OBJECTID) {
+			generic_err(fs_info, leaf, 0,
+			"invalid root, root %llu should never be empty",
+				    owner);
+			return -EUCLEAN;
+		}
 		key.objectid = btrfs_header_owner(leaf);
 		key.type = BTRFS_ROOT_ITEM_KEY;
 		key.offset = (u64)-1;
-- 
2.18.0

