Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6307 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730093AbeGRHWh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id A238F4B5CD85
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:12 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 19/19] btrfs: qgroup: Drop fs_info parameter from qgroup_rescan_leaf
Date: Wed, 18 Jul 2018 14:45:42 +0800
Message-ID: <20180718064542.2730-20-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 98eb2e314030..941fb06ff28b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2641,10 +2641,10 @@ static bool is_last_leaf(struct btrfs_path *path)
  * returns < 0 on error, 0 when more leafs are to be scanned.
  * returns 1 when done.
  */
-static int
-qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
-		   struct btrfs_trans_handle *trans)
+static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
+			      struct btrfs_path *path)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_key found;
 	struct extent_buffer *scratch_leaf = NULL;
 	struct ulist *roots = NULL;
@@ -2759,7 +2759,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
 			err = -EINTR;
 		} else {
-			err = qgroup_rescan_leaf(fs_info, path, trans);
+			err = qgroup_rescan_leaf(trans, path);
 		}
 		if (err > 0)
 			btrfs_commit_transaction(trans);
-- 
2.18.0



