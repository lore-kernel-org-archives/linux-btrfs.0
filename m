Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54119 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3JGUUw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 16:20:52 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so2601064wes.28
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 13:20:51 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: remove unnecessary key copy when logging inode
Date: Mon,  7 Oct 2013 21:20:44 +0100
Message-Id: <1381177244-8613-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs_insert_empty_item() function doesn't modify its
key argument.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/tree-log.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 964c583..2a1f690 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3167,11 +3167,10 @@ static int log_inode_item(struct btrfs_trans_handle *trans,
 			  struct inode *inode)
 {
 	struct btrfs_inode_item *inode_item;
-	struct btrfs_key key;
 	int ret;
 
-	memcpy(&key, &BTRFS_I(inode)->location, sizeof(key));
-	ret = btrfs_insert_empty_item(trans, log, path, &key,
+	ret = btrfs_insert_empty_item(trans, log, path,
+				      &BTRFS_I(inode)->location,
 				      sizeof(*inode_item));
 	if (ret && ret != -EEXIST)
 		return ret;
-- 
1.7.9.5

