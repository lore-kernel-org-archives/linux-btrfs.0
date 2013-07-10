Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51499 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJXp2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 19:45:28 -0400
Received: by mail-wi0-f175.google.com with SMTP id m6so11991146wiv.8
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jul 2013 16:45:27 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: restore can now recover file xattrs
Date: Thu, 11 Jul 2013 00:45:20 +0100
Message-Id: <1373499920-32007-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This change adds a new option to the restore command, named -x,
that makes it restore file extented attributes too. This is an
optional behaviour and it's disabled by default.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-restore.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index e48df40..0f6169e 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -30,6 +30,8 @@
 #include <lzo/lzoconf.h>
 #include <lzo/lzo1x.h>
 #include <zlib.h>
+#include <sys/types.h>
+#include <attr/xattr.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -47,6 +49,7 @@ static int get_snaps = 0;
 static int verbose = 0;
 static int ignore_errors = 0;
 static int overwrite = 0;
+static int get_xattrs = 0;
 
 #define LZO_LEN 4
 #define PAGE_CACHE_SIZE 4096
@@ -412,6 +415,105 @@ again:
 }
 
 
+static int set_file_xattrs(struct btrfs_root *root, u64 inode,
+			   int fd, const char *file_name)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_dir_item *di;
+	u32 name_len = 0;
+	u32 data_len = 0;
+	u32 len = 0;
+	char *name = NULL;
+	char *data = NULL;
+	int ret = 0;
+
+	key.objectid = inode;
+	key.type = BTRFS_XATTR_ITEM_KEY;
+	key.offset = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	leaf = path->nodes[0];
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			do {
+				ret = next_leaf(root, path);
+				if (ret < 0) {
+					fprintf(stderr, "Error searching for"
+						" extended attributes: %d\n",
+						ret);
+					goto out;
+				} else if (ret) {
+					/* No more leaves to search */
+					goto out;
+				}
+				leaf = path->nodes[0];
+			} while (!leaf);
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+		if (key.type != BTRFS_XATTR_ITEM_KEY || key.objectid != inode)
+			break;
+
+		di = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_dir_item);
+
+		len = btrfs_dir_name_len(leaf, di);
+		if (len > name_len) {
+			free(name);
+			name = (char *) malloc(len + 1);
+			if (!name) {
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
+		read_extent_buffer(leaf, name, (unsigned long)(di + 1), len);
+		name[len] = '\0';
+		name_len = len;
+
+		len = btrfs_dir_data_len(leaf, di);
+		if (len > data_len) {
+			free(data);
+			data = (char *) malloc(len);
+			if (!data) {
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
+		read_extent_buffer(leaf, data,
+				   (unsigned long)(di + 1) + name_len, len);
+		data_len = len;
+
+		if (fsetxattr(fd, name, data, data_len, 0)) {
+			int err = errno;
+
+			fprintf(stderr, "Error setting extended attribute %s"
+				" on file %s: %s", name, file_name,
+				strerror(err));
+		}
+
+		path->slots[0]++;
+	}
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	free(name);
+	free(data);
+
+	return ret;
+}
+
+
 static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		     const char *file)
 {
@@ -535,6 +637,11 @@ set_size:
 		if (ret)
 			return ret;
 	}
+	if (get_xattrs) {
+		ret = set_file_xattrs(root, key->objectid, fd, file);
+		if (ret)
+			return ret;
+	}
 	return 0;
 }
 
@@ -966,6 +1073,7 @@ const char * const cmd_restore_usage[] = {
 	"Try to restore files from a damaged filesystem (unmounted)",
 	"",
 	"-s              get snapshots",
+	"-x              get extended attributes",
 	"-v              verbose",
 	"-i              ignore errors",
 	"-o              overwrite",
@@ -991,7 +1099,7 @@ int cmd_restore(int argc, char **argv)
 	int find_dir = 0;
 	int list_roots = 0;
 
-	while ((opt = getopt(argc, argv, "sviot:u:df:r:l")) != -1) {
+	while ((opt = getopt(argc, argv, "sxviot:u:df:r:l")) != -1) {
 		switch (opt) {
 			case 's':
 				get_snaps = 1;
@@ -1045,6 +1153,9 @@ int cmd_restore(int argc, char **argv)
 			case 'l':
 				list_roots = 1;
 				break;
+			case 'x':
+				get_xattrs = 1;
+				break;
 			default:
 				usage(cmd_restore_usage);
 		}
-- 
1.7.9.5

