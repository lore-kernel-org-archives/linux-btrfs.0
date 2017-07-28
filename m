Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36517 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751606AbdG1HuT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 03:50:19 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECE42AC05
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 07:50:17 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant setting of uuid in btrfs_block_header.
Date: Fri, 28 Jul 2017 10:50:14 +0300
Message-Id: <1501228214-11103-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_alloc_dev_extent currently unconditionally sets the uuid in the leaf block
header the function is working with. This is unnecessary since this operation
is peformed by the core btree handling code (splitting a node, allocating a new
btree block etc). So let's remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5a1913956f20..84501e9d486c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1611,8 +1611,6 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
 
-	write_extent_buffer_chunk_tree_uuid(leaf, fs_info->chunk_tree_uuid);
-
 	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
 	btrfs_mark_buffer_dirty(leaf);
 out:
-- 
2.7.4

