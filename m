Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B98C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 07:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 917352081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 07:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfCHH3i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 02:29:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:33458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726297AbfCHH3h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Mar 2019 02:29:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1DDDAF9C;
        Fri,  8 Mar 2019 07:29:35 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
Subject: [PATCH 1/3] btrfs: tree-checker: Verify chunk items
Date:   Fri,  8 Mar 2019 15:29:27 +0800
Message-Id: <20190308072929.30863-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190308072929.30863-1-wqu@suse.com>
References: <20190308072929.30863-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We already have btrfs_check_chunk_valid() to verify each chunk before
tree-checker.

Merge that function into tree-checker, and update its error message to
be more readable.

Old error message would be something like:
  BTRFS error (device dm-3): invalid chunk num_stipres: 0

New error message would be:
  Btrfs critical (device dm-3): corrupt superblock syschunk array: chunk_start=2097152, invalid chunk num_stripes: 0
Or
  Btrfs critical (device dm-3): corrupt leaf: root=3 block=8388608 slot=3 chunk_start=2097152, invalid chunk num_stripes: 0

Btrfs_check_chunk_valid() is exported for super block syschunk array
verification.

Also make tree-checker to verify chunk items, this makes chunk item
checker covers all chunks and avoid fuzzed image.

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202751
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 152 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/tree-checker.h |   3 +
 fs/btrfs/volumes.c      |  94 +------------------------
 3 files changed, 156 insertions(+), 93 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index b8cdaf472031..fe3f37c23c29 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -448,6 +448,152 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+__printf(5, 6)
+__cold
+static void chunk_err(const struct btrfs_fs_info *fs_info,
+		      const struct extent_buffer *leaf,
+		      const struct btrfs_chunk *chunk, u64 logical,
+		      const char *fmt, ...)
+{
+	/* Only superblock eb is able to have such small offset */
+	bool is_sb = (leaf->start == BTRFS_SUPER_INFO_OFFSET);
+	struct va_format vaf;
+	va_list args;
+	int i;
+	int slot = -1;
+
+	if (!is_sb) {
+		/*
+		 * Get the slot number by iterating through all slots, this
+		 * would provide better readability.
+		 */
+		for (i = 0; i < btrfs_header_nritems(leaf); i++) {
+			if (btrfs_item_ptr_offset(leaf, i) ==
+					(unsigned long) chunk) {
+				slot = i;
+				break;
+			}
+		}
+	}
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (is_sb)
+		btrfs_crit(fs_info,
+		"corrupt superblock syschunk array: chunk_start=%llu, %pV",
+			   logical, &vaf);
+	else
+		btrfs_crit(fs_info,
+	"corrupt leaf: root=%llu block=%llu slot=%d chunk_start=%llu, %pV",
+			   BTRFS_CHUNK_TREE_OBJECTID, leaf->start, slot,
+			   logical, &vaf);
+	va_end(args);
+}
+
+/*
+ * The common chunk check which could also work on super block sys chunk array.
+ *
+ * Return -EUCLEAN if anything is corrupted.
+ * Return 0 if everything is OK.
+ */
+int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *leaf,
+			    struct btrfs_chunk *chunk, u64 logical)
+{
+	u64 length;
+	u64 stripe_len;
+	u16 num_stripes;
+	u16 sub_stripes;
+	u64 type;
+	u64 features;
+	bool mixed = false;
+
+	length = btrfs_chunk_length(leaf, chunk);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
+	type = btrfs_chunk_type(leaf, chunk);
+
+	if (!num_stripes) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk num_stripes: %u", num_stripes);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk logical %llu", logical);
+		return -EUCLEAN;
+	}
+	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk sectorsize %u",
+			  btrfs_chunk_sector_size(leaf, chunk));
+		return -EUCLEAN;
+	}
+	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk length %llu", length);
+		return -EUCLEAN;
+	}
+	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk stripe length: %llu", stripe_len);
+		return -EUCLEAN;
+	}
+	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+	    type) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "unrecognized chunk type: %llu",
+			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+			  btrfs_chunk_type(leaf, chunk));
+		return -EUCLEAN;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "missing chunk type flag: 0x%llx", type);
+		return -EUCLEAN;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
+	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			"system chunk with data or metadata type: 0x%llx", type);
+		return -EUCLEAN;
+	}
+
+	features = btrfs_super_incompat_flags(fs_info->super_copy);
+	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+		mixed = true;
+
+	if (!mixed) {
+		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
+		    (type & BTRFS_BLOCK_GROUP_DATA)) {
+			chunk_err(fs_info, leaf, chunk, logical,
+			"mixed chunk type in non-mixed mode: 0x%llx", type);
+			return -EUCLEAN;
+		}
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
+	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
+	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
+	     num_stripes != 1)) {
+		chunk_err(fs_info, leaf, chunk, logical,
+			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
+			num_stripes, sub_stripes,
+			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -455,6 +601,7 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 			   struct extent_buffer *leaf,
 			   struct btrfs_key *key, int slot)
 {
+	struct btrfs_chunk *chunk;
 	int ret = 0;
 
 	switch (key->type) {
@@ -472,6 +619,11 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
 		ret = check_block_group_item(fs_info, leaf, key, slot);
 		break;
+	case BTRFS_CHUNK_ITEM_KEY:
+		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk,
+					      key->offset);
+		break;
 	}
 	return ret;
 }
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index 6f8d1b627c53..6cb96ba5e711 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -33,4 +33,7 @@ int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
 			   struct extent_buffer *leaf);
 int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
 
+int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *leaf,
+			    struct btrfs_chunk *chunk, u64 logical);
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 15561926ab32..0e3822870f1e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -27,6 +27,7 @@
 #include "math.h"
 #include "dev-replace.h"
 #include "sysfs.h"
+#include "tree-checker.h"
 
 const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = {
@@ -6705,99 +6706,6 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	return dev;
 }
 
-/* Return -EIO if any error, otherwise return 0. */
-static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
-				   struct extent_buffer *leaf,
-				   struct btrfs_chunk *chunk, u64 logical)
-{
-	u64 length;
-	u64 stripe_len;
-	u16 num_stripes;
-	u16 sub_stripes;
-	u64 type;
-	u64 features;
-	bool mixed = false;
-
-	length = btrfs_chunk_length(leaf, chunk);
-	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
-	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
-	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
-	type = btrfs_chunk_type(leaf, chunk);
-
-	if (!num_stripes) {
-		btrfs_err(fs_info, "invalid chunk num_stripes: %u",
-			  num_stripes);
-		return -EIO;
-	}
-	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
-		btrfs_err(fs_info, "invalid chunk logical %llu", logical);
-		return -EIO;
-	}
-	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
-		btrfs_err(fs_info, "invalid chunk sectorsize %u",
-			  btrfs_chunk_sector_size(leaf, chunk));
-		return -EIO;
-	}
-	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
-		btrfs_err(fs_info, "invalid chunk length %llu", length);
-		return -EIO;
-	}
-	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
-		btrfs_err(fs_info, "invalid chunk stripe length: %llu",
-			  stripe_len);
-		return -EIO;
-	}
-	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
-	    type) {
-		btrfs_err(fs_info, "unrecognized chunk type: %llu",
-			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
-			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
-			  btrfs_chunk_type(leaf, chunk));
-		return -EIO;
-	}
-
-	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
-		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
-		return -EIO;
-	}
-
-	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
-	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
-		btrfs_err(fs_info,
-			"system chunk with data or metadata type: 0x%llx", type);
-		return -EIO;
-	}
-
-	features = btrfs_super_incompat_flags(fs_info->super_copy);
-	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
-		mixed = true;
-
-	if (!mixed) {
-		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
-		    (type & BTRFS_BLOCK_GROUP_DATA)) {
-			btrfs_err(fs_info,
-			"mixed chunk type in non-mixed mode: 0x%llx", type);
-			return -EIO;
-		}
-	}
-
-	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
-	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
-	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
-	     num_stripes != 1)) {
-		btrfs_err(fs_info,
-			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
-			num_stripes, sub_stripes,
-			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
 					u64 devid, u8 *uuid, bool error)
 {
-- 
2.21.0

