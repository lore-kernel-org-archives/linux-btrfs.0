Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50926 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbeINM42 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 08:56:28 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E050FAF58
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 07:43:13 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Do metadata prealloc as long as we're not modifying csum tree
Date: Fri, 14 Sep 2018 15:43:07 +0800
Message-Id: <20180914074307.17565-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In github issues, one user reports unexpected ENOSPC error if enabling
datasum.
After some investigation, it looks like that during ext2_saved/image
creation, we could create large file extent whose size can be 128M (max
data extent size).

In that case, its csum will be at least 128K. Under certain case we need
to allocate extra metadata chunks to fulfill such space requirement.

However we only do metadata prealloc if we're reserving extents for fs
trees.
(we use btrfs_root::ref_cows to determine whether we should do metadata
prealloc, and that member is only set for fs trees).

There is no explaination on why we only do metadata prealloc for file
trees, but at least from my investigation, it could be related to avoid
nested extent tree modication.

At least extent reservation for csum tree shouldn't be a problem with
metadata block group preallocation.

So change the metadata block group preallocation check from
"root->ref_cow" to "root->root_key.objectid !=
BTRFS_EXTENT_TREE_OBJECTID", and add some comment for it.

Issue: 123
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 extent-tree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index 5d49af5a901e..bdf1b0e94c5f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2652,7 +2652,12 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 		profile = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
 	}
 
-	if (root->ref_cows) {
+	/*
+	 * Do metadata preallocate if we're not modifying extent tree.
+	 * Allocating chunk while modify extent tree could lead to tranid
+	 * mismatch, as do_chunk_alloc() could commit transaction.
+	 */
+	if (root->root_key.objectid != BTRFS_EXTENT_TREE_OBJECTID) {
 		if (!(profile & BTRFS_BLOCK_GROUP_METADATA)) {
 			ret = do_chunk_alloc(trans, info,
 					     num_bytes,
-- 
2.19.0
