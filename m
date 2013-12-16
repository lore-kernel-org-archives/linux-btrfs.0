Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab3LPQeU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 11:34:20 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2A1BAABE7
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 16:34:19 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/3] btrfs: Check read-only status of roots during send
Date: Mon, 16 Dec 2013 17:34:17 +0100
Message-Id: <c80eb84e6c8ab788de0f73e332755e27d518f7fd.1387211246.git.dsterba@suse.cz>
In-Reply-To: <cover.1387211245.git.dsterba@suse.cz>
References: <cover.1387211245.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All the subvolues that are involved in send must be read-only during the
whole operation. The ioctl SUBVOL_SETFLAGS could be used to change the
status to read-write and the result of send stream is undefined if the
data change unexpectedly.

Fix that by adding a refcount for all involved roots and verify that
there's no send in progress during SUBVOL_SETFLAGS ioctl call that does
read-only -> read-write transition.

We need refcounts because there are no restrictions on number of send
parallel operations currently run on a single subvolume, be it source,
parent or one of the multiple clone sources.

Kernel is silent when the RO checks fail and returns EPERM. The same set
of checks is done already in userspace before send starts.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h |    6 ++++++
 fs/btrfs/ioctl.c |   22 +++++++++++++++++++---
 fs/btrfs/send.c  |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 54ab86127f7a..302753cd51cf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1795,6 +1795,12 @@ struct btrfs_root {
 	struct list_head ordered_extents;
 	struct list_head ordered_root;
 	u64 nr_ordered_extents;
+
+	/*
+	 * Number of currently running SEND ioctls to prevent
+	 * manipulation with the read-only status via SUBVOL_SETFLAGS
+	 */
+	int send_in_progress;
 };
 
 struct btrfs_ioctl_defrag_range_args {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a111622598b0..158680a0f94e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1698,12 +1698,28 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_drop_sem;
 
 	root_flags = btrfs_root_flags(&root->root_item);
-	if (flags & BTRFS_SUBVOL_RDONLY)
+	if (flags & BTRFS_SUBVOL_RDONLY) {
 		btrfs_set_root_flags(&root->root_item,
 				     root_flags | BTRFS_ROOT_SUBVOL_RDONLY);
-	else
-		btrfs_set_root_flags(&root->root_item,
+	} else {
+		/*
+		 * Block RO -> RW transition if this subvolume is involved in
+		 * send
+		 */
+		spin_lock(&root->root_item_lock);
+		if (root->send_in_progress == 0) {
+			btrfs_set_root_flags(&root->root_item,
 				     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
+			spin_unlock(&root->root_item_lock);
+		} else {
+			spin_unlock(&root->root_item_lock);
+			btrfs_warn(root->fs_info,
+			"Attempt to set subvolume %llu read-write during send",
+					root->root_key.objectid);
+			ret = -EPERM;
+			goto out_drop_sem;
+		}
+	}
 
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 95f0fae4ce59..468eba26ad8c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4629,6 +4629,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	struct send_ctx *sctx = NULL;
 	u32 i;
 	u64 *clone_sources_tmp = NULL;
+	int clone_sources_to_rollback = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -4637,6 +4638,14 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	fs_info = send_root->fs_info;
 
 	/*
+	 * The subvolume must remain read-only during send, protect against
+	 * making it RW.
+	 */
+	spin_lock(&send_root->root_item_lock);
+	send_root->send_in_progress++;
+	spin_unlock(&send_root->root_item_lock);
+
+	/*
 	 * This is done when we lookup the root, it should already be complete
 	 * by the time we get here.
 	 */
@@ -4671,6 +4680,15 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		up_read(&send_root->fs_info->extent_commit_sem);
 	}
 
+	/*
+	 * Userspace tools do the checks and warn the user if it's
+	 * not RO.
+	 */
+	if (!btrfs_root_readonly(send_root)) {
+		ret = -EPERM;
+		goto out;
+	}
+
 	arg = memdup_user(arg_, sizeof(*arg));
 	if (IS_ERR(arg)) {
 		ret = PTR_ERR(arg);
@@ -4757,6 +4775,15 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 				ret = PTR_ERR(clone_root);
 				goto out;
 			}
+			clone_sources_to_rollback = i + 1;
+			spin_lock(&clone_root->root_item_lock);
+			clone_root->send_in_progress++;
+			if (!btrfs_root_readonly(clone_root)) {
+				spin_unlock(&clone_root->root_item_lock);
+				ret = -EPERM;
+				goto out;
+			}
+			spin_unlock(&clone_root->root_item_lock);
 			sctx->clone_roots[i].root = clone_root;
 		}
 		vfree(clone_sources_tmp);
@@ -4772,6 +4799,14 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 			ret = PTR_ERR(sctx->parent_root);
 			goto out;
 		}
+		spin_lock(&sctx->parent_root->root_item_lock);
+		sctx->parent_root->send_in_progress++;
+		if (!btrfs_root_readonly(sctx->parent_root)) {
+			spin_unlock(&sctx->parent_root->root_item_lock);
+			ret = -EPERM;
+			goto out;
+		}
+		spin_unlock(&sctx->parent_root->root_item_lock);
 	}
 
 	/*
@@ -4800,6 +4835,25 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	}
 
 out:
+	for (i = 0; i < clone_sources_to_rollback; i++) {
+		struct btrfs_root *r = sctx->clone_roots[i].root;
+
+		spin_lock(&r->root_item_lock);
+		r->send_in_progress--;
+		spin_unlock(&r->root_item_lock);
+	}
+	if (!IS_ERR(sctx->parent_root)) {
+		struct btrfs_root *r = sctx->parent_root;
+
+		spin_lock(&r->root_item_lock);
+		r->send_in_progress--;
+		spin_unlock(&r->root_item_lock);
+	}
+
+	spin_lock(&send_root->root_item_lock);
+	send_root->send_in_progress--;
+	spin_unlock(&send_root->root_item_lock);
+
 	kfree(arg);
 	vfree(clone_sources_tmp);
 
-- 
1.7.9

