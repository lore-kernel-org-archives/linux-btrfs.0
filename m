Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:57256 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaDOSr0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 14:47:26 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so10014462wes.15
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 11:47:25 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: allow compression property gets for read-only subvolumes
Date: Tue, 15 Apr 2014 20:47:27 +0100
Message-Id: <1397591247-25376-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because the function open_file_or_dir() always opened the input file in
read/write mode (O_RDWR), we were not able to due a compression property
get against a file living in a read-only subvolume/snapshot.
Fix this by opening the file with O_RDONLY mode if we're doing a property
get.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 props.c | 3 ++-
 utils.c | 9 +++++++--
 utils.h | 1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/props.c b/props.c
index 4d0aeea..bd74975 100644
--- a/props.c
+++ b/props.c
@@ -119,8 +119,9 @@ static int prop_compression(enum prop_object_type type,
 	DIR *dirstream = NULL;
 	char *buf = NULL;
 	char *xattr_name = NULL;
+	int open_flags = value ? O_RDWR : O_RDONLY;
 
-	fd = open_file_or_dir(object, &dirstream);
+	fd = open_file_or_dir3(object, &dirstream, open_flags);
 	if (fd == -1) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: open %s failed. %s\n",
diff --git a/utils.c b/utils.c
index 0bfb9d9..458ba54 100644
--- a/utils.c
+++ b/utils.c
@@ -1625,7 +1625,7 @@ u64 parse_size(char *s)
 	return strtoull(s, NULL, 10) * mult;
 }
 
-int open_file_or_dir(const char *fname, DIR **dirstream)
+int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
 {
 	int ret;
 	struct stat st;
@@ -1641,7 +1641,7 @@ int open_file_or_dir(const char *fname, DIR **dirstream)
 			return -1;
 		fd = dirfd(*dirstream);
 	} else if (S_ISREG(st.st_mode) || S_ISLNK(st.st_mode)) {
-		fd = open(fname, O_RDWR);
+		fd = open(fname, open_flags);
 	} else {
 		/*
 		 * we set this on purpose, in case the caller output
@@ -1658,6 +1658,11 @@ int open_file_or_dir(const char *fname, DIR **dirstream)
 	return fd;
 }
 
+int open_file_or_dir(const char *fname, DIR **dirstream)
+{
+	return open_file_or_dir3(fname, dirstream, O_RDWR);
+}
+
 void close_file_or_dir(int fd, DIR *dirstream)
 {
 	if (dirstream)
diff --git a/utils.h b/utils.h
index 06ec938..fc581ca 100644
--- a/utils.h
+++ b/utils.h
@@ -73,6 +73,7 @@ int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
 u64 arg_strtou64(const char *str);
 int open_file_or_dir(const char *fname, DIR **dirstream);
+int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags);
 void close_file_or_dir(int fd, DIR *dirstream);
 int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
-- 
1.9.1

