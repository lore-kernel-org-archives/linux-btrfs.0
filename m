Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:51859 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754363AbcJLINW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 04:13:22 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 1/5] Btrfs: incremental send, fix don't skip root inode in overwrite_ref
Date: Wed, 12 Oct 2016 16:12:46 +0800
Message-Id: <1476259970-1866-2-git-send-email-robbieko@synology.com>
In-Reply-To: <1476259970-1866-1-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

When root dir item change, don't skip will_overwrite_ref,
because root inode always exist.

Example:
Parent snapshot:
|---- a1/ (ino 257, dir)
|---- a2/ (ino 258, dir)

Send snapshot:
|---- a2 (ino 257, file)

ERROR: rename o257-29-0 -> a2 failed: Is a directory

when process 257, first rmdir (ino 257,dir), and then mkfile o257-29-0,
and rename o257-29-0 -> a2, but now parent snapshot had a2(ino 258,dir),
we don't ignore it.

therefore is_inode_existent always return 1,
and will_overwrite_ref don't check gen for root inode.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a87675f..1862f8a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1681,6 +1681,10 @@ static int is_inode_existent(struct send_ctx *sctx, u64 ino, u64 gen)
 {
 	int ret;
 
+	if (ino == BTRFS_FIRST_FREE_OBJECTID) {
+		return 1;
+	}
+
 	ret = get_cur_inode_state(sctx, ino, gen);
 	if (ret < 0)
 		goto out;
@@ -1866,7 +1870,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	 * not deleted and then re-created, if it was then we have no overwrite
 	 * and we can just unlink this entry.
 	 */
-	if (sctx->parent_root) {
+	if (sctx->parent_root && dir != BTRFS_FIRST_FREE_OBJECTID) {
 		ret = get_inode_info(sctx->parent_root, dir, NULL, &gen, NULL,
 				     NULL, NULL, NULL);
 		if (ret < 0 && ret != -ENOENT)
-- 
1.9.1

