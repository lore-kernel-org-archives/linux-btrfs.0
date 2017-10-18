Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59226 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935996AbdJRIBJ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 18 Oct 2017 04:01:09 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 5/5] btrfs-progs: mkfs: Move source dir size calculation to its own files
Date: Wed, 18 Oct 2017 16:00:54 +0800
Message-Id: <20171018080054.25509-6-wqu@suse.com>
In-Reply-To: <20171018080054.25509-1-wqu@suse.com>
References: <20171018080054.25509-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also rename the function from size_sourcedir() to mkfs_size_dir().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c    | 66 ++--------------------------------------------------------
 mkfs/rootdir.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/rootdir.h |  2 ++
 3 files changed, 67 insertions(+), 64 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 693a9d85f6b6..e2ebe3ce069f 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -31,7 +31,6 @@
 #include <uuid/uuid.h>
 #include <ctype.h>
 #include <blkid/blkid.h>
-#include <ftw.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"
@@ -448,67 +447,6 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/*
- * This ignores symlinks with unreadable targets and subdirs that can't
- * be read.  It's a best-effort to give a rough estimate of the size of
- * a subdir.  It doesn't guarantee that prepopulating btrfs from this
- * tree won't still run out of space.
- */
-static u64 global_total_size;
-static u64 fs_block_size;
-static int ftw_add_entry_size(const char *fpath, const struct stat *st,
-			      int type)
-{
-	if (type == FTW_F || type == FTW_D)
-		global_total_size += round_up(st->st_size, fs_block_size);
-
-	return 0;
-}
-
-static u64 size_sourcedir(const char *dir_name, u64 sectorsize,
-			  u64 *num_of_meta_chunks_ret, u64 *size_of_data_ret)
-{
-	u64 dir_size = 0;
-	u64 total_size = 0;
-	int ret;
-	u64 default_chunk_size = SZ_8M;
-	u64 allocated_meta_size = SZ_8M;
-	u64 allocated_total_size = 20 * SZ_1M;	/* 20MB */
-	u64 num_of_meta_chunks = 0;
-	u64 num_of_data_chunks = 0;
-	u64 num_of_allocated_meta_chunks =
-			allocated_meta_size / default_chunk_size;
-
-	global_total_size = 0;
-	fs_block_size = sectorsize;
-	ret = ftw(dir_name, ftw_add_entry_size, 10);
-	dir_size = global_total_size;
-	if (ret < 0) {
-		error("ftw subdir walk of %s failed: %s", dir_name,
-			strerror(errno));
-		exit(1);
-	}
-
-	num_of_data_chunks = (dir_size + default_chunk_size - 1) /
-		default_chunk_size;
-
-	num_of_meta_chunks = (dir_size / 2) / default_chunk_size;
-	if (((dir_size / 2) % default_chunk_size) != 0)
-		num_of_meta_chunks++;
-	if (num_of_meta_chunks <= num_of_allocated_meta_chunks)
-		num_of_meta_chunks = 0;
-	else
-		num_of_meta_chunks -= num_of_allocated_meta_chunks;
-
-	total_size = allocated_total_size +
-		     (num_of_data_chunks * default_chunk_size) +
-		     (num_of_meta_chunks * default_chunk_size);
-
-	*num_of_meta_chunks_ret = num_of_meta_chunks;
-	*size_of_data_ret = num_of_data_chunks * default_chunk_size;
-	return total_size;
-}
-
 static int zero_output_file(int out_fd, u64 size)
 {
 	int loop_num;
@@ -1079,8 +1017,8 @@ int main(int argc, char **argv)
 			goto error;
 		}
 
-		source_dir_size = size_sourcedir(source_dir, sectorsize,
-					     &num_of_meta_chunks, &size_of_data);
+		source_dir_size = btrfs_mkfs_size_dir(source_dir, sectorsize,
+					&num_of_meta_chunks, &size_of_data);
 		if(block_count < source_dir_size)
 			block_count = source_dir_size;
 		ret = zero_output_file(fd, block_count);
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 2cc8a3ac06d8..83a3191d2bd7 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -24,6 +24,7 @@
 #include <dirent.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <ftw.h>
 #include "ctree.h"
 #include "internal.h"
 #include "disk-io.h"
@@ -33,6 +34,15 @@
 #include "mkfs/rootdir.h"
 #include "send-utils.h"
 
+/*
+ * This ignores symlinks with unreadable targets and subdirs that can't
+ * be read.  It's a best-effort to give a rough estimate of the size of
+ * a subdir.  It doesn't guarantee that prepopulating btrfs from this
+ * tree won't still run out of space.
+ */
+static u64 global_total_size;
+static u64 fs_block_size;
+
 static u64 index_cnt = 2;
 
 static int add_directory_items(struct btrfs_trans_handle *trans,
@@ -670,3 +680,56 @@ fail:
 out:
 	return ret;
 }
+
+static int ftw_add_entry_size(const char *fpath, const struct stat *st,
+			      int type)
+{
+	if (type == FTW_F || type == FTW_D)
+		global_total_size += round_up(st->st_size, fs_block_size);
+
+	return 0;
+}
+
+u64 btrfs_mkfs_size_dir(const char *dir_name, u64 sectorsize,
+			u64 *num_of_meta_chunks_ret, u64 *size_of_data_ret)
+{
+	u64 dir_size = 0;
+	u64 total_size = 0;
+	int ret;
+	u64 default_chunk_size = SZ_8M;
+	u64 allocated_meta_size = SZ_8M;
+	u64 allocated_total_size = 20 * SZ_1M;	/* 20MB */
+	u64 num_of_meta_chunks = 0;
+	u64 num_of_data_chunks = 0;
+	u64 num_of_allocated_meta_chunks =
+			allocated_meta_size / default_chunk_size;
+
+	global_total_size = 0;
+	fs_block_size = sectorsize;
+	ret = ftw(dir_name, ftw_add_entry_size, 10);
+	dir_size = global_total_size;
+	if (ret < 0) {
+		error("ftw subdir walk of %s failed: %s", dir_name,
+			strerror(errno));
+		exit(1);
+	}
+
+	num_of_data_chunks = (dir_size + default_chunk_size - 1) /
+		default_chunk_size;
+
+	num_of_meta_chunks = (dir_size / 2) / default_chunk_size;
+	if (((dir_size / 2) % default_chunk_size) != 0)
+		num_of_meta_chunks++;
+	if (num_of_meta_chunks <= num_of_allocated_meta_chunks)
+		num_of_meta_chunks = 0;
+	else
+		num_of_meta_chunks -= num_of_allocated_meta_chunks;
+
+	total_size = allocated_total_size +
+		     (num_of_data_chunks * default_chunk_size) +
+		     (num_of_meta_chunks * default_chunk_size);
+
+	*num_of_meta_chunks_ret = num_of_meta_chunks;
+	*size_of_data_ret = num_of_data_chunks * default_chunk_size;
+	return total_size;
+}
diff --git a/mkfs/rootdir.h b/mkfs/rootdir.h
index 68f88643bf7a..a557bd183f7b 100644
--- a/mkfs/rootdir.h
+++ b/mkfs/rootdir.h
@@ -27,4 +27,6 @@ struct directory_name_entry {
 
 int btrfs_mkfs_fill_dir(const char *source_dir, struct btrfs_root *root,
 			bool verbose);
+u64 btrfs_mkfs_size_dir(const char *dir_name, u64 sectorsize,
+			u64 *num_of_meta_chunks_ret, u64 *size_of_data_ret);
 #endif
-- 
2.14.2

