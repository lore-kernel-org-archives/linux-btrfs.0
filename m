Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11385 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab2GLClL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jul 2012 22:41:11 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <jbacik@fusionio.com>
Subject: [PATCH v2] Btrfs: improve multi-thread buffer read
Date: Thu, 12 Jul 2012 10:13:51 +0800
Message-Id: <1342059231-20301-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While testing with my buffer read fio jobs[1], I find that btrfs does not
perform well enough.

Here is a scenario in fio jobs:

We have 4 threads, "t1 t2 t3 t4", starting to buffer read a same file,
and all of them will race on add_to_page_cache_lru(), and if one thread
successfully puts its page into the page cache, it takes the responsibility
to read the page's data.

And what's more, reading a page needs a period of time to finish, in which
other threads can slide in and process rest pages:

     t1          t2          t3          t4
   add Page1
   read Page1  add Page2
     |         read Page2  add Page3
     |            |        read Page3  add Page4
     |            |           |        read Page4
-----|------------|-----------|-----------|--------
     v            v           v           v
    bio          bio         bio         bio

Now we have four bios, each of which holds only one page since we need to
maintain consecutive pages in bio.  Thus, we can end up with far more bios
than we need.

Here we're going to
a) delay the real read-page section and
b) try to put more pages into page cache.

With that said, we can make each bio hold more pages and reduce the number
of bios we need.

Here is some numbers taken from fio results:
         w/o patch                 w patch
       -------------  --------  ---------------
READ:    745MB/s        +32%       987MB/s

[1]:
[global]
group_reporting
thread
numjobs=4
bs=32k
rw=read
ioengine=sync
directory=/mnt/btrfs/

[READ]
filename=foobar
size=2000M
invalidate=1

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
v1->v2: if we fail to make a allocation, just fall back to the old way to
        read page.
 fs/btrfs/extent_io.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 01c21b6..5c8ab6c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3549,6 +3549,11 @@ int extent_writepages(struct extent_io_tree *tree,
 	return ret;
 }
 
+struct pagelst {
+	struct page *page;
+	struct list_head lst;
+};
+
 int extent_readpages(struct extent_io_tree *tree,
 		     struct address_space *mapping,
 		     struct list_head *pages, unsigned nr_pages,
@@ -3557,19 +3562,51 @@ int extent_readpages(struct extent_io_tree *tree,
 	struct bio *bio = NULL;
 	unsigned page_idx;
 	unsigned long bio_flags = 0;
+	LIST_HEAD(page_pool);
+	struct pagelst *pagelst = NULL;
 
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
+		bool delay_read = true;
 
 		prefetchw(&page->flags);
 		list_del(&page->lru);
+
+		if (!pagelst)
+			pagelst = kmalloc(sizeof(*pagelst), GFP_NOFS);
+		if (!pagelst)
+			delay_read = false;
+
 		if (!add_to_page_cache_lru(page, mapping,
 					page->index, GFP_NOFS)) {
-			__extent_read_full_page(tree, page, get_extent,
-						&bio, 0, &bio_flags);
+			if (delay_read) {
+				pagelst->page = page;
+				list_add(&pagelst->lst, &page_pool);
+				page_cache_get(page);
+				pagelst = NULL;
+			} else {
+				__extent_read_full_page(tree, page, get_extent,
+							&bio, 0, &bio_flags);
+			}
 		}
 		page_cache_release(page);
 	}
+
+	while (!list_empty(&page_pool)) {
+		struct page *page;
+
+		pagelst = list_entry(page_pool.prev, struct pagelst, lst);
+		page = pagelst->page;
+
+		prefetchw(&page->flags);
+		__extent_read_full_page(tree, page, get_extent,
+					&bio, 0, &bio_flags);
+
+		page_cache_release(page);
+		list_del(&pagelst->lst);
+		kfree(pagelst);
+	}
+	BUG_ON(!list_empty(&page_pool));
 	BUG_ON(!list_empty(pages));
 	if (bio)
 		return submit_one_bio(READ, bio, 0, bio_flags);
-- 
1.6.5.2

