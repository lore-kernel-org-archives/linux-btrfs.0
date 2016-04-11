Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbcDKRfR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 13:35:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7F35FAC89
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 17:35:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/6] btrfs: send: use vmalloc only as fallback for clone_roots
Date: Mon, 11 Apr 2016 19:31:40 +0200
Message-Id: <2ea3965276a002936e1fb75ae8af51da384d705a.1460394967.git.dsterba@suse.com>
In-Reply-To: <cover.1460394967.git.dsterba@suse.com>
References: <cover.1460394967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ab1b4d259836..02967374d0d9 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6047,10 +6047,13 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 
 	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
 
-	sctx->clone_roots = vzalloc(alloc_size);
+	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!sctx->clone_roots) {
-		ret = -ENOMEM;
-		goto out;
+		sctx->clone_roots = vzalloc(alloc_size);
+		if (!sctx->clone_roots) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	alloc_size = arg->clone_sources_count * sizeof(*arg->clone_sources);
@@ -6221,7 +6224,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		if (sctx->send_filp)
 			fput(sctx->send_filp);
 
-		vfree(sctx->clone_roots);
+		kvfree(sctx->clone_roots);
 		kvfree(sctx->send_buf);
 		kvfree(sctx->read_buf);
 
-- 
2.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
