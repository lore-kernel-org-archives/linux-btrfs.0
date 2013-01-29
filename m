Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab3A2UlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 15:41:14 -0500
Message-ID: <510833E4.6080609@redhat.com>
Date: Tue, 29 Jan 2013 14:41:08 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH 2/2, RFC] btrfs-progs: overhaul mkfs.btrfs -r option
References: <510831DC.4070709@redhat.com>
In-Reply-To: <510831DC.4070709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The manpage for the "-r" option simply says that
it will copy the path specified to -r into the newly
made filesystem.

There's not a lot of reason to treat that option as differently
as it is now - today it ignores discard, fs size, and mixed
options, for example.  It also failed to check whether the
target device was mounted before proceeding.  Etc...

Rework things so that we really follow the same paths whether
or not -r is specified, but with one special case for -r:

* If the device does not exist, it will be created as
  a regular file of the minimum size to hold the -r path,
  or of size specified by the -b option.

This also changes a little behavior; it does not pre-fill
the new file with zeros, but allows it to be sparse, and does
not truncate an existing device file.  If you want to start
with an empty file, just don't point it at an existing
file...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Lightly tested . . 

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 72025ed..c9f9e4f 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -63,6 +63,12 @@ Specify the sectorsize, the minimum block allocation.
 .TP
 \fB\-r\fR, \fB\-\-rootdir \fIrootdir\fR
 Specify a directory to copy into the newly created fs.
+This option is limited to a single device.  As a special
+case for this option, if the device does not exist,
+it will be created as a regular file of either the minimum
+required size, or the size specified by the
+\fB\-b\fR
+option.
 .TP
 \fB\-K\fR, \fB\-\-nodiscard \fR
 Do not perform whole device TRIM operation by default.
diff --git a/mkfs.c b/mkfs.c
index 940702d..129fae8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1020,15 +1020,6 @@ fail_no_files:
 	return -1;
 }
 
-static int open_target(char *output_name)
-{
-	int output_fd;
-	output_fd = open(output_name, O_CREAT | O_RDWR | O_TRUNC,
-		         S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
-
-	return output_fd;
-}
-
 static int create_chunks(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, u64 num_of_meta_chunks,
 			 u64 size_of_data)
@@ -1150,28 +1141,6 @@ static u64 size_sourcedir(char *dir_name, u64 sectorsize,
 	return total_size;
 }
 
-static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
-{
-	int len = sectorsize;
-	int loop_num = size / sectorsize;
-	u64 location = 0;
-	char *buf = malloc(len);
-	int ret = 0, i;
-	ssize_t written;
-
-	if (!buf)
-		return -ENOMEM;
-	memset(buf, 0, len);
-	for (i = 0; i < loop_num; i++) {
-		written = pwrite64(out_fd, buf, len, location);
-		if (written != len)
-			ret = -EIO;
-		location += sectorsize;
-	}
-	free(buf);
-	return ret;
-}
-
 static int check_leaf_or_node_size(u32 size, u32 sectorsize)
 {
 	if (size < sectorsize) {
@@ -1291,55 +1260,74 @@ int main(int ac, char **av)
 	if (ac == 0)
 		print_usage();
 
+	if (source_dir && ac > 1) {
+		fprintf(stderr,
+			"The -r option is limited to a single device\n");
+		exit(1);
+	}
+
 	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
-	if (source_dir == 0) {
-		file = av[optind++];
-		ret = check_mounted(file);
-		if (ret < 0) {
-			fprintf(stderr, "error checking %s mount status\n", file);
-			exit(1);
-		}
-		if (ret == 1) {
-			fprintf(stderr, "%s is mounted\n", file);
-			exit(1);
-		}
-		ac--;
-		fd = open(file, O_RDWR);
-		if (fd < 0) {
-			fprintf(stderr, "unable to open %s\n", file);
-			exit(1);
-		}
-		first_file = file;
-		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
-					   block_count, &mixed, nodiscard);
-		if (block_count && block_count > dev_block_count) {
-			fprintf(stderr, "%s is smaller than requested size\n", file);
-			exit(1);
-		}
-	} else {
-		ac = 0;
-		file = av[optind++];
-		fd = open_target(file);
-		if (fd < 0) {
-			fprintf(stderr, "unable to open the %s\n", file);
-			exit(1);
-		}
+	file = av[optind++];
+	ac--; /* used that arg */
 
-		first_file = file;
+	ret = check_mounted(file);
+	if (ret < 0) {
+		fprintf(stderr, "error checking %s mount status\n", file);
+		exit(1);
+	}
+	if (ret == 1) {
+		fprintf(stderr, "%s is mounted\n", file);
+		exit(1);
+	}
+
+	first_file = file;
+
+	if (source_dir) {
 		source_dir_size = size_sourcedir(source_dir, sectorsize,
 					     &num_of_meta_chunks, &size_of_data);
-		if(block_count < source_dir_size)
+		if (!block_count) {
 			block_count = source_dir_size;
-		ret = zero_output_file(fd, block_count, sectorsize);
-		if (ret) {
-			fprintf(stderr, "unable to zero the output file\n");
+		} else if (block_count < source_dir_size) {
+			fprintf(stderr,
+				"%s requires %llu, requested size %llu\n",
+				source_dir, source_dir_size, block_count);
 			exit(1);
 		}
-		/* our "device" is the new image file */
-		dev_block_count = block_count;
 	}
+
+	fd = open(file, O_RDWR);
+
+	/*
+	 * As a special case for the -r option, if the device file does not
+	 * exist, create a regular file with the appropriate size.
+	 */
+	if (fd < 0 && errno == ENOENT && source_dir) {
+		fd = open(file, O_CREAT | O_RDWR,
+				S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+		if (fd >= 0) {
+			ret = ftruncate(fd, block_count);
+			if (ret < 0) {
+				fprintf(stderr, "unable to truncate %s\n", file);
+				exit(1);
+			}
+		}
+	}
+
+	if (fd < 0) {
+		fprintf(stderr, "unable to open %s\n", file);
+		exit(1);
+	}
+
+	ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
+				   block_count, &mixed, nodiscard);
+
+	if (block_count && block_count > dev_block_count) {
+		fprintf(stderr, "%s is smaller than requested size\n", file);
+		exit(1);
+	}
+
 	if (mixed) {
 		if (metadata_profile != data_profile) {
 			fprintf(stderr, "With mixed block groups data and metadata "
diff --git a/utils.c b/utils.c
index 938f9a5..344ba2e 100644
--- a/utils.c
+++ b/utils.c
@@ -808,6 +808,9 @@ int check_mounted(const char* file)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
+		/* if the file isn't there, it is clearly not mounted! */
+		if (errno == ENOENT)
+			return 0;
 		fprintf (stderr, "check_mounted(): Could not open %s\n", file);
 		return -errno;
 	}

