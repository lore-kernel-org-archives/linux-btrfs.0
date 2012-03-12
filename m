From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 3/3] Btrfs-progs: bring 'subvol get-default' back in
Date: Mon, 12 Mar 2012 20:05:47 +0200
Message-ID: <1331575547-5796-4-git-send-email-idryomov@gmail.com>
References: <1331575547-5796-1-git-send-email-idryomov@gmail.com>
Cc: idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331575547-5796-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Commit bab2c565 accidentally broke 'subvol get-default' command by
removing almost all of the underlying code.  Bring it back with some
fixes and improvements.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs-list.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ctree.h      |    2 +
 2 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index cc1dc66..00c428b 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -552,6 +552,60 @@ build:
 	return full;
 }
 
+static int get_default_subvolid(int fd, u64 *default_id)
+{
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	u64 found = 0;
+	int ret;
+
+	memset(&args, 0, sizeof(args));
+
+	/*
+	 * search for a dir item with a name 'default' in the tree of
+	 * tree roots, it should point us to a default root
+	 */
+	sk->tree_id = 1;
+
+	/* don't worry about ancient format and request only one item */
+	sk->nr_items = 1;
+
+	sk->max_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
+	sk->min_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
+	sk->max_type = BTRFS_DIR_ITEM_KEY;
+	sk->min_type = BTRFS_DIR_ITEM_KEY;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0)
+		return ret;
+
+	/* the ioctl returns the number of items it found in nr_items */
+	if (sk->nr_items == 0)
+		goto out;
+
+	sh = (struct btrfs_ioctl_search_header *)args.buf;
+
+	if (sh->type == BTRFS_DIR_ITEM_KEY) {
+		struct btrfs_dir_item *di;
+		int name_len;
+		char *name;
+
+		di = (struct btrfs_dir_item *)(sh + 1);
+		name_len = btrfs_stack_dir_name_len(di);
+		name = (char *)(di + 1);
+
+		if (!strncmp("default", name, name_len))
+			found = btrfs_disk_key_objectid(&di->location);
+	}
+
+out:
+	*default_id = found;
+	return 0;
+}
+
 static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 {
 	int ret;
@@ -663,12 +717,32 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-int list_subvols(int fd, int print_parent)
+int list_subvols(int fd, int print_parent, int get_default)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
+	u64 default_id;
 	int ret;
 
+	if (get_default) {
+		ret = get_default_subvolid(fd, &default_id);
+		if (ret) {
+			fprintf(stderr, "ERROR: can't perform the search - %s\n",
+				strerror(errno));
+			return ret;
+		}
+		if (default_id == 0) {
+			fprintf(stderr, "ERROR: 'default' dir item not found\n");
+			return ret;
+		}
+
+		/* no need to resolve roots if FS_TREE is default */
+		if (default_id == BTRFS_FS_TREE_OBJECTID) {
+			printf("ID 5 (FS_TREE)\n");
+			return ret;
+		}
+	}
+
 	ret = __list_subvol_search(fd, &root_lookup);
 	if (ret) {
 		fprintf(stderr, "ERROR: can't perform the search - %s\n",
@@ -696,6 +770,11 @@ int list_subvols(int fd, int print_parent)
 		char *path;
 
 		entry = rb_entry(n, struct root_info, rb_node);
+		if (get_default && entry->root_id != default_id) {
+			n = rb_prev(n);
+			continue;
+		}
+
 		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
 		if (print_parent) {
 			printf("ID %llu parent %llu top level %llu path %s\n",
diff --git a/ctree.h b/ctree.h
index 5309059..141ec59 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1416,6 +1416,8 @@ BTRFS_SETGET_FUNCS(dir_type, struct btrfs_dir_item, type, 8);
 BTRFS_SETGET_FUNCS(dir_name_len, struct btrfs_dir_item, name_len, 16);
 BTRFS_SETGET_FUNCS(dir_transid, struct btrfs_dir_item, transid, 64);
 
+BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len, struct btrfs_dir_item, name_len, 16);
+
 static inline void btrfs_dir_item_key(struct extent_buffer *eb,
 				      struct btrfs_dir_item *item,
 				      struct btrfs_disk_key *key)
-- 
1.7.9.1

