Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18718 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751833AbdDCUrI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 16:47:08 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: cleanup submit_one_bio
Date: Mon,  3 Apr 2017 13:45:47 -0700
Message-Id: <1491252347-3827-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@bio_offset is passed into submit_bio_hook and is used at
btrfs_wq_submit_bio(), but only dio code makes use of @bio_offset, so
remove other dead code.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7b5139d..79f38e6a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2746,19 +2746,14 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 				       unsigned long bio_flags)
 {
 	int ret = 0;
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct page *page = bvec->bv_page;
 	struct extent_io_tree *tree = bio->bi_private;
-	u64 start;
-
-	start = page_offset(page) + bvec->bv_offset;
 
 	bio->bi_private = NULL;
 	bio_get(bio);
 
 	if (tree->ops)
 		ret = tree->ops->submit_bio_hook(page->mapping->host, bio,
-					   mirror_num, bio_flags, start);
+					   mirror_num, bio_flags, 0);
 	else
 		btrfsic_submit_bio(bio);
 
-- 
2.5.5

