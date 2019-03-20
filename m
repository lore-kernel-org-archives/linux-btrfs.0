Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8DAC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86C4A2184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfCTGhZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:37:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:40838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727143AbfCTGhZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:37:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76695AC69
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:37:22 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCh v2 1/9] btrfs: Move btrfs_check_chunk_valid() to tree-check.[ch] and export it
Date:   Wed, 20 Mar 2019 14:37:09 +0800
Message-Id: <20190320063717.31770-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320063717.31770-1-wqu@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

By function, chunk item verification is more suitable to be done inside
tree-checker.

So move btrfs_check_chunk_valid() to tree-checker.c and export it.

And since it's now moved to tree-checker, also add a better comment for
what this function is doing.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 99 +++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/tree-checker.h |  3 ++
 fs/btrfs/volumes.c      | 94 +-------------------------------------
 3 files changed, 103 insertions(+), 93 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index b8cdaf472031..4e44323ae758 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -448,6 +448,105 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
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
+		btrfs_err(fs_info, "invalid chunk num_stripes: %u",
+			  num_stripes);
+		return -EIO;
+	}
+	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
+		btrfs_err(fs_info, "invalid chunk logical %llu", logical);
+		return -EIO;
+	}
+	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
+		btrfs_err(fs_info, "invalid chunk sectorsize %u",
+			  btrfs_chunk_sector_size(leaf, chunk));
+		return -EIO;
+	}
+	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
+		btrfs_err(fs_info, "invalid chunk length %llu", length);
+		return -EIO;
+	}
+	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
+		btrfs_err(fs_info, "invalid chunk stripe length: %llu",
+			  stripe_len);
+		return -EIO;
+	}
+	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+	    type) {
+		btrfs_err(fs_info, "unrecognized chunk type: %llu",
+			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+			  btrfs_chunk_type(leaf, chunk));
+		return -EIO;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
+		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
+		return -EIO;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
+	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
+		btrfs_err(fs_info,
+			"system chunk with data or metadata type: 0x%llx", type);
+		return -EIO;
+	}
+
+	features = btrfs_super_incompat_flags(fs_info->super_copy);
+	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+		mixed = true;
+
+	if (!mixed) {
+		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
+		    (type & BTRFS_BLOCK_GROUP_DATA)) {
+			btrfs_err(fs_info,
+			"mixed chunk type in non-mixed mode: 0x%llx", type);
+			return -EIO;
+		}
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes != 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
+	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
+	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
+	     num_stripes != 1)) {
+		btrfs_err(fs_info,
+			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
+			num_stripes, sub_stripes,
+			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+
 /*
  * Common point to switch the item-specific validation.
  */
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
index 9024eee889b9..2a4ac5aa2a16 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -27,6 +27,7 @@
 #include "math.h"
 #include "dev-replace.h"
 #include "sysfs.h"
+#include "tree-checker.h"
 
 const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = {
@@ -6714,99 +6715,6 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
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
-	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes != 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
-	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
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

