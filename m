Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:36935 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964918AbcJ1Bl1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 21:41:27 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 1/6] Btrfs: incremental send, do not skip generation inconsistency check for inode 256.
Date: Fri, 28 Oct 2016 09:40:45 +0800
Message-Id: <1477618850-12922-2-git-send-email-robbieko@synology.com>
In-Reply-To: <1477618850-12922-1-git-send-email-robbieko@synology.com>
References: <1477618850-12922-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Example scenario:
Parent snapshot:
|.                (ino 256, gen 5)
|---- a1/         (ino 257, gen 5)
|---- a2/         (ino 258, gen 5)

Send snapshot:
|.                (ino 256, gen 7)
|---- a2          (ino 257, gen 7)

rmdir a1
mkfile o257-7-0
rename o257-7-0 -> a2
ERROR: rename o257-7-0 -> a2 failed: Is a directory

While computing the send stream the following steps happen:

1) delete a1;

2) mkfile o257-7-0;

3) rename o257-7-0->a2;

In step 3 we will check whether it will lead to overwrite.

The generation number of inode 257's parent (ino 256) in send snapshot
is 7, which is inconsistent with the one in parent snapshot (gen 5).
For the general parent directory except inode 256, if its generation
is not identical between parent and send snapshot, it will be removed
then created. Thus it's not possible to happen overwrite under the new
directory. However for the special inode 256, the above logic does not
work since it is a subvolume. So overwrite check is required for the
inode 256.
Fix by skipping generation inconsistency check for inode 256.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a87675f..2060e75 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1681,6 +1681,9 @@ static int is_inode_existent(struct send_ctx *sctx, u64 ino, u64 gen)
 {
 	int ret;
 
+	if (ino == BTRFS_FIRST_FREE_OBJECTID)
+		return 1;
+
 	ret = get_cur_inode_state(sctx, ino, gen);
 	if (ret < 0)
 		goto out;
@@ -1866,7 +1869,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
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

