Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54529 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab3JNVtT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 17:49:19 -0400
Received: by mail-wi0-f179.google.com with SMTP id hm4so2454949wib.12
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 14:49:18 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: optimize tree-log.c:count_inode_refs()
Date: Mon, 14 Oct 2013 22:49:11 +0100
Message-Id: <1381787351-15451-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Avoid repeated tree searches by processing all inode ref items in
a leaf at once instead of processing one at a time, followed by a
path release and a tree search for a key with a decremented offset.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/tree-log.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 849b729..7b077a8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1307,6 +1307,7 @@ static int count_inode_refs(struct btrfs_root *root,
 				break;
 			path->slots[0]--;
 		}
+process_slot:
 		btrfs_item_key_to_cpu(path->nodes[0], &key,
 				      path->slots[0]);
 		if (key.objectid != ino ||
@@ -1327,6 +1328,10 @@ static int count_inode_refs(struct btrfs_root *root,
 
 		if (key.offset == 0)
 			break;
+		if (path->slots[0] > 0) {
+			path->slots[0]--;
+			goto process_slot;
+		}
 		key.offset--;
 		btrfs_release_path(path);
 	}
-- 
1.7.9.5

