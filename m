Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33932 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbdFFUxp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 16:53:45 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: fix Null pointer dereference in dio read endio
Date: Tue,  6 Jun 2017 13:52:52 -0600
Message-Id: <20170606195252.17563-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With switching to use btrfs_bio_clone_partial() to split bio in
directIO path, read endio is also adapted to that by recording a
iterator in btrfs_bio, however, it breaks those bios which are less
than stripe length thus no need to be split and results in NULL
pointer dereference.

This fixes the issue by recording the required bio iterator in
btrfs_bio_clone() which is used to clone non-split bio in directIO
path.  It doesn't affect other calls of btrfs_bio_clone() because they
don't need to use this iterator.

This bug was caught by fstests/generic/091.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
Based on David's for-next.
Fixes: commit "Btrfs: change how we iterate bios in endio"

Have run through fstests without introducing new problems.

 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 806e8d6..a91c3a1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2719,6 +2719,7 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask)
 		btrfs_bio->csum = NULL;
 		btrfs_bio->csum_allocated = NULL;
 		btrfs_bio->end_io = NULL;
+		btrfs_bio->iter = bio->bi_iter;
 	}
 	return new;
 }
-- 
2.9.4

