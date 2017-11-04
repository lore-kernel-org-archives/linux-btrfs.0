Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932671AbdKGONG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 09:13:06 -0500
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BA29218B4
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Nov 2017 14:13:05 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] Btrfs: move definition of the function btrfs_find_new_delalloc_bytes
Date: Sat,  4 Nov 2017 04:19:56 +0000
Message-Id: <20171104041956.9674-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Move the definition of the function btrfs_find_new_delalloc_bytes() closer
to the function btrfs_dirty_pages(), because in a future commit it will be
used exclusively by btrfs_dirty_pages(). This just moves the function's
definition, with no functional changes at all.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: It's actually the first version of the patch, since the patch
    following this one is a v2 (its v1 splitted into two patches).

 fs/btrfs/file.c | 83 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 74127d6167d2..14b7056dd241 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -477,6 +477,48 @@ static void btrfs_drop_pages(struct page **pages, size_t num_pages)
 	}
 }
 
+
+static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
+					 const u64 start,
+					 const u64 len,
+					 struct extent_state **cached_state)
+{
+	u64 search_start = start;
+	const u64 end = start + len - 1;
+
+	while (search_start < end) {
+		const u64 search_len = end - search_start + 1;
+		struct extent_map *em;
+		u64 em_len;
+		int ret = 0;
+
+		em = btrfs_get_extent(inode, NULL, 0, search_start,
+				      search_len, 0);
+		if (IS_ERR(em))
+			return PTR_ERR(em);
+
+		if (em->block_start != EXTENT_MAP_HOLE)
+			goto next;
+
+		em_len = em->len;
+		if (em->start < search_start)
+			em_len -= search_start - em->start;
+		if (em_len > search_len)
+			em_len = search_len;
+
+		ret = set_extent_bit(&inode->io_tree, search_start,
+				     search_start + em_len - 1,
+				     EXTENT_DELALLOC_NEW,
+				     NULL, cached_state, GFP_NOFS);
+next:
+		search_start = extent_map_end(em);
+		free_extent_map(em);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 /*
  * after copy_from_user, pages need to be dirtied and we need to make
  * sure holes are created between the current EOF and the start of
@@ -1404,47 +1446,6 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 
 }
 
-static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
-					 const u64 start,
-					 const u64 len,
-					 struct extent_state **cached_state)
-{
-	u64 search_start = start;
-	const u64 end = start + len - 1;
-
-	while (search_start < end) {
-		const u64 search_len = end - search_start + 1;
-		struct extent_map *em;
-		u64 em_len;
-		int ret = 0;
-
-		em = btrfs_get_extent(inode, NULL, 0, search_start,
-				      search_len, 0);
-		if (IS_ERR(em))
-			return PTR_ERR(em);
-
-		if (em->block_start != EXTENT_MAP_HOLE)
-			goto next;
-
-		em_len = em->len;
-		if (em->start < search_start)
-			em_len -= search_start - em->start;
-		if (em_len > search_len)
-			em_len = search_len;
-
-		ret = set_extent_bit(&inode->io_tree, search_start,
-				     search_start + em_len - 1,
-				     EXTENT_DELALLOC_NEW,
-				     NULL, cached_state, GFP_NOFS);
-next:
-		search_start = extent_map_end(em);
-		free_extent_map(em);
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
 /*
  * This function locks the extent and properly waits for data=ordered extents
  * to finish before allowing the pages to be modified if need.
-- 
2.11.0

