Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aristotle.killerwolves.net ([182.160.128.151]:39363 "EHLO
	aristotle.killerwolves.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab2HLKxH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Aug 2012 06:53:07 -0400
Message-ID: <50278B56.9040903@killerwolves.net>
Date: Sun, 12 Aug 2012 20:54:14 +1000
From: Ben Peddell <klightspeed@killerwolves.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Fix unaligned pointer accesses of btrfs_key->offset (try
 2)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The offset field in the btrfs_key structure is unaligned.

Unlike x86, unaligned accesses on ARM will result in Unaligned Access
traps, which are usually ignored, and the lower bits of the pointer
address being accessed are zeroed.

This means that in this case the lower 8 bits of the value that should
go into key->offset actually goes into key->type, the value that is put
into key->offset is shifted right 8 bits, and the top 8 bits remain from
the previous value in key->offset.

This currently occurs in mkfs.btrfs, causing it to abort, and could
potentially occur in the filesystem driver, causing internal corruption.

This patch works around the two unaligned accesses of key->offset through
a pointer by giving find_next_chunk an aligned pointer.

Signed-off-by: Ben Peddell <bpeddell@killerwolves.net>

---
 volumes.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index 8dca5e1..47a6d5f 100644
--- a/volumes.c
+++ b/volumes.c
@@ -644,6 +644,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	u64 avail;
 	u64 max_avail = 0;
 	u64 percent_max;
+	u64 offset;
 	int num_stripes = 1;
 	int min_stripes = 1;
 	int sub_stripes = 0;
@@ -760,7 +761,8 @@ again:
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-			      &key.offset);
+			      &offset);
+	key.offset = offset;
 	if (ret)
 		return ret;
 
@@ -864,6 +866,7 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	struct list_head *cur;
 	struct map_lookup *map;
 	u64 calc_size = 8 * 1024 * 1024;
+	u64 offset;
 	int num_stripes = 1;
 	int sub_stripes = 0;
 	int ret;
@@ -874,7 +877,8 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-			      &key.offset);
+			      &offset);
+	key.offset = offset;
 	if (ret)
 		return ret;
 
-- 
1.7.3.4

