Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbcDKRfV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 13:35:21 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C76D0AC73
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 17:35:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/6] btrfs: send: use vmalloc only as fallback for clone_sources_tmp
Date: Mon, 11 Apr 2016 19:31:44 +0200
Message-Id: <d29d9fa932231c56b143322aa0323265445bd971.1460394967.git.dsterba@suse.com>
In-Reply-To: <cover.1460394967.git.dsterba@suse.com>
References: <cover.1460394967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 02967374d0d9..53a40a7077a2 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6059,10 +6059,13 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	alloc_size = arg->clone_sources_count * sizeof(*arg->clone_sources);
 
 	if (arg->clone_sources_count) {
-		clone_sources_tmp = vmalloc(alloc_size);
+		clone_sources_tmp = kmalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);
 		if (!clone_sources_tmp) {
-			ret = -ENOMEM;
-			goto out;
+			clone_sources_tmp = vmalloc(alloc_size);
+			if (!clone_sources_tmp) {
+				ret = -ENOMEM;
+				goto out;
+			}
 		}
 
 		ret = copy_from_user(clone_sources_tmp, arg->clone_sources,
@@ -6100,7 +6103,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 			sctx->clone_roots[i].root = clone_root;
 			clone_sources_to_rollback = i + 1;
 		}
-		vfree(clone_sources_tmp);
+		kvfree(clone_sources_tmp);
 		clone_sources_tmp = NULL;
 	}
 
@@ -6218,7 +6221,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		btrfs_root_dec_send_in_progress(sctx->parent_root);
 
 	kfree(arg);
-	vfree(clone_sources_tmp);
+	kvfree(clone_sources_tmp);
 
 	if (sctx) {
 		if (sctx->send_filp)
-- 
2.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
