Return-Path: <SRS0=Px4L=ZL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD19C432C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Nov 2019 12:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F90020637
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Nov 2019 12:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfKSMGC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 07:06:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:49324 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727677AbfKSMGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Nov 2019 07:06:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4860B3DB;
        Tue, 19 Nov 2019 12:06:00 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/6] btrfs: Read stripe len directly in btrfs_rmap_block
Date:   Tue, 19 Nov 2019 14:05:54 +0200
Message-Id: <20191119120555.6465-6-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119120555.6465-1-nborisov@suse.com>
References: <20191119120555.6465-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

extent_map::orig_block_len contains the size of a physical stripe when
it's used to describe block groups. So get the size directly in
btrfs_rmap_block rather than open-coding the calculations. No
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/block-group.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c3b1f304bc70..2ab4d9cb598a 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1546,17 +1546,12 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 		return -EIO;
 
 	map = em->map_lookup;
-	data_stripe_length = em->len;
+	data_stripe_length = em->orig_block_len;
 	io_stripe_size = map->stripe_len;
 
-	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
-		data_stripe_length = div_u64(data_stripe_length, map->num_stripes / map->sub_stripes);
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID0)
-		data_stripe_length = div_u64(data_stripe_length, map->num_stripes);
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
-		data_stripe_length = div_u64(data_stripe_length, nr_data_stripes(map));
+	/* For raid5/6 adjust to a full IO stripe length */
+	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
 		io_stripe_size = map->stripe_len * nr_data_stripes(map);
-	}
 
 	buf = kcalloc(map->num_stripes, sizeof(u64), GFP_NOFS);
 	if (!buf) {
-- 
2.17.1

