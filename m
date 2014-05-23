Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63859 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEWSPY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 14:15:24 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so1315186wiw.2
        for <linux-btrfs@vger.kernel.org>; Fri, 23 May 2014 11:15:23 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: send, use the right limits for xattr names and values
Date: Fri, 23 May 2014 20:15:16 +0100
Message-Id: <1400872516-7664-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were limiting the sum of the xattr name and value lengths to PATH_MAX,
which is not correct, specially on filesystems created with btrfs-progs
v3.12 or higher, where the default leaf size is max(16384, PAGE_SIZE), or
systems with page sizes larger than 4096 bytes.

Xattrs have their own specific maximum name and value lengths, which depend
on the leaf size, therefore use these limits to be able to send xattrs with
sizes larger than PATH_MAX.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 70c5e8c..1a65a40 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -995,7 +995,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 	struct btrfs_dir_item *di;
 	struct btrfs_key di_key;
 	char *buf = NULL;
-	const int buf_len = PATH_MAX;
+	int buf_len;
 	u32 name_len;
 	u32 data_len;
 	u32 cur;
@@ -1005,6 +1005,11 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 	int num;
 	u8 type;
 
+	if (found_key->type == BTRFS_XATTR_ITEM_KEY)
+		buf_len = BTRFS_MAX_XATTR_SIZE(root);
+	else
+		buf_len = PATH_MAX;
+
 	buf = kmalloc(buf_len, GFP_NOFS);
 	if (!buf) {
 		ret = -ENOMEM;
@@ -1026,12 +1031,23 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 		type = btrfs_dir_type(eb, di);
 		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
 
-		/*
-		 * Path too long
-		 */
-		if (name_len + data_len > buf_len) {
-			ret = -ENAMETOOLONG;
-			goto out;
+		if (type == BTRFS_FT_XATTR) {
+			if (name_len > XATTR_NAME_MAX) {
+				ret = -ENAMETOOLONG;
+				goto out;
+			}
+			if (name_len + data_len > buf_len) {
+				ret = -E2BIG;
+				goto out;
+			}
+		} else {
+			/*
+			 * Path too long
+			 */
+			if (name_len + data_len > buf_len) {
+				ret = -ENAMETOOLONG;
+				goto out;
+			}
 		}
 
 		read_extent_buffer(eb, buf, (unsigned long)(di + 1),
-- 
1.9.1

