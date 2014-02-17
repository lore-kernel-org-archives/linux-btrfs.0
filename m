Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45122 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBQDtU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 22:49:20 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so14390840pde.0
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 19:49:20 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, sachin.kamat@linaro.org
Subject: [PATCH Resend] btrfs: Use PTR_ERR_OR_ZERO
Date: Mon, 17 Feb 2014 09:13:57 +0530
Message-Id: <1392608637-24756-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

PTR_RET is deprecated. Use PTR_ERR_OR_ZERO instead. While at it
also include missing err.h header.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 fs/btrfs/root-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 1389b69059de..38bb47e7d6b1 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/err.h>
 #include <linux/uuid.h>
 #include "ctree.h"
 #include "transaction.h"
@@ -271,7 +272,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 		key.offset++;
 
 		root = btrfs_read_fs_root(tree_root, &root_key);
-		err = PTR_RET(root);
+		err = PTR_ERR_OR_ZERO(root);
 		if (err && err != -ENOENT) {
 			break;
 		} else if (err == -ENOENT) {
-- 
1.7.9.5

