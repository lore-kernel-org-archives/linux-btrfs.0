Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759414AbcHEC3j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Aug 2016 22:29:39 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v2 3/3] btrfs: qgroup: Fix qgroup incorrectness caused by log replay
Date: Fri,  5 Aug 2016 10:29:23 +0800
Message-Id: <20160805022923.6170-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160805022923.6170-1-quwenruo@cn.fujitsu.com>
References: <20160805022923.6170-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When doing log replay at mount time(after power loss), qgroup will leak
numbers of replayed data extents.

The cause is almost the same of balance.
So fix it by manually informing qgroup for owner changed extents.

The bug can be detected by btrfs/119 test case.

Cc: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c05f69a..80f8345 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -27,6 +27,7 @@
 #include "backref.h"
 #include "hash.h"
 #include "compression.h"
+#include "qgroup.h"
 
 /* magic values for the inode_only field in btrfs_log_inode:
  *
@@ -680,6 +681,21 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		ins.type = BTRFS_EXTENT_ITEM_KEY;
 		offset = key->offset - btrfs_file_extent_offset(eb, item);
 
+		/*
+		 * Manually record dirty extent, as here we did a shallow
+		 * file extent item copy and skip normal backref update,
+		 * but modify extent tree all by ourselves.
+		 * So need to manually record dirty extent for qgroup,
+		 * as the owner of the file extent changed from log tree
+		 * (doesn't affect qgroup) to fs/file tree(affects qgroup)
+		 */
+		ret = btrfs_qgroup_record_dirty_extent(trans, root->fs_info,
+				btrfs_file_extent_disk_bytenr(eb, item),
+				btrfs_file_extent_disk_num_bytes(eb, item),
+				GFP_NOFS);
+		if (ret < 0)
+			goto out;
+
 		if (ins.objectid > 0) {
 			u64 csum_start;
 			u64 csum_end;
-- 
2.9.2



