Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36386 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdAQWiv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:38:51 -0500
Received: by mail-wm0-f66.google.com with SMTP id r126so41988930wmr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:38:50 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 23/24] btrfs: Make count_inode_extrefs take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:49 +0200
Message-Id: <1484692310-3987-24-git-send-email-n.borisov.lkml@gmail.com>
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
index 8c110d0e16c3..47e4f3610348 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1358,14 +1358,14 @@ static int insert_orphan_item(struct btrfs_trans_handle *trans,
 }
 
 static int count_inode_extrefs(struct btrfs_root *root,
-			       struct inode *inode, struct btrfs_path *path)
+			       struct btrfs_inode *inode, struct btrfs_path *path)
 {
 	int ret = 0;
 	int name_len;
 	unsigned int nlink = 0;
 	u32 item_size;
 	u32 cur_offset = 0;
-	u64 inode_objectid = btrfs_ino(BTRFS_I(inode));
+	u64 inode_objectid = btrfs_ino(inode);
 	u64 offset = 0;
 	unsigned long ptr;
 	struct btrfs_inode_extref *extref;
@@ -1487,7 +1487,7 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 
 	nlink = ret;
 
-	ret = count_inode_extrefs(root, inode, path);
+	ret = count_inode_extrefs(root, BTRFS_I(inode), path);
 	if (ret < 0)
 		goto out;
 
-- 
2.7.4

