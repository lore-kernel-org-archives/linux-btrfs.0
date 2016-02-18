Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41093 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1425111AbcBRFpj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 00:45:39 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v7 20/20] btrfs: dedup: Fix a bug when running inband dedup with balance
Date: Thu, 18 Feb 2016 13:42:58 +0800
Message-Id: <1455774178-3595-21-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

When running inband dedup with balance, it's possible that inband dedup
still increase ref on extents which are in RO chunk.

This may cause either find_data_references() gives warning, or make
run_delayed_refs() return -EIO and cause trans abort.

The cause is, normal dedup_del() is only called at run_delayed_ref()
time, which is too late for balance case.

This patch fixes this bug by calling dedup_del() at extent searching
time of balance.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2bd0011..913a7b1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -31,6 +31,7 @@
 #include "async-thread.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "dedup.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -3909,6 +3910,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path *path;
 	struct btrfs_extent_item *ei;
+	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 	u64 flags;
 	u32 item_size;
 	int ret;
@@ -4039,6 +4041,17 @@ restart:
 		if (rc->stage == MOVE_DATA_EXTENTS &&
 		    (flags & BTRFS_EXTENT_FLAG_DATA)) {
 			rc->found_file_extent = 1;
+			/*
+			 * This data extent will be replaced, but normal
+			 * dedup_del() will only happen at run_delayed_ref()
+			 * time, which is too late, so delete dedup hash early
+			 * to prevent its ref get increased.
+			 */
+			ret = btrfs_dedup_del(trans, fs_info, key.objectid);
+			if (ret < 0) {
+				err = ret;
+				break;
+			}
 			ret = relocate_data_extent(rc->data_inode,
 						   &key, &rc->cluster);
 			if (ret < 0) {
-- 
2.7.1



