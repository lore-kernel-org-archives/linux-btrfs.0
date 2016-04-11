Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbcDKRfI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 13:35:08 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 979FEAC73
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 17:35:05 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/6] btrfs: send: use vmalloc only as fallback for send_buf
Date: Mon, 11 Apr 2016 19:31:30 +0200
Message-Id: <771950c92fffe4ad7da53bc591aaa3e899480cc7.1460394967.git.dsterba@suse.com>
In-Reply-To: <cover.1460394967.git.dsterba@suse.com>
References: <cover.1460394967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 19b7bf4284ee..8f6f9d6d14df 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6022,10 +6022,13 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	sctx->clone_roots_cnt = arg->clone_sources_count;
 
 	sctx->send_max_size = BTRFS_SEND_BUF_SIZE;
-	sctx->send_buf = vmalloc(sctx->send_max_size);
+	sctx->send_buf = kmalloc(sctx->send_max_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!sctx->send_buf) {
-		ret = -ENOMEM;
-		goto out;
+		sctx->send_buf = vmalloc(sctx->send_max_size);
+		if (!sctx->send_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	sctx->read_buf = vmalloc(BTRFS_SEND_READ_SIZE);
@@ -6214,7 +6217,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 			fput(sctx->send_filp);
 
 		vfree(sctx->clone_roots);
-		vfree(sctx->send_buf);
+		kvfree(sctx->send_buf);
 		vfree(sctx->read_buf);
 
 		name_cache_free(sctx);
-- 
2.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
