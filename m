From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 1/8] Btrfs: add wrappers for working with alloc profiles
Date: Tue, 27 Mar 2012 18:04:21 +0300
Message-ID: <1332860668-27298-2-git-send-email-idryomov@gmail.com>
References: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add functions to abstract the conversion between chunk and extended
allocation profile formats and switch everybody to use them.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h       |   15 +++++++++++++++
 fs/btrfs/extent-tree.c |   25 +++++++------------------
 fs/btrfs/volumes.c     |   20 ++++++++------------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c2e17cd..aba7832 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -849,6 +849,21 @@ struct btrfs_csum_item {
  */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
+#define BTRFS_EXTENDED_PROFILE_MASK	(BTRFS_BLOCK_GROUP_PROFILE_MASK | \
+					 BTRFS_AVAIL_ALLOC_BIT_SINGLE)
+
+static inline u64 chunk_to_extended(u64 flags)
+{
+	if ((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0)
+		flags |= BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+
+	return flags;
+}
+static inline u64 extended_to_chunk(u64 flags)
+{
+	return flags & ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+}
+
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4269777..9f16fdb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3098,11 +3098,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 
 static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
-	u64 extra_flags = flags & BTRFS_BLOCK_GROUP_PROFILE_MASK;
-
-	/* chunk -> extended profile */
-	if (extra_flags == 0)
-		extra_flags = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+	u64 extra_flags = chunk_to_extended(flags) &
+				BTRFS_EXTENDED_PROFILE_MASK;
 
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		fs_info->avail_data_alloc_bits |= extra_flags;
@@ -3181,9 +3178,7 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	}
 
 out:
-	/* extended -> chunk profile */
-	flags &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
-	return flags;
+	return extended_to_chunk(flags);
 }
 
 static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
@@ -6914,11 +6909,8 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 			tgt = BTRFS_BLOCK_GROUP_METADATA | bctl->meta.target;
 		}
 
-		if (tgt) {
-			/* extended -> chunk profile */
-			tgt &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
-			return tgt;
-		}
+		if (tgt)
+			return extended_to_chunk(tgt);
 	}
 
 	/*
@@ -7597,11 +7589,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 static void clear_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
-	u64 extra_flags = flags & BTRFS_BLOCK_GROUP_PROFILE_MASK;
-
-	/* chunk -> extended profile */
-	if (extra_flags == 0)
-		extra_flags = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+	u64 extra_flags = chunk_to_extended(flags) &
+				BTRFS_EXTENDED_PROFILE_MASK;
 
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		fs_info->avail_data_alloc_bits &= ~extra_flags;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 58aad63e..4b263a2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2250,15 +2250,13 @@ static void unset_balance_control(struct btrfs_fs_info *fs_info)
  * Balance filters.  Return 1 if chunk should be filtered out
  * (should not be balanced).
  */
-static int chunk_profiles_filter(u64 chunk_profile,
+static int chunk_profiles_filter(u64 chunk_type,
 				 struct btrfs_balance_args *bargs)
 {
-	chunk_profile &= BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	chunk_type = chunk_to_extended(chunk_type) &
+				BTRFS_EXTENDED_PROFILE_MASK;
 
-	if (chunk_profile == 0)
-		chunk_profile = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
-
-	if (bargs->profiles & chunk_profile)
+	if (bargs->profiles & chunk_type)
 		return 0;
 
 	return 1;
@@ -2365,18 +2363,16 @@ static int chunk_vrange_filter(struct extent_buffer *leaf,
 	return 1;
 }
 
-static int chunk_soft_convert_filter(u64 chunk_profile,
+static int chunk_soft_convert_filter(u64 chunk_type,
 				     struct btrfs_balance_args *bargs)
 {
 	if (!(bargs->flags & BTRFS_BALANCE_ARGS_CONVERT))
 		return 0;
 
-	chunk_profile &= BTRFS_BLOCK_GROUP_PROFILE_MASK;
-
-	if (chunk_profile == 0)
-		chunk_profile = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+	chunk_type = chunk_to_extended(chunk_type) &
+				BTRFS_EXTENDED_PROFILE_MASK;
 
-	if (bargs->target & chunk_profile)
+	if (bargs->target == chunk_type)
 		return 1;
 
 	return 0;
-- 
1.7.9.1

