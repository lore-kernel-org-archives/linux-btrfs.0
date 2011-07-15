From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix BUG_ON() caused by ENOSPC when relocating space
Date: Fri, 15 Jul 2011 18:34:36 +0800
Message-ID: <4E2017BC.8060903@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Chris Mason <chris.mason@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we balanced the chunks across the devices, BUG_ON() in
__finish_chunk_alloc() was triggered.

------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:2568!
[SNIP]
Call Trace:
 [<ffffffffa049525e>] btrfs_alloc_chunk+0x8e/0xa0 [btrfs]
 [<ffffffffa04546b0>] do_chunk_alloc+0x330/0x3a0 [btrfs]
 [<ffffffffa045c654>] btrfs_reserve_extent+0xb4/0x1f0 [btrfs]
 [<ffffffffa045c86b>] btrfs_alloc_free_block+0xdb/0x350 [btrfs]
 [<ffffffffa048a8d8>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
 [<ffffffffa04476fd>] __btrfs_cow_block+0x14d/0x5e0 [btrfs]
 [<ffffffffa044660d>] ? read_block_for_search+0x14d/0x4d0 [btrfs]
 [<ffffffffa0447c9b>] btrfs_cow_block+0x10b/0x240 [btrfs]
 [<ffffffffa044dd5e>] btrfs_search_slot+0x49e/0x7a0 [btrfs]
 [<ffffffffa044f07d>] btrfs_insert_empty_items+0x8d/0xf0 [btrfs]
 [<ffffffffa045e973>] insert_with_overflow+0x43/0x110 [btrfs]
 [<ffffffffa045eb0d>] btrfs_insert_dir_item+0xcd/0x1f0 [btrfs]
 [<ffffffffa0489bd0>] ? map_extent_buffer+0xb0/0xc0 [btrfs]
 [<ffffffff812276ad>] ? rb_insert_color+0x9d/0x160
 [<ffffffffa046cc40>] ? inode_tree_add+0xf0/0x150 [btrfs]
 [<ffffffffa0474801>] btrfs_add_link+0xc1/0x1c0 [btrfs]
 [<ffffffff811dacac>] ? security_inode_init_security+0x1c/0x30
 [<ffffffffa04a28aa>] ? btrfs_init_acl+0x4a/0x180 [btrfs]
 [<ffffffffa047492f>] btrfs_add_nondir+0x2f/0x70 [btrfs]
 [<ffffffffa046af16>] ? btrfs_init_inode_security+0x46/0x60 [btrfs]
 [<ffffffffa0474ac0>] btrfs_create+0x150/0x1d0 [btrfs]
 [<ffffffff81159c63>] ? generic_permission+0x23/0xb0
 [<ffffffff8115b415>] vfs_create+0xa5/0xc0
 [<ffffffff8115ce6e>] do_last+0x5fe/0x880
 [<ffffffff8115dc0d>] path_openat+0xcd/0x3d0
 [<ffffffff8115e029>] do_filp_open+0x49/0xa0
 [<ffffffff8116a965>] ? alloc_fd+0x95/0x160
 [<ffffffff8114f0c7>] do_sys_open+0x107/0x1e0
 [<ffffffff810bcc3f>] ? audit_syscall_entry+0x1bf/0x1f0
 [<ffffffff8114f1e0>] sys_open+0x20/0x30
 [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
[SNIP]
RIP  [<ffffffffa049444a>] __finish_chunk_alloc+0x20a/0x220 [btrfs]

The reason is:
Task1					Space balance task
do_chunk_alloc()
  __finish_chunk_alloc()
    update device info
    in the chunk tree
      alloc system metadata block
					relocate system metadata block group
					  set system metadata block group
					  readonly, This block group is the
					  only one that can allocate space. So
					  there is no free space that can be
					  allocated now.
        find no space and don't try
        to alloc new chunk, and then
        return ENOSPC
  BUG_ON() in __finish_chunk_alloc()
  was triggered.

Fix this bug by allocating a new system metadata chunk before relocating the
old one if we find there is no free space which can be allocated after setting
the old block group to be read-only.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71cd456..00c8a1a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6524,15 +6524,28 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 	return flags;
 }
 
-static int set_block_group_ro(struct btrfs_block_group_cache *cache)
+static int set_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
 	u64 num_bytes;
+	u64 min_allocable_bytes;
 	int ret = -ENOSPC;
 
 	if (cache->ro)
 		return 0;
 
+	/*
+	 * We need some metadata space and system metadata space for
+	 * allocating chunks in some corner cases until we force to set
+	 * it to be readonly.
+	 */
+	if ((sinfo->flags &
+	     (BTRFS_BLOCK_GROUP_SYSTEM | BTRFS_BLOCK_GROUP_METADATA)) &&
+	    !force)
+		min_allocable_bytes = 1 * 1024 * 1024;
+	else
+		min_allocable_bytes = 0;
+
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
@@ -6540,7 +6553,8 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache)
 
 	if (sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned +
 	    sinfo->bytes_may_use + sinfo->bytes_readonly +
-	    cache->reserved_pinned + num_bytes <= sinfo->total_bytes) {
+	    cache->reserved_pinned + num_bytes + min_allocable_bytes <=
+	    sinfo->total_bytes) {
 		sinfo->bytes_readonly += num_bytes;
 		sinfo->bytes_reserved += cache->reserved_pinned;
 		cache->reserved_pinned = 0;
@@ -6571,7 +6585,7 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 		do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags,
 			       CHUNK_ALLOC_FORCE);
 
-	ret = set_block_group_ro(cache);
+	ret = set_block_group_ro(cache, 0);
 	if (!ret)
 		goto out;
 	alloc_flags = get_alloc_profile(root, cache->space_info->flags);
@@ -6579,7 +6593,7 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 			     CHUNK_ALLOC_FORCE);
 	if (ret < 0)
 		goto out;
-	ret = set_block_group_ro(cache);
+	ret = set_block_group_ro(cache, 0);
 out:
 	btrfs_end_transaction(trans, root);
 	return ret;
@@ -7016,7 +7030,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		set_avail_alloc_bits(root->fs_info, cache->flags);
 		if (btrfs_chunk_readonly(root, cache->key.objectid))
-			set_block_group_ro(cache);
+			set_block_group_ro(cache, 1);
 	}
 
 	list_for_each_entry_rcu(space_info, &root->fs_info->space_info, list) {
@@ -7030,9 +7044,9 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		 * mirrored block groups.
 		 */
 		list_for_each_entry(cache, &space_info->block_groups[3], list)
-			set_block_group_ro(cache);
+			set_block_group_ro(cache, 1);
 		list_for_each_entry(cache, &space_info->block_groups[4], list)
-			set_block_group_ro(cache);
+			set_block_group_ro(cache, 1);
 	}
 
 	init_global_block_rsv(info);
-- 
1.7.4
