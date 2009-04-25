From: Andi Kleen <andi@firstfloor.org>
Subject: btrfs progs 0.18 compilation fixes for gcc 4.0.2
Date: Sat, 25 Apr 2009 21:03:37 +0200
Message-ID: <20090425190337.GA6510@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


gcc 4.0.2 complained about various uninitialized variables 
in btrfs progs 0.18, which bombed out with -Werror.
I think the file-item.c was actually valid and could indeed
return an uninitialized return value from very brief code reading
(could be wrong on that)
Here's the patch I used to make it compile.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff -u btrfs-progs-0.18/extent-tree.c-o btrfs-progs-0.18/extent-tree.c
--- btrfs-progs-0.18/extent-tree.c-o	2009-04-25 20:57:26.000000000 +0200
+++ btrfs-progs-0.18/extent-tree.c	2009-04-25 20:58:12.000000000 +0200
@@ -2564,7 +2564,7 @@
 	u64 total_metadata = 0;
 	u64 chunk_objectid;
 	int ret;
-	int bit;
+	int bit = 0;
 	struct btrfs_root *extent_root;
 	struct btrfs_block_group_cache *cache;
 	struct extent_io_tree *block_group_cache;
diff -u btrfs-progs-0.18/file-item.c-o btrfs-progs-0.18/file-item.c
--- btrfs-progs-0.18/file-item.c-o	2009-04-25 20:58:19.000000000 +0200
+++ btrfs-progs-0.18/file-item.c	2009-04-25 20:58:58.000000000 +0200
@@ -193,7 +193,7 @@
 			  struct btrfs_root *root, u64 alloc_end,
 			  u64 bytenr, char *data, size_t len)
 {
-	int ret;
+	int ret = 0;
 	struct btrfs_key file_key;
 	struct btrfs_key found_key;
 	u64 next_offset = (u64)-1;
diff -u btrfs-progs-0.18/btrfs-image.c-o btrfs-progs-0.18/btrfs-image.c
--- btrfs-progs-0.18/btrfs-image.c-o	2009-04-25 20:59:13.000000000 +0200
+++ btrfs-progs-0.18/btrfs-image.c	2009-04-25 20:59:45.000000000 +0200
@@ -249,7 +249,7 @@
 static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 			 FILE *out, int num_threads, int compress_level)
 {
-	int i, ret;
+	int i, ret = 0;
 
 	memset(md, 0, sizeof(*md));
 	pthread_cond_init(&md->cond, NULL);



-- 
ak@linux.intel.com -- Speaking for myself only.
