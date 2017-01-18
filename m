Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42488 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750712AbdARF0g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 00:26:36 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B539B47B0CB2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 13:21:09 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: lowmem-check: Fix false alert on dropped leaf
Date: Wed, 18 Jan 2017 13:21:07 +0800
Message-ID: <20170118052107.7394-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs-progs test case 021-partially-dropped-snapshot-case, if the
first leaf is already dropped, btrfs check low-memory mode will report
false alert:

checking fs roots
checksum verify failed on 29917184 found E4E3BDB6 wanted 00000000
checksum verify failed on 29917184 found E4E3BDB6 wanted 00000000
checksum verify failed on 29917184 found E4E3BDB6 wanted 00000000
checksum verify failed on 29917184 found E4E3BDB6 wanted 00000000

This is caused by we are calling check_fs_first_inode() function,
unlike the rest part of check_fs_root_v2(), it doesn't have enough check
on dropping progress, and caused the false alert.

Fix it by checking dropping progress before searching slot.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1dba2985..25247fd9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4939,11 +4939,18 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 	int err = 0;
 	int ret;
 
-	btrfs_init_path(&path);
 	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
+	/* For root being dropped, we don't need to check first inode */
+	if (btrfs_root_refs(&root->root_item) == 0 &&
+	    btrfs_disk_key_objectid(&root->root_item.drop_progress) >=
+	    key.objectid)
+		return 0;
+
+	btrfs_init_path(&path);
+
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0)
 		goto out;
-- 
2.11.0



