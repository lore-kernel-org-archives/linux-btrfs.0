Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43019 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756081AbaFSClV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 22:41:21 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J2fJWJ024064
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 10:41:19 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH RESEND 3/7] btrfs: Skip scrubbing removed chunks to avoid -ENOENT.
Date: Thu, 19 Jun 2014 10:42:51 +0800
Message-ID: <1403145775-22641-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

When run scrub with balance, sometimes -ENOENT will be returned, since
in scrub_enumerate_chunks() will search dev_extent in *COMMIT_ROOT*, but
btrfs_lookup_block_group() will search block group in *MEMORY*, so if a
chunk is removed but not committed, -ENOENT will be returned.

However, there is no need to stop scrubbing since other chunks may be
scrubbed without problem.

So this patch changes the behavior to skip removed chunks and continue
to scrub the rest.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ac80188..b6d198f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2725,11 +2725,8 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
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
@@ -2740,10 +2737,12 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
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
@@ -2802,7 +2801,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		dev_replace->cursor_left = dev_replace->cursor_right;
 		dev_replace->item_needs_writeback = 1;
-
+skip:
 		key.offset = found_key.offset + length;
 		btrfs_release_path(path);
 	}
-- 
1.9.3

