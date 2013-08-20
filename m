Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49334 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3HTQwI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 12:52:08 -0400
Received: by mail-wg0-f53.google.com with SMTP id c11so602240wgh.8
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 09:52:06 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix printing of non NULL terminated string
Date: Tue, 20 Aug 2013 17:51:48 +0100
Message-Id: <1377017508-9355-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The name buffer is not terminated by a '\0' character,
therefore it needs to be printed with %.*s and use the
length of the buffer.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/delayed-inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index fa88297..c0c3a6b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1471,10 +1471,10 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&delayed_node->mutex);
 	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "err add delayed dir index item(name: %s) into "
-				"the insertion tree of the delayed node"
+		printk(KERN_ERR "err add delayed dir index item (name: %.*s) "
+				"into the insertion tree of the delayed node "
 				"(root id: %llu, inode id: %llu, errno: %d)\n",
-				name,
+		                name_len, name,
 				(unsigned long long)delayed_node->root->objectid,
 				(unsigned long long)delayed_node->inode_id,
 				ret);
-- 
1.7.9.5

