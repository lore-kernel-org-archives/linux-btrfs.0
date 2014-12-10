Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:41842 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933307AbaLJVFm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:42 -0500
Received: from mail-in-11-z2.arcor-online.net (mail-in-11-z2.arcor-online.net [151.189.8.28])
	by mx.arcor.de (Postfix) with ESMTP id AE4E1D8003
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:40 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 06/18] btrfs restore: set uid/gid/mode/times
Date: Wed, 10 Dec 2014 21:51:36 +0100
Message-Id: <1418244708-7087-7-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

current btrfs restore will discard file attributes. This patch
sets them regular files and directories, as found in the
meta data.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |  116 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 101 insertions(+), 15 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 2f9b72d..5aa2167 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -33,6 +33,7 @@
 #include <zlib.h>
 #include <regex.h>
 #include <getopt.h>
+#include <sys/time.h>
 #include <sys/types.h>
 #include <sys/xattr.h>
 
@@ -549,6 +550,95 @@ out:
 	return ret;
 }
 
+#define _INVALID_SIZE ((off_t)~0ULL)
+static int stat_from_inode(struct stat *st, struct btrfs_root *root,
+			   struct btrfs_key *key)
+{
+	static struct btrfs_path *path;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_timespec *ts;
+	struct extent_buffer *eb;
+
+	if (!path)
+		path = btrfs_alloc_path();
+
+	memset(st, 0, sizeof(*st));
+	st->st_size = _INVALID_SIZE;
+
+	if (!path) {
+		fprintf(stderr, "Ran out of memory\n");
+		return -ENOMEM;
+	}
+
+	if (btrfs_lookup_inode(NULL, root, path, key, 0)) {
+		btrfs_release_path(path);
+		return -ENOENT;
+	}
+
+	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_inode_item);
+	eb = path->nodes[0];
+
+	st->st_size = btrfs_inode_size(eb, inode_item);
+	st->st_uid = btrfs_inode_uid(eb, inode_item);
+	st->st_gid = btrfs_inode_gid(eb, inode_item);
+	st->st_mode = btrfs_inode_mode(eb, inode_item);
+
+	ts = btrfs_inode_atime(eb, inode_item);
+	st->st_atim.tv_sec = ts->sec;
+	st->st_atim.tv_nsec = ts->nsec;
+
+	ts = btrfs_inode_mtime(eb, inode_item);
+	st->st_mtim.tv_sec = ts->sec;
+	st->st_mtim.tv_nsec = ts->nsec;
+
+	ts = btrfs_inode_ctime(eb, inode_item);
+	st->st_ctim.tv_sec = ts->sec;
+	st->st_ctim.tv_nsec = ts->nsec;
+
+	btrfs_release_path(path);
+	return 0;
+}
+
+static void set_fd_attrs(int fd, const struct stat *st, const char *file)
+{
+	struct timeval tv[2];
+	if (st->st_size == _INVALID_SIZE)
+		return;
+
+	tv[0].tv_sec = st->st_atim.tv_sec;
+	tv[0].tv_usec = st->st_atim.tv_nsec/1000;
+	tv[1].tv_sec = st->st_mtim.tv_sec;
+	tv[1].tv_usec = st->st_mtim.tv_nsec/1000;
+	if (S_ISREG(st->st_mode) && ftruncate(fd, st->st_size) == -1)
+		fprintf(stderr, "failed to set file size on %s\n",
+			file);
+	if (fchown(fd, st->st_uid, st->st_gid) == -1)
+		fprintf(stderr, "failed to set uid/gid on %s\n",
+			file);
+	if (fchmod(fd, st->st_mode) == -1)
+		fprintf(stderr, "failed to set permissions on %s\n",
+			file);
+	if (futimes(fd, tv) == -1)
+		fprintf(stderr, "failed to set file times on %s\n",
+			file);
+}
+
+static int set_file_attrs(const char *output_rootdir, const char *file,
+			  const struct stat *st)
+{
+	int fd;
+	static char path[4096];
+	snprintf(path, sizeof(path), "%s%s", output_rootdir, file);
+	fd = open(path, O_RDONLY|O_NOATIME);
+	if (fd == -1) {
+		fprintf(stderr, "failed to open %s\n", path_name);
+		return -1;
+	}
+	set_fd_attrs(fd, st, path);
+	close(fd);
+	return 0;
+}
 
 static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		     const char *file)
@@ -556,13 +646,12 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	struct extent_buffer *leaf;
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *fi;
-	struct btrfs_inode_item *inode_item;
 	struct btrfs_key found_key;
 	int ret;
 	int extent_type;
 	int compression;
 	int loops = 0;
-	u64 found_size = 0;
+	struct stat st;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -570,13 +659,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		return -ENOMEM;
 	}
 
-	ret = btrfs_lookup_inode(NULL, root, path, key, 0);
-	if (ret == 0) {
-		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				    struct btrfs_inode_item);
-		found_size = btrfs_inode_size(path->nodes[0], inode_item);
-	}
-	btrfs_release_path(path);
+	stat_from_inode(&st, root, key);
 
 	key->offset = 0;
 	key->type = BTRFS_EXTENT_DATA_KEY;
@@ -672,16 +755,14 @@ next:
 
 	btrfs_free_path(path);
 set_size:
-	if (found_size) {
-		ret = ftruncate(fd, (loff_t)found_size);
-		if (ret)
-			return ret;
-	}
 	if (get_xattrs) {
 		ret = set_file_xattrs(root, key->objectid, fd, file);
 		if (ret)
-			return ret;
+			fprintf(stderr, "failed to set xattrs on %s\n",
+				file);
 	}
+
+	set_fd_attrs(fd, &st, file);
 	return 0;
 }
 
@@ -693,6 +774,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *dir_item;
 	struct btrfs_key found_key, location;
+	struct stat dirst;
 	char filename[BTRFS_NAME_LEN + 1];
 	unsigned long name_ptr;
 	int name_len;
@@ -707,6 +789,8 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		return -ENOMEM;
 	}
 
+	stat_from_inode(&dirst, root, key);
+
 	key->offset = 0;
 	key->type = BTRFS_DIR_INDEX_KEY;
 
@@ -931,6 +1015,8 @@ next:
 		path->slots[0]++;
 	}
 
+	set_file_attrs(output_rootdir, in_dir, &dirst);
+
 	if (verbose)
 		printf("Done searching %s\n", in_dir);
 	btrfs_free_path(path);
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
