Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23130 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbaAFJ0h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 04:26:37 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s069QZ23030974
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 17:26:35 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs: fix protection between send and root deletion
Date: Mon, 6 Jan 2014 17:25:37 +0800
Message-Id: <1389000339-15388-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should gurantee that parent and clone root can not be destroyed
during send, for this we have two ideas.

1.by holding @subvol_sem, this might be a nightmare, because it will
block all subvolumes deletion for a long time.

2.Miao pointed out we can reuse @send_in_progress, that mean we will
skip snapshot deletion if root sending is in progress.

Here we adopt the second approach since it won't block other subvolumes
deletion for a long time.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 13 ++++++++++---
 fs/btrfs/send.c  | 17 +++++++++++++++++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 71e1fc7..ea19eff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3505,12 +3505,19 @@ static inline int btrfs_fs_closing(struct btrfs_fs_info *fs_info)
 }
 
 /*
- * If we remount the fs to be R/O or umount the fs, the cleaner needn't do
- * anything except sleeping. This function is used to check the status of
- * the fs.
+ * If we remount the fs to be R/O, umount the fs or we are sending a
+ * subvolume, the cleaner needn't do anything except sleeping. This
+ * function is used to check the status of the fs.
  */
 static inline int btrfs_need_cleaner_sleep(struct btrfs_root *root)
 {
+	spin_lock(&root->root_item_lock);
+	if (root->send_in_progress) {
+		spin_unlock(&root->root_item_lock);
+		return 1;
+	}
+	spin_unlock(&root->root_item_lock);
+
 	return (root->fs_info->sb->s_flags & MS_RDONLY ||
 		btrfs_fs_closing(root->fs_info));
 }
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 076b066..f9cdeb7 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4752,6 +4752,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	u32 i;
 	u64 *clone_sources_tmp = NULL;
 	int clone_sources_to_rollback = 0;
+	int index;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -4892,20 +4893,28 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 			key.objectid = clone_sources_tmp[i];
 			key.type = BTRFS_ROOT_ITEM_KEY;
 			key.offset = (u64)-1;
+
+			index = srcu_read_lock(&fs_info->subvol_srcu);
+
 			clone_root = btrfs_read_fs_root_no_name(fs_info, &key);
 			if (IS_ERR(clone_root)) {
+				srcu_read_unlock(&fs_info->subvol_srcu, index);
 				ret = PTR_ERR(clone_root);
 				goto out;
 			}
 			clone_sources_to_rollback = i + 1;
+
 			spin_lock(&clone_root->root_item_lock);
 			clone_root->send_in_progress++;
 			if (!btrfs_root_readonly(clone_root)) {
 				spin_unlock(&clone_root->root_item_lock);
+				srcu_read_unlock(&fs_info->subvol_srcu, index);
 				ret = -EPERM;
 				goto out;
 			}
 			spin_unlock(&clone_root->root_item_lock);
+			srcu_read_unlock(&fs_info->subvol_srcu, index);
+
 			sctx->clone_roots[i].root = clone_root;
 		}
 		clone_sources_to_rollback--;
@@ -4917,19 +4926,27 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		key.objectid = arg->parent_root;
 		key.type = BTRFS_ROOT_ITEM_KEY;
 		key.offset = (u64)-1;
+
+		index = srcu_read_lock(&fs_info->subvol_srcu);
+
 		sctx->parent_root = btrfs_read_fs_root_no_name(fs_info, &key);
 		if (IS_ERR(sctx->parent_root)) {
+			srcu_read_unlock(&fs_info->subvol_srcu, index);
 			ret = PTR_ERR(sctx->parent_root);
 			goto out;
 		}
+
 		spin_lock(&sctx->parent_root->root_item_lock);
 		sctx->parent_root->send_in_progress++;
 		if (!btrfs_root_readonly(sctx->parent_root)) {
 			spin_unlock(&sctx->parent_root->root_item_lock);
+			srcu_read_unlock(&fs_info->subvol_srcu, index);
 			ret = -EPERM;
 			goto out;
 		}
 		spin_unlock(&sctx->parent_root->root_item_lock);
+
+		srcu_read_unlock(&fs_info->subvol_srcu, index);
 	}
 
 	/*
-- 
1.8.3.1

