Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37795 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209Ab3DXUvQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 16:51:16 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C03A09A068E
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 14:51:15 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 1UqCrOV5qJXwmbZa (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 14:51:15 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't panic if we're trying to drop too many refs
Date: Wed, 24 Apr 2013 16:51:13 -0400
Message-ID: <1366836673-2100-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is just obnoxious.  Just print a message, abort the transaction, and return
an error.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 52b7e15..796c4ef 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5613,7 +5613,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	}
 
 	refs = btrfs_extent_refs(leaf, ei);
-	BUG_ON(refs < refs_to_drop);
+	if (refs < refs_to_drop) {
+		btrfs_err(info, "trying to drop %d refs but we only have %Lu "
+			  "for bytenr %Lu\n", refs_to_drop, refs, bytenr);
+		ret = -EINVAL;
+		btrfs_abort_transaction(trans, extent_root, ret);
+		goto out;
+	}
 	refs -= refs_to_drop;
 
 	if (refs > 0) {
-- 
1.7.7.6

