Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28921 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761489Ab3EAQXs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 12:23:48 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: fix off-by-one in fiemap
Date: Thu,  2 May 2013 00:23:41 +0800
Message-Id: <1367425421-10598-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

lock_extent/unlock_extent expect an exclusive end.

Tested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cdee391..e3aafce 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3913,7 +3913,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		last_for_get_extent = isize;
 	}
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len - 1, 0,
 			 &cached_state);
 
 	em = get_extent_skip_holes(inode, start, last_for_get_extent,
@@ -4000,7 +4000,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 out_free:
 	free_extent_map(em);
 out:
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len,
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len - 1,
 			     &cached_state, GFP_NOFS);
 	return ret;
 }
-- 
1.7.7.6

