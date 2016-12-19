Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42029 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753149AbcLSG5F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 01:57:05 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 72A2E41B4BD1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 14:56:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/6] btrfs-progs: file-item: Fix wrong file extents inserted
Date: Mon, 19 Dec 2016 14:56:37 +0800
Message-Id: <20161219065642.25078-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we specify NO_HOLES incompat feature when converting, the result
image still uses hole file extents.
And further more, the hole is incorrect as its disk_num_bytes is not
zero.

The problem is at btrfs_insert_file_extent() which doesn't check if we
are going to insert hole file extent.

Modify it to skip hole file extents to allow it follow restrict NO_HOLES
flag.

And since no_holes flag can be triggered on half-way, so current fsck
won't report such error, as it consider it as old file holes.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c |  2 +-
 file-item.c    | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/convert/main.c b/convert/main.c
index fd6f77b..15f14af 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -336,7 +336,7 @@ static int record_file_blocks(struct blk_iterate_data *data,
 		       key.offset > cur_off);
 		fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
 		extent_disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
-		extent_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
+		extent_num_bytes = btrfs_file_extent_num_bytes(node, fi);
 		BUG_ON(cur_off - key.offset >= extent_num_bytes);
 		btrfs_release_path(&path);
 
diff --git a/file-item.c b/file-item.c
index 67c0b4f..e462b4b 100644
--- a/file-item.c
+++ b/file-item.c
@@ -36,11 +36,22 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     u64 disk_num_bytes, u64 num_bytes)
 {
 	int ret = 0;
+	int is_hole = 0;
 	struct btrfs_file_extent_item *item;
 	struct btrfs_key file_key;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 
+	if (offset == 0)
+		is_hole = 1;
+	/* For NO_HOLES, we don't insert hole file extent */
+	if (btrfs_fs_incompat(root->fs_info, NO_HOLES) && is_hole)
+		return 0;
+
+	/* For hole, its disk_bytenr and disk_num_bytes must be 0 */
+	if (is_hole)
+		disk_num_bytes = 0;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
2.10.2



