Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16546 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab2GPGFO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jul 2012 02:05:14 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <chris.mason@fusionio.com>, <JBacik@fusionio.com>
Subject: [PATCH v3] Btrfs: improve multi-thread buffer read
Date: Mon, 16 Jul 2012 14:05:25 -0400
Message-Id: <1342461925-22495-1-git-send-email-liubo2009@cn.fujitsu.com>
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
READ:    745MB/s        +19%       887MB/s

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
v2->v3: adopt kernel native pagevec instead of kmalloc.
v1->v2: if we fail to make a allocation, just fall back to the old way to
        read page.

 fs/btrfs/extent_io.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 01c21b6..2fcbcac 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3557,7 +3557,10 @@ int extent_readpages(struct extent_io_tree *tree,
 	struct bio *bio = NULL;
 	unsigned page_idx;
 	unsigned long bio_flags = 0;
+	struct pagevec pvec;
+	int i = 0;
 
+	pagevec_init(&pvec, 0);
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
 
@@ -3565,11 +3568,22 @@ int extent_readpages(struct extent_io_tree *tree,
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping,
 					page->index, GFP_NOFS)) {
-			__extent_read_full_page(tree, page, get_extent,
+			page_cache_get(page);
+			if (pagevec_add(&pvec, page) == 0) {
+				for (i = 0; i < pagevec_count(&pvec); i++)
+					__extent_read_full_page(tree,
+						pvec.pages[i], get_extent,
 						&bio, 0, &bio_flags);
+				pagevec_release(&pvec);
+			}
 		}
 		page_cache_release(page);
 	}
+	for (i = 0; i < pagevec_count(&pvec); i++)
+		__extent_read_full_page(tree, pvec.pages[i], get_extent,
+					&bio, 0, &bio_flags);
+	pagevec_release(&pvec);
+
 	BUG_ON(!list_empty(pages));
 	if (bio)
 		return submit_one_bio(READ, bio, 0, bio_flags);
-- 
1.6.5.2

