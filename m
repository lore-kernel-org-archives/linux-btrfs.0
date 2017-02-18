Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34364 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbdBRB3V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 20:29:21 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/7] Btrfs: handle operations for device replace separately
Date: Fri, 17 Feb 2017 17:28:18 -0800
Message-Id: <1487381301-865-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since this part is mostly self-independent, this moves it to a separate
function.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 179 +++++++++++++++++++++++++++++------------------------
 1 file changed, 98 insertions(+), 81 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f62efc7..c434489 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5545,6 +5545,100 @@ static int get_extra_mirror_from_replace(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static void handle_ops_on_dev_replace(enum btrfs_map_op op,
+				      struct btrfs_bio **bbio_ret,
+				      struct btrfs_dev_replace *dev_replace,
+				      int *num_stripes_ret, int *max_errors_ret)
+{
+	struct btrfs_bio *bbio = *bbio_ret;
+	u64 srcdev_devid = dev_replace->srcdev->devid;
+	int tgtdev_indexes = 0;
+	int num_stripes = *num_stripes_ret;
+	int max_errors = *max_errors_ret;
+	int i;
+
+	if (op == BTRFS_MAP_WRITE) {
+		int index_where_to_add;
+
+		/*
+		 * duplicate the write operations while the dev replace
+		 * procedure is running. Since the copying of the old disk to
+		 * the new disk takes place at run time while the filesystem is
+		 * mounted writable, the regular write operations to the old
+		 * disk have to be duplicated to go to the new disk as well.
+		 *
+		 * Note that device->missing is handled by the caller, and that
+		 * the write to the old disk is already set up in the stripes
+		 * array.
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
+				bbio->tgtdev_map[i] = index_where_to_add;
+				index_where_to_add++;
+				max_errors++;
+				tgtdev_indexes++;
+			}
+		}
+		num_stripes = index_where_to_add;
+	} else if (op == BTRFS_MAP_GET_READ_MIRRORS) {
+		int index_srcdev = 0;
+		int found = 0;
+		u64 physical_of_found = 0;
+
+		/*
+		 * During the dev-replace procedure, the target drive can also
+		 * be used to read data in case it is needed to repair a corrupt
+		 * block elsewhere. This is possible if the requested area is
+		 * left of the left cursor. In this area, the target drive is a
+		 * full copy of the source drive.
+		 */
+		for (i = 0; i < num_stripes; i++) {
+			if (bbio->stripes[i].dev->devid == srcdev_devid) {
+				/*
+				 * In case of DUP, in order to keep it simple,
+				 * only add the mirror with the lowest physical
+				 * address
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
+			struct btrfs_bio_stripe *tgtdev_stripe =
+				bbio->stripes + num_stripes;
+
+			tgtdev_stripe->physical = physical_of_found;
+			tgtdev_stripe->length =
+				bbio->stripes[index_srcdev].length;
+			tgtdev_stripe->dev = dev_replace->tgtdev;
+			bbio->tgtdev_map[index_srcdev] = num_stripes;
+
+			tgtdev_indexes++;
+			num_stripes++;
+		}
+	}
+
+	*num_stripes_ret = num_stripes;
+	*max_errors_ret = max_errors;
+	bbio->num_tgtdevs = tgtdev_indexes;
+	*bbio_ret = bbio;
+}
+
 static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			     enum btrfs_map_op op,
 			     u64 logical, u64 *length,
@@ -5825,86 +5919,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	if (bbio->raid_map)
 		sort_parity_stripes(bbio, num_stripes);
 
-	tgtdev_indexes = 0;
-	if (dev_replace_is_ongoing && op == BTRFS_MAP_WRITE &&
-	    dev_replace->tgtdev != NULL) {
-		int index_where_to_add;
-		u64 srcdev_devid = dev_replace->srcdev->devid;
-
-		/*
-		 * duplicate the write operations while the dev replace
-		 * procedure is running. Since the copying of the old disk
-		 * to the new disk takes place at run time while the
-		 * filesystem is mounted writable, the regular write
-		 * operations to the old disk have to be duplicated to go
-		 * to the new disk as well.
-		 * Note that device->missing is handled by the caller, and
-		 * that the write to the old disk is already set up in the
-		 * stripes array.
-		 */
-		index_where_to_add = num_stripes;
-		for (i = 0; i < num_stripes; i++) {
-			if (bbio->stripes[i].dev->devid == srcdev_devid) {
-				/* write to new disk, too */
-				struct btrfs_bio_stripe *new =
-					bbio->stripes + index_where_to_add;
-				struct btrfs_bio_stripe *old =
-					bbio->stripes + i;
-
-				new->physical = old->physical;
-				new->length = old->length;
-				new->dev = dev_replace->tgtdev;
-				bbio->tgtdev_map[i] = index_where_to_add;
-				index_where_to_add++;
-				max_errors++;
-				tgtdev_indexes++;
-			}
-		}
-		num_stripes = index_where_to_add;
-	} else if (dev_replace_is_ongoing &&
-		   op == BTRFS_MAP_GET_READ_MIRRORS &&
-		   dev_replace->tgtdev != NULL) {
-		u64 srcdev_devid = dev_replace->srcdev->devid;
-		int index_srcdev = 0;
-		int found = 0;
-		u64 physical_of_found = 0;
-
-		/*
-		 * During the dev-replace procedure, the target drive can
-		 * also be used to read data in case it is needed to repair
-		 * a corrupt block elsewhere. This is possible if the
-		 * requested area is left of the left cursor. In this area,
-		 * the target drive is a full copy of the source drive.
-		 */
-		for (i = 0; i < num_stripes; i++) {
-			if (bbio->stripes[i].dev->devid == srcdev_devid) {
-				/*
-				 * In case of DUP, in order to keep it
-				 * simple, only add the mirror with the
-				 * lowest physical address
-				 */
-				if (found &&
-				    physical_of_found <=
-				     bbio->stripes[i].physical)
-					continue;
-				index_srcdev = i;
-				found = 1;
-				physical_of_found = bbio->stripes[i].physical;
-			}
-		}
-		if (found) {
-			struct btrfs_bio_stripe *tgtdev_stripe =
-				bbio->stripes + num_stripes;
-
-			tgtdev_stripe->physical = physical_of_found;
-			tgtdev_stripe->length =
-				bbio->stripes[index_srcdev].length;
-			tgtdev_stripe->dev = dev_replace->tgtdev;
-			bbio->tgtdev_map[index_srcdev] = num_stripes;
-
-			tgtdev_indexes++;
-			num_stripes++;
-		}
+	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL &&
+	    (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)) {
+		handle_ops_on_dev_replace(op, &bbio, dev_replace, &num_stripes,
+					  &max_errors);
 	}
 
 	*bbio_ret = bbio;
@@ -5912,7 +5930,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	bbio->num_stripes = num_stripes;
 	bbio->max_errors = max_errors;
 	bbio->mirror_num = mirror_num;
-	bbio->num_tgtdevs = tgtdev_indexes;
 
 	/*
 	 * this is the case that REQ_READ && dev_replace_is_ongoing &&
-- 
2.5.5

