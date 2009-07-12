From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] brtfs: less- and greater than confusion
Date: Mon, 13 Jul 2009 00:30:48 +0200
Message-ID: <4A5A6418.2070906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Without this the loop won't start

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3ab80e9..2c873c9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2795,7 +2795,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		}
 	}
 
-	for (i = 0; i > nr; i++) {
+	for (i = 0; i < nr; i++) {
 		struct btrfs_multi_bio *multi;
 		struct btrfs_bio_stripe *stripe;
 		int ret;
