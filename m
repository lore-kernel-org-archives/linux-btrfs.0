Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:4097 "EHLO mail.synology.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784AbbFVJJC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 05:09:02 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 7/7] Btrfs: incremental send, avoid the overhead of allocating an orphan_dir_info object unnecessarily
Date: Mon, 22 Jun 2015 17:08:48 +0800
Message-Id: <1434964128-31757-8-git-send-email-robbieko@synology.com>
In-Reply-To: <1434964128-31757-1-git-send-email-robbieko@synology.com>
References: <1434964128-31757-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Avoid the overhead of allocating an orphan_dir_info object unnecessarily.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 579a4c8..9c60421 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2785,12 +2785,6 @@ add_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
 	struct rb_node *parent = NULL;
 	struct orphan_dir_info *entry, *odi;
 
-	odi = kmalloc(sizeof(*odi), GFP_NOFS);
-	if (!odi)
-		return ERR_PTR(-ENOMEM);
-	odi->ino = dir_ino;
-	odi->gen = 0;
-
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct orphan_dir_info, node);
@@ -2799,11 +2793,16 @@ add_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
 		} else if (dir_ino > entry->ino) {
 			p = &(*p)->rb_right;
 		} else {
-			kfree(odi);
 			return entry;
 		}
 	}
 
+	odi = kmalloc(sizeof(*odi), GFP_NOFS);
+	if (!odi)
+		return ERR_PTR(-ENOMEM);
+	odi->ino = dir_ino;
+	odi->gen = 0;
+
 	rb_link_node(&odi->node, parent, p);
 	rb_insert_color(&odi->node, &sctx->orphan_dirs);
 	return odi;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
