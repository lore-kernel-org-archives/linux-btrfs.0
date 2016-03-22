Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758113AbcCVBiq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:46 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 20/27] btrfs: dedupe: Fix a bug when running inband dedupe with balance
Date: Tue, 22 Mar 2016 09:35:45 +0800
Message-Id: <1458610552-9845-21-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

When running inband dedupe with balance, it's possible that inband dedupe
still increase ref on extents which are in RO chunk.

This may cause either find_data_references() gives warning, or make
run_delayed_refs() return -EIO and cause trans abort.

The cause is, normal dedupe_del() is only called at run_delayed_ref()
time, which is too late for balance case.

This patch fixes this bug by calling dedupe_del() at extent searching
time of balance.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2bd0011..71a5cd0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -31,6 +31,7 @@
 #include "async-thread.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "dedupe.h"
 
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
@@ -4032,6 +4034,20 @@ restart:
 			}
 		}
 
+		/*
+		 * This data extent will be replaced, but normal
+		 * dedupe_del() will only happen at run_delayed_ref()
+		 * time, which is too late, so delete dedupe hash early
+		 * to prevent its ref get increased.
+		 */
+		if (rc->stage == MOVE_DATA_EXTENTS &&
+		    (flags & BTRFS_EXTENT_FLAG_DATA)) {
+			ret = btrfs_dedupe_del(trans, fs_info, key.objectid);
+			if (ret < 0) {
+				err = ret;
+				break;
+			}
+		}
 		btrfs_end_transaction_throttle(trans, rc->extent_root);
 		btrfs_btree_balance_dirty(rc->extent_root);
 		trans = NULL;
-- 
2.7.3



