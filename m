Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaCMFJ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 01:09:29 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2D56Gxr003962
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Mar 2014 13:09:26 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: fix bug on mkfs with relative path specified
Date: Thu, 13 Mar 2014 13:01:30 +0800
Message-Id: <1394686891-23271-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bug accurs when exec:
	# mkfs.btrfs -r <a relative path> <device>
	(note: the path should be 'valid' correspond to your `pwd`)
error msg:
	$ scandir for <a relative path> failed: No such file...

o Replace strdup() with realpath() to get the correct scan path.
o fix memory leaks and adopt the "single return + goto out" pattern

Reported-by: Saul Wold <sgw@linux.intel.com>
Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
change log
	v1->v2: 1. add check for realpath() return value
		2. fix memory leaks for dir_entry
		3. adopt "single return + goto out" pattern
---
 mkfs.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2dc90c2..d7049c9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -756,6 +756,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	ino_t parent_inum, cur_inum;
 	ino_t highest_inum = 0;
 	char *parent_dir_name;
+	char real_path[PATH_MAX];
 	struct btrfs_path path;
 	struct extent_buffer *leaf;
 	struct btrfs_key root_dir_key;
@@ -764,7 +765,12 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	/* Add list for source directory */
 	dir_entry = malloc(sizeof(struct directory_name_entry));
 	dir_entry->dir_name = dir_name;
-	dir_entry->path = strdup(dir_name);
+	dir_entry->path = realpath(dir_name, real_path);
+	if (!dir_entry->path) {
+		fprintf(stderr, "get directory real path error\n");
+		ret = -1;
+		goto fail_no_dir;
+	}
 
 	parent_inum = highest_inum + BTRFS_FIRST_FREE_OBJECTID;
 	dir_entry->inum = parent_inum;
@@ -778,7 +784,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	ret = btrfs_lookup_inode(trans, root, &path, &root_dir_key, 1);
 	if (ret) {
 		fprintf(stderr, "root dir lookup error\n");
-		return -1;
+		goto fail_no_dir;
 	}
 
 	leaf = path.nodes[0];
@@ -802,6 +808,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		if (chdir(parent_dir_entry->path)) {
 			fprintf(stderr, "chdir error for %s\n",
 				parent_dir_name);
+			ret = -1;
 			goto fail_no_files;
 		}
 
@@ -811,6 +818,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		{
 			fprintf(stderr, "scandir for %s failed: %s\n",
 				parent_dir_name, strerror (errno));
+			ret = -1;
 			goto fail;
 		}
 
@@ -820,6 +828,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 			if (lstat(cur_file->d_name, &st) == -1) {
 				fprintf(stderr, "lstat failed for file %s\n",
 					cur_file->d_name);
+				ret = -1;
 				goto fail;
 			}
 
@@ -876,20 +885,22 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		}
 
 		free_namelist(files, count);
-		free(parent_dir_entry->path);
 		free(parent_dir_entry);
 
 		index_cnt = 2;
 
 	} while (!list_empty(&dir_head->list));
 
-	return 0;
+out:
+	return !!ret;
 fail:
 	free_namelist(files, count);
 fail_no_files:
-	free(parent_dir_entry->path);
 	free(parent_dir_entry);
-	return -1;
+	goto out;
+fail_no_dir:
+	free(dir_entry);
+	goto out;
 }
 
 static int open_target(char *output_name)
-- 
1.8.1.4

