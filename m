Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34038 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbcEIOCB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 10:02:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 577DD2010B
	for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2016 14:01:56 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 11FEC2011E
	for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2016 14:01:54 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix race between fsync and direct IO writes for prealloc extents
Date: Mon,  9 May 2016 15:01:49 +0100
Message-Id: <1462802509-1974-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When we do a direct IO write against a preallocated extent (fallocate)
that does not go beyond the i_size of the inode, we do the write operation
without holding the inode's i_mutex (an optimization that landed in
commit 38851cc19adb ("Btrfs: implement unlocked dio write")). This allows
for a very tiny time window where a race can happen with a concurrent
fsync using the fast code path, as the direct IO write path creates first
a new extent map (no longer flagged as a prealloc extent) and then it
creates the ordered extent, while the fast fsync path first collects
ordered extents and then it collects extent maps. This allows for the
possibility of the fast fsync path to collect the new extent map without
collecting the new ordered extent, and therefore logging an extent item
based on the extent map without waiting for the ordered extent to be
created and complete. This can result in a situation where after a log
replay we end up with an extent not marked anymore as prealloc but it was
only partially written (or not written at all), exposing random, stale or
garbage data corresponding to the unwritten pages and without any
checksums in the csum tree covering the extent's range.

This is an extension of what was done in commit de0ee0edb21f ("Btrfs: fix
race between fsync and lockless direct IO writes").

So fix this by creating first the ordered extent and then the extent
map, so that this way if the fast fsync patch collects the new extent
map it also collects the corresponding ordered extent.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c8d30ef..5372268 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7658,6 +7658,25 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 
 		if (can_nocow_extent(inode, start, &len, &orig_start,
 				     &orig_block_len, &ram_bytes) == 1) {
+
+			/*
+			 * Create the ordered extent before the extent map. This
+			 * is to avoid races with the fast fsync path because it
+			 * collects ordered extents into a local list and then
+			 * collects all the new extent maps, so we must create
+			 * the ordered extent first and make sure the fast fsync
+			 * path collects any new ordered extents after
+			 * collecting new extent maps as well. The fsync path
+			 * simply can not rely on inode_dio_wait() because it
+			 * causes deadlock with AIO.
+			 */
+			ret = btrfs_add_ordered_extent_dio(inode, start,
+					   block_start, len, len, type);
+			if (ret) {
+				free_extent_map(em);
+				goto unlock_err;
+			}
+
 			if (type == BTRFS_ORDERED_PREALLOC) {
 				free_extent_map(em);
 				em = create_pinned_em(inode, start, len,
@@ -7666,17 +7685,29 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 						       orig_block_len,
 						       ram_bytes, type);
 				if (IS_ERR(em)) {
+					struct btrfs_ordered_extent *oe;
+
 					ret = PTR_ERR(em);
+					oe = btrfs_lookup_ordered_extent(inode,
+									 start);
+					ASSERT(oe);
+					if (WARN_ON(!oe))
+						goto unlock_err;
+					set_bit(BTRFS_ORDERED_IOERR,
+						&oe->flags);
+					set_bit(BTRFS_ORDERED_IO_DONE,
+						&oe->flags);
+					btrfs_remove_ordered_extent(inode, oe);
+					/*
+					 * Once for our lookup and once for the
+					 * ordered extents tree.
+					 */
+					btrfs_put_ordered_extent(oe);
+					btrfs_put_ordered_extent(oe);
 					goto unlock_err;
 				}
 			}
 
-			ret = btrfs_add_ordered_extent_dio(inode, start,
-					   block_start, len, len, type);
-			if (ret) {
-				free_extent_map(em);
-				goto unlock_err;
-			}
 			goto unlock;
 		}
 	}
-- 
2.7.0.rc3

