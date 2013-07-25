Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from etezian.org ([198.101.225.253]:40087 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab3GYAJz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jul 2013 20:09:55 -0400
From: Andi Shyti <andi@etezian.org>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        andi@etezian.org
Subject: [PATCH] btrfs: raid56: avoid double allocation
Date: Thu, 25 Jul 2013 02:09:40 +0200
Message-Id: <1374710980-5707-1-git-send-email-andi@etezian.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

alloc_rbio frees already bbio and raid_map, therefore they don't
need to be freed in case it fails

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 fs/btrfs/raid56.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0525e13..35fe775 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1687,11 +1687,9 @@ int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 	struct blk_plug_cb *cb;
 
 	rbio = alloc_rbio(root, bbio, raid_map, stripe_len);
-	if (IS_ERR(rbio)) {
-		kfree(raid_map);
-		kfree(bbio);
+	if (IS_ERR(rbio))
 		return PTR_ERR(rbio);
-	}
+
 	bio_list_add(&rbio->bio_list, bio);
 	rbio->bio_list_bytes = bio->bi_size;
 
-- 
1.8.3.2

