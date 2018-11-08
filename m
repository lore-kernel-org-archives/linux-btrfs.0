Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80616C46465
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5231020825
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5231020825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbeKHRwe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 12:52:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:35026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726474AbeKHRwd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 12:52:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26DADAE00
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 08:18:12 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Remove unused extent_state argument from btrfs_writepage_endio_finish_ordered
Date:   Thu,  8 Nov 2018 10:18:08 +0200
Message-Id: <20181108081808.16920-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181108081808.16920-1-nborisov@suse.com>
References: <20181108081808.16920-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This parameter was never used, yet was part of the interface of the
function ever since its introduction as extent_io_ops::writepage_end_io_hook
in e6dcd2dc9c48 ("Btrfs: New data=ordered implementation"). Now that
NULL is passed everywhere as a value for this parameter let's remove it
for good. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/compression.c |  6 ++++--
 fs/btrfs/ctree.h       |  4 ++--
 fs/btrfs/extent_io.c   | 12 +++++-------
 fs/btrfs/inode.c       |  7 +++----
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index bde8d0487bbb..717d9300dd18 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -251,8 +251,10 @@ static void end_compressed_bio_write(struct bio *bio)
 	tree = &BTRFS_I(inode)->io_tree;
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
 	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
-			cb->start, cb->start + cb->len - 1, NULL,
-			bio->bi_status ? BLK_STS_OK : BLK_STS_NOTSUPP);
+					     cb->start,
+					     cb->start + cb->len - 1,
+					     bio->bi_status ?
+					     BLK_STS_OK : BLK_STS_NOTSUPP);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b41ec42f405..c48fcaf4004d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3179,7 +3179,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *new_root,
 			     struct btrfs_root *parent_root,
 			     u64 new_dirid);
-void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
+ void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 			       unsigned *bits);
 void btrfs_clear_delalloc_extent(struct inode *inode,
 				 struct extent_state *state, unsigned *bits);
@@ -3231,7 +3231,7 @@ int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
 		struct writeback_control *wbc);
 int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end);
 void btrfs_writepage_endio_finish_ordered(struct page *page, u64 start,
-		u64 end, struct extent_state *state, int uptodate);
+					  u64 end, int uptodate);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cca9d3cbe74a..f3bf7f9c13c0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2408,7 +2408,7 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-	btrfs_writepage_endio_finish_ordered(page, start, end, NULL, uptodate);
+	btrfs_writepage_endio_finish_ordered(page, start, end, uptodate);
 
 	if (!uptodate) {
 		ClearPageUptodate(page);
@@ -3329,8 +3329,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 
 	end = page_end;
 	if (i_size <= start) {
-		btrfs_writepage_endio_finish_ordered(page, start, page_end,
-						     NULL, 1);
+		btrfs_writepage_endio_finish_ordered(page, start, page_end, 1);
 		goto done;
 	}
 
@@ -3342,7 +3341,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 
 		if (cur >= i_size) {
 			btrfs_writepage_endio_finish_ordered(page, cur,
-							     page_end, NULL, 1);
+							     page_end, 1);
 			break;
 		}
 		em = btrfs_get_extent(BTRFS_I(inode), page, pg_offset, cur,
@@ -3379,7 +3378,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 			if (!compressed)
 				btrfs_writepage_endio_finish_ordered(page, cur,
 							    cur + iosize - 1,
-							    NULL, 1);
+							    1);
 			else if (compressed) {
 				/* we don't want to end_page_writeback on
 				 * a compressed extent.  this happens
@@ -4066,8 +4065,7 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 			ret = __extent_writepage(page, &wbc_writepages, &epd);
 		else {
 			btrfs_writepage_endio_finish_ordered(page, start,
-						    start + PAGE_SIZE - 1,
-						    NULL, 1);
+						    start + PAGE_SIZE - 1, 1);
 			unlock_page(page);
 		}
 		put_page(page);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a097f5fde31d..c3f540933238 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -852,8 +852,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 			const u64 end = start + async_extent->ram_size - 1;
 
 			p->mapping = inode->i_mapping;
-			btrfs_writepage_endio_finish_ordered(p, start, end,
-							     NULL, 0);
+			btrfs_writepage_endio_finish_ordered(p, start, end, 0);
 
 			p->mapping = NULL;
 			extent_clear_unlock_delalloc(inode, start, end, end,
@@ -3152,8 +3151,8 @@ static void finish_ordered_fn(struct btrfs_work *work)
 	btrfs_finish_ordered_io(ordered_extent);
 }
 
-void btrfs_writepage_endio_finish_ordered(struct page *page, u64 start, u64 end,
-				struct extent_state *state, int uptodate)
+void btrfs_writepage_endio_finish_ordered(struct page *page, u64 start,
+					  u64 end, int uptodate)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-- 
2.17.1

