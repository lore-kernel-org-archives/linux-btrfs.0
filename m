Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6F4C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 13:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871A6217D7
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 13:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbeLRNKG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:10:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:38696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbeLRNKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 08:10:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A6E2AF3B
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 13:10:04 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove impossible condition from mergable_maps
Date:   Tue, 18 Dec 2018 15:10:02 +0200
Message-Id: <20181218131002.12480-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
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
 fs/btrfs/extent_map.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7eea8b6e2cd3..7cc893876f83 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -217,8 +217,6 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 	      prev->block_start == EXTENT_MAP_HOLE) ||
 	     (next->block_start == EXTENT_MAP_INLINE &&
 	      prev->block_start == EXTENT_MAP_INLINE) ||
-	     (next->block_start == EXTENT_MAP_DELALLOC &&
-	      prev->block_start == EXTENT_MAP_DELALLOC) ||
 	     (next->block_start < EXTENT_MAP_LAST_BYTE - 1 &&
 	      next->block_start == extent_map_block_end(prev)))) {
 		return 1;
-- 
2.17.1

