Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2777 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751960AbbIPDnz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 23:43:55 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8G3hbR6012777
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 11:43:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs: Do per-chunk degrade mode check at mount time
Date: Wed, 16 Sep 2015 11:43:50 +0800
Message-ID: <1442375031-18212-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs supports different raid profile for meta/data/sys, and as
different profile support different tolerated missing device, it's
better to check if it can be mounted degraded at a per-chunk base.

So this patch will add check for read_one_chunk() against its profile,
other than checking it against with the lowest duplication profile.

Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reported-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 644e070..3272187 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6164,12 +6164,15 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			  struct btrfs_chunk *chunk)
 {
 	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	struct super_block *sb = root->fs_info->sb;
 	struct map_lookup *map;
 	struct extent_map *em;
 	u64 logical;
 	u64 length;
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
+	int missing = 0;
+	int max_tolerated;
 	int num_stripes;
 	int ret;
 	int i;
@@ -6238,7 +6241,21 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			btrfs_warn(root->fs_info, "devid %llu uuid %pU is missing",
 						devid, uuid);
 		}
+		if (map->stripes[i].dev->missing)
+			missing++;
 		map->stripes[i].dev->in_fs_metadata = 1;
+
+	}
+
+	/* XXX: Why the function name is SO LOOOOOOOOOOOOOOOOONG?! */
+	max_tolerated =
+		btrfs_get_num_tolerated_disk_barrier_failures(map->type);
+	if (missing > max_tolerated && !(sb->s_flags & MS_RDONLY)) {
+		free_extent_map(em);
+		btrfs_error(root->fs_info, -EIO,
+			"missing device(%d) exceeds the limit(%d), writeable mount is not allowed\n",
+			missing, max_tolerated);
+		return -EIO;
 	}
 
 	write_lock(&map_tree->map_tree.lock);
-- 
2.5.2

