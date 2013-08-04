Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54366 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3HDS7N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Aug 2013 14:59:13 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so1794050wgg.28
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 11:59:12 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix inode leak on kmalloc failure in tree-log.c
Date: Sun,  4 Aug 2013 19:58:57 +0100
Message-Id: <1375642737-18448-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In tree-log.c:replay_one_name(), if memory allocation for
the name fails, ensure we iput the dir inode we got before
before we return.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/tree-log.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ff60d89..6797a93 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1536,8 +1536,10 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 
 	name_len = btrfs_dir_name_len(eb, di);
 	name = kmalloc(name_len, GFP_NOFS);
-	if (!name)
-		return -ENOMEM;
+	if (!name) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	log_type = btrfs_dir_type(eb, di);
 	read_extent_buffer(eb, name, (unsigned long)(di + 1),
-- 
1.7.9.5

