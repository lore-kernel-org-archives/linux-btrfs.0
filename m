Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BA7C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 14:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A4E420657
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 14:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfAHOxt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:53:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:54852 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727662AbfAHOxt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 09:53:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2162DAE76
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 14:53:48 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     dsterba@suse.cz
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Remove impossible condition from mergable_maps
Date:   Tue,  8 Jan 2019 16:53:46 +0200
Message-Id: <20190108145346.24724-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190107191019.GD23615@twin.jikos.cz>
References: <20190107191019.GD23615@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can never have extents marked as EXTENT_MAP_DELALLOC since this
value is only ever used by btrfs_get_extent_fiemap. In this case the
extent map is created by btrfs_get_extent_fiemap and is never really
published, this flag is used to return the corresponding userspace one.
Considering this, it's pointless having a check for EXTENT_MAP_DELALLOC
in mergable_maps. Just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V2: 
 * Add assert in mergable_maps to ensure EXTENT_MAP_DELALLOC is not set
 * Clarifty that EXTENT_MAP_DELALLOC is only used during fiemap in a comment

 fs/btrfs/extent_map.c | 4 ++--
 fs/btrfs/extent_map.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index a042a193c120..c65f208acfb3 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -210,6 +210,8 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 	if (!list_empty(&prev->list) || !list_empty(&next->list))
 		return 0;
 
+	ASSERT(next->block_start != EXTENT_MAP_DELALLOC &&
+	       prev->block_start != EXTENT_MAP_DELALLOC);
 	if (extent_map_end(prev) == next->start &&
 	    prev->flags == next->flags &&
 	    prev->bdev == next->bdev &&
@@ -217,8 +219,6 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 	      prev->block_start == EXTENT_MAP_HOLE) ||
 	     (next->block_start == EXTENT_MAP_INLINE &&
 	      prev->block_start == EXTENT_MAP_INLINE) ||
-	     (next->block_start == EXTENT_MAP_DELALLOC &&
-	      prev->block_start == EXTENT_MAP_DELALLOC) ||
 	     (next->block_start < EXTENT_MAP_LAST_BYTE - 1 &&
 	      next->block_start == extent_map_block_end(prev)))) {
 		return 1;
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index ef05a0121652..9ef8766f478a 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -9,7 +9,7 @@
 #define EXTENT_MAP_LAST_BYTE ((u64)-4)
 #define EXTENT_MAP_HOLE ((u64)-3)
 #define EXTENT_MAP_INLINE ((u64)-2)
-#define EXTENT_MAP_DELALLOC ((u64)-1)
+#define EXTENT_MAP_DELALLOC ((u64)-1) /* used only during fiemap calls */
 
 /* bits for the extent_map::flags field */
 enum {
-- 
2.17.1

