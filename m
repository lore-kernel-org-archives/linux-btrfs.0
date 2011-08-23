From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 01/21] Btrfs: get rid of *_alloc_profile fields
Date: Tue, 23 Aug 2011 23:01:42 +0300
Message-ID: <1314129722-31601-2-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

{data,metadata,system}_alloc_profile fields have been unused for a long
time now.  Get rid of them.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h       |    3 ---
 fs/btrfs/disk-io.c     |    3 ---
 fs/btrfs/extent-tree.c |   10 ++++------
 fs/btrfs/volumes.c     |    6 ++----
 4 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03912c5..dcf2fd7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1095,9 +1095,6 @@ struct btrfs_fs_info {
 	u64 avail_data_alloc_bits;
 	u64 avail_metadata_alloc_bits;
 	u64 avail_system_alloc_bits;
-	u64 data_alloc_profile;
-	u64 metadata_alloc_profile;
-	u64 system_alloc_profile;
 
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac6..46d0412 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1997,9 +1997,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
-	fs_info->data_alloc_profile = (u64)-1;
-	fs_info->metadata_alloc_profile = (u64)-1;
-	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
 
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f5be06a..4e1b763 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2998,14 +2998,12 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
-		flags |= root->fs_info->avail_data_alloc_bits &
-			 root->fs_info->data_alloc_profile;
+		flags |= root->fs_info->avail_data_alloc_bits;
 	else if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
-		flags |= root->fs_info->avail_system_alloc_bits &
-			 root->fs_info->system_alloc_profile;
+		flags |= root->fs_info->avail_system_alloc_bits;
 	else if (flags & BTRFS_BLOCK_GROUP_METADATA)
-		flags |= root->fs_info->avail_metadata_alloc_bits &
-			 root->fs_info->metadata_alloc_profile;
+		flags |= root->fs_info->avail_metadata_alloc_bits;
+
 	return btrfs_reduce_alloc_profile(root, flags);
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2a4cc7..ed96275 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2711,8 +2711,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 		return ret;
 
 	alloc_profile = BTRFS_BLOCK_GROUP_METADATA |
-			(fs_info->metadata_alloc_profile &
-			 fs_info->avail_metadata_alloc_bits);
+				fs_info->avail_metadata_alloc_bits;
 	alloc_profile = btrfs_reduce_alloc_profile(root, alloc_profile);
 
 	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
@@ -2722,8 +2721,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	sys_chunk_offset = chunk_offset + chunk_size;
 
 	alloc_profile = BTRFS_BLOCK_GROUP_SYSTEM |
-			(fs_info->system_alloc_profile &
-			 fs_info->avail_system_alloc_bits);
+				fs_info->avail_system_alloc_bits;
 	alloc_profile = btrfs_reduce_alloc_profile(root, alloc_profile);
 
 	ret = __btrfs_alloc_chunk(trans, extent_root, &sys_map,
-- 
1.7.5.4

