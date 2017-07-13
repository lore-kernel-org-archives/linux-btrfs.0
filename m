Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50065 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752545AbdGMPnj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 11:43:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C13E4AC16
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 15:43:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: btrfs_create_repair_bio never fails, skip error handling
Date: Thu, 13 Jul 2017 17:42:15 +0200
Message-Id: <20170713154215.20191-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As it uses the non-failinig bio allocation, we can remove error handling
from the callers as well.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 4 ----
 fs/btrfs/inode.c     | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2e6f69908303..7010b7764e23 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2394,10 +2394,6 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 				      start - page_offset(page),
 				      (int)phy_offset, failed_bio->bi_end_io,
 				      NULL);
-	if (!bio) {
-		free_io_failure(failure_tree, tree, failrec);
-		return -EIO;
-	}
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
 
 	btrfs_debug(btrfs_sb(inode->i_sb),
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5d3c6ac960fd..97460e492d91 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8017,10 +8017,6 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	isector >>= inode->i_sb->s_blocksize_bits;
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
 				pgoff, isector, repair_endio, repair_arg);
-	if (!bio) {
-		free_io_failure(failure_tree, io_tree, failrec);
-		return -EIO;
-	}
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
 
 	btrfs_debug(BTRFS_I(inode)->root->fs_info,
-- 
2.13.0

