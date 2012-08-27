Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:25365 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab2H0Qxz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 12:53:55 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH 1/2] Btrfs: cleanup extents after we finish logging inode
Date: Tue, 28 Aug 2012 00:52:19 +0800
Message-Id: <1346086340-14776-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is based on Josef's "Btrfs: turbo charge fsync".

We should cleanup those extents after we've finished logging inode,
otherwise we may do redundant work on them.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-log.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5190cd6..e7365d7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3167,6 +3167,12 @@ next_slot:
 			err = ret;
 			goto out_unlock;
 		}
+	} else {
+		struct extent_map_tree *tree = &BTRFS_I(inode)->extent_tree;
+		struct extent_map *em, *n;
+
+		list_for_each_entry_safe(em, n, &tree->modified_extents, list)
+			list_del_init(&em->list);
 	}
 
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-- 
1.7.7.6

