Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:54074 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab3A1OqJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 09:46:09 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id vuI0DXugW03VqoqB (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 07:46:08 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not merge logged extents if we've removed them from the tree
Date: Mon, 28 Jan 2013 09:52:56 -0500
Message-ID: <1359384776-2107-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You can run into this problem where if somebody is fsyncing and writing out
the existing extents you will have removed the extent map from the em tree,
but it's still valid for the current fsync so we go ahead and write it.  The
problem is we unconditionally try to merge it back into the em tree, but if
we've removed it from the em tree that will cause problems.  So fix this by
only trying to merge it in if it is still a part of the tree.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_map.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index ed88f5e..9759911 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -289,7 +289,8 @@ out:
 void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em)
 {
 	clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
-	try_merge_map(tree, em);
+	if (em->in_tree)
+		try_merge_map(tree, em);
 }
 
 /**
-- 
1.7.7.6

