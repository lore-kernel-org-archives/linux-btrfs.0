From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [12/23] BTRFS: Clean up unused variables -- bugs
Date: Thu, 10 Jun 2010 13:10:48 +0200 (CEST)
Message-ID: <20100610111048.24CCFB1A2B@basil.firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>


These are all the cases where a variable is set, but not
read which are really bugs.

- Couple of incorrect error handling fixed.
- One incorrect use of a allocation policy
- Some other things

Still needs more review.

Found by gcc 4.6's new warnings

Cc: chris.mason@oracle.com
cc: linux-btrfs@vger.kernel.org


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/btrfs/dir-item.c    |    2 +-
 fs/btrfs/extent-tree.c |    3 +--
 fs/btrfs/extent_io.c   |    2 ++
 fs/btrfs/inode.c       |    6 +++---
 fs/btrfs/relocation.c  |    4 +++-
 fs/btrfs/tree-log.c    |    2 +-
 6 files changed, 11 insertions(+), 8 deletions(-)

Index: linux-2.6.35-rc2-gcc/fs/btrfs/extent-tree.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/btrfs/extent-tree.c
+++ linux-2.6.35-rc2-gcc/fs/btrfs/extent-tree.c
@@ -3337,8 +3337,7 @@ struct btrfs_block_rsv *btrfs_alloc_bloc
 	btrfs_init_block_rsv(block_rsv);
 
 	alloc_target = btrfs_get_alloc_profile(root, 0);
-	block_rsv->space_info = __find_space_info(fs_info,
-						  BTRFS_BLOCK_GROUP_METADATA);
+	block_rsv->space_info = __find_space_info(fs_info, alloc_target);
 
 	return block_rsv;
 }
Index: linux-2.6.35-rc2-gcc/fs/btrfs/dir-item.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/btrfs/dir-item.c
+++ linux-2.6.35-rc2-gcc/fs/btrfs/dir-item.c
@@ -427,5 +427,5 @@ int btrfs_delete_one_dir_name(struct btr
 		ret = btrfs_truncate_item(trans, root, path,
 					  item_len - sub_item_len, 1);
 	}
-	return 0;
+	return ret;
 }
Index: linux-2.6.35-rc2-gcc/fs/btrfs/extent_io.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/btrfs/extent_io.c
+++ linux-2.6.35-rc2-gcc/fs/btrfs/extent_io.c
@@ -2825,6 +2825,8 @@ int extent_prepare_write(struct extent_i
 					 NULL, 1,
 					 end_bio_extent_preparewrite, 0,
 					 0, 0);
+			if (ret && !err)
+				err = ret;
 			iocount++;
 			block_start = block_start + iosize;
 		} else {
Index: linux-2.6.35-rc2-gcc/fs/btrfs/inode.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/btrfs/inode.c
+++ linux-2.6.35-rc2-gcc/fs/btrfs/inode.c
@@ -1372,7 +1372,7 @@ int btrfs_merge_bio_hook(struct page *pa
 
 	if (map_length < length + size)
 		return 1;
-	return 0;
+	return ret;
 }
 
 /*
@@ -2672,7 +2672,7 @@ static int check_path_shared(struct btrf
 {
 	struct extent_buffer *eb;
 	int level;
-	int ret;
+	int ret = 0;
 	u64 refs;
 
 	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
@@ -2686,7 +2686,7 @@ static int check_path_shared(struct btrf
 		if (refs > 1)
 			return 1;
 	}
-	return 0;
+	return ret; /* XXX callers? */
 }
 
 /*
Index: linux-2.6.35-rc2-gcc/fs/btrfs/tree-log.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/btrfs/tree-log.c
+++ linux-2.6.35-rc2-gcc/fs/btrfs/tree-log.c
@@ -2273,7 +2273,7 @@ fail:
 	}
 	btrfs_end_log_trans(root);
 
-	return 0;
+	return err;
 }
 
 /* see comments for btrfs_del_dir_entries_in_log */
Index: linux-2.6.35-rc2-gcc/fs/btrfs/relocation.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/btrfs/relocation.c
+++ linux-2.6.35-rc2-gcc/fs/btrfs/relocation.c
@@ -3098,6 +3098,8 @@ static int add_tree_block(struct reloc_c
 		BUG_ON(item_size != sizeof(struct btrfs_extent_item_v0));
 		ret = get_ref_objectid_v0(rc, path, extent_key,
 					  &ref_owner, NULL);
+		if (ret < 0)
+			return ret;
 		BUG_ON(ref_owner >= BTRFS_MAX_LEVEL);
 		level = (int)ref_owner;
 		/* FIXME: get real generation */
@@ -4142,7 +4144,7 @@ int btrfs_reloc_clone_csums(struct inode
 		btrfs_add_ordered_sum(inode, ordered, sums);
 	}
 	btrfs_put_ordered_extent(ordered);
-	return 0;
+	return ret;
 }
 
 void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
