Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46804 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2JaPQi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 11:16:38 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, chris.mason@fusionio.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Btrfs: Fix typo in fs/btrfs
Date: Thu,  1 Nov 2012 00:16:32 +0900
Message-Id: <1351696592-14721-1-git-send-email-standby24x7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Correct spelling typo in btrfs.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/btrfs/ctree.h   | 2 +-
 fs/btrfs/volumes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 926c9ff..9dda9a9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -413,7 +413,7 @@ struct btrfs_root_backup {
 	__le64 bytes_used;
 	__le64 num_devices;
 	/* future */
-	__le64 unsed_64[4];
+	__le64 unused_64[4];
 
 	u8 tree_root_level;
 	u8 chunk_root_level;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 029b903..36b7f43 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4287,7 +4287,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 
 			rcu_read_lock();
 			name = rcu_dereference(dev->name);
-			pr_debug("btrfs_map_bio: rw %d, secor=%llu, dev=%lu "
+			pr_debug("btrfs_map_bio: rw %d, sector=%llu, dev=%lu "
 				 "(%s id %llu), size=%u\n", rw,
 				 (u64)bio->bi_sector, (u_long)dev->bdev->bd_dev,
 				 name->str, dev->devid, bio->bi_size);
-- 
1.8.0.rc3.16.g8ead1bf

