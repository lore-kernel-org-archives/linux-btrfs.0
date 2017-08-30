Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:33457 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752395AbdH3R2q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 13:28:46 -0400
Received: by mail-pg0-f49.google.com with SMTP id t3so21768210pgt.0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 10:28:46 -0700 (PDT)
From: Yingyi Luo <yingyil@google.com>
To: linux-btrfs@vger.kernel.org
Cc: drosen@google.com, yingyil <yingyil@google.com>
Subject: [PATCH 2/4 v2] btrfs-progs: add a parameter to btrfs_link_subvol
Date: Wed, 30 Aug 2017 10:24:48 -0700
Message-Id: <20170830172450.27460-3-yingyil@google.com>
In-Reply-To: <20170830172450.27460-1-yingyil@google.com>
References: <20170825232101.10859-1-yingyil@google.com>
 <20170830172450.27460-1-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: yingyil <yingyil@google.com>

A convert parameter is added as a flag to indicate if btrfs_link_subvol()
is used for btrfs-convert. The change cascades down to the callchain.

Signed-off-by: yingyil <yingyil@google.com>
---
v2: Added a flag for btrfs_link_subvol() function so that it can be used in a
more general way. For example, if mkfs calls this function, it will return
directly with an error code if the subvolume creation fails.

 convert/main.c |  2 +-
 utils.c        | 25 +++++++++++++++----------
 utils.h        |  2 +-
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 8f7fec25..19a60782 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1192,7 +1192,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 		task_deinit(ctx.info);
 	}
 
-	image_root = btrfs_link_subvol(root, subvol_name, CONV_IMAGE_SUBVOL_OBJECTID);
+	image_root = btrfs_link_subvol(root, subvol_name, CONV_IMAGE_SUBVOL_OBJECTID, 1);
 	if (!image_root) {
 		error("unable to link subvolume %s", subvol_name);
 		goto fail;
diff --git a/utils.c b/utils.c
index 32382328..20ea9e74 100644
--- a/utils.c
+++ b/utils.c
@@ -2576,7 +2576,7 @@ void btrfs_config_init(void)
 }
 
 struct btrfs_root *btrfs_link_subvol(struct btrfs_root *root,
-		const char *base, u64 root_objectid)
+		const char *base, u64 root_objectid, int convert)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -2642,16 +2642,21 @@ struct btrfs_root *btrfs_link_subvol(struct btrfs_root *root,
 	key.type = BTRFS_ROOT_ITEM_KEY;
 
 	memcpy(buf, base, len);
-	for (i = 0; i < 1024; i++) {
-		ret = btrfs_insert_dir_item(trans, root, buf, len, dirid,
-					    &key, BTRFS_FT_DIR, index);
-		if (ret != -EEXIST)
-			break;
-		len = snprintf(buf, ARRAY_SIZE(buf), "%s%d", base, i);
-		if (len < 1 || len > BTRFS_NAME_LEN) {
-			ret = -EINVAL;
-			break;
+	if (convert) {
+		for (i = 0; i < 1024; i++) {
+			ret = btrfs_insert_dir_item(trans, root, buf, len, dirid,
+						    &key, BTRFS_FT_DIR, index);
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
diff --git a/utils.h b/utils.h
index 886590fd..28aa8373 100644
--- a/utils.h
+++ b/utils.h
@@ -171,6 +171,6 @@ unsigned int rand_range(unsigned int upper);
 void init_rand_seed(u64 seed);
 
 struct btrfs_root *btrfs_link_subvol(struct btrfs_root *root, const char *base,
-				     u64 root_objectid);
+				     u64 root_objectid, int convert);
 
 #endif
-- 
2.14.1.342.g6490525c54-goog

