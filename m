Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33799 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdAQWls (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:48 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so9436135wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:41:47 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 24/24] btrfs: Make count_inode_refs take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:50 +0200
Message-Id: <1484692310-3987-25-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 47e4f3610348..a16da4a3ab63 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1402,7 +1402,7 @@ static int count_inode_extrefs(struct btrfs_root *root,
 }
 
 static int count_inode_refs(struct btrfs_root *root,
-			       struct inode *inode, struct btrfs_path *path)
+			       struct btrfs_inode *inode, struct btrfs_path *path)
 {
 	int ret;
 	struct btrfs_key key;
@@ -1410,7 +1410,7 @@ static int count_inode_refs(struct btrfs_root *root,
 	unsigned long ptr;
 	unsigned long ptr_end;
 	int name_len;
-	u64 ino = btrfs_ino(BTRFS_I(inode));
+	u64 ino = btrfs_ino(inode);
 
 	key.objectid = ino;
 	key.type = BTRFS_INODE_REF_KEY;
@@ -1481,7 +1481,7 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = count_inode_refs(root, inode, path);
+	ret = count_inode_refs(root, BTRFS_I(inode), path);
 	if (ret < 0)
 		goto out;
 
-- 
2.7.4

