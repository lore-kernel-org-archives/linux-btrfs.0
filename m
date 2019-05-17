Return-Path: <SRS0=EcPT=TR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD8BC46460
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 May 2019 09:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3927A2087B
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 May 2019 09:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfEQJmY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 May 2019 05:42:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:33296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728466AbfEQJmY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 May 2019 05:42:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04965AEDB
        for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2019 09:42:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9EA33DA871; Fri, 17 May 2019 11:43:22 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 05/15] btrfs: use raid_attr in btrfs_chunk_max_errors
Date:   Fri, 17 May 2019 11:43:22 +0200
Message-Id: <7870aa26a06ec143808232dc58b20f24a5dc18d6.1558085801.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1558085801.git.dsterba@suse.com>
References: <cover.1558085801.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The number of tolerated failures is stored in the raid_attr table, use
it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a3fa741c8534..995a15a816f2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5325,19 +5325,9 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans)
 
 static inline int btrfs_chunk_max_errors(struct map_lookup *map)
 {
-	int max_errors;
-
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
-			 BTRFS_BLOCK_GROUP_RAID10 |
-			 BTRFS_BLOCK_GROUP_RAID5)) {
-		max_errors = 1;
-	} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
-		max_errors = 2;
-	} else {
-		max_errors = 0;
-	}
+	const int index = btrfs_bg_flags_to_raid_index(map->type);
 
-	return max_errors;
+	return btrfs_raid_array[index].tolerated_failures;
 }
 
 int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
-- 
2.21.0

