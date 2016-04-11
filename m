Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbcDKRfY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 13:35:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1BC47AC73
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 17:35:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/6] btrfs: clone: use vmalloc only as fallback for nodesize bufer
Date: Mon, 11 Apr 2016 19:31:47 +0200
Message-Id: <c3e3930516c4d14ed1d6d70964fbc4f3faa36844.1460394967.git.dsterba@suse.com>
In-Reply-To: <cover.1460394967.git.dsterba@suse.com>
References: <cover.1460394967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21423dd15da4..0cb80379e6f6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3468,13 +3468,16 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	u64 last_dest_end = destoff;
 
 	ret = -ENOMEM;
-	buf = vmalloc(root->nodesize);
-	if (!buf)
-		return ret;
+	buf = kmalloc(root->nodesize, GFP_KERNEL | __GFP_NOWARN);
+	if (!buf) {
+		buf = vmalloc(root->nodesize);
+		if (!buf)
+			return ret;
+	}
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		vfree(buf);
+		kvfree(buf);
 		return ret;
 	}
 
@@ -3775,7 +3778,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 
 out:
 	btrfs_free_path(path);
-	vfree(buf);
+	kvfree(buf);
 	return ret;
 }
 
-- 
2.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
