Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30441 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdAZBQs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 20:16:48 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: cleanup unused cached_state in __extent_writepage_io
Date: Wed, 25 Jan 2017 17:15:54 -0800
Message-Id: <1485393354-14139-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@cached_state is no more required in __extent_writepage_io, also remove the
goto label.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ac383a..d5f3edb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3330,7 +3330,6 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	u64 block_start;
 	u64 iosize;
 	sector_t sector;
-	struct extent_state *cached_state = NULL;
 	struct extent_map *em;
 	struct block_device *bdev;
 	size_t pg_offset = 0;
@@ -3351,8 +3350,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 
 			update_nr_written(page, wbc, nr_written);
 			unlock_page(page);
-			ret = 1;
-			goto done_unlocked;
+			return 1;
 		}
 	}
 
@@ -3454,11 +3452,6 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	}
 done:
 	*nr_ret = nr;
-
-done_unlocked:
-
-	/* drop our reference on any cached states */
-	free_extent_state(cached_state);
 	return ret;
 }
 
-- 
1.8.3.1

