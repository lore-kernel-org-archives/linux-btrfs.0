Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16558 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbcFCTEX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 15:04:23 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2 2/2] Btrfs: add valid checks for chunk loading
Date: Fri,  3 Jun 2016 12:05:15 -0700
Message-Id: <1464980715-6442-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
References: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To prevent fuzz filesystem images from panic the whole system,
we need various validation checks to refuse to mount such an image
if btrfs finds any invalid value during loading chunks, including
both sys_array and regular chunks.

Note that these checks may not be sufficient to cover all corner cases,
feel free to add more checks.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: 
 - Fix several typos.

 fs/btrfs/volumes.c | 81 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 66 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d403ab6..7a169de 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6250,27 +6250,23 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	return dev;
 }
 
-static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
-			  struct extent_buffer *leaf,
-			  struct btrfs_chunk *chunk)
+/* Return -EIO if any error, otherwise return 0. */
+static int btrfs_check_chunk_valid(struct btrfs_root *root,
+				   struct extent_buffer *leaf,
+				   struct btrfs_chunk *chunk, u64 logical)
 {
-	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
-	struct map_lookup *map;
-	struct extent_map *em;
-	u64 logical;
 	u64 length;
 	u64 stripe_len;
-	u64 devid;
-	u8 uuid[BTRFS_UUID_SIZE];
-	int num_stripes;
-	int ret;
-	int i;
+	u16 num_stripes;
+	u16 sub_stripes;
+	u64 type;
 
-	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
-	/* Validation check */
+	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
+	type = btrfs_chunk_type(leaf, chunk);
+
 	if (!num_stripes) {
 		btrfs_err(root->fs_info, "invalid chunk num_stripes: %u",
 			  num_stripes);
@@ -6281,6 +6277,11 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			  "invalid chunk logical %llu", logical);
 		return -EIO;
 	}
+	if (btrfs_chunk_sector_size(leaf, chunk) != root->sectorsize) {
+		btrfs_err(root->fs_info, "invalid chunk sectorsize %u",
+			  btrfs_chunk_sector_size(leaf, chunk));
+		return -EIO;
+	}
 	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
 		btrfs_err(root->fs_info,
 			"invalid chunk length %llu", length);
@@ -6292,13 +6293,53 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		return -EIO;
 	}
 	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
-	    btrfs_chunk_type(leaf, chunk)) {
+	    type) {
 		btrfs_err(root->fs_info, "unrecognized chunk type: %llu",
 			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
 			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 			  btrfs_chunk_type(leaf, chunk));
 		return -EIO;
 	}
+	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
+	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
+	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
+	     num_stripes != 1)) {
+		btrfs_err(root->fs_info, "invalid num_stripes:sub_stripes %u:%u for profile %llu",
+			  num_stripes, sub_stripes,
+			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
+			  struct extent_buffer *leaf,
+			  struct btrfs_chunk *chunk)
+{
+	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	struct map_lookup *map;
+	struct extent_map *em;
+	u64 logical;
+	u64 length;
+	u64 stripe_len;
+	u64 devid;
+	u8 uuid[BTRFS_UUID_SIZE];
+	int num_stripes;
+	int ret;
+	int i;
+
+	logical = key->offset;
+	length = btrfs_chunk_length(leaf, chunk);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+
+	ret = btrfs_check_chunk_valid(root, leaf, chunk, logical);
+	if (ret)
+		return ret;
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
@@ -6546,6 +6587,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	u32 array_size;
 	u32 len = 0;
 	u32 cur_offset;
+	u64 type;
 	struct btrfs_key key;
 
 	ASSERT(BTRFS_SUPER_INFO_SIZE <= root->nodesize);
@@ -6612,6 +6654,15 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 				break;
 			}
 
+			type = btrfs_chunk_type(sb, chunk);
+			if ((type & BTRFS_BLOCK_GROUP_SYSTEM) == 0) {
+				printk(KERN_ERR
+	    "BTRFS: invalid chunk type %llu in sys_array at offset %u\n",
+					type, cur_offset);
+				ret = -EIO;
+				break;
+			}
+
 			len = btrfs_chunk_item_size(num_stripes);
 			if (cur_offset + len > array_size)
 				goto out_short_read;
-- 
2.5.5

