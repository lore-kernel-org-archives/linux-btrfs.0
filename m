Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752496AbeDSHqo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 03:46:44 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 31F16ADDA
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 07:46:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/6] btrfs: Remove map argument from try_release_extent_state
Date: Thu, 19 Apr 2018 10:46:35 +0300
Message-Id: <1524123999-4220-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1524123999-4220-1-git-send-email-nborisov@suse.com>
References: <1524123999-4220-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not used in the function so just remove it. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9e72e4048acd..ffa7bf370f14 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4202,8 +4202,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
  * are locked or under IO and drops the related state bits if it is safe
  * to drop the page.
  */
-static int try_release_extent_state(struct extent_map_tree *map,
-				    struct extent_io_tree *tree,
+static int try_release_extent_state(struct extent_io_tree *tree,
 				    struct page *page, gfp_t mask)
 {
 	u64 start = page_offset(page);
@@ -4278,7 +4277,7 @@ int try_release_extent_mapping(struct page *page, gfp_t mask)
 			free_extent_map(em);
 		}
 	}
-	return try_release_extent_state(map, tree, page, mask);
+	return try_release_extent_state(tree, page, mask);
 }
 
 /*
-- 
2.7.4

