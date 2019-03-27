Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21837C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED6712087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfC0MYZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:24:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:55234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728376AbfC0MYY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 08:24:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CBE40AF5B
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 12:24:22 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 05/15] btrfs: Populate ->orig_block_len during read_one_chunk
Date:   Wed, 27 Mar 2019 14:24:08 +0200
Message-Id: <20190327122418.24027-6-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190327122418.24027-1-nborisov@suse.com>
References: <20190327122418.24027-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Chunks read from disk currently don't get their ->orig_block_len member
set, in contrast when a new chunk is allocated, the respective
extent_map's ->orig_block_len is assigned the size of the stripe of this
chunk. Let's apply the same strategy for chunks which are read from
disk, not only does this codify the invariant that ->orig_block_len
always contains the size of the stripe for a chunk (when the em belongs
to the mapping tree). But it's also a preparatory patch for further work
around tracking chunk allocation in an extent tree rather than
pinned/pending lists.

Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 256f7c5476bc..d2d37adbc6fd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6814,6 +6814,26 @@ static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
 			      devid, uuid);
 }
 
+static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripes)
+{
+	int index = btrfs_bg_flags_to_raid_index(type);
+	int ncopies = btrfs_raid_array[index].ncopies;
+	int data_stripes;
+
+	switch (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case BTRFS_BLOCK_GROUP_RAID5:
+		data_stripes = num_stripes - 1;
+		break;
+	case BTRFS_BLOCK_GROUP_RAID6:
+		data_stripes = num_stripes - 2;
+		break;
+	default:
+		data_stripes = num_stripes / ncopies;
+		break;
+	}
+	return div_u64(chunk_len, data_stripes);
+}
+
 static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
@@ -6873,6 +6893,8 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	map->type = btrfs_chunk_type(leaf, chunk);
 	map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
 	map->verified_stripes = 0;
+	em->orig_block_len = calc_stripe_length(map->type, em->len,
+						map->num_stripes);
 	for (i = 0; i < num_stripes; i++) {
 		map->stripes[i].physical =
 			btrfs_stripe_offset_nr(leaf, chunk, i);
@@ -7730,25 +7752,6 @@ int btrfs_bg_type_to_factor(u64 flags)
 }
 
 
-static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripes)
-{
-	int index = btrfs_bg_flags_to_raid_index(type);
-	int ncopies = btrfs_raid_array[index].ncopies;
-	int data_stripes;
-
-	switch (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
-	case BTRFS_BLOCK_GROUP_RAID5:
-		data_stripes = num_stripes - 1;
-		break;
-	case BTRFS_BLOCK_GROUP_RAID6:
-		data_stripes = num_stripes - 2;
-		break;
-	default:
-		data_stripes = num_stripes / ncopies;
-		break;
-	}
-	return div_u64(chunk_len, data_stripes);
-}
 
 static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 				 u64 chunk_offset, u64 devid,
-- 
2.17.1

