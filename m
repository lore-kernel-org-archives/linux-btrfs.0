Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29541 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755820AbbIUCMs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 22:12:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8L2CTvj003268
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 10:12:29 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs: Introduce a new function to check if all chunks a OK for degraded mount
Date: Mon, 21 Sep 2015 10:10:39 +0800
Message-ID: <1442801443-5132-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, btrfs_check_degradable(), to judge if all
chunks in btrfs is OK for degraded mount.

It provides the new basis for accurate btrfs mount/remount and even
runtime degraded mount check other than old one-size-fit-all method.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 64 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 644e070..f1ef215 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6906,3 +6906,66 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info)
 		fs_devices = fs_devices->seed;
 	}
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
index 2ca784a..fe758df 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -547,5 +547,6 @@ static inline void unlock_chunks(struct btrfs_root *root)
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
+int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags);
 
 #endif
-- 
2.5.2

