Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39979 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2GTFrG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 01:47:06 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <chris.mason@fusionio.com>, <jbacik@fusionio.com>, <dave@jikos.cz>
Subject: [PATCH v4] Btrfs: improve multi-thread buffer read
Date: Fri, 20 Jul 2012 13:46:33 +0800
Message-Id: <1342763193-8733-1-git-send-email-liubo2009@cn.fujitsu.com>
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
READ:    745MB/s        +25%       934MB/s

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
v3->v4: adopt a simple page array instead of pagevec to avoid side effect
        that may be brought by pagevec_release().
v2->v3: adopt kernel native pagevec instead of kmalloc.
v1->v2: if we fail to make a allocation, just fall back to the old way to
        read page.

 fs/btrfs/extent_io.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 01c21b6..12001cb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3557,19 +3557,38 @@ int extent_readpages(struct extent_io_tree *tree,
 	struct bio *bio = NULL;
 	unsigned page_idx;
 	unsigned long bio_flags = 0;
+	struct page *pagepool[16];
+	struct page *page;
+	int i = 0;
+	int nr = 0;
 
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
-		struct page *page = list_entry(pages->prev, struct page, lru);
+		page = list_entry(pages->prev, struct page, lru);
 
 		prefetchw(&page->flags);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping,
 					page->index, GFP_NOFS)) {
-			__extent_read_full_page(tree, page, get_extent,
+			page_cache_get(page);
+			pagepool[nr++] = page;
+			if (nr == 16) {
+				for (i = 0; i < nr; i++) {
+					__extent_read_full_page(tree,
+						pagepool[i], get_extent,
 						&bio, 0, &bio_flags);
+					page_cache_release(pagepool[i]);
+				}
+				nr = 0;
+			}
 		}
 		page_cache_release(page);
 	}
+	for (i = 0; i < nr; i++) {
+		__extent_read_full_page(tree, pagepool[i], get_extent,
+					&bio, 0, &bio_flags);
+		page_cache_release(pagepool[i]);
+	}
+
 	BUG_ON(!list_empty(pages));
 	if (bio)
 		return submit_one_bio(READ, bio, 0, bio_flags);
-- 
1.6.5.2

