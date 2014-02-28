Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:13485 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752684AbaB1R1K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 12:27:10 -0500
Date: Fri, 28 Feb 2014 19:27:06 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: free path if we don't find root item
Message-ID: <20140228172705.GA3536@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_find_last_root before returning with -ENOENT (if root item is
not found) free path and also remove btrfs_release_path before
btrfs_free_path because btrfs_free_path anyway calls it.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 root-tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/root-tree.c b/root-tree.c
index 858fe2f..f16f0ba 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -40,8 +40,10 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	if (path->slots[0] == 0)
+	if (path->slots[0] == 0) {
+		btrfs_free_path(path);
 		return -ENOENT;
+	}
 
 	BUG_ON(ret == 0);
 	l = path->nodes[0];
@@ -56,7 +58,6 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 	memcpy(key, &found_key, sizeof(found_key));
 	ret = 0;
 out:
-	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -120,7 +121,6 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	write_extent_buffer(l, item, ptr, sizeof(*item));
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 out:
-	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.8.5.3

