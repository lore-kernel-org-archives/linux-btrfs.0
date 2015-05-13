Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48900 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751418AbbEMJS2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 05:18:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lukas.lueg@gmail.com>
Subject: [PATCH 4/4] btrfs-progs: Add extra chunk item check to avoid btrfs-progs crash.
Date: Wed, 13 May 2015 17:15:36 +0800
Message-ID: <1431508536-7275-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds extra check when reading a chunk item:
1) Check chunk type.
Don't allow any unsupported type/profile bit.

2) Check num_stripes
Any chunk item should contain at least one stripe.
For system chunk, the chunk item size(calculated by btrfs_stripe size *
(num_stripes - 1) + btrfs_chunk size) should not exceed
BTRFS_SYSTEM_CHUNK_SIZE(2048).
For normal chunk, the chunk item size(calculated) should match the chunk
item size.

3) Check num_stripes/sub_stripes against chunk profile.
Num_stripes/sub_stripes must meet its lower limit for its chunk profile.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/volumes.c b/volumes.c
index 16dbf64..77cc305 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1575,9 +1575,14 @@ static struct btrfs_device *fill_missing_device(u64 devid)
 	return device;
 }
 
+/*
+ * Slot is used to verfy the chunk item is valid
+ *
+ * For sys chunk in superblock, pass -1 to indicate sys chunk.
+ */
 static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
-			  struct btrfs_chunk *chunk)
+			  struct btrfs_chunk *chunk, int slot)
 {
 	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
 	struct map_lookup *map;
@@ -1615,6 +1620,51 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	map->type = btrfs_chunk_type(leaf, chunk);
 	map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
 
+	/* Check on chunk item type */
+	if (map->type & ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+			  BTRFS_BLOCK_GROUP_PROFILE_MASK)) {
+		fprintf(stderr, "Unknown chunk type bits: %llu\n",
+			map->type & ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+				      BTRFS_BLOCK_GROUP_PROFILE_MASK));
+		ret = -EIO;
+		goto out;
+	}
+
+	/*
+	 * Btrfs_chunk contains at least one stripe, and for sys_chunk
+	 * it can't exceed the system chunk array size
+	 * For normal chunk, it should match its chunk item size.
+	 */
+	if (num_stripes < 1 ||
+	    (slot == -1 && sizeof(struct btrfs_stripe) * num_stripes >
+	     BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) ||
+	    (slot >= 0 && sizeof(struct btrfs_stripe) * (num_stripes - 1) >
+	     btrfs_item_size_nr(leaf, slot))) {
+		fprintf(stderr, "Invalid num_stripes: %u\n",
+		        num_stripes);
+		ret = -EIO;
+		goto out;
+	}
+
+	/*
+	 * Device number check against profile
+	 */
+	if ((map->type & BTRFS_BLOCK_GROUP_RAID10 && num_stripes < 4 &&
+	     map->sub_stripes < 2) ||
+	    (map->type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 2) ||
+	    (map->type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 3) ||
+	    (map->type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 4) ||
+	    (map->type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 1) ||
+	    ((map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
+	     num_stripes != 1)) {
+		fprintf(stderr,
+			"Invalid num_stripes:sub_stripes %u:%u for profile %llu\n",
+		        num_stripes, map->sub_stripes,
+			map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		ret = -EIO;
+		goto out;
+	}
+
 	for (i = 0; i < num_stripes; i++) {
 		map->stripes[i].physical =
 			btrfs_stripe_offset_nr(leaf, chunk, i);
@@ -1635,6 +1685,9 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	BUG_ON(ret);
 
 	return 0;
+out:
+	free(map);
+	return ret;
 }
 
 static int fill_device_from_item(struct extent_buffer *leaf,
@@ -1773,7 +1826,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
 			chunk = (struct btrfs_chunk *)(ptr - (u8 *)super_copy);
-			ret = read_one_chunk(root, &key, sb, chunk);
+			ret = read_one_chunk(root, &key, sb, chunk, -1);
 			if (ret)
 				break;
 			num_stripes = btrfs_chunk_num_stripes(sb, chunk);
@@ -1835,7 +1888,8 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
-			ret = read_one_chunk(root, &found_key, leaf, chunk);
+			ret = read_one_chunk(root, &found_key, leaf, chunk,
+					     slot);
 			BUG_ON(ret);
 		}
 		path->slots[0]++;
-- 
2.4.0

