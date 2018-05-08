Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:43337 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754341AbeEHKLx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 06:11:53 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 1/2] btrfs: incremental send, optimization add orphan_dir_info
Date: Tue,  8 May 2018 18:11:37 +0800
Message-Id: <1525774298-6919-2-git-send-email-robbieko@synology.com>
In-Reply-To: <1525774298-6919-1-git-send-email-robbieko@synology.com>
References: <1525774298-6919-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

moving the allocation to the end in order to avoid unnecessary
allocations

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 484e2af..2830871 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2855,12 +2855,6 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
 	struct rb_node *parent = NULL;
 	struct orphan_dir_info *entry, *odi;
 
-	odi = kmalloc(sizeof(*odi), GFP_KERNEL);
-	if (!odi)
-		return ERR_PTR(-ENOMEM);
-	odi->ino = dir_ino;
-	odi->gen = 0;
-
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct orphan_dir_info, node);
@@ -2869,11 +2863,16 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
 		} else if (dir_ino > entry->ino) {
 			p = &(*p)->rb_right;
 		} else {
-			kfree(odi);
 			return entry;
 		}
 	}
 
+	odi = kmalloc(sizeof(*odi), GFP_KERNEL);
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

