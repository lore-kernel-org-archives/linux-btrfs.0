Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63888 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3HFS2g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Aug 2013 14:28:36 -0400
Received: by mail-wg0-f43.google.com with SMTP id z12so671453wgg.10
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Aug 2013 11:28:35 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH RFC] Btrfs-progs: allow btrfstune to set persistent mount options
Date: Tue,  6 Aug 2013 19:28:27 +0100
Message-Id: <1375813707-14167-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the complement to the corresponding kernel patch that
adds support for permanent options.

NOTE: Like the corresponding kernel patch, this is a WIP with the
goal o gathering feedback.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 btrfstune.c  |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 ctree.h      |    8 +++++
 print-tree.c |    9 +++++
 3 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 4db1767..b3d3e57 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -97,12 +97,100 @@ int enable_skinny_metadata(struct btrfs_root *root)
 	return 0;
 }
 
+static int set_persistent_mount_options(struct btrfs_root *root,
+					const char *options)
+{
+	int ret;
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_path *path;
+	struct btrfs_key key, location;
+	struct extent_buffer *leaf;
+	struct btrfs_dir_item *dir_item;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_root *tree_root = root->fs_info->tree_root;
+	unsigned long data_ptr;
+	u32 data_size, data_len;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = BTRFS_PERSISTENT_OPTIONS_OBJECTID;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, tree_root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	if (!ret) {
+		char *buf;
+
+		leaf = path->nodes[0];
+		dir_item = btrfs_item_ptr(leaf, path->slots[0],
+					  struct btrfs_dir_item);
+		buf = (char *) malloc(btrfs_dir_data_len(leaf, dir_item));
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		read_extent_buffer(leaf, buf,
+				   (unsigned long)((char *)(dir_item + 1)),
+				   btrfs_dir_data_len(leaf, dir_item));
+		printf("Current persistent options:  %.*s\n",
+		       btrfs_dir_data_len(leaf, dir_item), buf);
+		free(buf);
+		ret = btrfs_del_item(trans, tree_root, path);
+		if (ret)
+			goto out;
+	}
+
+	btrfs_release_path(root, path);
+
+	data_len = strlen(options);
+	data_size = sizeof(*dir_item) + data_len;
+	ret = btrfs_insert_empty_item(trans, tree_root, path, &key, data_size);
+	if (ret)
+		goto out;
+
+	leaf = path->nodes[0];
+	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
+
+	memset(&location, 0, sizeof(location));
+	btrfs_cpu_key_to_disk(&disk_key, &location);
+	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
+	btrfs_set_dir_type(leaf, dir_item, BTRFS_FT_UNKNOWN);
+	btrfs_set_dir_name_len(leaf, dir_item, 0);
+	btrfs_set_dir_data_len(leaf, dir_item, data_len);
+	data_ptr = (unsigned long)((char *)(dir_item + 1));
+
+	write_extent_buffer(leaf, options, data_ptr, data_len);
+	btrfs_mark_buffer_dirty(leaf);
+
+out:
+	if (!ret && trans)
+		ret = btrfs_commit_transaction(trans, root);
+	else if (trans)
+		btrfs_free_transaction(root, trans);
+	btrfs_free_path(path);
+	if (!ret)
+		printf("New persistent options:      %s\n", options);
+
+	return ret;
+}
+
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
 	fprintf(stderr, "\t-S value\tenable/disable seeding\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
-	fprintf(stderr, "\t-x enable skinny metadata extent refs\n");
+	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
+	fprintf(stderr, "\t-o options\tset persistent mount options\n");
 }
 
 int main(int argc, char *argv[])
@@ -114,9 +202,10 @@ int main(int argc, char *argv[])
 	int seeding_value = 0;
 	int skinny_flag = 0;
 	int ret;
+	char *options = NULL;
 
 	while(1) {
-		int c = getopt(argc, argv, "S:rx");
+		int c = getopt(argc, argv, "S:rxo:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -130,6 +219,9 @@ int main(int argc, char *argv[])
 		case 'x':
 			skinny_flag = 1;
 			break;
+		case 'o':
+			options = optarg;
+			break;
 		default:
 			print_usage();
 			return 1;
@@ -171,6 +263,15 @@ int main(int argc, char *argv[])
 		success++;
 	}
 
+	if (options) {
+		ret = set_persistent_mount_options(root, options);
+		if (ret)
+			fprintf(stderr,
+				"Error setting persistent options: %d\n", ret);
+		else
+			success++;
+	}
+
 	if (success > 0) {
 		ret = 0;
 	} else {
diff --git a/ctree.h b/ctree.h
index 0b0d701..8255661 100644
--- a/ctree.h
+++ b/ctree.h
@@ -102,6 +102,14 @@ struct btrfs_free_space_ctl;
  */
 #define BTRFS_FREE_INO_OBJECTID -12ULL
 
+/*
+ * Item that stores permanent mount options. These options
+ * have effect if they are not specified as well at mount
+ * time (that is, if a permanent option is also specified at
+ * mount time, the later wins).
+ */
+#define BTRFS_PERSISTENT_OPTIONS_OBJECTID -13ULL
+
 /* dummy objectid represents multiple objectids */
 #define BTRFS_MULTIPLE_OBJECTIDS -255ULL
 
diff --git a/print-tree.c b/print-tree.c
index aae47a9..4cb7af6 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -585,6 +585,9 @@ static void print_objectid(u64 objectid, u8 type)
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
 		break;
+	case BTRFS_PERSISTENT_OPTIONS_OBJECTID:
+		printf("PERSISTENT_OPTIONS");
+		break;
 	case (u64)-1:
 		printf("-1");
 		break;
@@ -849,6 +852,12 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_DEV_STATS_KEY:
 			printf("\t\tdevice stats\n");
 			break;
+		case 0:
+			if (objectid == BTRFS_PERSISTENT_OPTIONS_OBJECTID) {
+				di = btrfs_item_ptr(l, i, struct btrfs_dir_item);
+				print_dir_item(l, item, di);
+			}
+			break;
 		};
 		fflush(stdout);
 	}
-- 
1.7.9.5

