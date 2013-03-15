Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38906 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab3COOse (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 10:48:34 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: johannes.hirte@fem.tu-ilmenau.de, darrick.wong@oracle.com
Subject: [PATCH] Btrfs: fix warning of free_extent_map
Date: Fri, 15 Mar 2013 22:46:39 +0800
Message-Id: <1363358799-17991-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Users report that an extent map's list is still linked when it's actually
going to be freed from cache.

The story is that

a) when we're going to drop an extent map and may split this large one into
smaller ems, and if this large one is flagged as EXTENT_FLAG_LOGGING which means
that it's on the list to be logged, then the smaller ems split from it will also
be flagged as EXTENT_FLAG_LOGGING, and this is _not_ expected.

b) we'll keep ems from unlinking the list and freeing when they are flagged with
EXTENT_FLAG_LOGGING, because the log code holds one reference.

The end result is the warning, but the truth is that we set the flag
EXTENT_FLAG_LOGGING only during fsync.

So clear flag EXTENT_FLAG_LOGGING for extent maps split from a large one.

Reported-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 83c790d..7bdb47f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -591,6 +591,7 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 		}
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 		clear_bit(EXTENT_FLAG_PINNED, &em->flags);
+		clear_bit(EXTENT_FLAG_LOGGING, &flags);
 		remove_extent_mapping(em_tree, em);
 		if (no_splits)
 			goto next;
-- 
1.7.7.6

