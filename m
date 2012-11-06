Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:29443 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp1) (RZmta 30.22 OK)
	with ESMTP id X022c8oA6As7hF for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 22/26] Btrfs: changes to live filesystem are also written to replacement disk
Date: Tue,  6 Nov 2012 17:38:40 +0100
Message-Id: <f27babf0a20246ff745dad5bb3d1fa884e946990.1352217244.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

During a running dev replace operation, all write requests to
the live filesystem are duplicated to also write to the target
drive. Therefore btrfs_map_block() is changed to duplicate
stripes that are written to the source disk of a device replace
procedure to be written to the target disk as well.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/volumes.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 208cc13..164f9b1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4049,6 +4049,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	int num_stripes;
 	int max_errors = 0;
 	struct btrfs_bio *bbio = NULL;
+	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	int dev_replace_is_ongoing = 0;
+	int num_alloc_stripes;
 
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, logical, *length);
@@ -4094,6 +4097,11 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	if (!bbio_ret)
 		goto out;
 
+	btrfs_dev_replace_lock(dev_replace);
+	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
+	if (!dev_replace_is_ongoing)
+		btrfs_dev_replace_unlock(dev_replace);
+
 	num_stripes = 1;
 	stripe_index = 0;
 	stripe_nr_orig = stripe_nr;
@@ -4160,7 +4168,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	}
 	BUG_ON(stripe_index >= map->num_stripes);
 
-	bbio = kzalloc(btrfs_bio_size(num_stripes), GFP_NOFS);
+	num_alloc_stripes = num_stripes;
+	if (dev_replace_is_ongoing && (rw & (REQ_WRITE | REQ_DISCARD)))
+		num_alloc_stripes <<= 1;
+	bbio = kzalloc(btrfs_bio_size(num_alloc_stripes), GFP_NOFS);
 	if (!bbio) {
 		ret = -ENOMEM;
 		goto out;
@@ -4255,11 +4266,48 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 	}
 
+	if (dev_replace_is_ongoing && (rw & (REQ_WRITE | REQ_DISCARD)) &&
+	    dev_replace->tgtdev != NULL) {
+		int index_where_to_add;
+		u64 srcdev_devid = dev_replace->srcdev->devid;
+
+		/*
+		 * duplicate the write operations while the dev replace
+		 * procedure is running. Since the copying of the old disk
+		 * to the new disk takes place at run time while the
+		 * filesystem is mounted writable, the regular write
+		 * operations to the old disk have to be duplicated to go
+		 * to the new disk as well.
+		 * Note that device->missing is handled by the caller, and
+		 * that the write to the old disk is already set up in the
+		 * stripes array.
+		 */
+		index_where_to_add = num_stripes;
+		for (i = 0; i < num_stripes; i++) {
+			if (bbio->stripes[i].dev->devid == srcdev_devid) {
+				/* write to new disk, too */
+				struct btrfs_bio_stripe *new =
+					bbio->stripes + index_where_to_add;
+				struct btrfs_bio_stripe *old =
+					bbio->stripes + i;
+
+				new->physical = old->physical;
+				new->length = old->length;
+				new->dev = dev_replace->tgtdev;
+				index_where_to_add++;
+				max_errors++;
+			}
+		}
+		num_stripes = index_where_to_add;
+	}
+
 	*bbio_ret = bbio;
 	bbio->num_stripes = num_stripes;
 	bbio->max_errors = max_errors;
 	bbio->mirror_num = mirror_num;
 out:
+	if (dev_replace_is_ongoing)
+		btrfs_dev_replace_unlock(dev_replace);
 	free_extent_map(em);
 	return ret;
 }
-- 
1.8.0

