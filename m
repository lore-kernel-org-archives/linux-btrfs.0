Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59684 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3JLTdI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Oct 2013 15:33:08 -0400
Received: by mail-wi0-f181.google.com with SMTP id l12so2110344wiv.2
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Oct 2013 12:33:07 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't leak delayed node on path allocation failure
Date: Sat, 12 Oct 2013 20:32:59 +0100
Message-Id: <1381606379-11728-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the path allocation failed, we would return without decrementing
the reference count in the delayed node we got before, resulting
in a leak.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/delayed-inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index cbd9523..df1a496 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1174,8 +1174,10 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 	mutex_unlock(&delayed_node->mutex);
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		btrfs_release_delayed_node(delayed_node);
 		return -ENOMEM;
+	}
 	path->leave_spinning = 1;
 
 	block_rsv = trans->block_rsv;
-- 
1.7.9.5

