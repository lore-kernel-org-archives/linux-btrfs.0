Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25038 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbcC2OWo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:22:44 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 01/12] btrfs: Introduce a new function to check if all chunks a OK for degraded mount
Date: Tue, 29 Mar 2016 22:22:18 +0800
Message-Id: <1459261349-32206-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce a new function, btrfs_check_degradable(), to judge if all chunks
in btrfs is OK for degraded mount.

It provides the new basis for accurate btrfs mount/remount and even
runtime degraded mount check other than old one-size-fit-all method.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 64 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e2b54d546b7c..dd3dc53a302a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7042,3 +7042,66 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 
 	call_rcu(&device->rcu, free_device);
 }
+
+/*
+ * Check if all chunks in the fs is OK for degraded mount
+ * Caller itself should do extra check if DEGRADED mount option is given
+ * for >0 return value.
+ *
+ * Return 0 if all chunks are OK.
+ * Return >0 if all chunks are degradable but not all OK.
+ * Return <0 if any chunk is not degradable or other bug.
+ */
+int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
+{
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct extent_map *em;
+	u64 next_start = 0;
+	int ret = 0;
+
+	if (flags & MS_RDONLY)
+		return 0;
+
+	read_lock(&map_tree->map_tree.lock);
+	em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)(-1));
+	/* No any chunk? Should be a huge bug */
+	if (!em) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	while (em) {
+		struct map_lookup *map;
+		int missing = 0;
+		int max_tolerated;
+		int i;
+
+		map = (struct map_lookup *) em->bdev;
+		max_tolerated =
+			btrfs_get_num_tolerated_disk_barrier_failures(
+					map->type);
+		for (i = 0; i < map->num_stripes; i++) {
+			if (map->stripes[i].dev->missing)
+				missing++;
+		}
+		if (missing > max_tolerated) {
+			ret = -EIO;
+			btrfs_warn(fs_info,
+				   "missing devices(%d) exceeds the limit(%d), writebale mount is not allowed",
+				   missing, max_tolerated);
+			goto out;
+		} else if (missing)
+			ret = 1;
+		next_start = extent_map_end(em);
+
+		/*
+		 * Alwasy search range [next_start, (u64)-1) to find the next
+		 * chunk map
+		 */
+		em = lookup_extent_mapping(&map_tree->map_tree, next_start,
+					   (u64)(-1) - next_start);
+	}
+out:
+	read_unlock(&map_tree->map_tree.lock);
+	return ret;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1939ebde63df..351431a3f5aa 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -566,5 +566,6 @@ static inline void unlock_chunks(struct btrfs_root *root)
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
+int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags);
 
 #endif
-- 
2.7.0

