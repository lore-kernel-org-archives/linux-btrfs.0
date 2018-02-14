Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55780 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754489AbeBNHuT (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 14 Feb 2018 02:50:19 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: mkfs/rootdir: Fix memory leak in traverse_directory()
Date: Wed, 14 Feb 2018 15:50:06 +0800
Message-Id: <20180214075006.6576-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bug is exposed by mkfs test case 009, with D=asan.

We are leaking memory of parent_dir_entry->path() which ,except the
rootdir, is allocated by strdup().

Before fixing it, unifiy the allocation of parent_dir_entry() to heap
allocation.

Then fix it by adding "free(parent_dir_entry->path);" in
traverse_directory() and error handler.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 5 +++--
 mkfs/rootdir.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 9be4bcbfd0b5..f9472e126674 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -453,7 +453,6 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	ino_t parent_inum, cur_inum;
 	ino_t highest_inum = 0;
 	const char *parent_dir_name;
-	char real_path[PATH_MAX];
 	struct btrfs_path path;
 	struct extent_buffer *leaf;
 	struct btrfs_key root_dir_key;
@@ -464,7 +463,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	if (!dir_entry)
 		return -ENOMEM;
 	dir_entry->dir_name = dir_name;
-	dir_entry->path = realpath(dir_name, real_path);
+	dir_entry->path = realpath(dir_name, NULL);
 	if (!dir_entry->path) {
 		error("realpath  failed for %s: %s", dir_name, strerror(errno));
 		ret = -1;
@@ -616,6 +615,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		}
 
 		free_namelist(files, count);
+		free(parent_dir_entry->path);
 		free(parent_dir_entry);
 
 		index_cnt = 2;
@@ -686,6 +686,7 @@ fail:
 		dir_entry = list_entry(dir_head.list.next,
 				       struct directory_name_entry, list);
 		list_del(&dir_entry->list);
+		free(dir_entry->path);
 		free(dir_entry);
 	}
 out:
diff --git a/mkfs/rootdir.h b/mkfs/rootdir.h
index d0fc2eb58563..f06c7dd16e3c 100644
--- a/mkfs/rootdir.h
+++ b/mkfs/rootdir.h
@@ -23,7 +23,7 @@
 
 struct directory_name_entry {
 	const char *dir_name;
-	const char *path;
+	char *path;
 	ino_t inum;
 	struct list_head list;
 };
-- 
2.16.1

