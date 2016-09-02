Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57940 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932424AbcIBTlm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 15:41:42 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82JXD4a015990
        for <linux-btrfs@vger.kernel.org>; Fri, 2 Sep 2016 12:41:41 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 256qdu94fx-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:41:41 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 4/7] Btrfs: kill the start argument to read_extent_buffer_pages
Date: Fri, 2 Sep 2016 15:40:03 -0400
Message-ID: <1472845206-22870-5-git-send-email-jbacik@fb.com>
In-Reply-To: <1472845206-22870-1-git-send-email-jbacik@fb.com>
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nobody uses this, it makes no sense to do partial reads of extent buffers.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/disk-io.c   | 13 ++++++-------
 fs/btrfs/extent_io.c | 26 +++++++-------------------
 fs/btrfs/extent_io.h |  2 +-
 3 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ebd33ef..9c42e53 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -443,7 +443,7 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
  */
 static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 					  struct extent_buffer *eb,
-					  u64 start, u64 parent_transid)
+					  u64 parent_transid)
 {
 	struct extent_io_tree *io_tree;
 	int failed = 0;
@@ -455,8 +455,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 	while (1) {
-		ret = read_extent_buffer_pages(io_tree, eb, start,
-					       WAIT_COMPLETE,
+		ret = read_extent_buffer_pages(io_tree, eb, WAIT_COMPLETE,
 					       btree_get_extent, mirror_num);
 		if (!ret) {
 			if (!verify_parent_transid(io_tree, eb,
@@ -1098,7 +1097,7 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr)
 	if (IS_ERR(buf))
 		return;
 	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
-				 buf, 0, WAIT_NONE, btree_get_extent, 0);
+				 buf, WAIT_NONE, btree_get_extent, 0);
 	free_extent_buffer(buf);
 }
 
@@ -1116,7 +1115,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
 
 	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
 
-	ret = read_extent_buffer_pages(io_tree, buf, 0, WAIT_PAGE_LOCK,
+	ret = read_extent_buffer_pages(io_tree, buf, WAIT_PAGE_LOCK,
 				       btree_get_extent, mirror_num);
 	if (ret) {
 		free_extent_buffer(buf);
@@ -1172,7 +1171,7 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	if (IS_ERR(buf))
 		return buf;
 
-	ret = btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
+	ret = btree_read_extent_buffer_pages(root, buf, parent_transid);
 	if (ret) {
 		free_extent_buffer(buf);
 		return ERR_PTR(ret);
@@ -4035,7 +4034,7 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root)
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 {
 	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
-	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
+	return btree_read_extent_buffer_pages(root, buf, parent_transid);
 }
 
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6036431..045e525 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5157,11 +5157,10 @@ int extent_buffer_uptodate(struct extent_buffer *eb)
 }
 
 int read_extent_buffer_pages(struct extent_io_tree *tree,
-			     struct extent_buffer *eb, u64 start, int wait,
+			     struct extent_buffer *eb, int wait,
 			     get_extent_t *get_extent, int mirror_num)
 {
 	unsigned long i;
-	unsigned long start_i;
 	struct page *page;
 	int err;
 	int ret = 0;
@@ -5175,16 +5174,8 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
 		return 0;
 
-	if (start) {
-		WARN_ON(start < eb->start);
-		start_i = (start >> PAGE_SHIFT) -
-			(eb->start >> PAGE_SHIFT);
-	} else {
-		start_i = 0;
-	}
-
 	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = start_i; i < num_pages; i++) {
+	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
 		if (wait == WAIT_NONE) {
 			if (!trylock_page(page))
@@ -5199,15 +5190,14 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 		}
 	}
 	if (all_uptodate) {
-		if (start_i == 0)
-			set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 		goto unlock_exit;
 	}
 
 	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
 	eb->read_mirror = 0;
 	atomic_set(&eb->io_pages, num_reads);
-	for (i = start_i; i < num_pages; i++) {
+	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
 
 		if (!PageUptodate(page)) {
@@ -5248,7 +5238,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	if (ret || wait != WAIT_COMPLETE)
 		return ret;
 
-	for (i = start_i; i < num_pages; i++) {
+	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
 		wait_on_page_locked(page);
 		if (!PageUptodate(page))
@@ -5258,12 +5248,10 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	return ret;
 
 unlock_exit:
-	i = start_i;
 	while (locked_pages > 0) {
-		page = eb->pages[i];
-		i++;
-		unlock_page(page);
 		locked_pages--;
+		page = eb->pages[locked_pages];
+		unlock_page(page);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 61adf16..0518e3e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -361,7 +361,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb);
 #define WAIT_COMPLETE	1
 #define WAIT_PAGE_LOCK	2
 int read_extent_buffer_pages(struct extent_io_tree *tree,
-			     struct extent_buffer *eb, u64 start, int wait,
+			     struct extent_buffer *eb, int wait,
 			     get_extent_t *get_extent, int mirror_num);
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
-- 
2.7.4

