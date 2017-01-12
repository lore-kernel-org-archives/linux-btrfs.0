Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35268 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdALOBW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:22 -0500
Received: by mail-qk0-f196.google.com with SMTP id u25so2786930qki.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:21 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 24/24] btrfs: Make count_inode_refs take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:50 +0200
Message-Id: <1484229650-24554-25-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0c5eb664640f..162223404eca 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1401,7 +1401,7 @@ static int count_inode_extrefs(struct btrfs_root *root,
 }
 
 static int count_inode_refs(struct btrfs_root *root,
-			       struct inode *inode, struct btrfs_path *path)
+			       struct btrfs_inode *inode, struct btrfs_path *path)
 {
 	int ret;
 	struct btrfs_key key;
@@ -1409,7 +1409,7 @@ static int count_inode_refs(struct btrfs_root *root,
 	unsigned long ptr;
 	unsigned long ptr_end;
 	int name_len;
-	u64 ino = btrfs_ino(BTRFS_I(inode));
+	u64 ino = btrfs_ino(inode);
 
 	key.objectid = ino;
 	key.type = BTRFS_INODE_REF_KEY;
@@ -1480,7 +1480,7 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = count_inode_refs(root, inode, path);
+	ret = count_inode_refs(root, BTRFS_I(inode), path);
 	if (ret < 0)
 		goto out;
 
-- 
2.7.4

