Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48820 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753755AbdK2JQd (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:33 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 8/9] btrfs-progs: mkfs: Use the whole file or block device to mkfs for rootdir
Date: Wed, 29 Nov 2017 17:16:03 +0800
Message-Id: <20171129091604.2194-9-wqu@suse.com>
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
References: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For --rootdir, even for large existing file or block device, it will
always shrink the result filesystem.

The problem is, mkfs.btrfs will try to calculate the dir size, and use
it as @block_count to mkfs, which makes the result filesystem shrinked.

Fix by trying to get the original block device or file size as
@block_count, so mkfs.btrfs can use the full file/block device for
--rootdir option.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 22 ++++++++++++++++++++--
 utils.c     |  2 +-
 utils.h     |  1 +
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index a34b73bfb845..eeeba9292856 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -995,13 +995,31 @@ int main(int argc, char **argv)
 	 * This must be done before minimal device size check.
 	 */
 	if (source_dir_set) {
-		fd = open(file, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR | S_IRGRP |
-			  S_IWGRP | S_IROTH);
+		int oflags = O_RDWR;
+		struct stat statbuf;
+
+		if (is_path_exist(file) == 0)
+			oflags |= O_CREAT;
+
+		fd = open(file, oflags , S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP |
+					 S_IROTH);
 		if (fd < 0) {
 			error("unable to open %s: %s", file, strerror(errno));
 			goto error;
 		}
+		ret = fstat(fd, &statbuf);
+		if (ret < 0) {
+			error("unable to stat %s: %s", file, strerror(errno));
+			ret = -errno;
+			goto error;
+		}
 
+		/*
+		 * Block_count not specified, use file/dev size first.
+		 * Or we will always use source_dir_size calculated for mkfs.
+		 */
+		if (!block_count)
+			block_count = btrfs_device_size(fd, &statbuf);
 		source_dir_size = btrfs_mkfs_size_dir(source_dir, sectorsize,
 				min_dev_size, metadata_profile, data_profile);
 		if (block_count < source_dir_size)
diff --git a/utils.c b/utils.c
index 22c137514592..80071e23fe2b 100644
--- a/utils.c
+++ b/utils.c
@@ -447,7 +447,7 @@ int is_mount_point(const char *path)
 	return ret;
 }
 
-static int is_reg_file(const char *path)
+int is_reg_file(const char *path)
 {
 	struct stat statbuf;
 
diff --git a/utils.h b/utils.h
index 860c25d3cdba..bd7484fd3620 100644
--- a/utils.h
+++ b/utils.h
@@ -123,6 +123,7 @@ char *__strncpy_null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
 int is_mount_point(const char *file);
 int is_path_exist(const char *file);
+int is_reg_file(const char *path);
 int check_arg_type(const char *input);
 int open_path_or_dev_mnt(const char *path, DIR **dirstream, int verbose);
 int btrfs_open(const char *path, DIR **dirstream, int verbose, int dir_only);
-- 
2.15.0

