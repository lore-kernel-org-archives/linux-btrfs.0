From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: [PATCH V3] Btrfs-progs: add "btrfs subvolume get-default" subcommand
Date: Tue, 12 Jul 2011 10:48:37 +0800
Message-ID: <1310438917-23048-1-git-send-email-xin.zhong@intel.com>
Cc: xin.zhong@intel.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add subcommand to get the default subvolume of btrfs filesystem

V2->V3:
* add man page
* based on http://git.darksatanic.net/repo/btrfs-progs-unstable.git
  integration-20110705

Reviewed-by: Andreas Philipp <philipp.andreas@gmail.com>
Reviewed-by: Goffredo Baroncelli <kreijack@libero.it>
Reported-by: Yang, Yi <yi.y.yang@intel.com>
Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
---
 btrfs-list.c   |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 btrfs.c        |    3 ++
 btrfs_cmds.c   |   31 ++++++++++++++++++++++++++++-
 btrfs_cmds.h   |    3 +-
 man/btrfs.8.in |    7 ++++++
 5 files changed, 98 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 07b179a..016d09c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -560,7 +560,7 @@ build:
 	return full;
 }
 
-int list_subvols(int fd, int print_parent)
+int list_subvols(int fd, int print_parent, int get_default)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
@@ -569,10 +569,12 @@ int list_subvols(int fd, int print_parent)
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
 	int e;
 
@@ -672,6 +674,52 @@ int list_subvols(int fd, int print_parent)
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
+	if (get_default) {
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: can't perform the search\n");
+			return ret;
+		}
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
+
 	/* now that we have all the subvol-relative paths filled in,
 	 * we have to string the subvols together so that we can get
 	 * a path all the way back to the FS root
@@ -680,7 +728,13 @@ int list_subvols(int fd, int print_parent)
 	while (n) {
 		struct root_info *entry;
 		entry = rb_entry(n, struct root_info, rb_node);
-		resolve_root(&root_lookup, entry, print_parent);
+		if (!get_default)
+			resolve_root(&root_lookup, entry, print_parent);
+		/* we only want the default subvolume */
+		else if (subvol_id == entry->root_id)
+			resolve_root(&root_lookup, entry, print_parent);
+		else if (subvol_id == 0)
+			break;
 		n = rb_prev(n);
 	}
 
diff --git a/btrfs.c b/btrfs.c
index 67d6f6f..1af8360 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -94,6 +94,9 @@ static struct Command commands[] = {
 		"-l len     defragment only up to len bytes\n"
 		"-t size    minimal size of file to be considered for defragmenting\n"
 	},
+	{ do_get_default_subvol, 1, "subvolume get-default", "<path>\n"
+		"Get the default subvolume of a filesystem."
+	},
 	{ do_fssync, 1,
 	  "filesystem sync", "<path>\n"
 		"Force a sync on the filesystem <path>.",
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 0612f34..e151c25 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -340,7 +340,7 @@ int do_subvol_list(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, print_parent);
+	ret = list_subvols(fd, print_parent, 0);
 	if (ret)
 		return 19;
 	return 0;
@@ -1443,6 +1443,35 @@ int do_change_label(int nargs, char **argv)
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
+	ret = list_subvols(fd, 0, 1);
+	if (ret)
+		return 19;
+	return 0;
+}
+
 int do_df_filesystem(int nargs, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 83faa5b..d983588 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -34,7 +34,8 @@ int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
 int do_subvol_list(int nargs, char **argv);
 int do_set_default_subvol(int nargs, char **argv);
-int list_subvols(int fd, int print_parent);
+int do_get_default_subvol(int nargs, char **argv);
+int list_subvols(int fd, int print_parent, int get_default);
 int do_df_filesystem(int nargs, char **argv);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int do_find_newer(int argc, char **argv);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 84a60cd..61ce0df 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,6 +15,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
+.PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
@@ -126,6 +128,11 @@ Set the subvolume of the filesystem \fI<path>\fR which is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP
 
+\fBsubvolume get-default\fR\fI <path>\fR
+Get the default subvolume of the filesystem \fI<path>\fR. The output format
+is similar to \fBsubvolume list\fR command.
+.TP
+
 \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
 Defragment file data and/or directory metadata. To defragment all files in a
-- 
1.7.0.4

