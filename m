Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:58398 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbbFDL1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 07:27:54 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 3/5] Btrfs: incremental send, fix orphan_dir_info not completely cleared
Date: Thu,  4 Jun 2015 19:18:08 +0800
Message-Id: <1433416690-19177-4-git-send-email-robbieko@synology.com>
In-Reply-To: <1433416690-19177-1-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's one case where we not clear orphan_dir_info issue.

Example:

Parent snapshot:
|---- a/ (ino 279)
  |---- c (ino 282)
|---- del/ (ino 281)
  |---- tmp/ (ino 280)
  |---- long/ (ino 283)
  |---- longlong/ (ino 284)

Send snapshot:
|---- a/ (ino 279)
  |---- long (ino 283)
  |---- longlong (ino 284)
|---- c/ (ino 282)
  |---- tmp/ (ino 280)

Here we process 281 use can_rmdir check, but 280 is waiting, so create orphan_dir_info
and when 282 is move to dest, so 280 can move to c/tmp, and now run can_rmdir check again.
Return is false, because 283 and 284 is unprocess, but now not release orphan_dir_info.
When 283 and 284 is processd, 281 be delete, but not delete orphan_dir_info.
So fix this by release orphan_dir_info for this case.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 596b9dc..ff9d052 100644
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
@@ -2913,6 +2912,12 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 		}
 
 		if (loc.objectid > send_progress) {
+			struct orphan_dir_info *odi;
+
+			odi = get_orphan_dir_info(sctx, dir);
+			if (odi) {
+				free_orphan_dir_info(sctx, odi);
+			}
 			ret = 0;
 			goto out;
 		}
-- 
1.9.1

