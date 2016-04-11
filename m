Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbcDKRfL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 13:35:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DE42CAC73
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 17:35:08 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/6] btrfs: send: use vmalloc only as fallback for read_buf
Date: Mon, 11 Apr 2016 19:31:34 +0200
Message-Id: <b004f904a3c595f5ae00b49b733f0dc008b87dd8.1460394967.git.dsterba@suse.com>
In-Reply-To: <cover.1460394967.git.dsterba@suse.com>
References: <cover.1460394967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 8f6f9d6d14df..fc9d7f6212c1 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6031,10 +6031,13 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		}
 	}
 
-	sctx->read_buf = vmalloc(BTRFS_SEND_READ_SIZE);
+	sctx->read_buf = kmalloc(BTRFS_SEND_READ_SIZE, GFP_KERNEL | __GFP_NOWARN);
 	if (!sctx->read_buf) {
-		ret = -ENOMEM;
-		goto out;
+		sctx->read_buf = vmalloc(BTRFS_SEND_READ_SIZE);
+		if (!sctx->read_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	sctx->pending_dir_moves = RB_ROOT;
@@ -6218,7 +6221,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 
 		vfree(sctx->clone_roots);
 		kvfree(sctx->send_buf);
-		vfree(sctx->read_buf);
+		kvfree(sctx->read_buf);
 
 		name_cache_free(sctx);
 
-- 
2.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
