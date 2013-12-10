Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3LJLYB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 06:24:01 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBABNw7u020270
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 19:23:58 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: cleanup unnecessary parameter and variant of prepare_pages()
Date: Tue, 10 Dec 2013 19:25:03 +0800
Message-Id: <1386674704-8501-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- the caller has gotten the inode object, needn't pass the file object.
  And if so, we needn't define a inode pointer variant.
- the position should be aligned by the page size not sector size, so
  we also needn't pass the root object into prepare_pages().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 82d0342..ecb4f1f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1239,22 +1239,20 @@ static int prepare_uptodate_page(struct page *page, u64 pos,
  * waits for data=ordered extents to finish before allowing the pages to be
  * modified.
  */
-static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
-			 struct page **pages, size_t num_pages,
-			 loff_t pos, unsigned long first_index,
-			 size_t write_bytes, bool force_uptodate)
+static noinline int prepare_pages(struct inode *inode, struct page **pages,
+				  size_t num_pages, loff_t pos,
+				  size_t write_bytes, bool force_uptodate)
 {
 	struct extent_state *cached_state = NULL;
 	int i;
 	unsigned long index = pos >> PAGE_CACHE_SHIFT;
-	struct inode *inode = file_inode(file);
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 	int err = 0;
 	int faili = 0;
 	u64 start_pos;
 	u64 last_pos;
 
-	start_pos = pos & ~((u64)root->sectorsize - 1);
+	start_pos = pos & ~((u64)PAGE_CACHE_SIZE - 1);
 	last_pos = ((u64)index + num_pages) << PAGE_CACHE_SHIFT;
 
 again:
@@ -1462,8 +1460,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		 * pages we want, so we don't really need to worry about the
 		 * contents of pages from loop to loop
 		 */
-		ret = prepare_pages(root, file, pages, num_pages,
-				    pos, first_index, write_bytes,
+		ret = prepare_pages(inode, pages, num_pages,
+				    pos, write_bytes,
 				    force_page_uptodate);
 		if (ret)
 			break;
-- 
1.8.3.1

