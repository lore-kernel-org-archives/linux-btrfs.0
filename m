Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:21394 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab2KFQiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:50 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp1) (RZmta 30.22 OK)
	with ESMTP id X03d73oA6Asmyd for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 25/26] Btrfs: allow repair code to include target disk when searching mirrors
Date: Tue,  6 Nov 2012 17:38:43 +0100
Message-Id: <ff71eb04c46e0e7e328584babd708043bce9aae1.1352217244.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

Make the target disk of a running device replace operation
available for reading. This is only used as a last ressort for
the defect repair procedure. And it is dependent on the location
of the data block to read, because during an ongoing device
replace operation, the target drive is only partially filled
with the filesystem data.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/volumes.c | 159 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 154 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index edd5573..959a4c8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4009,6 +4009,12 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	else
 		ret = 1;
 	free_extent_map(em);
+
+	btrfs_dev_replace_lock(&fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))
+		ret++;
+	btrfs_dev_replace_unlock(&fs_info->dev_replace);
+
 	return ret;
 }
 
@@ -4073,6 +4079,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	int dev_replace_is_ongoing = 0;
 	int num_alloc_stripes;
+	int patch_the_first_stripe_for_dev_replace = 0;
+	u64 physical_to_patch_in_first_stripe = 0;
 
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, logical, *length);
@@ -4089,9 +4097,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	map = (struct map_lookup *)em->bdev;
 	offset = logical - em->start;
 
-	if (mirror_num > map->num_stripes)
-		mirror_num = 0;
-
 	stripe_nr = offset;
 	/*
 	 * stripe_nr counts the total number of stripes we have to stride
@@ -4123,6 +4128,88 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	if (!dev_replace_is_ongoing)
 		btrfs_dev_replace_unlock(dev_replace);
 
+	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
+	    !(rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)) &&
+	    dev_replace->tgtdev != NULL) {
+		/*
+		 * in dev-replace case, for repair case (that's the only
+		 * case where the mirror is selected explicitly when
+		 * calling btrfs_map_block), blocks left of the left cursor
+		 * can also be read from the target drive.
+		 * For REQ_GET_READ_MIRRORS, the target drive is added as
+		 * the last one to the array of stripes. For READ, it also
+		 * needs to be supported using the same mirror number.
+		 * If the requested block is not left of the left cursor,
+		 * EIO is returned. This can happen because btrfs_num_copies()
+		 * returns one more in the dev-replace case.
+		 */
+		u64 tmp_length = *length;
+		struct btrfs_bio *tmp_bbio = NULL;
+		int tmp_num_stripes;
+		u64 srcdev_devid = dev_replace->srcdev->devid;
+		int index_srcdev = 0;
+		int found = 0;
+		u64 physical_of_found = 0;
+
+		ret = __btrfs_map_block(fs_info, REQ_GET_READ_MIRRORS,
+			     logical, &tmp_length, &tmp_bbio, 0);
+		if (ret) {
+			WARN_ON(tmp_bbio != NULL);
+			goto out;
+		}
+
+		tmp_num_stripes = tmp_bbio->num_stripes;
+		if (mirror_num > tmp_num_stripes) {
+			/*
+			 * REQ_GET_READ_MIRRORS does not contain this
+			 * mirror, that means that the requested area
+			 * is not left of the left cursor
+			 */
+			ret = -EIO;
+			kfree(tmp_bbio);
+			goto out;
+		}
+
+		/*
+		 * process the rest of the function using the mirror_num
+		 * of the source drive. Therefore look it up first.
+		 * At the end, patch the device pointer to the one of the
+		 * target drive.
+		 */
+		for (i = 0; i < tmp_num_stripes; i++) {
+			if (tmp_bbio->stripes[i].dev->devid == srcdev_devid) {
+				/*
+				 * In case of DUP, in order to keep it
+				 * simple, only add the mirror with the
+				 * lowest physical address
+				 */
+				if (found &&
+				    physical_of_found <=
+				     tmp_bbio->stripes[i].physical)
+					continue;
+				index_srcdev = i;
+				found = 1;
+				physical_of_found =
+					tmp_bbio->stripes[i].physical;
+			}
+		}
+
+		if (found) {
+			mirror_num = index_srcdev + 1;
+			patch_the_first_stripe_for_dev_replace = 1;
+			physical_to_patch_in_first_stripe = physical_of_found;
+		} else {
+			WARN_ON(1);
+			ret = -EIO;
+			kfree(tmp_bbio);
+			goto out;
+		}
+
+		kfree(tmp_bbio);
+	} else if (mirror_num > map->num_stripes) {
+		mirror_num = 0;
+	}
+
 	num_stripes = 1;
 	stripe_index = 0;
 	stripe_nr_orig = stripe_nr;
@@ -4193,8 +4280,12 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	BUG_ON(stripe_index >= map->num_stripes);
 
 	num_alloc_stripes = num_stripes;
-	if (dev_replace_is_ongoing && (rw & (REQ_WRITE | REQ_DISCARD)))
-		num_alloc_stripes <<= 1;
+	if (dev_replace_is_ongoing) {
+		if (rw & (REQ_WRITE | REQ_DISCARD))
+			num_alloc_stripes <<= 1;
+		if (rw & REQ_GET_READ_MIRRORS)
+			num_alloc_stripes++;
+	}
 	bbio = kzalloc(btrfs_bio_size(num_alloc_stripes), GFP_NOFS);
 	if (!bbio) {
 		ret = -ENOMEM;
@@ -4323,12 +4414,70 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			}
 		}
 		num_stripes = index_where_to_add;
+	} else if (dev_replace_is_ongoing && (rw & REQ_GET_READ_MIRRORS) &&
+		   dev_replace->tgtdev != NULL) {
+		u64 srcdev_devid = dev_replace->srcdev->devid;
+		int index_srcdev = 0;
+		int found = 0;
+		u64 physical_of_found = 0;
+
+		/*
+		 * During the dev-replace procedure, the target drive can
+		 * also be used to read data in case it is needed to repair
+		 * a corrupt block elsewhere. This is possible if the
+		 * requested area is left of the left cursor. In this area,
+		 * the target drive is a full copy of the source drive.
+		 */
+		for (i = 0; i < num_stripes; i++) {
+			if (bbio->stripes[i].dev->devid == srcdev_devid) {
+				/*
+				 * In case of DUP, in order to keep it
+				 * simple, only add the mirror with the
+				 * lowest physical address
+				 */
+				if (found &&
+				    physical_of_found <=
+				     bbio->stripes[i].physical)
+					continue;
+				index_srcdev = i;
+				found = 1;
+				physical_of_found = bbio->stripes[i].physical;
+			}
+		}
+		if (found) {
+			u64 length = map->stripe_len;
+
+			if (physical_of_found + length <=
+			    dev_replace->cursor_left) {
+				struct btrfs_bio_stripe *tgtdev_stripe =
+					bbio->stripes + num_stripes;
+
+				tgtdev_stripe->physical = physical_of_found;
+				tgtdev_stripe->length =
+					bbio->stripes[index_srcdev].length;
+				tgtdev_stripe->dev = dev_replace->tgtdev;
+
+				num_stripes++;
+			}
+		}
 	}
 
 	*bbio_ret = bbio;
 	bbio->num_stripes = num_stripes;
 	bbio->max_errors = max_errors;
 	bbio->mirror_num = mirror_num;
+
+	/*
+	 * this is the case that REQ_READ && dev_replace_is_ongoing &&
+	 * mirror_num == num_stripes + 1 && dev_replace target drive is
+	 * available as a mirror
+	 */
+	if (patch_the_first_stripe_for_dev_replace && num_stripes > 0) {
+		WARN_ON(num_stripes > 1);
+		bbio->stripes[0].dev = dev_replace->tgtdev;
+		bbio->stripes[0].physical = physical_to_patch_in_first_stripe;
+		bbio->mirror_num = map->num_stripes + 1;
+	}
 out:
 	if (dev_replace_is_ongoing)
 		btrfs_dev_replace_unlock(dev_replace);
-- 
1.8.0

