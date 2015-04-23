Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33809 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030364AbbDWQw7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 12:52:59 -0400
Received: by qcyk17 with SMTP id k17so12378615qcy.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 09:52:58 -0700 (PDT)
Message-ID: <55392369.8020603@gmail.com>
Date: Thu, 23 Apr 2015 12:52:57 -0400
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs-progs: optionally restore symlinks.
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <55392221.6090502@gmail.com>

Restore symlinks, optionally with owner/times.

Signed-off-by: Dan Merillat <dan.merillat@gmail.com>
---
 Documentation/btrfs-restore.asciidoc |   3 +
 cmds-restore.c                       | 140 ++++++++++++++++++++++++++++++++++-
 2 files changed, 140 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-restore.asciidoc b/Documentation/btrfs-restore.asciidoc
index 89e0c87..06a0498 100644
--- a/Documentation/btrfs-restore.asciidoc
+++ b/Documentation/btrfs-restore.asciidoc
@@ -32,6 +32,9 @@ get extended attributes.
 -m|--metadata::
 restore owner, mode and times.
 
+-S|--symlinks::
+restore symbolic links as well as normal files.
+
 -v::
 verbose.
 
diff --git a/cmds-restore.c b/cmds-restore.c
index 8869f2a..c7a3e96 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -45,9 +45,11 @@
 
 static char fs_name[PATH_MAX];
 static char path_name[PATH_MAX];
+static char symlink_target[PATH_MAX];
 static int get_snaps = 0;
 static int verbose = 0;
 static int restore_metadata = 0;
+static int restore_symlinks = 0;
 static int ignore_errors = 0;
 static int overwrite = 0;
 static int get_xattrs = 0;
@@ -812,6 +814,125 @@ static int overwrite_ok(const char * path)
 	return 1;
 }
 
+static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
+		     const char *file)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *extent_item;
+	struct btrfs_inode_item *inode_item;
+	u32 len;
+	int ret;
+
+	ret = overwrite_ok(path_name);
+	if (ret == 0)
+	    return 0; // skip this file.
+
+	if (ret == 2) { // symlink() can't overwrite, so unlink first.
+		ret = unlink(path_name);
+		if (ret) {
+			fprintf(stderr, "failed to unlink '%s' for overwrite\n",
+					path_name);
+			return ret;
+		}
+	}
+
+	key->type = BTRFS_EXTENT_DATA_KEY;
+	key->offset = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	leaf = path->nodes[0];
+	if (!leaf) {
+		fprintf(stderr, "Error getting leaf for symlink '%s'\n", file);
+		ret = -1;
+		goto out;
+	}
+
+	extent_item = btrfs_item_ptr(leaf, path->slots[0],
+			struct btrfs_file_extent_item);
+
+	len = btrfs_file_extent_inline_item_len(leaf,
+			btrfs_item_nr(path->slots[0]));
+	if (len > PATH_MAX) {
+		fprintf(stderr, "Symlink '%s' target length %d is longer than PATH_MAX\n",
+				fs_name, len);
+		ret = -1;
+		goto out;
+	}
+
+	u32 name_offset = (unsigned long) extent_item
+			+ offsetof(struct btrfs_file_extent_item, disk_bytenr);
+	read_extent_buffer(leaf, symlink_target, name_offset, len);
+
+	symlink_target[len] = 0;
+
+	if (!dry_run) {
+		ret = symlink(symlink_target, path_name);
+		if (ret<0) {
+			fprintf(stderr, "Failed to restore symlink '%s': %s\n",
+					path_name, strerror(errno));
+			goto out;
+		}
+	}
+	printf("SYMLINK: '%s' => '%s'\n", path_name, symlink_target);
+
+	ret = 0;
+	if (!restore_metadata)
+		goto out;
+
+	/* Symlink metadata operates differently than files/directories,
+	 * so do our own work here.
+	 */
+
+	key->type = BTRFS_INODE_ITEM_KEY;
+	key->offset = 0;
+
+	btrfs_release_path(path);
+
+	ret = btrfs_lookup_inode(NULL, root, path, key, 0);
+	if (ret) {
+		fprintf(stderr, "Failed to lookup inode for '%s'\n", file);
+		goto out;
+	}
+
+	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			struct btrfs_inode_item);
+
+	fchownat(-1, file, btrfs_inode_uid(path->nodes[0], inode_item),
+				   btrfs_inode_gid(path->nodes[0], inode_item),
+				   AT_SYMLINK_NOFOLLOW);
+	if (ret) {
+		fprintf(stderr, "Failed to change owner: %s\n",
+				strerror(errno));
+		goto out;
+	}
+
+	struct btrfs_timespec *bts;
+	struct timespec times[2];
+
+	bts = btrfs_inode_atime(inode_item);
+	times[0].tv_sec  = btrfs_timespec_sec(path->nodes[0], bts);
+	times[0].tv_nsec = btrfs_timespec_nsec(path->nodes[0], bts);
+
+	bts = btrfs_inode_mtime(inode_item);
+	times[1].tv_sec  = btrfs_timespec_sec(path->nodes[0], bts);
+	times[1].tv_nsec = btrfs_timespec_nsec(path->nodes[0], bts);
+
+	ret = utimensat(-1, file, times, AT_SYMLINK_NOFOLLOW);
+	if (ret)
+		fprintf(stderr, "Failed to set times: %s\n", strerror(errno));
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		      const char *output_rootdir, const char *in_dir,
 		      const regex_t *mreg)
@@ -924,8 +1045,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		snprintf(path_name, PATH_MAX, "%s%s", output_rootdir, fs_name);
 
 		/*
-		 * At this point we're only going to restore directories and
-		 * files, no symlinks or anything else.
+		 * Restore directories, files, symlinks and metadata.
 		 */
 		if (type == BTRFS_FT_REG_FILE) {
 			if (!overwrite_ok(path_name))
@@ -1032,6 +1152,15 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 					goto next;
 				goto out;
 			}
+		} else if (type == BTRFS_FT_SYMLINK) {
+			if (restore_symlinks)
+			ret = copy_symlink(root, &location, path_name);
+			if (ret<0) {
+				if (ignore_errors)
+					goto next;
+				btrfs_free_path(path);
+				return ret;
+			}
 		}
 next:
 		path->slots[0]++;
@@ -1258,6 +1387,7 @@ const char * const cmd_restore_usage[] = {
 	"-s              get snapshots",
 	"-x              get extended attributes",
 	"-m|--metadata   restore owner, mode and times",
+	"-S|--symlinks	 restore symbolic links"
 	"-v              verbose",
 	"-i              ignore errors",
 	"-o              overwrite",
@@ -1300,10 +1430,11 @@ int cmd_restore(int argc, char **argv)
 			{ "path-regex", required_argument, NULL, 256},
 			{ "dry-run", no_argument, NULL, 'D'},
 			{ "metadata", no_argument, NULL, 'm'},
+			{ "symlinks", no_argument, NULL, 'S'},
 			{ NULL, 0, NULL, 0}
 		};
 
-		opt = getopt_long(argc, argv, "sxviot:u:dmf:r:lDc", long_options,
+		opt = getopt_long(argc, argv, "sSxviot:u:dmf:r:lDc", long_options,
 					NULL);
 		if (opt < 0)
 			break;
@@ -1352,6 +1483,9 @@ int cmd_restore(int argc, char **argv)
 			case 'm':
 				restore_metadata = 1;
 				break;
+			case 'S':
+				restore_symlinks = 1;
+				break;
 			case 'D':
 				dry_run = 1;
 				break;
-- 
2.1.4

