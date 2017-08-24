Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33312 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753411AbdHXVNF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 17:13:05 -0400
Received: by mail-wm0-f67.google.com with SMTP id e67so685503wmd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 14:13:05 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [RFC PATCH] Btrfs: handle unaligned tail of data ranges more efficient
Date: Fri, 25 Aug 2017 00:12:35 +0300
Message-Id: <20170824211235.23152-1-nefelim4ag@gmail.com>
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
index 98d85d2009f8..ccb66c1485e2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1360,7 +1360,11 @@ void extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end)
 	unsigned long end_index = end >> PAGE_SHIFT;
 	struct page *page;

-	while (index <= end_index) {
+	/* Don't miss unaligned end */
+	if (end%PAGE_SIZE > 0)
+		end_index++;
+
+	while (index < end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		BUG_ON(!page); /* Pages should be in the extent_io_tree */
 		clear_page_dirty_for_io(page);
@@ -1375,7 +1379,11 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
 	unsigned long end_index = end >> PAGE_SHIFT;
 	struct page *page;

-	while (index <= end_index) {
+	/* Don't miss unaligned end */
+	if (end%PAGE_SIZE > 0)
+		end_index++;
+
+	while (index < end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		BUG_ON(!page); /* Pages should be in the extent_io_tree */
 		__set_page_dirty_nobuffers(page);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cb7779b08aaf..79feaea0fede 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10745,7 +10745,11 @@ void btrfs_set_range_writeback(void *private_data, u64 start, u64 end)
 	unsigned long end_index = end >> PAGE_SHIFT;
 	struct page *page;

-	while (index <= end_index) {
+	/* Don't miss unaligned end */
+	if (end%PAGE_SIZE > 0)
+		end_index++;
+
+	while (index < end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		ASSERT(page); /* Pages should be in the extent_io_tree */
 		set_page_writeback(page);
--
2.14.1
