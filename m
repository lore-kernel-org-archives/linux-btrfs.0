Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8765 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752480AbaLII1m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 03:27:42 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB98RJVU013470
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Dec 2014 16:27:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 05/13] btrfs-progs: Record highest inode number before repair.
Date: Tue, 9 Dec 2014 16:27:24 +0800
Message-ID: <1418113652-25088-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Record highest inode number before inode repair.

This is especially important for corrupted leaf case.
Under that case, if use btrfs_find_free_objectid, it may find a ino
existing in corrupted leaf but dropped by btree_recover.
If that happens, created dir will be referenced incorrectly since there
may be inode_ref or dir_index/item refers to it.

So we must record the highest inode number according to the inode_cache.
Inode_cache is OK since when a inode_ref or dir_index/item is found even
the referenced source is not found, it will be created.
If we record the highest inode number of inode_cache, and use
highest_inode + 1 as 'lost+found' dir, it will ensure the newly created
dir not conflicting with any possible inode.

This provides the basis for nlink or inode rebuild for repairing btrfs
with leaf/node corruption.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v4:
   Newly introduced.
---
 cmds-check.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 9fc1410..1f35cc2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1927,6 +1927,21 @@ static int check_inode_recs(struct btrfs_root *root,
 	}
 
 	/*
+	 * We need to record the highest inode number for later 'lost+found'
+	 * dir creation.
+	 * We must select a ino not used/refered by any existing inode, or
+	 * 'lost+found' ino may be a missing ino in a corrupted leaf,
+	 * this may cause 'lost+found' dir has wrong nlinks.
+	 */
+	cache = last_cache_extent(inode_cache);
+	if (cache) {
+		node = container_of(cache, struct ptr_node, cache);
+		rec = node->data;
+		if (rec->ino > root->highest_inode)
+			root->highest_inode = rec->ino;
+	}
+
+	/*
 	 * We need to repair backrefs first because we could change some of the
 	 * errors in the inode recs.
 	 *
-- 
2.1.3

