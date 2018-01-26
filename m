Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:53295 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751543AbeAZDWQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 22:22:16 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 19AD749F19B0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 11:22:11 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/6] btrfs-progs: Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE
Date: Fri, 26 Jan 2018 11:22:04 +0800
Message-ID: <1516936926-18707-4-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do a cleanup. Also make it consistent with kernel.
Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE, since
maybe in some situation we do not know root, but just know fs_info.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 ctree.h    | 2 +-
 dir-item.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index ace93cc3..c82e7547 100644
--- a/ctree.h
+++ b/ctree.h
@@ -364,7 +364,7 @@ struct btrfs_header {
 #define BTRFS_MAX_INLINE_DATA_SIZE(fs_info) (BTRFS_LEAF_DATA_SIZE(fs_info) - \
 					sizeof(struct btrfs_item) - \
 					sizeof(struct btrfs_file_extent_item))
-#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
+#define BTRFS_MAX_XATTR_SIZE(fs_info)	(BTRFS_LEAF_DATA_SIZE(fs_info) - \
 				 sizeof(struct btrfs_item) -\
 				 sizeof(struct btrfs_dir_item))
 
diff --git a/dir-item.c b/dir-item.c
index 462546c0..0b7250c9 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -311,7 +311,8 @@ static int verify_dir_item(struct btrfs_root *root,
 
 	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
 	if ((btrfs_dir_data_len(leaf, dir_item) +
-	     btrfs_dir_name_len(leaf, dir_item)) > BTRFS_MAX_XATTR_SIZE(root)) {
+	     btrfs_dir_name_len(leaf, dir_item)) >
+			BTRFS_MAX_XATTR_SIZE(root->fs_info)) {
 		fprintf(stderr, "invalid dir item name + data len: %u + %u\n",
 		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
-- 
2.14.3



