From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 11/12] Btrfs: Fix btrfs_drop_extent_cache for skip pinned
 case
Date: Thu, 12 Nov 2009 17:36:44 +0800
Message-ID: <4AFBD72C.6010407@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The check for skip pinned case is wrong, it may breaks the
while loop immaturely.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
---
 fs/btrfs/file.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a4a6d2c..a78fb9b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -179,18 +179,14 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 		}
 		flags = em->flags;
 		if (skip_pinned && test_bit(EXTENT_FLAG_PINNED, &em->flags)) {
-			if (em->start <= start &&
-			    (!testend || em->start + em->len >= start + len)) {
+			if (testend && em->start + em->len >= start + len) {
 				free_extent_map(em);
 				write_unlock(&em_tree->lock);
 				break;
 			}
-			if (start < em->start) {
-				len = em->start - start;
-			} else {
+			start = em->start + em->len;
+			if (testend)
 				len = start + len - (em->start + em->len);
-				start = em->start + em->len;
-			}
 			free_extent_map(em);
 			write_unlock(&em_tree->lock);
 			continue;
-- 
1.6.2.5

