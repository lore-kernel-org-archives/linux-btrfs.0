From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH] mkfs.btrfs: Fix compilation errors with gcc 4.6
Date: Sun, 26 Jun 2011 19:45:45 +0100
Message-ID: <2d8e41df20f9b3f82cc9796d391c14082c8aae1e.1309113811.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

gcc 4.6 complains about several possible use-before-initialise cases
in mkfs, and stops. Fix these by initialising one of the variables in
question, and using the correct error-handling paths for the
remainder.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 mkfs.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 3a87d6e..edd7018 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -750,7 +750,7 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 			  ino_t parent_inum, struct stat *st,
 			  const char *path_name, int out_fd)
 {
-	int ret;
+	int ret = -1;
 	ssize_t ret_read;
 	u64 bytes_read = 0;
 	char *buffer = NULL;
@@ -889,7 +889,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	ret = btrfs_lookup_inode(trans, root, &path, &root_dir_key, 1);
 	if (ret) {
 		fprintf(stderr, "root dir lookup error\n");
-		goto fail;
+		return -1;
 	}
 
 	leaf = path.nodes[0];
@@ -913,7 +913,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		if (chdir(parent_dir_entry->path)) {
 			fprintf(stderr, "chdir error for %s\n",
 				parent_dir_name);
-			goto fail;
+			goto fail_no_files;
 		}
 
 		count = scandir(parent_dir_entry->path, &files,
@@ -996,6 +996,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	return 0;
 fail:
 	free_namelist(files, count);
+fail_no_files:
 	free(parent_dir_entry->path);
 	free(parent_dir_entry);
 	return -1;
-- 
1.7.2.5

