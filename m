Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC36CC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 18:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96D0F208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 18:58:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96D0F208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbeK1F4v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 00:56:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:56086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726445AbeK1F4v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 00:56:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19E17AFF6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 18:58:00 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Refactor btrfs_merge_bio_hook
Date:   Tue, 27 Nov 2018 20:57:58 +0200
Message-Id: <20181127185758.16220-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function really checks whether adding more data to the bio will
straddle a stripe/chunk. So first let's give it a more appropraite
name - btrfs_bio_fits_in_stripe. Secondly, the offset parameter was
never used to just remove it. Thirdly, pages are submitted to either
btree or data inodes so it's guaranteed that tree->ops is set so replace
the check with an ASSERT. Finally, document the parameters of the
function. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/compression.c |  7 ++++---
 fs/btrfs/ctree.h       |  5 ++---
 fs/btrfs/extent_io.c   |  4 ++--
 fs/btrfs/inode.c       | 19 ++++++++++++-------
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 34d50bc5c10d..dba59ae914b8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -332,7 +332,8 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 		page = compressed_pages[pg_index];
 		page->mapping = inode->i_mapping;
 		if (bio->bi_iter.bi_size)
-			submit = btrfs_merge_bio_hook(page, 0, PAGE_SIZE, bio, 0);
+			submit = btrfs_bio_fits_in_stripe(page, PAGE_SIZE, bio,
+							  0);
 
 		page->mapping = NULL;
 		if (submit || bio_add_page(bio, page, PAGE_SIZE, 0) <
@@ -610,8 +611,8 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		page->index = em_start >> PAGE_SHIFT;
 
 		if (comp_bio->bi_iter.bi_size)
-			submit = btrfs_merge_bio_hook(page, 0, PAGE_SIZE,
-					comp_bio, 0);
+			submit = btrfs_bio_fits_in_stripe(page, PAGE_SIZE,
+							  comp_bio, 0);
 
 		page->mapping = NULL;
 		if (submit || bio_add_page(comp_bio, page, PAGE_SIZE, 0) <
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a98507fa9192..791112a82775 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3191,9 +3191,8 @@ void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 				 struct extent_state *other);
 void btrfs_split_delalloc_extent(struct inode *inode,
 				 struct extent_state *orig, u64 split);
-int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
-			 size_t size, struct bio *bio,
-			 unsigned long bio_flags);
+int btrfs_bio_fits_in_stripe(struct page *page, size_t size, struct bio *bio,
+			     unsigned long bio_flags);
 void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end);
 vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 582b4b1c41e0..19f4b8fd654f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2759,8 +2759,8 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 		else
 			contig = bio_end_sector(bio) == sector;
 
-		if (tree->ops && btrfs_merge_bio_hook(page, offset, page_size,
-						      bio, bio_flags))
+		ASSERT(tree->ops);
+		if (btrfs_bio_fits_in_stripe(page, page_size, bio, bio_flags))
 			can_merge = false;
 
 		if (prev_bio_flags != bio_flags || !contig || !can_merge ||
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index be7d43c42779..11c533db2db7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1881,16 +1881,21 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 }
 
 /*
- * Merge bio hook, this must check the chunk tree to make sure we don't create
- * bios that span stripes or chunks
+ * btrfs_bio_fits_in_stripe - Checks whether the size of the given bio will fit
+ * in a chunk's stripe. This function ensures that bios do not span a
+ * stripe/chunk
  *
- * return 1 if page cannot be merged to bio
- * return 0 if page can be merged to bio
+ * @page - The page we are about to add to the bio
+ * @size - size we want to add to the bio
+ * @bio - bio we want to ensure is smaller than a stripe
+ * @bio_flags - flags of the bio
+ *
+ * return 1 if page cannot be added to the bio
+ * return 0 if page can be added to the bio
  * return error otherwise
  */
-int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
-			 size_t size, struct bio *bio,
-			 unsigned long bio_flags)
+int btrfs_bio_fits_in_stripe(struct page *page, size_t size, struct bio *bio,
+			     unsigned long bio_flags)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-- 
2.17.1

