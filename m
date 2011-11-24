From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 81/99] btrfs: clean_tree_block should return void
Date: Wed, 23 Nov 2011 19:36:54 -0500
Message-ID: <20111124004229.194401490@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 clean_tree_block has no error conditions and should return void. Its
 callers already ignore the error codes.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    5 ++---
 fs/btrfs/disk-io.h |    4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fcb0f7f..e16a3e9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1033,8 +1033,8 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 
 }
 
-int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		     struct extent_buffer *buf)
+void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      struct extent_buffer *buf)
 {
 	struct inode *btree_inode = root->fs_info->btree_inode;
 	if (btrfs_header_generation(buf) ==
@@ -1055,7 +1055,6 @@ int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		clear_extent_buffer_dirty(&BTRFS_I(btree_inode)->io_tree,
 					  buf);
 	}
-	return 0;
 }
 
 static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index bec3ea4..5a2604a 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -42,8 +42,8 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
			 int mirror_num, struct extent_buffer **eb);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						   u64 bytenr, u32 blocksize);
-int clean_tree_block(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root, struct extent_buffer *buf);
+void clean_tree_block(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root, struct extent_buffer *buf);
 struct btrfs_root *open_ctree(struct super_block *sb,
 			      struct btrfs_fs_devices *fs_devices,
 			      char *options);



