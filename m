Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbeFZHKE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 03:10:04 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: misono.tomohiro@jp.fujitsu.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: qgroups: Move transaction managed inside btrfs_quota_enable
Date: Tue, 26 Jun 2018 10:09:58 +0300
Message-Id: <1529996998-15451-1-git-send-email-nborisov@suse.com>
In-Reply-To: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to
btrfs_quota_enable") not only resulted in an easier to follow code but
it also introduced a subtle bug. It changed the timing when the initial
transaction rescan was happening - before the commit it would happen
after transaction commit had occured but after the commit it might happen
before the transaction was committed. This results in failure to
correctly rescan the quota since there could be data which is still not
committed on disk.

This patch aims to fix this by movign the transaction creation/commit
inside btrfs_quota_enable, which allows to schedule the quota commit
after the transaction has been committed.

Fixes: 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to btrfs_quota_enable")
Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
Hi Misono, 

Care to test the following patch ? If you say it's ok I will do a similar one 
for the btrfs_quota_disable function. This will also allow me to get rid of 
the extra err variable in btrfs_ioctl_quota_ctl. Additionally I think the 
number of blocks (2) passed to the transaction for reservation might be 
wrong. 

 fs/btrfs/ioctl.c  |  2 +-
 fs/btrfs/qgroup.c | 17 ++++++++++++++---
 fs/btrfs/qgroup.h |  3 +--
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a399750b9e41..bf99d7aae3ae 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5161,7 +5161,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 
 	switch (sa->cmd) {
 	case BTRFS_QUOTA_CTL_ENABLE:
-		ret = btrfs_quota_enable(trans, fs_info);
+		ret = btrfs_quota_enable(fs_info);
 		break;
 	case BTRFS_QUOTA_CTL_DISABLE:
 		ret = btrfs_quota_disable(trans, fs_info);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1874a6d2e6f5..91bb7e97c0d0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -875,8 +875,7 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_quota_enable(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info)
+int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_root *tree_root = fs_info->tree_root;
@@ -886,6 +885,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_qgroup *qgroup = NULL;
+	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 	int slot;
 
@@ -893,6 +893,12 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	if (fs_info->quota_root)
 		goto out;
 
+	trans = btrfs_start_transaction(tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
 	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
 	if (!fs_info->qgroup_ulist) {
 		ret = -ENOMEM;
@@ -987,6 +993,11 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	fs_info->quota_root = quota_root;
 	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	spin_unlock(&fs_info->qgroup_lock);
+
+	ret = btrfs_commit_transaction(trans);
+	if (ret)
+		goto out_free_path;
+
 	ret = qgroup_rescan_init(fs_info, 0, 1);
 	if (!ret) {
 	        qgroup_rescan_zero_tracking(fs_info);
@@ -3061,7 +3072,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len);
 	extent_changeset_init(&changeset);
-	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
+	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
 			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d60dd06445ce..3900efab0e70 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -141,8 +141,7 @@ struct btrfs_qgroup {
 #define QGROUP_RELEASE		(1<<1)
 #define QGROUP_FREE		(1<<2)
 
-int btrfs_quota_enable(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info);
+int btrfs_quota_enable(struct btrfs_fs_info *fs_info);
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
-- 
2.7.4

