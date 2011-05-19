From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: return error code to caller when btrfs_previous_item fails
Date: Thu, 19 May 2011 16:03:42 +0900
Message-ID: <201105190703.AA00022@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The error code is returned instead of calling BUG_ON when
btrfs_previous_item returns the error.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/volumes.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b9fb8c..c95b214 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -983,14 +983,14 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 	if (ret > 0) {
 		ret = btrfs_previous_item(root, path, key.objectid,
 					  BTRFS_DEV_EXTENT_KEY);
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		extent = btrfs_item_ptr(leaf, path->slots[0],
 					struct btrfs_dev_extent);
 		BUG_ON(found_key.offset > start || found_key.offset +
 		       btrfs_dev_extent_length(leaf, extent) < start);
-		ret = 0;
 	} else if (ret == 0) {
 		leaf = path->nodes[0];
 		extent = btrfs_item_ptr(leaf, path->slots[0],
@@ -1003,6 +1003,7 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 	ret = btrfs_del_item(trans, root, path);
 	BUG_ON(ret);
 
+out:
 	btrfs_free_path(path);
 	return ret;
 }


