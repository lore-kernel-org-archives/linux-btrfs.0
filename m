From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 04/21] Btrfs: make avail_*_alloc_bits fields dynamic
Date: Tue, 23 Aug 2011 23:01:45 +0300
Message-ID: <1314129722-31601-5-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Currently when new chunks are created respective avail_alloc_bits field
is updated to reflect profiles of all chunks present in the system.
However when chunks are removed, corresponding profile bits are never
cleared.

This patch clears corresponding bit of avail_alloc_bits field when the
last chunk of that type goes away.  Restriper needs this to properly
operate when "downgrading".

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ed35eb5..a04f99b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7197,6 +7197,22 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void clear_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	u64 extra_flags = flags & BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	/* on-disk -> in-memory */
+	if (extra_flags == 0)
+		extra_flags = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+
+	if (flags & BTRFS_BLOCK_GROUP_DATA)
+		fs_info->avail_data_alloc_bits &= ~extra_flags;
+	if (flags & BTRFS_BLOCK_GROUP_METADATA)
+		fs_info->avail_metadata_alloc_bits &= ~extra_flags;
+	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
+		fs_info->avail_system_alloc_bits &= ~extra_flags;
+}
+
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start)
 {
@@ -7207,6 +7223,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct inode *inode;
 	int ret;
+	int index;
 	int factor;
 
 	root = root->fs_info->extent_root;
@@ -7222,6 +7239,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	free_excluded_extents(root, block_group);
 
 	memcpy(&key, &block_group->key, sizeof(key));
+	index = get_block_group_index(block_group);
 	if (block_group->flags & (BTRFS_BLOCK_GROUP_DUP |
 				  BTRFS_BLOCK_GROUP_RAID1 |
 				  BTRFS_BLOCK_GROUP_RAID10))
@@ -7296,6 +7314,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	 * are still on the list after taking the semaphore
 	 */
 	list_del_init(&block_group->list);
+	if (list_empty(&block_group->space_info->block_groups[index]))
+		clear_avail_alloc_bits(root->fs_info, block_group->flags);
 	up_write(&block_group->space_info->groups_sem);
 
 	if (block_group->cached == BTRFS_CACHE_STARTED)
-- 
1.7.5.4

