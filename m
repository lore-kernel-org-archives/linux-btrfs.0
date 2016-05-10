Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28337 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbcEJOB6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:01:58 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 01/13] btrfs: Introduce a new function to check if all chunks a OK for degraded mount
Date: Tue, 10 May 2016 22:01:38 +0800
Message-Id: <1462888911-5227-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
References: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce a new function, btrfs_check_degradable(), to judge if all chunks
in btrfs is OK for degraded mount.

It provides the new basis for accurate btrfs mount/remount and even
runtime degraded mount check other than old one-size-fit-all method.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 68 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4ff716d9b16c..f5fa5f88263c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7065,3 +7065,70 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 
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
+	read_unlock(&map_tree->map_tree.lock);
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
+				   "missing devices(%d) exceeds the limit(%d), writeable mount is not allowed",
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
+		free_extent_map(em);
+		read_lock(&map_tree->map_tree.lock);
+		em = lookup_extent_mapping(&map_tree->map_tree, next_start,
+					   (u64)(-1) - next_start);
+		read_unlock(&map_tree->map_tree.lock);
+	}
+out:
+	free_extent_map(em);
+	return ret;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 93e0a2560366..ae9d552c93bf 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -568,5 +568,6 @@ static inline void unlock_chunks(struct btrfs_root *root)
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
+int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags);
 
 #endif
-- 
2.7.0

