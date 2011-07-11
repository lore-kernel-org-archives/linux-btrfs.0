From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: [PATCH] Btrfs-progs: add "btrfs subvolume get-default" subcommand
Date: Mon, 11 Jul 2011 16:13:51 +0800
Message-ID: <1310372031-20500-1-git-send-email-xin.zhong@intel.com>
Cc: xin.zhong@intel.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add subcommand to get the default subvolume of btrfs filesystem

Reported-by: Yang, Yi <yi.y.yang@intel.com>
Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
---
 btrfs-list.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 btrfs.c      |    3 ++
 btrfs_cmds.c |   31 +++++++++++++++++++++++++++++-
 btrfs_cmds.h |    3 +-
 4 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 93766a8..e9c0266 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -536,7 +536,7 @@ build:
 	return full;
 }
 
-int list_subvols(int fd)
+int list_subvols(int fd, int get_default)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
@@ -545,10 +545,12 @@ int list_subvols(int fd)
 	struct btrfs_ioctl_search_key *sk = &args.key;
 	struct btrfs_ioctl_search_header *sh;
 	struct btrfs_root_ref *ref;
+	struct btrfs_dir_item *di;
 	unsigned long off = 0;
 	int name_len;
 	char *name;
 	u64 dir_id;
+	u64 subvol_id = 0;
 	int i;
 
 	root_lookup_init(&root_lookup);
@@ -642,6 +644,55 @@ int list_subvols(int fd)
 		n = rb_next(n);
 	}
 
+	memset(&args, 0, sizeof(args));
+
+	/* search in the tree of tree roots */
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+
+	/* search dir item */
+	sk->max_type = BTRFS_DIR_ITEM_KEY;
+	sk->min_type = BTRFS_DIR_ITEM_KEY;
+
+	sk->max_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
+	sk->min_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	/* just a big number, doesn't matter much */
+	sk->nr_items = 4096;
+
+	/* try to get the objectid of default subvolume */
+	if(get_default) {
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: can't perform the search\n");
+			return ret;
+		}
+		/* the ioctl returns the number of item it found in nr_items */
+		if (sk->nr_items == 0)
+			goto print;
+
+		off = 0;
+		/* go through each item to find dir item named "default" */
+		for (i = 0; i < sk->nr_items; i++) {
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+			off += sizeof(*sh);
+			if (sh->type == BTRFS_DIR_ITEM_KEY) {
+				di = (struct btrfs_dir_item *)(args.buf + off);
+				name_len = le16_to_cpu(di->name_len);
+				name = (char *)di + sizeof(struct btrfs_dir_item);
+				if (!strncmp("default", name, name_len)) {
+					subvol_id = btrfs_disk_key_objectid(
+						&di->location);
+					break;
+				}
+			}
+
+			off += sh->len;
+		}
+	}
+print:
 	/* now that we have all the subvol-relative paths filled in,
 	 * we have to string the subvols together so that we can get
 	 * a path all the way back to the FS root
@@ -650,7 +701,12 @@ int list_subvols(int fd)
 	while (n) {
 		struct root_info *entry;
 		entry = rb_entry(n, struct root_info, rb_node);
-		resolve_root(&root_lookup, entry);
+		if(!get_default)
+			resolve_root(&root_lookup, entry);
+		/* we only want the default subvolume */
+		else if(subvol_id == entry->root_id)
+			resolve_root(&root_lookup, entry);
+			
 		n = rb_prev(n);
 	}
 
diff --git a/btrfs.c b/btrfs.c
index 46314cf..6b73f88 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -73,6 +73,9 @@ static struct Command commands[] = {
 		"Set the subvolume of the filesystem <path> which will be mounted\n"
 		"as default."
 	},
+	{ do_get_default_subvol, 1, "subvolume get-default", "<path>\n"
+		"Get the default subvolume of a filesystem."
+	},
 	{ do_fssync, 1,
 	  "filesystem sync", "<path>\n"
 		"Force a sync on the filesystem <path>."
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..11c56f6 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -301,7 +301,7 @@ int do_subvol_list(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd);
+	ret = list_subvols(fd, 0);
 	if (ret)
 		return 19;
 	return 0;
@@ -834,6 +834,35 @@ int do_set_default_subvol(int nargs, char **argv)
 	return 0;
 }
 
+int do_get_default_subvol(int nargs, char **argv)
+{
+	int fd;
+	int ret;
+	char *subvol;
+
+	subvol = argv[1];
+
+	ret = test_issubvolume(subvol);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		return 12;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		return 13;
+	}
+
+	fd = open_file_or_dir(subvol);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		return 12;
+	}
+	ret = list_subvols(fd, 1);
+	if (ret)
+		return 19;
+	return 0;
+}
+
 int do_df_filesystem(int nargs, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..9cf1ca1 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -28,7 +28,8 @@ int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
 int do_subvol_list(int nargs, char **argv);
 int do_set_default_subvol(int nargs, char **argv);
-int list_subvols(int fd);
+int do_get_default_subvol(int nargs, char **argv);
+int list_subvols(int fd, int get_default);
 int do_df_filesystem(int nargs, char **argv);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int do_find_newer(int argc, char **argv);
-- 
1.7.0.4

