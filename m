Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:52714 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754466AbcJLINm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 04:13:42 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 4/5] Btrfs: incremental send, add gen check in did_overwrite_ref
Date: Wed, 12 Oct 2016 16:12:49 +0800
Message-Id: <1476259970-1866-5-git-send-email-robbieko@synology.com>
In-Reply-To: <1476259970-1866-1-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

There a some case similar as before.
add check parent generation in the did_overwrite_ref.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d908624..e090db2 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1939,6 +1939,19 @@ static int did_overwrite_ref(struct send_ctx *sctx,
 	if (ret <= 0)
 		goto out;
 
+	if (dir != BTRFS_FIRST_FREE_OBJECTID) {
+		ret = get_inode_info(sctx->send_root, dir, NULL, &gen, NULL,
+				     NULL, NULL, NULL);
+		if (ret < 0 && ret != -ENOENT)
+			goto out;
+		if (ret) {
+			ret = 0;
+			goto out;
+		}
+		if (gen != dir_gen)
+			goto out;
+	}
+
 	/* check if the ref was overwritten by another ref */
 	ret = lookup_dir_item_inode(sctx->send_root, dir, name, name_len,
 			&ow_inode, &other_type);
-- 
1.9.1

