Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:28280 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdH3Hd2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 03:33:28 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 291B6AC016E
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 16:33:22 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 74B663287C7
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 16:33:21 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: remove BTRFS_FS_QUOTA_DISABLING flag
Message-ID: <f624acec-ac1b-61ca-19c9-e7683fc0b4e2@jp.fujitsu.com>
Date: Wed, 30 Aug 2017 16:33:16 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, "btrfs quota enable" would fail after "btrfs quota disable" on
the first time with syslog output "qgroup_rescan_init failed with -22", but
it would succeed on the second time.

When "quota disable" is called, BTRFS_FS_QUOTA_DISABLING flag bit will be
set in fs_info->flags in btrfs_quota_disable(), but it will not be droppd
in btrfs_run_qgroups() (which is called in btrfs_commit_transaction())
because quota_root has already been freed. If "quota enable" is called
after that, both BTRFS_FS_QUOTA_DISABLING and BTRFS_FS_QUOTA_ENABLED flag
would be dropped in the btrfs_run_qgroups() since quota_root is not NULL.
This leads to the failure of "quota enable" on the first time.

BTRFS_FS_QUOTA_DISABLING flag is not used outside of "quota disable"
context and is equivalent to whether quota_root is NULL or not.
btrfs_run_qgroups() checks whether quota_root is NULL or not in the first
place. 

So, let's remove BTRFS_FS_QUOTA_DISABLING flag.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h  | 1 -
 fs/btrfs/qgroup.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3f3eb7b..49501c0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -709,7 +709,6 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_OPEN				5
 #define BTRFS_FS_QUOTA_ENABLED			6
 #define BTRFS_FS_QUOTA_ENABLING			7
-#define BTRFS_FS_QUOTA_DISABLING		8
 #define BTRFS_FS_UPDATE_UUID_TREE_GEN		9
 #define BTRFS_FS_CREATING_FREE_SPACE_TREE	10
 #define BTRFS_FS_BTREE_ERR			11
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4ce351e..f0b111e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -807,7 +807,6 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 	}
 	ret = 0;
 out:
-	set_bit(BTRFS_FS_QUOTA_DISABLING, &root->fs_info->flags);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -954,7 +953,6 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	if (!fs_info->quota_root)
 		goto out;
 	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
-	set_bit(BTRFS_FS_QUOTA_DISABLING, &fs_info->flags);
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
@@ -2087,8 +2085,6 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 
 	if (test_and_clear_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags))
 		set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
-	if (test_and_clear_bit(BTRFS_FS_QUOTA_DISABLING, &fs_info->flags))
-		clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 
 	spin_lock(&fs_info->qgroup_lock);
 	while (!list_empty(&fs_info->dirty_qgroups)) {
-- 
2.9.5


