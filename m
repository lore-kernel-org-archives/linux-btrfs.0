Return-Path: <SRS0=7Enz=7Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8F3C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Jun 2020 05:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BCC20678
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Jun 2020 05:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgFCF4O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 01:56:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:42464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgFCF4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Jun 2020 01:56:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 33698AE96;
        Wed,  3 Jun 2020 05:56:04 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 43/46] btrfs: Remove BTRFS_I calls in
Date:   Wed,  3 Jun 2020 08:55:43 +0300
Message-Id: <20200603055546.3889-44-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603055546.3889-1-nborisov@suse.com>
References: <20200603055546.3889-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All of its children functions use btrfs_inode.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bad40b41f329..39161a440125 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2265,7 +2265,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	struct extent_state *cached_state = NULL;
 	struct extent_changeset *data_reserved = NULL;
 	struct page *page;
-	struct inode *inode;
+	struct btrfs_inode *inode;
 	u64 page_start;
 	u64 page_end;
 	int ret = 0;
@@ -2273,7 +2273,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)

 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
-	inode = fixup->inode;
+	inode = BTRFS_I(fixup->inode);
 	page_start = page_offset(page);
 	page_end = page_offset(page) + PAGE_SIZE - 1;

@@ -2281,8 +2281,8 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	 * This is similar to page_mkwrite, we need to reserve the space before
 	 * we take the page lock.
 	 */
-	ret = btrfs_delalloc_reserve_space(BTRFS_I(inode), &data_reserved,
-					   page_start, PAGE_SIZE);
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
+					   PAGE_SIZE);
 again:
 	lock_page(page);

@@ -2310,10 +2310,8 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 		 *    when the page was already properly dealt with.
 		 */
 		if (!ret) {
-			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       PAGE_SIZE);
-			btrfs_delalloc_release_space(BTRFS_I(inode),
-						     data_reserved,
+			btrfs_delalloc_release_extents(inode, PAGE_SIZE);
+			btrfs_delalloc_release_space(inode, data_reserved,
 						     page_start, PAGE_SIZE,
 						     true);
 		}
@@ -2328,25 +2326,23 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	if (ret)
 		goto out_page;

-	lock_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			 &cached_state);
+	lock_extent_bits(&inode->io_tree, page_start, page_end, &cached_state);

 	/* already ordered? We're done */
 	if (PagePrivate2(page))
 		goto out_reserved;

-	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), page_start,
-					PAGE_SIZE);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_SIZE);
 	if (ordered) {
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
-				     page_end, &cached_state);
+		unlock_extent_cached(&inode->io_tree, page_start, page_end,
+				     &cached_state);
 		unlock_page(page);
-		btrfs_start_ordered_extent(inode, ordered, 1);
+		btrfs_start_ordered_extent(&inode->vfs_inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 		goto again;
 	}

-	ret = btrfs_set_extent_delalloc(BTRFS_I(inode), page_start, page_end, 0,
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
 					&cached_state);
 	if (ret)
 		goto out_reserved;
@@ -2361,11 +2357,11 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	BUG_ON(!PageDirty(page));
 	free_delalloc_space = false;
 out_reserved:
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
+	btrfs_delalloc_release_extents(inode, PAGE_SIZE);
 	if (free_delalloc_space)
-		btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-					     page_start, PAGE_SIZE, true);
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
+		btrfs_delalloc_release_space(inode, data_reserved, page_start,
+					     PAGE_SIZE, true);
+	unlock_extent_cached(&inode->io_tree, page_start, page_end,
 			     &cached_state);
 out_page:
 	if (ret) {
@@ -2388,7 +2384,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	 * that could need flushing space. Recursing back to fixup worker would
 	 * deadlock.
 	 */
-	btrfs_add_delayed_iput(inode);
+	btrfs_add_delayed_iput(&inode->vfs_inode);
 }

 /*
--
2.17.1

