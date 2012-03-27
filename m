From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: fix infinite loop in btrfs_shrink_device()
Date: Tue, 27 Mar 2012 18:14:19 +0300
Message-ID: <1332861259-27505-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If relocate of block group 0 fails with ENOSPC we end up infinitely
looping because key.offset -= 1 statement in that case brings us back to
where we started.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bcc0acd..be2d4e0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2987,7 +2987,7 @@ again:
 	key.offset = (u64)-1;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 
-	while (1) {
+	do {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto done;
@@ -3029,8 +3029,7 @@ again:
 			goto done;
 		if (ret == -ENOSPC)
 			failed++;
-		key.offset -= 1;
-	}
+	} while (key.offset-- > 0);
 
 	if (failed && !retried) {
 		failed = 0;
-- 
1.7.9.1

