Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751622AbeCHOfc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:32 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA715AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/22] btrfs: assume that prev_em_start is always valid in __do_readpage
Date: Thu,  8 Mar 2018 15:33:10 +0100
Message-Id: <f92bec1a7defa40fe7c51a4d570e45f419d0c9df.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass a valid pointer, we can remove the redundant checks.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d00d5a59ff21..36514baa661e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2875,6 +2875,8 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
  * handlers)
  * XXX JDM: This needs looking at to ensure proper page locking
  * return 0 on success, otherwise return error
+ *
+ * @prev_em_start:	return value of previous em start value; must be valid
  */
 static int __do_readpage(struct extent_io_tree *tree,
 			 struct page *page,
@@ -2903,6 +2905,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 	size_t blocksize = inode->i_sb->s_blocksize;
 	unsigned long this_bio_flag = 0;
 
+	ASSERT(prev_em_start);
+
 	set_page_extent_mapped(page);
 
 	end = page_end;
@@ -3012,12 +3016,11 @@ static int __do_readpage(struct extent_io_tree *tree,
 		 * non-optimal behavior (submitting 2 bios for the same extent).
 		 */
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
-		    prev_em_start && *prev_em_start != (u64)-1 &&
+		    *prev_em_start != (u64)-1 &&
 		    *prev_em_start != em->orig_start)
 			force_bio_submit = true;
 
-		if (prev_em_start)
-			*prev_em_start = em->orig_start;
+		*prev_em_start = em->orig_start;
 
 		free_extent_map(em);
 		em = NULL;
-- 
2.16.2

