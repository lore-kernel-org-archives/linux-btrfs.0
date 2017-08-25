Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33720 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754851AbdHYIsA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 04:48:00 -0400
Received: by mail-lf0-f65.google.com with SMTP id y15so1068154lfd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 01:47:59 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2] Btrfs: handle unaligned tail of data ranges more efficient
Date: Fri, 25 Aug 2017 11:47:44 +0300
Message-Id: <20170825084744.8075-1-nefelim4ag@gmail.com>
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
index 0aff9b278c19..bf6195fa9425 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1361,7 +1361,11 @@ void extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end)
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
@@ -1376,7 +1380,11 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
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
index c73f919491a0..444971d8ef2d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10710,7 +10710,11 @@ void btrfs_set_range_writeback(void *private_data, u64 start, u64 end)
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
2.14.1
