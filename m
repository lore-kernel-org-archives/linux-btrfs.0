Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45706 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdJCPHJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 11:07:09 -0400
Received: by mail-lf0-f68.google.com with SMTP id d17so10092508lfe.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 08:07:08 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 3/4] Btrfs: handle unaligned tail of data ranges more efficient
Date: Tue,  3 Oct 2017 18:06:03 +0300
Message-Id: <20171003150604.19596-4-nefelim4ag@gmail.com>
In-Reply-To: <20171003150604.19596-1-nefelim4ag@gmail.com>
References: <20171003150604.19596-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At now while switch page bits in data ranges
we always hande +1 page, for cover case
where end of data range is not page aligned

Let's handle that case more obvious and efficient
Check end aligment directly and touch +1 page
only then needed

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/extent_io.c | 12 ++++++++++--
 fs/btrfs/inode.c     |  6 +++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0538bf85adc3..131b7d1df9f7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1359,7 +1359,11 @@ void extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end)
 	unsigned long end_index = end >> PAGE_SHIFT;
 	struct page *page;

-	while (index <= end_index) {
+	/* Don't miss unaligned end */
+	if (!IS_ALIGNED(end, PAGE_SIZE))
+		end_index++;
+
+	while (index < end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		BUG_ON(!page); /* Pages should be in the extent_io_tree */
 		clear_page_dirty_for_io(page);
@@ -1374,7 +1378,11 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
 	unsigned long end_index = end >> PAGE_SHIFT;
 	struct page *page;

-	while (index <= end_index) {
+	/* Don't miss unaligned end */
+	if (!IS_ALIGNED(end, PAGE_SIZE))
+		end_index++;
+
+	while (index < end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		BUG_ON(!page); /* Pages should be in the extent_io_tree */
 		__set_page_dirty_nobuffers(page);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b6e81bd650ea..b4974d969f67 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10799,7 +10799,11 @@ void btrfs_set_range_writeback(void *private_data, u64 start, u64 end)
 	unsigned long end_index = end >> PAGE_SHIFT;
 	struct page *page;

-	while (index <= end_index) {
+	/* Don't miss unaligned end */
+	if (!IS_ALIGNED(end, PAGE_SIZE))
+		end_index++;
+
+	while (index < end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		ASSERT(page); /* Pages should be in the extent_io_tree */
 		set_page_writeback(page);
--
2.14.2
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
