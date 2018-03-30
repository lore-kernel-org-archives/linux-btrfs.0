Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:36606 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752288AbeC3WMS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 18:12:18 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix NULL pointer dereference in log_dir_items
Date: Sat, 31 Mar 2018 06:11:57 +0800
Message-Id: <1522447918-19147-3-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

0, 1 and <0 can be returned by btrfs_next_leaf(), and when <0 is
returned, path->nodes[0] could be NULL, log_dir_items lacks such a
check for <0 and we may run into a null pointer dereference panic.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/tree-log.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4344577..4ee9431 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3518,8 +3518,11 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 		 * from this directory and from this transaction
 		 */
 		ret = btrfs_next_leaf(root, path);
-		if (ret == 1) {
-			last_offset = (u64)-1;
+		if (ret) {
+			if (ret == 1)
+				last_offset = (u64)-1;
+			else
+				err = ret;
 			goto done;
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &tmp, path->slots[0]);
-- 
1.8.3.1

