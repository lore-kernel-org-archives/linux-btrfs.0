Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbbBXR5k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 12:57:40 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>, <stable@vger.kernel.org>
Subject: [PATCH] btrfs: fix lost return value due to variable shadowing
Date: Tue, 24 Feb 2015 18:57:18 +0100
Message-Id: <1424800638-16865-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A block-local variable stores error code but btrfs_get_blocks_direct may
not return it in the end as there's a ret defined in the function scope.

CC: <stable@vger.kernel.org>	# 3.6+
Fixes: d187663ef24c ("Btrfs: lock extents as we map them in DIO")
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8564d8ce03de..91a87f53be3c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7288,7 +7288,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	    ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
 	     em->block_start != EXTENT_MAP_HOLE)) {
 		int type;
-		int ret;
 		u64 block_start, orig_start, orig_block_len, ram_bytes;
 
 		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
-- 
1.8.4.5

