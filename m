Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65458 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751114AbdHRIdD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 04:33:03 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 6968947243A5
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 16:32:54 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: delete not-used parameter fd
Date: Fri, 18 Aug 2017 01:32:46 -0700
Message-ID: <1503045166-18612-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1503045166-18612-1-git-send-email-gujx@cn.fujitsu.com>
References: <1503045166-18612-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Parameter fd is not used in function make_image and
traverse_directory of mkfs.
Delete it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 mkfs/main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index ec82565..3e9c1b8 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -801,7 +801,7 @@ static char *make_path(const char *dir, const char *name)
 
 static int traverse_directory(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, const char *dir_name,
-			      struct directory_name_entry *dir_head, int out_fd)
+			      struct directory_name_entry *dir_head)
 {
 	int ret = 0;
 
@@ -1029,8 +1029,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int make_image(const char *source_dir, struct btrfs_root *root,
-		int out_fd)
+static int make_image(const char *source_dir, struct btrfs_root *root)
 {
 	int ret;
 	struct btrfs_trans_handle *trans;
@@ -1048,7 +1047,7 @@ static int make_image(const char *source_dir, struct btrfs_root *root,
 	INIT_LIST_HEAD(&dir_head.list);
 
 	trans = btrfs_start_transaction(root, 1);
-	ret = traverse_directory(trans, root, source_dir, &dir_head, out_fd);
+	ret = traverse_directory(trans, root, source_dir, &dir_head);
 	if (ret) {
 		error("unable to traverse directory %s: %d", source_dir, ret);
 		goto fail;
@@ -1882,7 +1881,7 @@ raid_groups:
 			goto out;
 		}
 
-		ret = make_image(source_dir, root, fd);
+		ret = make_image(source_dir, root);
 		if (ret) {
 			error("error wihle filling filesystem: %d", ret);
 			goto out;
-- 
1.9.1



