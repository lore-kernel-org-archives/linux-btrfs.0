From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix fiemap
Date: Tue, 23 Nov 2010 14:36:57 -0500
Message-ID: <1290541017-32638-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are two big problems currently with FIEMAP

1) We return extents for holes.  This isn't supposed to happen, we just don't
return extents for holes and then userspace interprets the lack of an extent as
a hole.

2) We sometimes don't set FIEMAP_EXTENT_LAST properly.  This is because we wait
to see a EXTENT_FLAG_VACANCY flag on the em, but this won't happen if say we ask
fiemap to map up to the last extent in a file, and there is nothing but holes up
to the i_size.  To fix this we need to lookup the last extent in this file and
save the logical offset, so if we happen to try and map that extent we can be
sure to set FIEMAP_EXTENT_LAST.

With this patch we now pass xfstest 225, which we never have before.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |   63 ++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index eac10e3..10e579d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2901,21 +2901,53 @@ out:
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent)
 {
-	int ret;
+	int ret = 0;
 	u64 off = start;
 	u64 max = start + len;
 	u32 flags = 0;
+	u32 found_type;
+	u64 last;
 	u64 disko = 0;
+	struct btrfs_key found_key;
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
+	struct btrfs_path *path;
+	struct btrfs_file_extent_item *item;
 	int end = 0;
 	u64 em_start = 0, em_len = 0;
 	unsigned long emflags;
-	ret = 0;
+	int hole = 0;
 
 	if (len == 0)
 		return -EINVAL;
 
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->leave_spinning = 1;
+
+	ret = btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root,
+				       path, inode->i_ino, -1, 0);
+	if (ret < 0) {
+		btrfs_free_path(path);
+		return ret;
+	}
+	WARN_ON(!ret);
+	path->slots[0]--;
+	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			      struct btrfs_file_extent_item);
+	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
+	found_type = btrfs_key_type(&found_key);
+
+	/* No extents, just return */
+	if (found_key.objectid != inode->i_ino ||
+	    found_type != BTRFS_EXTENT_DATA_KEY) {
+		btrfs_free_path(path);
+		return 0;
+	}
+	last = found_key.offset;
+	btrfs_free_path(path);
+
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
 			 &cached_state, GFP_NOFS);
 	em = get_extent(inode, NULL, 0, off, max - off, 0);
@@ -2925,11 +2957,18 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		ret = PTR_ERR(em);
 		goto out;
 	}
+
 	while (!end) {
+		hole = 0;
 		off = em->start + em->len;
 		if (off >= max)
 			end = 1;
 
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			hole = 1;
+			goto next;
+		}
+
 		em_start = em->start;
 		em_len = em->len;
 
@@ -2939,8 +2978,6 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		if (em->block_start == EXTENT_MAP_LAST_BYTE) {
 			end = 1;
 			flags |= FIEMAP_EXTENT_LAST;
-		} else if (em->block_start == EXTENT_MAP_HOLE) {
-			flags |= FIEMAP_EXTENT_UNWRITTEN;
 		} else if (em->block_start == EXTENT_MAP_INLINE) {
 			flags |= (FIEMAP_EXTENT_DATA_INLINE |
 				  FIEMAP_EXTENT_NOT_ALIGNED);
@@ -2953,10 +2990,10 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 			flags |= FIEMAP_EXTENT_ENCODED;
 
+next:
 		emflags = em->flags;
 		free_extent_map(em);
 		em = NULL;
-
 		if (!end) {
 			em = get_extent(inode, NULL, 0, off, max - off, 0);
 			if (!em)
@@ -2967,15 +3004,23 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			}
 			emflags = em->flags;
 		}
+
 		if (test_bit(EXTENT_FLAG_VACANCY, &emflags)) {
 			flags |= FIEMAP_EXTENT_LAST;
 			end = 1;
 		}
 
-		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
-					em_len, flags);
-		if (ret)
-			goto out_free;
+		if (em_start == last) {
+			flags |= FIEMAP_EXTENT_LAST;
+			end = 1;
+		}
+
+		if (!hole) {
+			ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
+						em_len, flags);
+			if (ret)
+				goto out_free;
+		}
 	}
 out_free:
 	free_extent_map(em);
-- 
1.6.6.1

