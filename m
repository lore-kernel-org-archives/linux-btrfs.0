Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34746 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbcG2Rx7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 13:53:59 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v4] Btrfs: remove BUG() in raid56
Date: Fri, 29 Jul 2016 10:57:55 -0700
Message-Id: <1469815075-5945-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1469645807-16370-1-git-send-email-bo.li.liu@oracle.com>
References: <1469645807-16370-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This BUG() has been triggered by a fuzz testing image, which contains
an invalid chunk type, ie. a single stripe chunk has the raid6 type.

Btrfs can handle this gracefully by returning -EIO, so besides using
btrfs_warn to give us more debugging information rather than a single
BUG(), we can return error properly.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: use btrfs_warn with more debugging information instead of WARN_ONCE.
v3: give a short summary about what happens when the error occurs and
    add a ASSERT(0).
v4: remove ASSERT(0).

 fs/btrfs/raid56.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index f8b6d41..bb0c14f 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2139,7 +2139,10 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
-		BUG();
+		btrfs_warn(root->fs_info,
+	"%s could not find the bad stripe in raid56 so that we cannot recover any more (bio has logical %llu len %llu, bbio has map_type %llu)",
+			   __func__, (u64)bio->bi_iter.bi_sector << 9,
+			   (u64)bio->bi_iter.bi_size, bbio->map_type);
 		if (generic_io)
 			btrfs_put_bbio(bbio);
 		kfree(rbio);
-- 
2.5.5

