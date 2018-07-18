Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6307 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729199AbeGRHWa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:30 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2333C4B5CD85
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:00 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/19] btrfs: qgroup: Drop quota_root parameter from del_qgroup_item
Date: Wed, 18 Jul 2018 14:45:26 +0800
Message-ID: <20180718064542.2730-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4c852ded1d52..6eb65a0e912e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -653,10 +653,10 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int del_qgroup_item(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *quota_root, u64 qgroupid)
+static int del_qgroup_item(struct btrfs_trans_handle *trans, u64 qgroupid)
 {
 	int ret;
+	struct btrfs_root *quota_root = trans->fs_info->quota_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 
@@ -1419,7 +1419,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 	}
-	ret = del_qgroup_item(trans, quota_root, qgroupid);
+	ret = del_qgroup_item(trans, qgroupid);
 	if (ret && ret != -ENOENT)
 		goto out;
 
-- 
2.18.0



