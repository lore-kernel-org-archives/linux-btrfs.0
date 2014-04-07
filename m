Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64465 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbaDGPmG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 11:42:06 -0400
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s37FfjmQ015007
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Apr 2014 08:42:05 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1k1tw80ak2-12
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 08:42:04 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't set path->need_commit_sem when searching backrefs
Date: Mon, 7 Apr 2014 11:40:42 -0400
Message-ID: <1396885242-20995-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I added the ability to specify we needed the commit_sem for using the commit
root with send.  However when we search clones we already hold the commit sem,
so we need to set path->need_commit_sem to 0 for this case.  This patch also
makes it so we don't have to re-allocate a new path for every extent of every
inode we check while looking at backrefs.  This is meant to be an incremental
that will be folded into my original ->need_comit_sem patch, just sending this
as a sanity check.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/send.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 59f0b85..1ac3ca9 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -772,29 +772,22 @@ out:
 /*
  * Helper function to retrieve some fields from an inode item.
  */
-static int get_inode_info(struct btrfs_root *root,
-			  u64 ino, u64 *size, u64 *gen,
-			  u64 *mode, u64 *uid, u64 *gid,
-			  u64 *rdev)
+static int __get_inode_info(struct btrfs_root *root, struct btrfs_path *path,
+			  u64 ino, u64 *size, u64 *gen, u64 *mode, u64 *uid,
+			  u64 *gid, u64 *rdev)
 {
 	int ret;
 	struct btrfs_inode_item *ii;
 	struct btrfs_key key;
-	struct btrfs_path *path;
-
-	path = alloc_path_for_send();
-	if (!path)
-		return -ENOMEM;
 
 	key.objectid = ino;
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto out;
 	if (ret) {
-		ret = -ENOENT;
-		goto out;
+		if (ret > 0)
+			ret = -ENOENT;
+		return ret;
 	}
 
 	ii = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -812,7 +805,22 @@ static int get_inode_info(struct btrfs_root *root,
 	if (rdev)
 		*rdev = btrfs_inode_rdev(path->nodes[0], ii);
 
-out:
+	return ret;
+}
+
+static int get_inode_info(struct btrfs_root *root,
+			  u64 ino, u64 *size, u64 *gen,
+			  u64 *mode, u64 *uid, u64 *gid,
+			  u64 *rdev)
+{
+	struct btrfs_path *path;
+	int ret;
+
+	path = alloc_path_for_send();
+	if (!path)
+		return -ENOMEM;
+	ret = __get_inode_info(root, path, ino, size, gen, mode, uid, gid,
+			       rdev);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -1086,6 +1094,7 @@ out:
 struct backref_ctx {
 	struct send_ctx *sctx;
 
+	struct btrfs_path *path;
 	/* number of total found references */
 	u64 found;
 
@@ -1156,8 +1165,9 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
 	 * There are inodes that have extents that lie behind its i_size. Don't
 	 * accept clones from these extents.
 	 */
-	ret = get_inode_info(found->root, ino, &i_size, NULL, NULL, NULL, NULL,
-			NULL);
+	ret = __get_inode_info(found->root, bctx->path, ino, &i_size, NULL, NULL,
+			       NULL, NULL, NULL);
+	btrfs_release_path(bctx->path);
 	if (ret < 0)
 		return ret;
 
@@ -1236,12 +1246,17 @@ static int find_extent_clone(struct send_ctx *sctx,
 	if (!tmp_path)
 		return -ENOMEM;
 
+	/* We only use this path under the commit sem */
+	tmp_path->need_commit_sem = 0;
+
 	backref_ctx = kmalloc(sizeof(*backref_ctx), GFP_NOFS);
 	if (!backref_ctx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	backref_ctx->path = tmp_path;
+
 	if (data_offset >= ino_size) {
 		/*
 		 * There may be extents that lie behind the file's size.
-- 
1.8.3.1

