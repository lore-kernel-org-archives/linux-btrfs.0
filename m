From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 6/9] mkfs.btrfs: write zeroes instead on uninitialized data.
Date: Sat,  4 Jun 2011 11:19:21 +0300
Message-ID: <1307175564-25355-7-git-send-email-slyfox@gentoo.org>
References: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Found by valgrind:
==8968== Use of uninitialised value of size 8
==8968==    at 0x41CE7D: crc32c_le (crc32c.c:98)
==8968==    by 0x40A1D0: csum_tree_block_size (disk-io.c:82)
==8968==    by 0x40A2D4: csum_tree_block (disk-io.c:105)
==8968==    by 0x40A7D6: write_tree_block (disk-io.c:241)
==8968==    by 0x40ACEE: __commit_transaction (disk-io.c:354)
==8968==    by 0x40AE9E: btrfs_commit_transaction (disk-io.c:385)
==8968==    by 0x42CF66: make_image (mkfs.c:1061)
==8968==    by 0x42DE63: main (mkfs.c:1410)
==8968==  Uninitialised value was created by a stack allocation
==8968==    at 0x42B5FB: add_inode_items (mkfs.c:493)

1. On-disk inode format has reserved (and thus, random at alloc time) fields:
   btrfs_inode_item: __le64 reserved[4]
2. Sometimes extents are created on disk without writing data there.
   (Or at least not all data is written there). Kernel code always had
   it kzalloc'ed.
Zero them all.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 extent_io.c |    1 +
 mkfs.c      |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index 069c199..a93d4d6 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -555,40 +555,41 @@ static int free_some_buffers(struct extent_io_tree *tree)
 		} else {
 			list_move_tail(&eb->lru, &tree->lru);
 		}
 		if (nrscan++ > 64)
 			break;
 	}
 	return 0;
 }
 
 static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 						   u64 bytenr, u32 blocksize)
 {
 	struct extent_buffer *eb;
 	int ret;
 
 	eb = malloc(sizeof(struct extent_buffer) + blocksize);
 	if (!eb) {
 		BUG();
 		return NULL;
 	}
+	memset (eb, 0, sizeof(struct extent_buffer) + blocksize);
 
 	eb->start = bytenr;
 	eb->len = blocksize;
 	eb->refs = 2;
 	eb->flags = 0;
 	eb->tree = tree;
 	eb->fd = -1;
 	eb->dev_bytenr = (u64)-1;
 	eb->cache_node.start = bytenr;
 	eb->cache_node.size = blocksize;
 
 	free_some_buffers(tree);
 	ret = insert_existing_cache_extent(&tree->cache, &eb->cache_node);
 	if (ret) {
 		free(eb);
 		return NULL;
 	}
 	list_add_tail(&eb->lru, &tree->lru);
 	tree->cache_size += blocksize;
 	return eb;
diff --git a/mkfs.c b/mkfs.c
index 8ff2b1e..32f25f5 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -394,40 +394,47 @@ static int add_directory_items(struct btrfs_trans_handle *trans,
 	if (S_ISLNK(st->st_mode))
 		filetype = BTRFS_FT_SYMLINK;
 
 	ret = btrfs_insert_dir_item(trans, root, name, name_len,
 				    parent_inum, &location,
 				    filetype, index_cnt);
 
 	*dir_index_cnt = index_cnt;
 	index_cnt++;
 
 	return ret;
 }
 
 static int fill_inode_item(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_inode_item *dst, struct stat *src)
 {
 	u64 blocks = 0;
 	u64 sectorsize = root->sectorsize;
 
+	/*
+	 * btrfs_inode_item has some reserved fields
+	 * and represents on-disk inode entry, so
+	 * zero everything to prevent information leak
+	 */
+	memset (dst, 0, sizeof (*dst));
+
 	btrfs_set_stack_inode_generation(dst, trans->transid);
 	btrfs_set_stack_inode_size(dst, src->st_size);
 	btrfs_set_stack_inode_nbytes(dst, 0);
 	btrfs_set_stack_inode_block_group(dst, 0);
 	btrfs_set_stack_inode_nlink(dst, src->st_nlink);
 	btrfs_set_stack_inode_uid(dst, src->st_uid);
 	btrfs_set_stack_inode_gid(dst, src->st_gid);
 	btrfs_set_stack_inode_mode(dst, src->st_mode);
 	btrfs_set_stack_inode_rdev(dst, 0);
 	btrfs_set_stack_inode_flags(dst, 0);
 	btrfs_set_stack_timespec_sec(&dst->atime, src->st_atime);
 	btrfs_set_stack_timespec_nsec(&dst->atime, 0);
 	btrfs_set_stack_timespec_sec(&dst->ctime, src->st_ctime);
 	btrfs_set_stack_timespec_nsec(&dst->ctime, 0);
 	btrfs_set_stack_timespec_sec(&dst->mtime, src->st_mtime);
 	btrfs_set_stack_timespec_nsec(&dst->mtime, 0);
 	btrfs_set_stack_timespec_sec(&dst->otime, 0);
 	btrfs_set_stack_timespec_nsec(&dst->otime, 0);
 
 	if (S_ISDIR(src->st_mode)) {
-- 
1.7.3.4

