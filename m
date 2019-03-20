Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6923C10F05
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B5B2186A
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbfCTGh1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:37:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:40844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726916AbfCTGh0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:37:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 47268AC93
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:37:24 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCh v2 2/9] btrfs: tree-checker: Make chunk item checker more readable
Date:   Wed, 20 Mar 2019 14:37:10 +0800
Message-Id: <20190320063717.31770-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320063717.31770-1-wqu@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Old error message would be something like:
  BTRFS error (device dm-3): invalid chunk num_stipres: 0

New error message would be:
  Btrfs critical (device dm-3): corrupt superblock syschunk array: chunk_start=2097152, invalid chunk num_stripes: 0
Or
  Btrfs critical (device dm-3): corrupt leaf: root=3 block=8388608 slot=3 chunk_start=2097152, invalid chunk num_stripes: 0

And for certain error message, also output expected value.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 81 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 4e44323ae758..c2e321d2b7bc 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -448,6 +448,51 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+__printf(5, 6)
+__cold
+static void chunk_err(const struct btrfs_fs_info *fs_info,
+		      const struct extent_buffer *leaf,
+		      const struct btrfs_chunk *chunk, u64 logical,
+		      const char *fmt, ...)
+{
+	bool is_sb;
+	struct va_format vaf;
+	va_list args;
+	int i;
+	int slot = -1;
+
+	/* Only superblock eb is able to have such small offset */
+	is_sb = (leaf->start == BTRFS_SUPER_INFO_OFFSET);
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
 /*
  * The common chunk check which could also work on super block sys chunk array.
  *
@@ -473,31 +518,38 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	type = btrfs_chunk_type(leaf, chunk);
 
 	if (!num_stripes) {
-		btrfs_err(fs_info, "invalid chunk num_stripes: %u",
-			  num_stripes);
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk num_stripes, have %u", num_stripes);
 		return -EIO;
 	}
 	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
-		btrfs_err(fs_info, "invalid chunk logical %llu", logical);
+		chunk_err(fs_info, leaf, chunk, logical,
+		"invalid chunk logical, have %llu should aligned to %u",
+			  logical, fs_info->sectorsize);
 		return -EIO;
 	}
 	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
-		btrfs_err(fs_info, "invalid chunk sectorsize %u",
-			  btrfs_chunk_sector_size(leaf, chunk));
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk sectorsize, have %u expect %u",
+			  btrfs_chunk_sector_size(leaf, chunk),
+			  fs_info->sectorsize);
 		return -EIO;
 	}
 	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
-		btrfs_err(fs_info, "invalid chunk length %llu", length);
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk length, have %llu", length);
 		return -EIO;
 	}
 	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
-		btrfs_err(fs_info, "invalid chunk stripe length: %llu",
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk stripe length: %llu",
 			  stripe_len);
 		return -EIO;
 	}
 	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 	    type) {
-		btrfs_err(fs_info, "unrecognized chunk type: %llu",
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "unrecognized chunk type: 0x%llx",
 			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
 			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 			  btrfs_chunk_type(leaf, chunk));
@@ -505,14 +557,17 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
-		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
+		chunk_err(fs_info, leaf, chunk, logical,
+	"missing chunk type flag, have 0x%llx one bit must be set in 0x%llx",
+			  type, BTRFS_BLOCK_GROUP_TYPE_MASK);
 		return -EIO;
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
 	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
-		btrfs_err(fs_info,
-			"system chunk with data or metadata type: 0x%llx", type);
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "system chunk with data or metadata type: 0x%llx",
+			  type);
 		return -EIO;
 	}
 
@@ -523,7 +578,7 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	if (!mixed) {
 		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
 		    (type & BTRFS_BLOCK_GROUP_DATA)) {
-			btrfs_err(fs_info,
+			chunk_err(fs_info, leaf, chunk, logical,
 			"mixed chunk type in non-mixed mode: 0x%llx", type);
 			return -EIO;
 		}
@@ -536,7 +591,7 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
 	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
 	     num_stripes != 1)) {
-		btrfs_err(fs_info,
+		chunk_err(fs_info, leaf, chunk, logical,
 			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
 			num_stripes, sub_stripes,
 			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
-- 
2.21.0

