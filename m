Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3961 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751587AbdF1Fns (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 01:43:48 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: <ahferroin7@gmail.com>, <kilobyte@angband.pl>, <demfloro@demfloro.ru>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v4 1/6] btrfs: Introduce a function to check if all chunks a OK for degraded rw mount
Date: Wed, 28 Jun 2017 13:43:30 +0800
Message-ID: <20170628054335.18806-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, btrfs_check_rw_degradable(), to check if all
chunks in btrfs is OK for degraded rw mount.

It provides the new basis for accurate btrfs mount/remount and even
runtime degraded mount check other than old one-size-fit-all method.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 59 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c95f018d4a1e..7a72fbdb8262 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6817,6 +6817,64 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 	return -EIO;
 }
 
+/*
+ * Check if all chunks in the fs is OK for read-write degraded mount
+ *
+ * Return true if all chunks meet the minimal RW mount requirement.
+ * Return false if any chunk doesn't meet the minimal RW mount requirement.
+ */
+bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct extent_map *em;
+	u64 next_start = 0;
+	bool ret = true;
+
+	read_lock(&map_tree->map_tree.lock);
+	em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)-1);
+	read_unlock(&map_tree->map_tree.lock);
+	/* No chunk at all? Return false anyway */
+	if (!em) {
+		ret = false;
+		goto out;
+	}
+	while (em) {
+		struct map_lookup *map;
+		int missing = 0;
+		int max_tolerated;
+		int i;
+
+		map = em->map_lookup;
+		max_tolerated =
+			btrfs_get_num_tolerated_disk_barrier_failures(
+					map->type);
+		for (i = 0; i < map->num_stripes; i++) {
+			struct btrfs_device *dev = map->stripes[i].dev;
+
+			if (!dev || !dev->bdev || dev->missing ||
+			    dev->last_flush_error)
+				missing++;
+		}
+		if (missing > max_tolerated) {
+			ret = false;
+			btrfs_warn(fs_info,
+	"chunk %llu missing %d devices, max tolerance is %d for writeble mount",
+				   em->start, missing, max_tolerated);
+			free_extent_map(em);
+			goto out;
+		}
+		next_start = extent_map_end(em);
+		free_extent_map(em);
+
+		read_lock(&map_tree->map_tree.lock);
+		em = lookup_extent_mapping(&map_tree->map_tree, next_start,
+					   (u64)(-1) - next_start);
+		read_unlock(&map_tree->map_tree.lock);
+	}
+out:
+	return ret;
+}
+
 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *root = fs_info->chunk_root;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6f45fd60d15a..a5897c7a7e86 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -543,4 +543,5 @@ struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 
+bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
 #endif
-- 
2.13.1



