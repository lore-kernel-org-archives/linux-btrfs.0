Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:49485 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752865AbdLEKtT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 05:49:19 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 8C1D2486A768
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 18:49:15 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: use enum instead of constant value
Date: Tue, 5 Dec 2017 18:35:30 +0800
Message-ID: <1512470130-7240-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use enum READA_BACK instead of value 1 to keep source robust.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/free-space-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index a5e34de..a105629 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1071,7 +1071,7 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	path2 = btrfs_alloc_path();
 	if (!path2) {
@@ -1577,7 +1577,7 @@ int load_free_space_tree(struct btrfs_caching_control *caching_ctl)
 	 */
 	path->skip_locking = 1;
 	path->search_commit_root = 1;
-	path->reada = 1;
+	path->reada = READA_BACK;
 
 	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
 	if (IS_ERR(info)) {
-- 
1.9.1



