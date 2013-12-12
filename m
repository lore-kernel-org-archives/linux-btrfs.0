Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:43670 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3LLTUp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 14:20:45 -0500
Received: by mail-we0-f182.google.com with SMTP id q59so936922wes.27
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Dec 2013 11:20:44 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: return immediately if tree log mod is not necessary
Date: Thu, 12 Dec 2013 19:19:52 +0000
Message-Id: <1386875993-427-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In ctree.c:tree_mod_log_set_node_key() we were calling
__tree_mod_log_insert_key() even when the modification doesn't need
to be logged. This would allocate a tree_mod_elem structure, fill it
and pass it to  __tree_mod_log_insert(), which would just acquire
the tree mod log write lock and then free the tree_mod_elem structure
and return (that is, a no-op).

Therefore call tree_mod_log_insert() instead of __tree_mod_log_insert()
which just returns immediately if the modification doesn't need to be
logged (without allocating the structure, fill it, acquire write lock,
free structure).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c811b9b..3b88d84 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -771,7 +771,7 @@ tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
 {
 	int ret;
 
-	ret = __tree_mod_log_insert_key(fs_info, eb, slot,
+	ret = tree_mod_log_insert_key(fs_info, eb, slot,
 					MOD_LOG_KEY_REPLACE,
 					atomic ? GFP_ATOMIC : GFP_NOFS);
 	BUG_ON(ret < 0);
-- 
1.7.9.5

