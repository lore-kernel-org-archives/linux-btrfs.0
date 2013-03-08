Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57957 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3CHUfW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2013 15:35:22 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8E9189A0407
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Mar 2013 13:35:20 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id DgaUOC76UN0REZ5a (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 08 Mar 2013 13:35:20 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: return EIO if we have extent tree corruption
Date: Fri, 8 Mar 2013 15:42:31 -0500
Message-ID: <1362775351-2620-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The callers of lookup_inline_extent_info all handle getting an error back
properly, so return an error if we have corruption instead of being a jerk and
panicing.  Still WARN_ON() since this is kind of crucial and I've been seeing it
a bit too much recently for my taste, I think we're doing something wrong
somewhere.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dd23e8e..742b7a7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1538,8 +1538,11 @@ again:
 	if (ret && !insert) {
 		err = -ENOENT;
 		goto out;
+	} else if (ret) {
+		err = -EIO;
+		WARN_ON(1);
+		goto out;
 	}
-	BUG_ON(ret); /* Corruption */
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-- 
1.7.7.6

