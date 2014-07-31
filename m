Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58026 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaGaKyc (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 31 Jul 2014 06:54:32 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: return path with unlocked nodes in btrfs_next_leaf
Date: Thu, 31 Jul 2014 12:53:39 +0100
Message-Id: <1406807619-20859-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Calling unlock_up() to release our new path doesn't release the
read lock on the node at level 1, because our return path has
path->slots[0] == 0, which makes unlock_up() skip unlocking that
node. Since we don't need to return that node locked, call
btrfs_unlock_up_safe() instead of unlock_up(), which will release
all nodes in the path (except the leaf of course).
For any level N >= 2, the corresponding node lock isn't released by
unlock_up() too if path->slots[N - 1] == 0.

Releasing the read lock immediately will allow concurrent writers
to write lock that node at level 1 (or higher levels if applicable)
while the btrfs_next_leaf() caller processes the leaf.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 783ea3b..8ca6761 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5833,7 +5833,7 @@ again:
 	}
 	ret = 0;
 done:
-	unlock_up(path, 0, 1, 0, NULL);
+	btrfs_unlock_up_safe(path, 1);
 	path->leave_spinning = old_spinning;
 	if (!old_spinning)
 		btrfs_set_path_blocking(path);
-- 
1.9.1

