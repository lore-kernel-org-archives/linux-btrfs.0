From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: cleanup error handling in btree_get_extent()
Date: Tue, 31 Jan 2012 16:17:21 +0900
Message-ID: <201201310717.AA00041@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes the redundant code of error handling for the
cleanup of btree_get_extent().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/disk-io.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4c86711..ee07847 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -221,21 +221,17 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 
 		free_extent_map(em);
 		em = lookup_extent_mapping(em_tree, start, len);
-		if (em) {
-			ret = 0;
-		} else {
-			em = lookup_extent_mapping(em_tree, failed_start,
-						   failed_len);
-			ret = -EIO;
+		if (!em) {
+			lookup_extent_mapping(em_tree, failed_start,
+					      failed_len);
+			em = ERR_PTR(-EIO);
 		}
 	} else if (ret) {
 		free_extent_map(em);
-		em = NULL;
+		em = ERR_PTR(ret);
 	}
 	write_unlock(&em_tree->lock);
 
-	if (ret)
-		em = ERR_PTR(ret);
 out:
 	return em;
 }

