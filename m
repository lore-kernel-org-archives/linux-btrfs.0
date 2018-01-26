Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2977 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752203AbeAZIbA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:31:00 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 30B4E49F19B8
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:52 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 13/15] btrfs-progs: check: find inode filetype in create_inode_item()
Date: Fri, 26 Jan 2018 16:35:17 +0800
Message-ID: <20180126083519.28373-14-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, find_file_type() doesn't return 0 if mismatched filetype is in a
backref.

Let create_inode_item() first call find_file_type() to get filetype.
If it failed, then guess filetype.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a83f0a92f48b..6091c7ef3442 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3140,6 +3140,8 @@ static int create_inode_item_lowmem(struct btrfs_trans_handle *trans,
 	return __create_inode_item(trans, root, ino, 0, 0, 0, mode);
 }
 
+static u32 btrfs_type_to_imode(u8 type);
+static int find_file_type(struct inode_record *rec, u8 *type);
 static int create_inode_item(struct btrfs_root *root,
 			     struct inode_record *rec, int root_dir)
 {
@@ -3148,14 +3150,19 @@ static int create_inode_item(struct btrfs_root *root,
 	u32 mode = 0;
 	u64 size = 0;
 	int ret;
+	u8 type = 0;
 
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		return ret;
+	nlink = root_dir ? 1 : rec->found_link;
+	ret = find_file_type(rec, &type);
+	if (!ret) {
+		mode = btrfs_type_to_imode(type) | 0755;
+		if (type == BTRFS_FT_REG_FILE)
+			size = rec->found_size;
+		else
+			size = rec->extent_end;
+		goto create_inode;
 	}
 
-	nlink = root_dir ? 1 : rec->found_link;
 	if (rec->found_dir_item) {
 		if (rec->found_file_extent)
 			fprintf(stderr, "root %llu inode %llu has both a dir "
@@ -3167,7 +3174,14 @@ static int create_inode_item(struct btrfs_root *root,
 		size = rec->found_size;
 	} else if (!rec->found_dir_item) {
 		size = rec->extent_end;
-		mode =  S_IFREG | 0755;
+		mode = S_IFREG | 0755;
+	}
+
+create_inode:
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		return ret;
 	}
 
 	ret = __create_inode_item(trans, root, rec->ino, size, rec->nbytes,
@@ -3307,7 +3321,8 @@ static int find_file_type(struct inode_record *rec, u8 *type)
 	}
 
 	list_for_each_entry(backref, &rec->backrefs, list) {
-		if (backref->found_dir_index || backref->found_dir_item) {
+		if ((backref->found_dir_index || backref->found_dir_item) &&
+		    (!(backref->errors & REF_ERR_FILETYPE_UNMATCH))) {
 			*type = backref->filetype;
 			return 0;
 		}
-- 
2.16.1



