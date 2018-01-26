Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752385AbeAZIax (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:53 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 7D0A549F19B8
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:46 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 03/15] btrfs-progs: lowmem check: find filetype in repair_inode_missing()
Date: Fri, 26 Jan 2018 16:35:07 +0800
Message-ID: <20180126083519.28373-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If parameter @filetype is 0, repair_inode_missing will find filetype
automatically.

And let it return -EEXIST instead of 0 if inode item is existed.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index b200fdccf0e5..08a2662e603c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5161,6 +5161,9 @@ out:
 /*
  * Insert the missing inode item.
  *
+ * @filetype: if 0, find file type automatically.
+ *                  if find nothing, set inode as regular file.
+ *
  * Returns 0 means success.
  * Returns <0 means error.
  */
@@ -5176,6 +5179,19 @@ static int repair_inode_item_missing(struct btrfs_root *root, u64 ino,
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
+	if (!filetype) {
+		ret = find_file_type_lowmem(root, ino, &filetype);
+		if (ret) {
+			ret = guess_file_type_lowmem(root, ino, &filetype);
+			if (ret) {
+				filetype = BTRFS_FT_REG_FILE;
+				error(
+		"can't get file type for inode %llu, using FILE as fallback",
+				      ino);
+			}
+		}
+	}
+
 	btrfs_init_path(&path);
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
@@ -5184,7 +5200,9 @@ static int repair_inode_item_missing(struct btrfs_root *root, u64 ino,
 	}
 
 	ret = btrfs_search_slot(trans, root, &key, &path, 1, 1);
-	if (ret < 0 || !ret)
+	if (!ret)
+		ret = -EEXIST;
+	if (ret < 0)
 		goto fail;
 
 	/* insert inode item */
-- 
2.16.1



