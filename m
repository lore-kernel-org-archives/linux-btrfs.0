Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60594 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730848AbeGMTCj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 15:02:39 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8DD3AD32
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 18:46:47 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: refactor block group replication factor calculation to a helper
Date: Fri, 13 Jul 2018 20:46:30 +0200
Message-Id: <a3f7c772bfbc3e1dee3a58b61fb220b8c7eab01f.1531503452.git.dsterba@suse.com>
In-Reply-To: <cover.1531503452.git.dsterba@suse.com>
References: <cover.1531503452.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are many places that open code the duplicity factor of the block
group profiles, create a common helper. This can be easily extended for
more copies.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 36 ++++++++----------------------------
 fs/btrfs/super.c       | 11 +++--------
 fs/btrfs/volumes.c     | 11 +++++++++++
 fs/btrfs/volumes.h     |  2 ++
 4 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d9fe58c0080..4ffa64e288da 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4060,11 +4060,7 @@ static void update_space_info(struct btrfs_fs_info *info, u64 flags,
 	struct btrfs_space_info *found;
 	int factor;
 
-	if (flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
-		     BTRFS_BLOCK_GROUP_RAID10))
-		factor = 2;
-	else
-		factor = 1;
+	factor = btrfs_bg_type_to_factor(flags);
 
 	found = __find_space_info(info, flags);
 	ASSERT(found);
@@ -4703,6 +4699,7 @@ static int can_overcommit(struct btrfs_fs_info *fs_info,
 	u64 space_size;
 	u64 avail;
 	u64 used;
+	int factor;
 
 	/* Don't overcommit when in mixed mode. */
 	if (space_info->flags & BTRFS_BLOCK_GROUP_DATA)
@@ -4737,10 +4734,8 @@ static int can_overcommit(struct btrfs_fs_info *fs_info,
 	 * doesn't include the parity drive, so we don't have to
 	 * change the math
 	 */
-	if (profile & (BTRFS_BLOCK_GROUP_DUP |
-		       BTRFS_BLOCK_GROUP_RAID1 |
-		       BTRFS_BLOCK_GROUP_RAID10))
-		avail >>= 1;
+	factor = btrfs_bg_type_to_factor(profile);
+	avail /= factor;
 
 	/*
 	 * If we aren't flushing all things, let us overcommit up to
@@ -6219,12 +6214,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache)
 			return -ENOENT;
-		if (cache->flags & (BTRFS_BLOCK_GROUP_DUP |
-				    BTRFS_BLOCK_GROUP_RAID1 |
-				    BTRFS_BLOCK_GROUP_RAID10))
-			factor = 2;
-		else
-			factor = 1;
+		factor = btrfs_bg_type_to_factor(cache->flags);
+
 		/*
 		 * If this block group has free space cache written out, we
 		 * need to make sure to load it if we are removing space.  This
@@ -9520,13 +9511,7 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
 			continue;
 		}
 
-		if (block_group->flags & (BTRFS_BLOCK_GROUP_RAID1 |
-					  BTRFS_BLOCK_GROUP_RAID10 |
-					  BTRFS_BLOCK_GROUP_DUP))
-			factor = 2;
-		else
-			factor = 1;
-
+		factor = btrfs_bg_type_to_factor(block_group->flags);
 		free_bytes += (block_group->key.offset -
 			       btrfs_block_group_used(&block_group->item)) *
 			       factor;
@@ -10343,12 +10328,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	memcpy(&key, &block_group->key, sizeof(key));
 	index = btrfs_bg_flags_to_raid_index(block_group->flags);
-	if (block_group->flags & (BTRFS_BLOCK_GROUP_DUP |
-				  BTRFS_BLOCK_GROUP_RAID1 |
-				  BTRFS_BLOCK_GROUP_RAID10))
-		factor = 2;
-	else
-		factor = 1;
+	factor = btrfs_bg_type_to_factor(block_group->flags);
 
 	/* make sure this block group isn't part of an allocation cluster */
 	cluster = &fs_info->data_alloc_cluster;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 81107ad49f3a..4f646b66cc06 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2098,14 +2098,9 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 				btrfs_account_ro_block_groups_free_space(found);
 
 			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
-				if (!list_empty(&found->block_groups[i])) {
-					switch (i) {
-					case BTRFS_RAID_DUP:
-					case BTRFS_RAID_RAID1:
-					case BTRFS_RAID_RAID10:
-						factor = 2;
-					}
-				}
+				if (!list_empty(&found->block_groups[i]))
+					factor = btrfs_bg_type_to_factor(
+						btrfs_raid_array[i].bg_flag);
 			}
 		}
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e034ad9e23b4..45635f4d78c8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7380,3 +7380,14 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info)
 		fs_devices = fs_devices->seed;
 	}
 }
+
+/*
+ * Multiplicity factor for simple profiles: DUP, RAID1-like and RAID10.
+ */
+int btrfs_bg_type_to_factor(u64 flags)
+{
+	if (flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
+		     BTRFS_BLOCK_GROUP_RAID10))
+		return 2;
+	return 1;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5139ec8daf4c..c7b9ad9733ea 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -560,4 +560,6 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 					struct btrfs_device *failing_dev);
 
+int btrfs_bg_type_to_factor(u64 flags);
+
 #endif
-- 
2.18.0

