From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] disk-io.c (open_ctree): Don't dereference NULL upon failed kzalloc
Date: Tue, 09 Sep 2008 16:19:48 +0200
Message-ID: <874p4p2ygr.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was looking at how *alloc-returned values are dereferenced,
and spotted two potential NULL dereferences (then stopped looking, for now):

changeset:   708:eecfd989f8c6
tag:         tip
user:        Jim Meyering <meyering@redhat.com>
date:        Tue Sep 09 16:02:31 2008 +0200
files:       disk-io.c
description:
disk-io.c (open_ctree): don't dereference NULL upon failed kzalloc


diff --git a/disk-io.c b/disk-io.c
--- a/disk-io.c
+++ b/disk-io.c
@@ -1321,35 +1321,36 @@ struct btrfs_root *open_ctree(struct sup
 	struct btrfs_root *extent_root = kzalloc(sizeof(struct btrfs_root),
 						 GFP_NOFS);
 	struct btrfs_root *tree_root = kzalloc(sizeof(struct btrfs_root),
 					       GFP_NOFS);
 	struct btrfs_fs_info *fs_info = kzalloc(sizeof(*fs_info),
 						GFP_NOFS);
 	struct btrfs_root *chunk_root = kzalloc(sizeof(struct btrfs_root),
 						GFP_NOFS);
 	struct btrfs_root *dev_root = kzalloc(sizeof(struct btrfs_root),
 					      GFP_NOFS);
 	struct btrfs_root *log_tree_root;
 
 	int ret;
 	int err = -EINVAL;
 
 	struct btrfs_super_block *disk_super;
 
-	if (!extent_root || !tree_root || !fs_info) {
+	if (!extent_root || !tree_root || !fs_info
+	    || !chunk_root || !dev_root) {
 		err = -ENOMEM;
 		goto fail;
 	}
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_NOFS);
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
 	INIT_LIST_HEAD(&fs_info->hashers);
 	INIT_LIST_HEAD(&fs_info->delalloc_inodes);
 	spin_lock_init(&fs_info->hash_lock);
 	spin_lock_init(&fs_info->delalloc_lock);
 	spin_lock_init(&fs_info->new_trans_lock);
 	spin_lock_init(&fs_info->ref_cache_lock);
 
 	init_completion(&fs_info->kobj_unregister);
 	fs_info->tree_root = tree_root;
 	fs_info->extent_root = extent_root;
 	fs_info->chunk_root = chunk_root;


Here are some offending dereferences:

	chunk_root->node = read_tree_block(chunk_root,
...
	dev_root->track_dirty = 1;
