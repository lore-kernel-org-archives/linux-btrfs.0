Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751622AbeCHOf3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:29 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A91DBAE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/22] btrfs: assume that bio_ret is always valid in submit_extent_page
Date: Thu,  8 Mar 2018 15:33:08 +0100
Message-Id: <2ce0d30ad6c25a4266fed3c00cbdb77a6145f207.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass a valid pointer so we can drop the redundant checks.
The call to submit_one_bio never happend and can be removed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dfeb74a0be77..d00d5a59ff21 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2758,6 +2758,7 @@ static int merge_bio(struct extent_io_tree *tree, struct page *page,
 
 /*
  * @opf:	bio REQ_OP_* and REQ_* flags as one value
+ * @bio_ret:	must be valid pointer, newly allocated bio will be stored there
  */
 static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
@@ -2778,7 +2779,9 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 	size_t page_size = min_t(size_t, size, PAGE_SIZE);
 	sector_t sector = offset >> 9;
 
-	if (bio_ret && *bio_ret) {
+	ASSERT(bio_ret);
+
+	if (*bio_ret) {
 		bio = *bio_ret;
 		if (old_compressed)
 			contig = bio->bi_iter.bi_sector == sector;
@@ -2813,10 +2816,7 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 		wbc_account_io(wbc, page, page_size);
 	}
 
-	if (bio_ret)
-		*bio_ret = bio;
-	else
-		ret = submit_one_bio(bio, mirror_num, bio_flags);
+	*bio_ret = bio;
 
 	return ret;
 }
-- 
2.16.2

