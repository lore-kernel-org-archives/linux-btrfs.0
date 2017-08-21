Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:62563 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753049AbdHUMiX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 08:38:23 -0400
Subject: [PATCH 1/5] btrfs: Use common error handling code in
 tree_mod_log_eb_copy()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Message-ID: <2aa6dff0-92e4-d5da-30fe-69f6c81fc6d7@users.sourceforge.net>
Date: Mon, 21 Aug 2017 14:37:40 +0200
MIME-Version: 1.0
In-Reply-To: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 21 Aug 2017 09:36:48 +0200

Add a jump target so that a bit of exception handling can be better reused
in this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/ctree.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d49db7d86be..d29cf946ebf9 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -823,17 +823,13 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	for (i = 0; i < nr_items; i++) {
 		tm_list_rem[i] = alloc_tree_mod_elem(src, i + src_offset,
 		    MOD_LOG_KEY_REMOVE, GFP_NOFS);
-		if (!tm_list_rem[i]) {
-			ret = -ENOMEM;
-			goto free_tms;
-		}
+		if (!tm_list_rem[i])
+			goto e_nomem;
 
 		tm_list_add[i] = alloc_tree_mod_elem(dst, i + dst_offset,
 		    MOD_LOG_KEY_ADD, GFP_NOFS);
-		if (!tm_list_add[i]) {
-			ret = -ENOMEM;
-			goto free_tms;
-		}
+		if (!tm_list_add[i])
+			goto e_nomem;
 	}
 
 	if (tree_mod_dont_log(fs_info, NULL))
@@ -854,6 +850,8 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 
 	return 0;
 
+e_nomem:
+	ret = -ENOMEM;
 free_tms:
 	for (i = 0; i < nr_items * 2; i++) {
 		if (tm_list[i] && !RB_EMPTY_NODE(&tm_list[i]->node))
-- 
2.14.0

