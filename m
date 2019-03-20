Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661C7C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 416202184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfCTGh2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:37:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:40854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727707AbfCTGh1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:37:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1AADEAD9F
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:37:26 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCh v2 3/9] btrfs: tree-checker: Make btrfs_check_chunk_valid() return EUCLEAN instead of EIO
Date:   Wed, 20 Mar 2019 14:37:11 +0800
Message-Id: <20190320063717.31770-4-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320063717.31770-1-wqu@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

To follow the standard behavior of tree-checker.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c2e321d2b7bc..63fbe0b5ae8e 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -520,31 +520,31 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	if (!num_stripes) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk num_stripes, have %u", num_stripes);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
 		chunk_err(fs_info, leaf, chunk, logical,
 		"invalid chunk logical, have %llu should aligned to %u",
 			  logical, fs_info->sectorsize);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk sectorsize, have %u expect %u",
 			  btrfs_chunk_sector_size(leaf, chunk),
 			  fs_info->sectorsize);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk length, have %llu", length);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk stripe length: %llu",
 			  stripe_len);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 	    type) {
@@ -553,14 +553,14 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
 			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 			  btrfs_chunk_type(leaf, chunk));
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
 		chunk_err(fs_info, leaf, chunk, logical,
 	"missing chunk type flag, have 0x%llx one bit must be set in 0x%llx",
 			  type, BTRFS_BLOCK_GROUP_TYPE_MASK);
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
@@ -568,7 +568,7 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "system chunk with data or metadata type: 0x%llx",
 			  type);
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	features = btrfs_super_incompat_flags(fs_info->super_copy);
@@ -580,7 +580,7 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 		    (type & BTRFS_BLOCK_GROUP_DATA)) {
 			chunk_err(fs_info, leaf, chunk, logical,
 			"mixed chunk type in non-mixed mode: 0x%llx", type);
-			return -EIO;
+			return -EUCLEAN;
 		}
 	}
 
@@ -595,7 +595,7 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
 			num_stripes, sub_stripes,
 			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	return 0;
-- 
2.21.0

