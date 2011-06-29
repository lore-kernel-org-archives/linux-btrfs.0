From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v4 1/7] btrfs: add an extra wait mode to read_extent_buffer_pages
Date: Wed, 29 Jun 2011 22:10:04 +0200
Message-ID: <85d9e7d63ee2492ae15c2693654d3837e6037ad2.1309375866.git.sensille@gmx.net>
References: <cover.1309375866.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1309375866.git.sensille@gmx.net>
In-Reply-To: <cover.1309375866.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

read_extent_buffer_pages currently has two modes, either trigger a read
without waiting for anything, or wait for the I/O to finish. The former
also bails when it's unable to lock the page. This patch now adds an
additional parameter to allow it to block on page lock, but don't wait
for completion.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c   |    4 ++--
 fs/btrfs/extent_io.c |    6 +++---
 fs/btrfs/extent_io.h |    3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ac8db5d..cff882c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -325,7 +325,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 	while (1) {
-		ret = read_extent_buffer_pages(io_tree, eb, start, 1,
+		ret = read_extent_buffer_pages(io_tree, eb, start, 1, 1,
 					       btree_get_extent, mirror_num);
 		if (!ret &&
 		    !verify_parent_transid(io_tree, eb, parent_transid))
@@ -940,7 +940,7 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	if (!buf)
 		return 0;
 	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
-				 buf, 0, 0, btree_get_extent, 0);
+				 buf, 0, 0, 0, btree_get_extent, 0);
 	free_extent_buffer(buf);
 	return ret;
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b181a94..b7f0b9b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3358,7 +3358,7 @@ int extent_buffer_uptodate(struct extent_io_tree *tree,
 
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb,
-			     u64 start, int wait,
+			     u64 start, int wait_lock, int wait_complete,
 			     get_extent_t *get_extent, int mirror_num)
 {
 	unsigned long i;
@@ -3392,7 +3392,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
-		if (!wait) {
+		if (!wait_lock) {
 			if (!trylock_page(page))
 				goto unlock_exit;
 		} else {
@@ -3436,7 +3436,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	if (bio)
 		submit_one_bio(READ, bio, mirror_num, bio_flags);
 
-	if (ret || !wait)
+	if (ret || !wait_complete)
 		return ret;
 
 	for (i = start_i; i < num_pages; i++) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a11a92e..5ef3735 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -241,7 +241,8 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 					 u64 start, unsigned long len);
 void free_extent_buffer(struct extent_buffer *eb);
 int read_extent_buffer_pages(struct extent_io_tree *tree,
-			     struct extent_buffer *eb, u64 start, int wait,
+			     struct extent_buffer *eb, u64 start,
+			     int wait_lock, int wait_complete,
 			     get_extent_t *get_extent, int mirror_num);
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
-- 
1.7.3.4

