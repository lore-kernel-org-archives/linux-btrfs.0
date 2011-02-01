From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] btrfs: checking NULL or not in some functions
Date: Tue, 01 Feb 2011 18:17:35 +0900
Message-ID: <201102010917.AA00006@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because NULL is returned when the memory allocation fails,
it is checked whether it is NULL. 

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    2 ++
 fs/btrfs/extent_io.c   |    2 ++
 fs/btrfs/tree-log.c    |    6 ++++++
 3 files changed, 10 insertions(+)

diff -urNp linux-2.6.38-rc2/fs/btrfs/extent-tree.c linux-2.6.38-rc2.new/fs/btrfs/extent-tree.c
--- linux-2.6.38-rc2/fs/btrfs/extent-tree.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/extent-tree.c	2011-02-01 14:47:14.000000000 +0900
@@ -6446,6 +6446,8 @@ static noinline int relocate_inode_pages
 	int ret = 0;
 
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
+	if (!ra)
+		return -ENOMEM;
 
 	mutex_lock(&inode->i_mutex);
 	first_index = start >> PAGE_CACHE_SHIFT;
diff -urNp linux-2.6.38-rc2/fs/btrfs/extent_io.c linux-2.6.38-rc2.new/fs/btrfs/extent_io.c
--- linux-2.6.38-rc2/fs/btrfs/extent_io.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/extent_io.c	2011-02-01 14:23:41.000000000 +0900
@@ -1920,6 +1920,8 @@ static int submit_extent_page(int rw, st
 		nr = bio_get_nr_vecs(bdev);
 
 	bio = btrfs_bio_alloc(bdev, sector, nr, GFP_NOFS | __GFP_HIGH);
+	if (!bio)
+		return -ENOMEM;
 
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
diff -urNp linux-2.6.38-rc2/fs/btrfs/tree-log.c linux-2.6.38-rc2.new/fs/btrfs/tree-log.c
--- linux-2.6.38-rc2/fs/btrfs/tree-log.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/tree-log.c	2011-02-01 14:36:21.000000000 +0900
@@ -2725,7 +2725,13 @@ static int btrfs_log_inode(struct btrfs_
 	log = root->log_root;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	dst_path = btrfs_alloc_path();
+	if (!dst_path) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
 
 	min_key.objectid = inode->i_ino;
 	min_key.type = BTRFS_INODE_ITEM_KEY;


