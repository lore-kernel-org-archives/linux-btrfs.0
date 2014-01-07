Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39955 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbaAGJ0r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 04:26:47 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH v2 2/4] Btrfs: fix protection between send and root deletion
Date: Tue, 7 Jan 2014 17:25:19 +0800
Message-Id: <1389086721-19624-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should gurantee that parent and clone roots can not be destroyed
during send, for this we have two ideas.

1.by holding @subvol_sem, this might be a nightmare, because it will
block all subvolumes deletion for a long time.

2.Miao pointed out we can reuse @send_in_progress, that mean we will
skip snapshot deletion if root sending is in progress.

Here we adopt the second approach since it won't block other subvolumes
deletion for a long time.

Besides in btrfs_clean_one_deleted_snapshot(), we only check first root
, if this root is involved in send, we return directly rather than
continue to check.There are several reasons about it:

1.this case happen seldomly.
2.after sending,cleaner thread can continue to drop that root.
3.make code simple

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1->v2:
	use right root to check(pointed by David)
---
 fs/btrfs/send.c        | 16 ++++++++++++++++
 fs/btrfs/transaction.c | 13 +++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5b69785..4e2461b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4753,6 +4753,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	u64 *clone_sources_tmp = NULL;
 	int clone_sources_to_rollback = 0;
 	int sort_clone_roots = 0;
+	int index;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -4893,8 +4894,12 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
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
@@ -4903,10 +4908,13 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
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
 		vfree(clone_sources_tmp);
@@ -4917,19 +4925,27 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
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
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 30d11bb..1ef8e28 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1971,6 +1971,19 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 	}
 	root = list_first_entry(&fs_info->dead_roots,
 			struct btrfs_root, root_list);
+	/*
+	 * Make sure root is not involved in send,
+	 * if we fail with first root, we return
+	 * directly rather than continue.
+	 */
+	spin_lock(&root->root_item_lock);
+	if (root->send_in_progress) {
+		spin_unlock(&fs_info->trans_lock);
+		spin_unlock(&root->root_item_lock);
+		return 0;
+	}
+	spin_unlock(&root->root_item_lock);
+
 	list_del_init(&root->root_list);
 	spin_unlock(&fs_info->trans_lock);
 
-- 
1.8.3.1

