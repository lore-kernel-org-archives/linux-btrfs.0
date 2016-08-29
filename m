Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16776 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932862AbcH2IJP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 04:09:15 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 06CCD4334C72
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 16:09:09 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] btrfs-progs: Do extra chunk check before processing chunk item
Date: Mon, 29 Aug 2016 16:09:02 +0800
Message-ID: <20160829080902.2952-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
References: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current we only do chunk validation check at mount time.

It's good for most case, but for fuzzed or manually crafted images, we
can insert a CHUNK_ITEM key into root tree.

Since mount time check will only check chunk tree, it will not check
CHUNK_ITEM in root tree.

Even with previous key type check against leaf owner, it is still
possible to modify the leaf owner to by-pass it.

So we still need to check chunk validation before processing it.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 16 ++++++++++++++++
 volumes.c    |  8 ++++----
 volumes.h    |  4 ++++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 617b867..1e1f7c9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5220,8 +5220,24 @@ static int process_chunk_item(struct cache_tree *chunk_cache,
 			      int slot)
 {
 	struct chunk_record *rec;
+	struct btrfs_chunk *chunk;
 	int ret = 0;
 
+	chunk = btrfs_item_ptr(eb, slot, struct btrfs_chunk);
+	/*
+	 * Do extra check for this chunk item,
+	 *
+	 * It's still possible one can craft a leaf with CHUNK_ITEM, with
+	 * wrong onwer(3) out of chunk tree, to pass both chunk tree check
+	 * and owner<->key_type check.
+	 */
+	ret = btrfs_check_chunk_valid(global_info->tree_root, eb, chunk, slot,
+				      key->offset);
+	if (ret < 0) {
+		error("chunk(%llu, %llu) is not valid, ignore it",
+		      key->offset, btrfs_chunk_length(eb, chunk));
+		return 0;
+	}
 	rec = btrfs_new_chunk_record(eb, key, slot);
 	ret = insert_cache_extent(chunk_cache, &rec->cache);
 	if (ret) {
diff --git a/volumes.c b/volumes.c
index 9a5580a..2d07e66 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1614,10 +1614,10 @@ static struct btrfs_device *fill_missing_device(u64 devid)
  * slot == -1: SYSTEM chunk
  * return -EIO on error, otherwise return 0
  */
-static int btrfs_check_chunk_valid(struct btrfs_root *root,
-				   struct extent_buffer *leaf,
-				   struct btrfs_chunk *chunk,
-				   int slot, u64 logical)
+int btrfs_check_chunk_valid(struct btrfs_root *root,
+			    struct extent_buffer *leaf,
+			    struct btrfs_chunk *chunk,
+			    int slot, u64 logical)
 {
 	u64 length;
 	u64 stripe_len;
diff --git a/volumes.h b/volumes.h
index af7182b..d7b7d3c 100644
--- a/volumes.h
+++ b/volumes.h
@@ -226,4 +226,8 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			     struct extent_buffer *eb,
 			     struct btrfs_multi_bio *multi,
 			     u64 stripe_len, u64 *raid_map);
+int btrfs_check_chunk_valid(struct btrfs_root *root,
+			    struct extent_buffer *leaf,
+			    struct btrfs_chunk *chunk,
+			    int slot, u64 logical);
 #endif
-- 
2.9.3



