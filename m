Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51426 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919AbaEOBTl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 21:19:41 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4F1JFxP006734
	for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 09:19:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs: Skip scrubbing removed chunks to avoid -ENOENT.
Date: Thu, 15 May 2014 09:20:17 +0800
Message-ID: <1400116818-14811-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When run scrub with balance, sometimes -ENOENT will be returned, since
in scrub_enumerate_chunks() will search dev_extent in *COMMIT_ROOT*, but
btrfs_lookup_block_group() will search block group in *MEMORY*, so if a
chunk is removed but not committed, -ENOENT will be returned.

However, there is no need to stop scrubbing since other chunks may be
scrubbed without problem.

So this patch changes the behavior to skip removed chunks and continue
to scrub the rest.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0be7799..adac948 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2724,11 +2724,8 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
 		length = btrfs_dev_extent_length(l, dev_extent);
 
-		if (found_key.offset + length <= start) {
-			key.offset = found_key.offset + length;
-			btrfs_release_path(path);
-			continue;
-		}
+		if (found_key.offset + length <= start)
+			goto skip;
 
 		chunk_tree = btrfs_dev_extent_chunk_tree(l, dev_extent);
 		chunk_objectid = btrfs_dev_extent_chunk_objectid(l, dev_extent);
@@ -2739,10 +2736,12 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 * the chunk from going away while we scrub it
 		 */
 		cache = btrfs_lookup_block_group(fs_info, chunk_offset);
-		if (!cache) {
-			ret = -ENOENT;
-			break;
-		}
+
+		/* some chunks are removed but not committed to disk yet,
+		 * continue scrubbing */
+		if (!cache)
+			goto skip;
+
 		dev_replace->cursor_right = found_key.offset + length;
 		dev_replace->cursor_left = found_key.offset;
 		dev_replace->item_needs_writeback = 1;
@@ -2801,7 +2800,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		dev_replace->cursor_left = dev_replace->cursor_right;
 		dev_replace->item_needs_writeback = 1;
-
+skip:
 		key.offset = found_key.offset + length;
 		btrfs_release_path(path);
 	}
-- 
1.9.2

