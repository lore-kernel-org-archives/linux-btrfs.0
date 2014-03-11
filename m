Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42060 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbaCKK2O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 06:28:14 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: sgw@linux.intel.com, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix bug on mkfs with relative path specified
Date: Tue, 11 Mar 2014 18:24:27 +0800
Message-Id: <1394533467-24967-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bug accurs when exec:
	# mkfs.btrfs -r <a relative path> <device>
	(note: the path should be 'valid' correspond to your `pwd`)
error msg:
	$ scandir for <a relative path> failed: No such file...

Replace strdup() with realpath() to get the correct scan path.

Reported-by: Saul Wold <sgw@linux.intel.com>
Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 mkfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2dc90c2..1bd3069 100644
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
@@ -764,7 +765,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	/* Add list for source directory */
 	dir_entry = malloc(sizeof(struct directory_name_entry));
 	dir_entry->dir_name = dir_name;
-	dir_entry->path = strdup(dir_name);
+	dir_entry->path = realpath(dir_name, real_path);
 
 	parent_inum = highest_inum + BTRFS_FIRST_FREE_OBJECTID;
 	dir_entry->inum = parent_inum;
@@ -876,7 +877,6 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		}
 
 		free_namelist(files, count);
-		free(parent_dir_entry->path);
 		free(parent_dir_entry);
 
 		index_cnt = 2;
@@ -887,7 +887,6 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 fail:
 	free_namelist(files, count);
 fail_no_files:
-	free(parent_dir_entry->path);
 	free(parent_dir_entry);
 	return -1;
 }
-- 
1.8.1.4

