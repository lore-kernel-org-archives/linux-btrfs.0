Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39208 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932125AbcJXCn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Oct 2016 22:43:56 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 2/4] btrfs-progs: fsck: Fix patch allocation check and leak in check_fs_first_inode
Date: Mon, 24 Oct 2016 10:43:33 +0800
Message-Id: <20161024024335.6770-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
References: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allocated 'path' in check_fs_first_inode() is not checked and for
btrfs_search_slot() error, it will leak 'path'.

Fix it.

Reported-by: David Sterba <dsterba@suse.cz>
Resolves-Coverity-CID: 1374098
Resolves-Coverity-CID: 1374099
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index a92901d..91ed8b4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4963,13 +4963,15 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 	int ret;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	key.objectid = 256;
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
-		return ret;
+		goto out;
 	if (ret > 0) {
 		ret = 0;
 		err |= INODE_ITEM_MISSING;
@@ -4979,6 +4981,7 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 	err &= ~LAST_ITEM;
 	if (err && !ret)
 		ret = -EIO;
+out:
 	btrfs_free_path(path);
 	return ret;
 }
-- 
2.10.1



