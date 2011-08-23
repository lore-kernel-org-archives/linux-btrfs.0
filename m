From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 02/21] Btrfs: introduce masks for chunk type and profile
Date: Tue, 23 Aug 2011 23:01:43 +0300
Message-ID: <1314129722-31601-3-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chunk's type and profile are encoded in u64 flags field.  Introduce
masks to easily access them.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h       |    8 ++++++++
 fs/btrfs/extent-tree.c |   12 +++---------
 fs/btrfs/volumes.c     |   11 ++---------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dcf2fd7..b882c95 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -717,6 +717,14 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
 #define BTRFS_NR_RAID_TYPES	   5
 
+#define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
+					 BTRFS_BLOCK_GROUP_SYSTEM |  \
+					 BTRFS_BLOCK_GROUP_METADATA)
+
+#define BTRFS_BLOCK_GROUP_PROFILE_MASK	(BTRFS_BLOCK_GROUP_RAID0 |   \
+					 BTRFS_BLOCK_GROUP_RAID1 |   \
+					 BTRFS_BLOCK_GROUP_DUP |     \
+					 BTRFS_BLOCK_GROUP_RAID10)
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4e1b763..de4c639 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -559,8 +559,7 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 	struct list_head *head = &info->space_info;
 	struct btrfs_space_info *found;
 
-	flags &= BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_SYSTEM |
-		 BTRFS_BLOCK_GROUP_METADATA;
+	flags &= BTRFS_BLOCK_GROUP_TYPE_MASK;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
@@ -2924,9 +2923,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		INIT_LIST_HEAD(&found->block_groups[i]);
 	init_rwsem(&found->groups_sem);
 	spin_lock_init(&found->lock);
-	found->flags = flags & (BTRFS_BLOCK_GROUP_DATA |
-				BTRFS_BLOCK_GROUP_SYSTEM |
-				BTRFS_BLOCK_GROUP_METADATA);
+	found->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
 	found->total_bytes = total_bytes;
 	found->disk_total = total_bytes * factor;
 	found->bytes_used = bytes_used;
@@ -2947,10 +2944,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 
 static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
-	u64 extra_flags = flags & (BTRFS_BLOCK_GROUP_RAID0 |
-				   BTRFS_BLOCK_GROUP_RAID1 |
-				   BTRFS_BLOCK_GROUP_RAID10 |
-				   BTRFS_BLOCK_GROUP_DUP);
+	u64 extra_flags = flags & BTRFS_BLOCK_GROUP_PROFILE_MASK;
 	if (extra_flags) {
 		if (flags & BTRFS_BLOCK_GROUP_DATA)
 			fs_info->avail_data_alloc_bits |= extra_flags;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ed96275..af4bf56 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2908,12 +2908,8 @@ again:
 		}
 	}
 	if (rw & REQ_DISCARD) {
-		if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
-				 BTRFS_BLOCK_GROUP_RAID1 |
-				 BTRFS_BLOCK_GROUP_DUP |
-				 BTRFS_BLOCK_GROUP_RAID10)) {
+		if (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK)
 			stripes_required = map->num_stripes;
-		}
 	}
 	if (multi_ret && (rw & (REQ_WRITE | REQ_DISCARD)) &&
 	    stripes_allocated < stripes_required) {
@@ -2937,10 +2933,7 @@ again:
 
 	if (rw & REQ_DISCARD)
 		*length = min_t(u64, em->len - offset, *length);
-	else if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
-			      BTRFS_BLOCK_GROUP_RAID1 |
-			      BTRFS_BLOCK_GROUP_RAID10 |
-			      BTRFS_BLOCK_GROUP_DUP)) {
+	else if (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 		/* we limit the length of each bio to what fits in a stripe */
 		*length = min_t(u64, em->len - offset,
 				map->stripe_len - stripe_offset);
-- 
1.7.5.4

