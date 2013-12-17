Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab3LQOHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 09:07:22 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, wangsl.fnst@cn.fujitsu.com
Subject: 
Date: Tue, 17 Dec 2013 15:07:20 +0100
Message-Id: <1387289240-10960-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <cover.1387211245.git.dsterba@suse.cz>
References: <cover.1387211245.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Subject: [PATCH 4/3] btrfs: check balance of send_in_progress

Warn if the balance goes below zero, which appears to be unlikely
though. Otherwise cleans up the code a bit.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

A followup to 3/3 that adds the check if send_in_progress is not going below
zero. It's a separate patch rather than folded into 3/3 so the change is
clearly visible. I'm not convinced that it's necessary to be that cautious
because it looks almost impossible to happen, but on the other hand we'd never
know that it happened.

 fs/btrfs/send.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 468eba26ad8c..46ea0cdfb88b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4618,6 +4618,21 @@ out:
 	return ret;
 }
 
+static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
+{
+	spin_lock(&root->root_item_lock);
+	root->send_in_progress--;
+	/*
+	 * Not much left to do, we don't know why it's unbalanced and
+	 * can't blindly reset it to 0.
+	 */
+	if (root->send_in_progress < 0)
+		btrfs_err(root->fs_info,
+			"send_in_progres unbalanced %d root %llu\n",
+			root->send_in_progress, root->root_key.objectid);
+	spin_unlock(&root->root_item_lock);
+}
+
 long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 {
 	int ret = 0;
@@ -4835,24 +4850,11 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	}
 
 out:
-	for (i = 0; i < clone_sources_to_rollback; i++) {
-		struct btrfs_root *r = sctx->clone_roots[i].root;
-
-		spin_lock(&r->root_item_lock);
-		r->send_in_progress--;
-		spin_unlock(&r->root_item_lock);
-	}
-	if (!IS_ERR(sctx->parent_root)) {
-		struct btrfs_root *r = sctx->parent_root;
-
-		spin_lock(&r->root_item_lock);
-		r->send_in_progress--;
-		spin_unlock(&r->root_item_lock);
-	}
-
-	spin_lock(&send_root->root_item_lock);
-	send_root->send_in_progress--;
-	spin_unlock(&send_root->root_item_lock);
+	for (i = 0; i < clone_sources_to_rollback; i++)
+		btrfs_root_dec_send_in_progress(sctx->clone_roots[i].root);
+	if (!IS_ERR(sctx->parent_root))
+		btrfs_root_dec_send_in_progress(sctx->parent_root);
+	btrfs_root_dec_send_in_progress(send_root);
 
 	kfree(arg);
 	vfree(clone_sources_tmp);
-- 
1.7.9

