From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 4/6] Btrfs: fix nocow when deleting the item
Date: Thu, 10 Nov 2011 14:28:50 +0800
Message-ID: <4EBB6F22.1050603@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_previous_item() just search the b+ tree, do not COW the nodes or leaves,
if we modify the result of it, the meta-data will be broken. fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f8e29431..c37433d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -999,7 +999,7 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 	key.objectid = device->devid;
 	key.offset = start;
 	key.type = BTRFS_DEV_EXTENT_KEY;
-
+again:
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret > 0) {
 		ret = btrfs_previous_item(root, path, key.objectid,
@@ -1012,6 +1012,9 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 					struct btrfs_dev_extent);
 		BUG_ON(found_key.offset > start || found_key.offset +
 		       btrfs_dev_extent_length(leaf, extent) < start);
+		key = found_key;
+		btrfs_release_path(path);
+		goto again;
 	} else if (ret == 0) {
 		leaf = path->nodes[0];
 		extent = btrfs_item_ptr(leaf, path->slots[0],
-- 
1.7.6.4
