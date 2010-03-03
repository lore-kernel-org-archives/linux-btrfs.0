From: jim owens <owens6336@gmail.com>
Subject: [PATCH dio.c V2 6/6] Btrfs: fix goto fail mistakes in btrfs_dio_read.
Date: Wed, 03 Mar 2010 13:55:24 -0500
Message-ID: <4B8EB09C.6050501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: jim owens <jim6336@gmail.com>
---
 fs/btrfs/dio.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index 05a7445..b1beafc 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -459,7 +459,7 @@ getlock:
 		end = data_len;
 	if (end <= diocb->start) {
 		mutex_unlock(&diocb->inode->i_mutex);
-		goto fail; /* 0 is returned past EOF */
+		return; /* 0 is returned past EOF */
 	}
 	if (!loop) {
 		loop++;
@@ -489,10 +489,7 @@ getlock:
 				"extent start %llu len %llu\n",
 				diocb->inode->i_ino, diocb->start, len);
 			err = -EIO;
-			goto fail;
-		}
-
-		if (em->block_start == EXTENT_MAP_INLINE) {
+		} else if (em->block_start == EXTENT_MAP_INLINE) {
 			/* ugly stuff because inline can exist in a large file
 			 * with other extents if a hole immediately follows.
 			 * the inline might end short of the btrfs block with
-- 
1.6.3.3
