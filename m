Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:34718 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbDUFs1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 01:48:27 -0400
Received: by qcyk17 with SMTP id k17so71065286qcy.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 22:48:26 -0700 (PDT)
Received: from ?IPv6:2001:470:8:414::10? (wolf.welp.gs. [2001:470:8:414::10])
        by mx.google.com with ESMTPSA id n83sm694770qkh.31.2015.04.20.22.48.25
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2015 22:48:26 -0700 (PDT)
Message-ID: <5535E4A8.8040600@gmail.com>
Date: Tue, 21 Apr 2015 01:48:24 -0400
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/1] btrfs-progs: optionally restore metadata
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As long as the inode is intact, the file metadata can be restored.
Directory data is restored at the end of search_dir.  Errors are
checked and returned, unless ignore_errors is requested.

Signed-off-by: Dan Merillat <dan.merillat@gmail.com>
---
 Documentation/btrfs-restore.txt |   3 ++
 cmds-restore.c                  | 114 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-restore.txt b/Documentation/btrfs-restore.txt
index 20fc366..a4e4d37 100644
--- a/Documentation/btrfs-restore.txt
+++ b/Documentation/btrfs-restore.txt
@@ -29,6 +29,9 @@ get snapshots, btrfs restore skips snapshots in default.
 -x::
 get extended attributes.
 
+-m|--metadata::
+set owner, permissions, access time and modify time.
+
 -v::
 verbose.
 
diff --git a/cmds-restore.c b/cmds-restore.c
index d2fc951..e95018f 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -48,6 +48,7 @@ static char fs_name[4096];
 static char path_name[4096];
 static int get_snaps = 0;
 static int verbose = 0;
+static int restore_metadata = 0;
 static int ignore_errors = 0;
 static int overwrite = 0;
 static int get_xattrs = 0;
@@ -547,6 +548,57 @@ out:
 	return ret;
 }
 
+static int copy_metadata(struct btrfs_root *root, int fd,
+		struct btrfs_key *key)
+{
+	struct btrfs_path *path;
+	struct btrfs_inode_item *inode_item;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		fprintf(stderr, "Ran out of memory\n");
+		return -ENOMEM;
+	}
+
+	ret = btrfs_lookup_inode(NULL, root, path, key, 0);
+	if (ret == 0) {
+
+		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_inode_item);
+
+		ret=fchown(fd, btrfs_inode_uid(path->nodes[0], inode_item),
+					   btrfs_inode_gid(path->nodes[0], inode_item));
+		if (ret) {
+			fprintf(stderr, "Failed to change owner: %s\n", strerror(errno));
+			goto out;
+		}
+		ret=fchmod(fd, btrfs_inode_mode(path->nodes[0], inode_item));
+		if (ret) {
+			fprintf(stderr, "Failed to change mode: %s\n", strerror(errno));
+			goto out;
+		}
+		struct btrfs_timespec *bts;
+		struct timespec times[2];
+
+		bts = btrfs_inode_atime(inode_item);
+		times[0].tv_sec=btrfs_timespec_sec(path->nodes[0], bts);
+		times[0].tv_nsec=btrfs_timespec_nsec(path->nodes[0], bts);
+
+		bts = btrfs_inode_mtime(inode_item);
+		times[1].tv_sec=btrfs_timespec_sec(path->nodes[0], bts);
+		times[1].tv_nsec=btrfs_timespec_nsec(path->nodes[0], bts);
+
+		ret=futimens(fd, times);
+		if (ret) {
+			fprintf(stderr, "Failed to set times: %s\n", strerror(errno));
+			goto out;
+		}
+	}
+out:
+	btrfs_release_path(path);
+	return ret;
+}
 
 static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		     const char *file)
@@ -555,6 +607,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_inode_item *inode_item;
+	struct btrfs_timespec *bts;
 	struct btrfs_key found_key;
 	int ret;
 	int extent_type;
@@ -567,12 +620,41 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		fprintf(stderr, "Ran out of memory\n");
 		return -ENOMEM;
 	}
+	struct timespec times[2];
+	int times_ok=0;
 
 	ret = btrfs_lookup_inode(NULL, root, path, key, 0);
 	if (ret == 0) {
 		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_inode_item);
 		found_size = btrfs_inode_size(path->nodes[0], inode_item);
+
+		if (restore_metadata) {
+			/* change the ownership and mode now, set times when
+			 * copyout is finished */
+
+			ret=fchown(fd, btrfs_inode_uid(path->nodes[0], inode_item),
+						   btrfs_inode_gid(path->nodes[0], inode_item));
+			if (ret && !ignore_errors) {
+				btrfs_release_path(path);
+				return ret;
+			}
+
+			ret=fchmod(fd, btrfs_inode_mode(path->nodes[0], inode_item));
+			if (ret && !ignore_errors) {
+				btrfs_release_path(path);
+				return ret;
+			}
+
+			bts = btrfs_inode_atime(inode_item);
+			times[0].tv_sec=btrfs_timespec_sec(path->nodes[0], bts);
+			times[0].tv_nsec=btrfs_timespec_nsec(path->nodes[0], bts);
+
+			bts = btrfs_inode_mtime(inode_item);
+			times[1].tv_sec=btrfs_timespec_sec(path->nodes[0], bts);
+			times[1].tv_nsec=btrfs_timespec_nsec(path->nodes[0], bts);
+			times_ok=1;
+		}
 	}
 	btrfs_release_path(path);
 
@@ -680,6 +762,11 @@ set_size:
 		if (ret)
 			return ret;
 	}
+	if (restore_metadata && times_ok) {
+		ret=futimens(fd, times);
+		if (ret)
+			return ret;
+	}
 	return 0;
 }
 
@@ -929,6 +1016,25 @@ next:
 		path->slots[0]++;
 	}
 
+	if (restore_metadata) {
+		snprintf(path_name, 4096, "%s%s", output_rootdir, in_dir);
+		fd = open(path_name, O_RDONLY);
+		if (fd < 0) {
+			fprintf(stderr, "Failed to access %s to restore metadata\n", path_name);
+			if (!ignore_errors)
+				return -1;
+		} else {
+			// set owner/mode/time on the directory as well
+			key->type=BTRFS_INODE_ITEM_KEY;
+			ret=copy_metadata(root, fd, key);
+			close(fd);
+			if (ret && !ignore_errors) {
+				btrfs_free_path(path);
+				return ret;
+			}
+		}
+	}
+
 	if (verbose)
 		printf("Done searching %s\n", in_dir);
 	btrfs_free_path(path);
@@ -1126,6 +1232,7 @@ const char * const cmd_restore_usage[] = {
 	"",
 	"-s              get snapshots",
 	"-x              get extended attributes",
+	"-m|--metadata   restore owner, mode and times",
 	"-v              verbose",
 	"-i              ignore errors",
 	"-o              overwrite",
@@ -1168,10 +1275,12 @@ int cmd_restore(int argc, char **argv)
 		static const struct option long_options[] = {
 			{ "path-regex", 1, NULL, 256},
 			{ "dry-run", 0, NULL, 'D'},
+			{ "metadata", 0, NULL, 'm'},
+			{ "debug-regex", 0, NULL, 257},
 			{ NULL, 0, NULL, 0}
 		};
 
-		opt = getopt_long(argc, argv, "sxviot:u:df:r:lDc", long_options,
+		opt = getopt_long(argc, argv, "sxviot:u:dmf:r:lDc", long_options,
 					&option_index);
 		if (opt < 0)
 			break;
@@ -1217,6 +1326,9 @@ int cmd_restore(int argc, char **argv)
 			case 'l':
 				list_roots = 1;
 				break;
+			case 'm':
+				restore_metadata = 1;
+				break;
 			case 'D':
 				dry_run = 1;
 				break;
-- 
2.1.4
