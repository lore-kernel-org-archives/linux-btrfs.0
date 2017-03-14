Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35560 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752759AbdCNUfO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 16:35:14 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2 3/7] Btrfs: introduce a function to get extra mirror from replace
Date: Tue, 14 Mar 2017 13:33:57 -0700
Message-Id: <1489523641-10345-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
References: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As the part of getting extra mirror in __btrfs_map_block is
self-independent, this puts it into a separate function.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 161 +++++++++++++++++++++++++++++------------------------
 1 file changed, 89 insertions(+), 72 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f94a45e..e3656e9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -139,6 +139,11 @@ static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
 static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
+static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
+			     enum btrfs_map_op op,
+			     u64 logical, u64 *length,
+			     struct btrfs_bio **bbio_ret,
+			     int mirror_num, int need_raid_map);
 
 DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
@@ -5444,6 +5449,83 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+/*
+ * In dev-replace case, for repair case (that's the only case where the mirror
+ * is selected explicitly when calling btrfs_map_block), blocks left of the
+ * left cursor can also be read from the target drive.
+ *
+ * For REQ_GET_READ_MIRRORS, the target drive is added as the last one to the
+ * array of stripes.
+ * For READ, it also needs to be supported using the same mirror number.
+ *
+ * If the requested block is not left of the left cursor, EIO is returned. This
+ * can happen because btrfs_num_copies() returns one more in the dev-replace
+ * case.
+ */
+static int get_extra_mirror_from_replace(struct btrfs_fs_info *fs_info,
+					 u64 logical, u64 length,
+					 u64 srcdev_devid, int *mirror_num,
+					 u64 *physical)
+{
+	struct btrfs_bio *bbio = NULL;
+	int num_stripes;
+	int index_srcdev = 0;
+	int found = 0;
+	u64 physical_of_found = 0;
+	int i;
+	int ret = 0;
+
+	ret = __btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
+				logical, &length, &bbio, 0, 0);
+	if (ret) {
+		ASSERT(bbio == NULL);
+		return ret;
+	}
+
+	num_stripes = bbio->num_stripes;
+	if (*mirror_num > num_stripes) {
+		/*
+		 * BTRFS_MAP_GET_READ_MIRRORS does not contain this mirror,
+		 * that means that the requested area is not left of the left
+		 * cursor
+		 */
+		btrfs_put_bbio(bbio);
+		return -EIO;
+	}
+
+	/*
+	 * process the rest of the function using the mirror_num of the source
+	 * drive. Therefore look it up first.  At the end, patch the device
+	 * pointer to the one of the target drive.
+	 */
+	for (i = 0; i < num_stripes; i++) {
+		if (bbio->stripes[i].dev->devid != srcdev_devid)
+			continue;
+
+		/*
+		 * In case of DUP, in order to keep it simple, only add the
+		 * mirror with the lowest physical address
+		 */
+		if (found &&
+		    physical_of_found <= bbio->stripes[i].physical)
+			continue;
+
+		index_srcdev = i;
+		found = 1;
+		physical_of_found = bbio->stripes[i].physical;
+	}
+
+	btrfs_put_bbio(bbio);
+
+	ASSERT(found);
+	if (!found)
+		return -EIO;
+
+	*mirror_num = index_srcdev + 1;
+	*physical = physical_of_found;
+	return ret;
+}
+
 static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			     enum btrfs_map_op op,
 			     u64 logical, u64 *length,
@@ -5548,79 +5630,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
 	    op != BTRFS_MAP_WRITE && op != BTRFS_MAP_GET_READ_MIRRORS &&
 	    dev_replace->tgtdev != NULL) {
-		/*
-		 * in dev-replace case, for repair case (that's the only
-		 * case where the mirror is selected explicitly when
-		 * calling btrfs_map_block), blocks left of the left cursor
-		 * can also be read from the target drive.
-		 * For REQ_GET_READ_MIRRORS, the target drive is added as
-		 * the last one to the array of stripes. For READ, it also
-		 * needs to be supported using the same mirror number.
-		 * If the requested block is not left of the left cursor,
-		 * EIO is returned. This can happen because btrfs_num_copies()
-		 * returns one more in the dev-replace case.
-		 */
-		u64 tmp_length = *length;
-		struct btrfs_bio *tmp_bbio = NULL;
-		int tmp_num_stripes;
-		u64 srcdev_devid = dev_replace->srcdev->devid;
-		int index_srcdev = 0;
-		int found = 0;
-		u64 physical_of_found = 0;
-
-		ret = __btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
-			     logical, &tmp_length, &tmp_bbio, 0, 0);
-		if (ret) {
-			WARN_ON(tmp_bbio != NULL);
-			goto out;
-		}
-
-		tmp_num_stripes = tmp_bbio->num_stripes;
-		if (mirror_num > tmp_num_stripes) {
-			/*
-			 * BTRFS_MAP_GET_READ_MIRRORS does not contain this
-			 * mirror, that means that the requested area
-			 * is not left of the left cursor
-			 */
-			ret = -EIO;
-			btrfs_put_bbio(tmp_bbio);
-			goto out;
-		}
-
-		/*
-		 * process the rest of the function using the mirror_num
-		 * of the source drive. Therefore look it up first.
-		 * At the end, patch the device pointer to the one of the
-		 * target drive.
-		 */
-		for (i = 0; i < tmp_num_stripes; i++) {
-			if (tmp_bbio->stripes[i].dev->devid != srcdev_devid)
-				continue;
-
-			/*
-			 * In case of DUP, in order to keep it simple, only add
-			 * the mirror with the lowest physical address
-			 */
-			if (found &&
-			    physical_of_found <= tmp_bbio->stripes[i].physical)
-				continue;
-
-			index_srcdev = i;
-			found = 1;
-			physical_of_found = tmp_bbio->stripes[i].physical;
-		}
-
-		btrfs_put_bbio(tmp_bbio);
-
-		if (!found) {
-			WARN_ON(1);
-			ret = -EIO;
+		ret = get_extra_mirror_from_replace(fs_info, logical, *length,
+						    dev_replace->srcdev->devid,
+						    &mirror_num,
+					    &physical_to_patch_in_first_stripe);
+		if (ret)
 			goto out;
-		}
-
-		mirror_num = index_srcdev + 1;
-		patch_the_first_stripe_for_dev_replace = 1;
-		physical_to_patch_in_first_stripe = physical_of_found;
+		else
+			patch_the_first_stripe_for_dev_replace = 1;
 	} else if (mirror_num > map->num_stripes) {
 		mirror_num = 0;
 	}
-- 
2.5.5

