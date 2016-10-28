Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:37742 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964894AbcJ1Blo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 21:41:44 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 5/6] Btrfs: incremental send, add generation check for inode is waiting for move.
Date: Fri, 28 Oct 2016 09:40:49 +0800
Message-Id: <1477618850-12922-6-git-send-email-robbieko@synology.com>
In-Reply-To: <1477618850-12922-1-git-send-email-robbieko@synology.com>
References: <1477618850-12922-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Example scenario:
Parent snapshot:
|---- d1/              (ino 257, gen 44)
|---- d4/              (ino 258, gen 44)
|---- d3/              (ino 259, gen 44)

Send snapshot:
|---- d1/              (ino 258, gen 47)
|---- d4/              (ino 260, gen 47)
    |---- d3/          (ino 259, gen 47)
        |---- d1/          (ino 257, gen 47)

rmdir d1
mkdir o257-47-0
mkdir o259-47-0
chown o257-47-0 - uid=0, gid=0
chmod o257-47-0 - mode=0755
rmdir d4
mkdir o258-47-0
rename d1 -> o257-44-0
ERROR: rename d1 -> o257-44-0 failed: No such file or directory

While computing the send stream the following steps happen:

1) While processing inode 257 we remove the d1 (ino 257, gen 44),
   create o257-47-0 and o259-47-0, and delay o257-47-0 rename operation
   because its new parent in the send snapshot, inode 259, was not yet
   processed and therefore not yet renamed;

2) Later when processing on inode 258, after we create o258-47-0 before
   rename it to d1, we need to check whether it will overwrite others.
   It shows it will overwrite to d1 (inode 257, gen 44) so needs to
   rename d1 (inode 257, gen 44) to unique name. But it was previously
   removed, which leads to rename failed. The reason why we thought
   d1 (inode 257, gen 44) would be overwirtten is inode 257 with diffent
   generation 47 is waiting for move, then we are mislead they are the
   same since we miss the generation check for them.

Fix this by adding generation check for the inode if it is waiting for
move.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 139f492..81a2bee 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1857,6 +1857,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	u64 gen;
 	u64 other_inode = 0;
 	u8 other_type = 0;
+	struct waiting_dir_move *dm = NULL;
 
 	if (!sctx->parent_root)
 		goto out;
@@ -1898,11 +1899,15 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
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

