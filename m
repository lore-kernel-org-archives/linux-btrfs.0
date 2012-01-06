From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 03/21] Btrfs: add BTRFS_AVAIL_ALLOC_BIT_SINGLE bit
Date: Fri,  6 Jan 2012 16:30:51 +0200
Message-ID: <1325860269-15013-4-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Right now on-disk BTRFS_BLOCK_GROUP_* profile bits are used for
avail_{data,metadata,system}_alloc_bits fields, which gather info about
available allocation profiles in the FS.  When chunk is created or read
from disk, its profile is OR'ed with the corresponding avail_alloc_bits
field.  Since SINGLE is denoted by 0 in the on-disk format, currently
there is no way to tell when such chunks become avaialble.  Restriper
needs that information, so add a separate bit for SINGLE profile.

This bit is going to be in-memory only, it should never be written out
to disk, so it's not a disk format change.  However to avoid remappings
in future, reserve corresponding on-disk bit.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h       |   15 +++++++++++++++
 fs/btrfs/extent-tree.c |   30 +++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4370a56..3f8f11e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -758,6 +758,7 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
+#define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 #define BTRFS_NR_RAID_TYPES		5
 
 #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
@@ -768,6 +769,15 @@ struct btrfs_csum_item {
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
 					 BTRFS_BLOCK_GROUP_DUP |     \
 					 BTRFS_BLOCK_GROUP_RAID10)
+/*
+ * We need a bit for restriper to be able to tell when chunks of type
+ * SINGLE are available.  This "extended" profile format is used in
+ * fs_info->avail_*_alloc_bits (in-memory) and balance item fields
+ * (on-disk).  The corresponding on-disk bit in chunk.type is reserved
+ * to avoid remappings between two formats in future.
+ */
+#define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
+
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
@@ -1140,6 +1150,11 @@ struct btrfs_fs_info {
 	spinlock_t ref_cache_lock;
 	u64 total_ref_cache_size;
 
+	/*
+	 * these three are in extended format (availability of single
+	 * chunks is denoted by BTRFS_AVAIL_ALLOC_BIT_SINGLE bit, other
+	 * types are denoted by corresponding BTRFS_BLOCK_GROUP_* bits)
+	 */
 	u64 avail_data_alloc_bits;
 	u64 avail_metadata_alloc_bits;
 	u64 avail_system_alloc_bits;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a8d8204..15a2294 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3014,16 +3014,24 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
 	u64 extra_flags = flags & BTRFS_BLOCK_GROUP_PROFILE_MASK;
-	if (extra_flags) {
-		if (flags & BTRFS_BLOCK_GROUP_DATA)
-			fs_info->avail_data_alloc_bits |= extra_flags;
-		if (flags & BTRFS_BLOCK_GROUP_METADATA)
-			fs_info->avail_metadata_alloc_bits |= extra_flags;
-		if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
-			fs_info->avail_system_alloc_bits |= extra_flags;
-	}
+
+	/* chunk -> extended profile */
+	if (extra_flags == 0)
+		extra_flags = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+
+	if (flags & BTRFS_BLOCK_GROUP_DATA)
+		fs_info->avail_data_alloc_bits |= extra_flags;
+	if (flags & BTRFS_BLOCK_GROUP_METADATA)
+		fs_info->avail_metadata_alloc_bits |= extra_flags;
+	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
+		fs_info->avail_system_alloc_bits |= extra_flags;
 }
 
+/*
+ * @flags: available profiles in extended format (see ctree.h)
+ *
+ * Returns reduced profile in chunk format.
+ */
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	/*
@@ -3053,8 +3061,12 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	if ((flags & BTRFS_BLOCK_GROUP_RAID0) &&
 	    ((flags & BTRFS_BLOCK_GROUP_RAID1) |
 	     (flags & BTRFS_BLOCK_GROUP_RAID10) |
-	     (flags & BTRFS_BLOCK_GROUP_DUP)))
+	     (flags & BTRFS_BLOCK_GROUP_DUP))) {
 		flags &= ~BTRFS_BLOCK_GROUP_RAID0;
+	}
+
+	/* extended -> chunk profile */
+	flags &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 	return flags;
 }
 
-- 
1.7.6.3

