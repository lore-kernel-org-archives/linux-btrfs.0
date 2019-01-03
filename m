Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64150C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E51320883
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbfACIuM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:50:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:60100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728760AbfACIuK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:50:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7EA0AFA5
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 08:50:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/7] btrfs: Replace open-coded maths with DIV_ROUND_UP
Date:   Thu,  3 Jan 2019 10:50:04 +0200
Message-Id: <20190103085005.32053-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190103085005.32053-1-nborisov@suse.com>
References: <20190103085005.32053-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In a couple of places it's required to calculate the number of pages
given a start and end offsets. Currently this is opencoded, unify the
code base by replacing all such sites with the DIV_ROUND_UP macro. Also,
current open-coded sites were buggy in that they were adding
'PAGE_SIZE', rather than 'PAGE_SIZE - 1'.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 7 +++----
 fs/btrfs/inode.c     | 8 +++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b9b30e618378..0cd41ec8b698 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3189,8 +3189,8 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 		 * delalloc_end is already one less than the total length, so
 		 * we don't subtract one from PAGE_SIZE
 		 */
-		delalloc_to_write += (delalloc_end - delalloc_start +
-				      PAGE_SIZE) >> PAGE_SHIFT;
+		delalloc_to_write += DIV_ROUND_UP(delalloc_end - delalloc_start,
+						  PAGE_SIZE);
 		delalloc_start = delalloc_end + 1;
 	}
 	if (wbc->nr_to_write < delalloc_to_write) {
@@ -4001,8 +4001,7 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 	struct address_space *mapping = inode->i_mapping;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct page *page;
-	unsigned long nr_pages = (end - start + PAGE_SIZE) >>
-		PAGE_SHIFT;
+	unsigned long nr_pages = DIV_ROUND_UP(end - start, PAGE_SIZE);
 
 	struct extent_page_data epd = {
 		.bio = NULL,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 41ad0d06b3d4..32977174826b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -469,7 +469,7 @@ static noinline void compress_file_range(struct inode *inode,
 	actual_end = min_t(u64, i_size_read(inode), end + 1);
 again:
 	will_compress = 0;
-	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
+	nr_pages = DIV_ROUND_UP(end - start, PAGE_SIZE);
 	BUILD_BUG_ON((BTRFS_MAX_COMPRESSED % PAGE_SIZE) != 0);
 	nr_pages = min_t(unsigned long, nr_pages,
 			BTRFS_MAX_COMPRESSED / PAGE_SIZE);
@@ -1157,8 +1157,7 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 	async_cow = container_of(work, struct async_cow, work);
 
 	fs_info = async_cow->fs_info;
-	nr_pages = (async_cow->end - async_cow->start + PAGE_SIZE) >>
-		PAGE_SHIFT;
+	nr_pages = DIV_ROUND_UP(async_cow->end - async_cow->start, PAGE_SIZE);
 
 	/* atomic_sub_return implies a barrier */
 	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
@@ -1221,8 +1220,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 				async_cow_start, async_cow_submit,
 				async_cow_free);
 
-		nr_pages = (cur_end - start + PAGE_SIZE) >>
-			PAGE_SHIFT;
+		nr_pages = DIV_ROUND_UP(cur_end - start, PAGE_SIZE);
 		atomic_add(nr_pages, &fs_info->async_delalloc_pages);
 
 		btrfs_queue_work(fs_info->delalloc_workers, &async_cow->work);
-- 
2.17.1

