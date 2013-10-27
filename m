Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49232 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3J0GE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 02:04:28 -0400
From: Cong Ding <dinggnu@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] btrfs: fix memory leakage
Date: Sat, 26 Oct 2013 23:04:05 -0700
Message-Id: <1382853846-1900-1-git-send-email-dinggnu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The memory allocated to "name" by function "extref_get_fields" isn't properly
freed when error occurs.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/btrfs/tree-log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79f057c..e75f3ed 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1169,8 +1169,10 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			 */
 			if (!dir)
 				dir = read_one_inode(root, parent_objectid);
-			if (!dir)
+			if (!dir) {
+				kfree(name);
 				return -ENOENT;
+			}
 		} else {
 			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
 					     &ref_index);
-- 
1.7.9.5

