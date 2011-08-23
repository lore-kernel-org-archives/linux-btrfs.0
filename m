From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 03/21] Btrfs: add BTRFS_AVAIL_ALLOC_BIT_SINGLE bit
Date: Tue, 23 Aug 2011 23:01:44 +0300
Message-ID: <1314129722-31601-4-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Right now on-disk BTRFS_BLOCK_GROUP_* profile bits are used for
avail_{data,metadata,system}_alloc_bits fields, which are there to tell
us about available allocation profiles in the fs.  When chunk is
created, it's profile is OR'ed with respective avail_alloc_bits field.
Since SINGLE is denoted by 0 in the on-disk format, currently there is
no way to tell when such chunks become avaialble.  Restriper needs that
information, so add a separate bit for SINGLE profile.

This bit is going to be in-memory only, it should never be written out
to disk, so it's not a disk format change.  However to avoid remappings
in future, reserve corresponding on-disk bit.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h       |   12 ++++++++++++
 fs/btrfs/extent-tree.c |   22 ++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b882c95..5b00eb8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -725,6 +725,17 @@ struct btrfs_csum_item {
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
 					 BTRFS_BLOCK_GROUP_DUP |     \
 					 BTRFS_BLOCK_GROUP_RAID10)
+/*
+ * We need a bit for restriper to be able to tell when chunks of type
+ * SINGLE are available.  It is used in avail_*_alloc_bits.
+ */
+#define BTRFS_AVAIL_ALLOC_BIT_SINGLE (1 << 7)
+
+/*
+ * To avoid troubles or remappings, reserve on-disk bit.
+ */
+#define BTRFS_BLOCK_GROUP_RESERVED   (1 << 7)
+
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
@@ -1100,6 +1111,7 @@ struct btrfs_fs_info {
 	spinlock_t ref_cache_lock;
 	u64 total_ref_cache_size;
 
+	/* SINGLE has it's own bit for these three */
 	u64 avail_data_alloc_bits;
 	u64 avail_metadata_alloc_bits;
 	u64 avail_system_alloc_bits;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index de4c639..ed35eb5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2945,14 +2945,17 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
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
+	/* on-disk -> in-memory */
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
 
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
@@ -2986,6 +2989,9 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	     (flags & BTRFS_BLOCK_GROUP_RAID10) |
 	     (flags & BTRFS_BLOCK_GROUP_DUP)))
 		flags &= ~BTRFS_BLOCK_GROUP_RAID0;
+
+	/* in-memory -> on-disk */
+	flags &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 	return flags;
 }
 
-- 
1.7.5.4

