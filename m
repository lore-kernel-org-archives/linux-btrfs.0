Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:47507 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760684AbaCUMrH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 08:47:07 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so1569873wes.34
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Mar 2014 05:47:06 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: send, avoid unnecessary inode item lookup in the btree
Date: Fri, 21 Mar 2014 12:46:54 +0000
Message-Id: <1395406014-8535-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regardless of whether the caller is interested or not in knowing the inode's
generation (dir_gen != NULL), get_first_ref always does a btree lookup to get
the inode item. Avoid this useless lookup if dir_gen parameter is NULL (which
is in some cases).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ab404ff..7233991 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1667,10 +1667,12 @@ static int get_first_ref(struct btrfs_root *root, u64 ino,
 		goto out;
 	btrfs_release_path(path);
 
-	ret = get_inode_info(root, parent_dir, NULL, dir_gen, NULL, NULL,
-			NULL, NULL);
-	if (ret < 0)
-		goto out;
+	if (dir_gen) {
+		ret = get_inode_info(root, parent_dir, NULL, dir_gen, NULL,
+				     NULL, NULL, NULL);
+		if (ret < 0)
+			goto out;
+	}
 
 	*dir = parent_dir;
 
@@ -1686,13 +1688,12 @@ static int is_first_ref(struct btrfs_root *root,
 	int ret;
 	struct fs_path *tmp_name;
 	u64 tmp_dir;
-	u64 tmp_dir_gen;
 
 	tmp_name = fs_path_alloc();
 	if (!tmp_name)
 		return -ENOMEM;
 
-	ret = get_first_ref(root, ino, &tmp_dir, &tmp_dir_gen, tmp_name);
+	ret = get_first_ref(root, ino, &tmp_dir, NULL, tmp_name);
 	if (ret < 0)
 		goto out;
 
-- 
1.7.10.4

