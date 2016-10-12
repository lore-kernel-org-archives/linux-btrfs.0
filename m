Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:52123 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754466AbcJLIN3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 04:13:29 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 5/5] Btrfs: incremental send, add gen check if has waiting_dir_move in the will_overwrite_ref
Date: Wed, 12 Oct 2016 16:12:50 +0800
Message-Id: <1476259970-1866-6-git-send-email-robbieko@synology.com>
In-Reply-To: <1476259970-1866-1-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

There a some case similar as before.
add check generation if has waiting_dir_move in the will_overwrite_ref

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e090db2..92b7518 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1858,6 +1858,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	u64 gen;
 	u64 other_inode = 0;
 	u8 other_type = 0;
+	struct waiting_dir_move *dm = NULL;
 
 	if (!sctx->parent_root)
 		goto out;
@@ -1899,11 +1900,15 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	 * overwrite anything at this point in time.
 	 */
 	if (other_inode > sctx->send_progress ||
-	    is_waiting_for_move(sctx, other_inode)) {
+		((dm = get_waiting_dir_move(sctx, other_inode)) != NULL)) {
 		ret = get_inode_info(sctx->parent_root, other_inode, NULL,
 				who_gen, NULL, NULL, NULL, NULL);
 		if (ret < 0)
 			goto out;
+		if (dm && dm->gen != *who_gen) {
+			ret = 0;
+			goto out;
+		}
 
 		ret = 1;
 		*who_ino = other_inode;
-- 
1.9.1

