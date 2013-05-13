Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2056 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab3EMPMa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:12:30 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH 5/5] Btrfs: update the global reserve if it is empty
Date: Mon, 13 May 2013 21:55:12 +0800
Message-Id: <1368453312-7027-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before applying this patch, we reserved the space for the global reserve
by the minimum unit if we found it is empty, it was unreasonable and
inefficient, because if the global reserve space was depleted, it implied
that the size of the global reserve was too small. In this case, we shoud
update the global reserve and fill it.

Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c48e1bd..c75fe11 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6656,12 +6656,13 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	int ret;
+	bool global_updated = false;
 
 	block_rsv = get_block_rsv(trans, root);
 
 	if (unlikely(block_rsv->size == 0))
 		goto try_reserve;
-
+again:
 	ret = block_rsv_use_bytes(block_rsv, blocksize);
 	if (!ret)
 		return block_rsv;
@@ -6669,6 +6670,12 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	if (block_rsv->failfast)
 		return ERR_PTR(ret);
 
+	if (block_rsv->type == BTRFS_BLOCK_RSV_GLOBAL && !global_updated) {
+		global_updated = true;
+		update_global_block_rsv(root->fs_info);
+		goto again;
+	}
+
 	if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
 		static DEFINE_RATELIMIT_STATE(_rs,
 				DEFAULT_RATELIMIT_INTERVAL * 10,
-- 
1.8.0.1

