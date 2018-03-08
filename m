Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56781 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754612AbeCHOfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:37 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9A36EAE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/22] btrfs: cleanup merging conditions in submit_extent_page
Date: Thu,  8 Mar 2018 15:33:15 +0100
Message-Id: <c268cf123903199a103a96d3baf9b07846f5ca43.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The merge call was factored out to a separate helper but it's a trivial
one and arguably we can opencode it and cache the value.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ffcbdb2390a1..2fbc58b0b908 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2744,18 +2744,6 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	return blk_status_to_errno(ret);
 }
 
-static int merge_bio(struct extent_io_tree *tree, struct page *page,
-		     unsigned long offset, size_t size, struct bio *bio,
-		     unsigned long bio_flags)
-{
-	int ret = 0;
-	if (tree->ops)
-		ret = tree->ops->merge_bio_hook(page, offset, size, bio,
-						bio_flags);
-	return ret;
-
-}
-
 /*
  * @opf:	bio REQ_OP_* and REQ_* flags as one value
  * @bio_ret:	must be valid pointer, newly allocated bio will be stored there
@@ -2774,23 +2762,27 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 {
 	int ret = 0;
 	struct bio *bio;
-	int contig = 0;
-	int old_compressed = prev_bio_flags & EXTENT_BIO_COMPRESSED;
 	size_t page_size = min_t(size_t, size, PAGE_SIZE);
 	sector_t sector = offset >> 9;
 
 	ASSERT(bio_ret);
 
 	if (*bio_ret) {
+		bool contig;
+		bool can_merge = true;
+
 		bio = *bio_ret;
-		if (old_compressed)
+		if (prev_bio_flags & EXTENT_BIO_COMPRESSED)
 			contig = bio->bi_iter.bi_sector == sector;
 		else
 			contig = bio_end_sector(bio) == sector;
 
-		if (prev_bio_flags != bio_flags || !contig ||
+		if (tree->ops && tree->ops->merge_bio_hook(page, offset,
+					page_size, bio, bio_flags))
+			can_merge = false;
+
+		if (prev_bio_flags != bio_flags || !contig || !can_merge ||
 		    force_bio_submit ||
-		    merge_bio(tree, page, pg_offset, page_size, bio, bio_flags) ||
 		    bio_add_page(bio, page, page_size, pg_offset) < page_size) {
 			ret = submit_one_bio(bio, mirror_num, prev_bio_flags);
 			if (ret < 0) {
-- 
2.16.2

