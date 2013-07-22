Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19558 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab3GVG5s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 02:57:48 -0400
Date: Mon, 22 Jul 2013 09:55:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] btrfs/raid56: fix and cleanup some error paths
Message-ID: <20130722065515.GB14617@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The alloc_rbio() frees "raid_map" and "bbio" on error, so there is a
potential double free bug in raid56_parity_write().  The
raid56_parity_write() and raid56_parity_recover() functions should still
free "raid_map" and "bbio" on error if other errors occur though, so I
have added some more calls to kfree().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0525e13..0db856c 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1687,11 +1687,8 @@ int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 	struct blk_plug_cb *cb;
 
 	rbio = alloc_rbio(root, bbio, raid_map, stripe_len);
-	if (IS_ERR(rbio)) {
-		kfree(raid_map);
-		kfree(bbio);
+	if (IS_ERR(rbio))
 		return PTR_ERR(rbio);
-	}
 	bio_list_add(&rbio->bio_list, bio);
 	rbio->bio_list_bytes = bio->bi_size;
 
@@ -2041,9 +2038,8 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 	int ret;
 
 	rbio = alloc_rbio(root, bbio, raid_map, stripe_len);
-	if (IS_ERR(rbio)) {
+	if (IS_ERR(rbio))
 		return PTR_ERR(rbio);
-	}
 
 	rbio->read_rebuild = 1;
 	bio_list_add(&rbio->bio_list, bio);
@@ -2052,6 +2048,8 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
 		BUG();
+		kfree(raid_map);
+		kfree(bbio);
 		kfree(rbio);
 		return -EIO;
 	}
