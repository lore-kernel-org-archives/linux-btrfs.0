Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbbATJHt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 04:07:49 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH RFC v2 4/5] Revert "btrfs: move commit out of sysfs when changing label"
Date: Tue, 20 Jan 2015 17:05:36 +0800
Message-ID: <1421744737-16586-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit a6f69dc8018d ("btrfs: move commit out of sysfs when
changing label").
Unlike most btrfs file operations, sysfs don't go through the normal
open/read/write routine which will initiate a sb_start_*write/read.

This is very dangerous on frozen btrfs, if using the pending changes
method, sysfs change can make fs_info->pending_changes to 1, and later
sync_fs() call will cause deadlock.

So revert the patch to deal the deadlock caused by the following
workload:
freeze() -> change lable -> sync() -> unfreeze()

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/sysfs.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 92db3f6..226f726 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -369,6 +369,9 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 				 const char *buf, size_t len)
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = fs_info->fs_root;
+	int ret;
 	size_t p_len;
 
 	if (fs_info->sb->s_flags & MS_RDONLY)
@@ -383,18 +386,20 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	if (p_len >= BTRFS_LABEL_SIZE)
 		return -EINVAL;
 
-	spin_lock(&fs_info->super_lock);
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	spin_lock(&root->fs_info->super_lock);
 	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
 	memcpy(fs_info->super_copy->label, buf, p_len);
-	spin_unlock(&fs_info->super_lock);
+	spin_unlock(&root->fs_info->super_lock);
+	ret = btrfs_commit_transaction(trans, root);
 
-	/*
-	 * We don't want to do full transaction commit from inside sysfs
-	 */
-	btrfs_set_pending(fs_info, COMMIT);
-	wake_up_process(fs_info->transaction_kthread);
+	if (!ret)
+		return len;
 
-	return len;
+	return ret;
 }
 BTRFS_ATTR_RW(label, btrfs_label_show, btrfs_label_store);
 
-- 
2.2.2

