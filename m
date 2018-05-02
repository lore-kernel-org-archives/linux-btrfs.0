Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42943 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbeEBMTi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 08:19:38 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 34440AD2E
        for <linux-btrfs@vger.kernel.org>; Wed,  2 May 2018 12:19:37 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 2/2] btrfs: Factor out write portion of btrfs_get_blocks_direct
Date: Wed,  2 May 2018 15:19:33 +0300
Message-Id: <1525263573-2969-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1525263573-2969-1-git-send-email-nborisov@suse.com>
References: <1525263573-2969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that the read side is extracted into its own function, do the same
to the write side. This leaves btrfs_get_blocks_direct_write with the
sole purpose of handling common locking required. Also flip the
condition in btrfs_get_blocks_direct_write so that the write case
comes first and we check for if (Create) rather than if (!create). This
is purely subjective but I believe makes reading a bit more "linear".
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V3:
 * Nothing's changed. 

v2: 
 * Removed __ prefix from function name 
  * Use a ret variable in btrfs_get_blocks_direct_write and a goto label to 
   implement return strategy. 
 fs/btrfs/inode.c | 207 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 108 insertions(+), 99 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1ce1bcfc4255..c49bfda61a84 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7795,6 +7795,104 @@ static int btrfs_get_blocks_direct_read(struct extent_map *em,
 	return 0;
 }
 
+static int btrfs_get_blocks_direct_write(struct extent_map **map,
+					 struct buffer_head *bh_result,
+					 struct inode *inode,
+					 struct btrfs_dio_data *dio_data,
+					 u64 start, u64 len)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct extent_map *em = *map;
+	int ret = 0;
+
+	/*
+	 * We don't allocate a new extent in the following cases
+	 *
+	 * 1) The inode is marked as NODATACOW. In this case we'll just use the
+	 * existing extent.
+	 * 2) The extent is marked as PREALLOC. We're good to go here and can
+	 * just use the extent.
+	 *
+	 */
+	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
+	    ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
+	     em->block_start != EXTENT_MAP_HOLE)) {
+		int type;
+		u64 block_start, orig_start, orig_block_len, ram_bytes;
+
+		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+			type = BTRFS_ORDERED_PREALLOC;
+		else
+			type = BTRFS_ORDERED_NOCOW;
+		len = min(len, em->len - (start - em->start));
+		block_start = em->block_start + (start - em->start);
+
+		if (can_nocow_extent(inode, start, &len, &orig_start,
+				     &orig_block_len, &ram_bytes) == 1 &&
+		    btrfs_inc_nocow_writers(fs_info, block_start)) {
+			struct extent_map *em2;
+
+			em2 = btrfs_create_dio_extent(inode, start, len,
+						      orig_start, block_start,
+						      len, orig_block_len,
+						      ram_bytes, type);
+			btrfs_dec_nocow_writers(fs_info, block_start);
+			if (type == BTRFS_ORDERED_PREALLOC) {
+				free_extent_map(em);
+				*map = em = em2;
+			}
+
+			if (em2 && IS_ERR(em2)) {
+				ret = PTR_ERR(em2);
+				goto out;
+			}
+			/*
+			 * For inode marked NODATACOW or extent marked PREALLOC,
+			 * use the existing or preallocated extent, so does not
+			 * need to adjust btrfs_space_info's bytes_may_use.
+			 */
+			btrfs_free_reserved_data_space_noquota(inode, start,
+							       len);
+			goto skip_cow;
+		}
+	}
+
+	/* this will cow the extent */
+	len = bh_result->b_size;
+	free_extent_map(em);
+	*map = em = btrfs_new_extent_direct(inode, start, len);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		goto out;
+	}
+
+	len = min(len, em->len - (start - em->start));
+
+skip_cow:
+	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
+		inode->i_blkbits;
+	bh_result->b_size = len;
+	bh_result->b_bdev = em->bdev;
+	set_buffer_mapped(bh_result);
+
+	if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+		set_buffer_new(bh_result);
+
+	/*
+	 * Need to update the i_size under the extent lock so buffered
+	 * readers will get the updated i_size when we unlock.
+	 */
+	if (!dio_data->overwrite && start + len > i_size_read(inode))
+		i_size_write(inode, start + len);
+
+	WARN_ON(dio_data->reserve < len);
+	dio_data->reserve -= len;
+	dio_data->unsubmitted_oe_range_end = start + len;
+	current->journal_info = dio_data;
+out:
+	return ret;
+}
+
 static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -7863,7 +7961,16 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		goto unlock_err;
 	}
 
-	if (!create) {
+	if (create) {
+		ret = btrfs_get_blocks_direct_write(&em, bh_result, inode,
+						    dio_data, start, len);
+		if (ret < 0)
+			goto unlock_err;
+
+		/* clear and unlock the entire range */
+		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+				 unlock_bits, 1, 0, &cached_state);
+	} else {
 		ret = btrfs_get_blocks_direct_read(em, bh_result, inode,
 						   start, len);
 		/* Can be negative only if we read from a hole */
@@ -7884,106 +7991,8 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		} else {
 			free_extent_state(cached_state);
 		}
-		free_extent_map(em);
-		return 0;
 	}
 
-	/*
-	 * We don't allocate a new extent in the following cases
-	 *
-	 * 1) The inode is marked as NODATACOW.  In this case we'll just use the
-	 * existing extent.
-	 * 2) The extent is marked as PREALLOC.  We're good to go here and can
-	 * just use the extent.
-	 *
-	 */
-	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
-	    ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
-	     em->block_start != EXTENT_MAP_HOLE)) {
-		int type;
-		u64 block_start, orig_start, orig_block_len, ram_bytes;
-
-		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
-			type = BTRFS_ORDERED_PREALLOC;
-		else
-			type = BTRFS_ORDERED_NOCOW;
-		len = min(len, em->len - (start - em->start));
-		block_start = em->block_start + (start - em->start);
-
-		if (can_nocow_extent(inode, start, &len, &orig_start,
-				     &orig_block_len, &ram_bytes) == 1 &&
-		    btrfs_inc_nocow_writers(fs_info, block_start)) {
-			struct extent_map *em2;
-
-			em2 = btrfs_create_dio_extent(inode, start, len,
-						      orig_start, block_start,
-						      len, orig_block_len,
-						      ram_bytes, type);
-			btrfs_dec_nocow_writers(fs_info, block_start);
-			if (type == BTRFS_ORDERED_PREALLOC) {
-				free_extent_map(em);
-				em = em2;
-			}
-			if (em2 && IS_ERR(em2)) {
-				ret = PTR_ERR(em2);
-				goto unlock_err;
-			}
-			/*
-			 * For inode marked NODATACOW or extent marked PREALLOC,
-			 * use the existing or preallocated extent, so does not
-			 * need to adjust btrfs_space_info's bytes_may_use.
-			 */
-			btrfs_free_reserved_data_space_noquota(inode,
-					start, len);
-			goto unlock;
-		}
-	}
-
-	/*
-	 * this will cow the extent, reset the len in case we changed
-	 * it above
-	 */
-	len = bh_result->b_size;
-	free_extent_map(em);
-	em = btrfs_new_extent_direct(inode, start, len);
-	if (IS_ERR(em)) {
-		ret = PTR_ERR(em);
-		goto unlock_err;
-	}
-	len = min(len, em->len - (start - em->start));
-unlock:
-	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
-		inode->i_blkbits;
-	bh_result->b_size = len;
-	bh_result->b_bdev = em->bdev;
-	set_buffer_mapped(bh_result);
-	if (create) {
-		if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
-			set_buffer_new(bh_result);
-
-		/*
-		 * Need to update the i_size under the extent lock so buffered
-		 * readers will get the updated i_size when we unlock.
-		 */
-		if (!dio_data->overwrite && start + len > i_size_read(inode))
-			i_size_write(inode, start + len);
-
-		WARN_ON(dio_data->reserve < len);
-		dio_data->reserve -= len;
-		dio_data->unsubmitted_oe_range_end = start + len;
-		current->journal_info = dio_data;
-	}
-
-	/*
-	 * In the case of write we need to clear and unlock the entire range,
-	 * in the case of read we need to unlock only the end area that we
-	 * aren't using if there is any left over space.
-	 */
-	if (lockstart < lockend) {
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-				 lockend, unlock_bits, 1, 0,
-				 &cached_state);
-	}
 	free_extent_map(em);
 
 	return 0;
-- 
2.7.4

