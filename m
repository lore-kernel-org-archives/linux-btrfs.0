Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:55831 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdIOSSk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 14:18:40 -0400
Received: by mail-pf0-f171.google.com with SMTP id r71so1828131pfe.12
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 11:18:40 -0700 (PDT)
From: Yingyi Luo <yingyil@google.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: drosen@google.com, yingyi.luo@eecs.northwestern.edu,
        yingyil <yingyil@google.com>
Subject: [PATCH 2/4 v3] btrfs-progs: add a parameter to btrfs_mksubvol
Date: Fri, 15 Sep 2017 11:17:31 -0700
Message-Id: <20170915181731.17910-1-yingyil@google.com>
In-Reply-To: <20170830172450.27460-3-yingyil@google.com>
References: <20170830172450.27460-3-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: yingyil <yingyil@google.com>

A convert parameter is added as a flag to indicate if btrfs_mksubvol()
is used for btrfs-convert. The change cascades down to the callchain.

Signed-off-by: yingyil <yingyil@google.com>
---
v3: changed the convert flag from int type to bool type.

 convert/main.c |  2 +-
 ctree.h        |  4 +++-
 inode.c        | 26 ++++++++++++++++----------
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 0babf0e8..882daf7c 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1197,7 +1197,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 	}
 
 	image_root = btrfs_mksubvol(root, subvol_name,
-				    CONV_IMAGE_SUBVOL_OBJECTID);
+				    CONV_IMAGE_SUBVOL_OBJECTID, true);
 	if (!image_root) {
 		error("unable to link subvolume %s", subvol_name);
 		goto fail;
diff --git a/ctree.h b/ctree.h
index 22313576..ae25eed5 100644
--- a/ctree.h
+++ b/ctree.h
@@ -19,6 +19,8 @@
 #ifndef __BTRFS_CTREE_H__
 #define __BTRFS_CTREE_H__
 
+#include <stdbool.h>
+
 #if BTRFS_FLAT_INCLUDES
 #include "list.h"
 #include "kerncompat.h"
@@ -2751,7 +2753,7 @@ int btrfs_add_orphan_item(struct btrfs_trans_handle *trans,
 int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		char *name, int namelen, u64 parent_ino, u64 *ino, int mode);
 struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root, const char *base,
-				  u64 root_objectid);
+				  u64 root_objectid, bool convert);
 
 /* file.c */
 int btrfs_get_extent(struct btrfs_trans_handle *trans,
diff --git a/inode.c b/inode.c
index 5dd816bf..ea812ce8 100644
--- a/inode.c
+++ b/inode.c
@@ -573,7 +573,8 @@ out:
 }
 
 struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
-				  const char *base, u64 root_objectid)
+				  const char *base, u64 root_objectid,
+				  bool convert)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -639,16 +640,21 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 	key.type = BTRFS_ROOT_ITEM_KEY;
 
 	memcpy(buf, base, len);
-	for (i = 0; i < 1024; i++) {
-		ret = btrfs_insert_dir_item(trans, root, buf, len,
-					    dirid, &key, BTRFS_FT_DIR, index);
-		if (ret != -EEXIST)
-			break;
-		len = snprintf(buf, ARRAY_SIZE(buf), "%s%d", base, i);
-		if (len < 1 || len > BTRFS_NAME_LEN) {
-			ret = -EINVAL;
-			break;
+	if (convert) {
+		for (i = 0; i < 1024; i++) {
+			ret = btrfs_insert_dir_item(trans, root, buf, len,
+					dirid, &key, BTRFS_FT_DIR, index);
+			if (ret != -EEXIST)
+				break;
+			len = snprintf(buf, ARRAY_SIZE(buf), "%s%d", base, i);
+			if (len < 1 || len > BTRFS_NAME_LEN) {
+				ret = -EINVAL;
+				break;
+			}
 		}
+	} else {
+		ret = btrfs_insert_dir_item(trans, root, buf, len, dirid, &key,
+					    BTRFS_FT_DIR, index);
 	}
 	if (ret)
 		goto fail;
-- 
2.14.1.690.gbb1197296e-goog

