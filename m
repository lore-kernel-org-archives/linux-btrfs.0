Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:64701 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab3AFPcs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 10:32:48 -0500
Received: by mail-bk0-f42.google.com with SMTP id ji2so7983433bkc.15
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 07:32:47 -0800 (PST)
From: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
Subject: [PATCH] Btrfs-progs: add UUID switches to mkfs and convert
Date: Sun,  6 Jan 2013 16:32:11 +0100
Message-Id: <1357486331-4615-2-git-send-email-falbrechtskirchinger@gmail.com>
In-Reply-To: <1357486331-4615-1-git-send-email-falbrechtskirchinger@gmail.com>
References: <1357486331-4615-1-git-send-email-falbrechtskirchinger@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the following switches to mkfs.btrfs and update man page:
* -U UUID, --uuid UUID

Add the following switches to btrfs-convert:
* -U UUID
* -U new
  Generates a random UUID (default behavior).
* -U copy
  Copies the UUID from the ext2fs.

Signed-off-by: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
---
 convert.c           | 48 ++++++++++++++++++++++++++++++++++++++++--------
 man/mkfs.btrfs.8.in |  4 ++++
 mkfs.c              | 20 ++++++++++++++++++--
 utils.c             |  6 +++---
 utils.h             |  4 ++--
 5 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/convert.c b/convert.c
index fa7bf8c..67c8a87 100644
--- a/convert.c
+++ b/convert.c
@@ -2272,9 +2272,11 @@ err:
 	return ret;
 }
 
-int do_convert(const char *devname, int datacsum, int packing, int noxattr)
+int do_convert(const char *devname, int copy_fsid, u8 fsid[BTRFS_UUID_SIZE],
+	       int datacsum, int packing, int noxattr)
 {
 	int i, fd, ret;
+	u8 *fsid_ptr;
 	u32 blocksize;
 	u64 blocks[7];
 	u64 total_bytes;
@@ -2313,9 +2315,14 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		fprintf(stderr, "unable to open %s\n", devname);
 		goto fail;
 	}
+	if (copy_fsid) {
+		fsid_ptr = ext2_fs->super->s_uuid;
+	} else {
+		fsid_ptr = fsid;
+	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
-			 blocks, total_bytes, blocksize, blocksize,
-			 blocksize, blocksize);
+			 fsid_ptr, blocks, total_bytes,
+			 blocksize, blocksize, blocksize, blocksize);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree\n");
 		goto fail;
@@ -2752,23 +2759,28 @@ fail:
 
 static void print_usage(void)
 {
-	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] device\n");
+	printf("usage: btrfs-convert [-d] [-i] [-n] [-r]"
+	       " [-U UUID | new | copy] device\n");
 	printf("\t-d disable data checksum\n");
 	printf("\t-i ignore xattrs and ACLs\n");
 	printf("\t-n disable packing of small files\n");
 	printf("\t-r roll back to ext2fs\n");
+	printf("\t-U UUID specify FS UUID\n");
+	printf("\t-U new generate random FS UUID (default)\n");
+	printf("\t-U copy copy FS UUID from ext2fs\n");
 }
 
 int main(int argc, char *argv[])
 {
-	int ret;
+	int ret, copy_fsid = 0;
 	int packing = 1;
 	int noxattr = 0;
 	int datacsum = 1;
 	int rollback = 0;
-	char *file;
+	char *file, *fsid_str = NULL;
+	u8 fsid[BTRFS_UUID_SIZE];
 	while(1) {
-		int c = getopt(argc, argv, "dinr");
+		int c = getopt(argc, argv, "dinrU:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -2784,6 +2796,9 @@ int main(int argc, char *argv[])
 			case 'r':
 				rollback = 1;
 				break;
+			case 'U':
+				fsid_str = optarg;
+				break;
 			default:
 				print_usage();
 				return 1;
@@ -2801,10 +2816,27 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (fsid_str) {
+		if (strcmp(fsid_str, "new") == 0) {
+			uuid_generate(fsid);
+		} else if (strcmp(fsid_str, "copy") == 0) {
+			copy_fsid = 1;
+		} else {
+			if (uuid_parse(fsid_str, fsid) == -1) {
+				fprintf(stderr, "failed to parse UUID: %s\n",
+					fsid_str);
+				return 1;
+			}
+		}
+	} else {
+		uuid_generate(fsid);
+	}
+
 	if (rollback) {
 		ret = do_rollback(file, 0);
 	} else {
-		ret = do_convert(file, datacsum, packing, noxattr);
+		ret = do_convert(file, copy_fsid, fsid, datacsum, packing,
+				 noxattr);
 	}
 	if (ret)
 		return 1;
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 72025ed..73abcc0 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -12,6 +12,7 @@ mkfs.btrfs \- create a btrfs filesystem
 [ \fB\-M\fP\fI mixed data+metadata\fP ]
 [ \fB\-n\fP\fI nodesize\fP ]
 [ \fB\-s\fP\fI sectorsize\fP ]
+[ \fB\-U\fP\fI UUID\fP ]
 [ \fB\-r\fP\fI rootdir\fP ]
 [ \fB\-K\fP ]
 [ \fB\-h\fP ]
@@ -61,6 +62,9 @@ Specify the nodesize. By default the value is set to the pagesize.
 \fB\-s\fR, \fB\-\-sectorsize \fIsize\fR
 Specify the sectorsize, the minimum block allocation.
 .TP
+\fB\-U\fR, \fB\-\-uuid \fIUUID\fR
+Specify the UUID for the filesystem.
+.TP
 \fB\-r\fR, \fB\-\-rootdir \fIrootdir\fR
 Specify a directory to copy into the newly created fs.
 .TP
diff --git a/mkfs.c b/mkfs.c
index 47f0c9c..1bdb0d3 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -347,6 +347,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -M --mixed mix metadata and data together\n");
 	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
+	fprintf(stderr, "\t -U --uuid FS UUID\n");
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
@@ -407,6 +408,7 @@ static struct option long_options[] = {
 	{ "mixed", 0, NULL, 'M' },
 	{ "nodesize", 1, NULL, 'n' },
 	{ "sectorsize", 1, NULL, 's' },
+	{ "uuid", 1, NULL, 'U' },
 	{ "data", 1, NULL, 'd' },
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
@@ -1229,6 +1231,8 @@ int main(int ac, char **av)
 	struct btrfs_trans_handle *trans;
 	char *label = NULL;
 	char *first_file;
+	char *fsid_str = NULL;
+	u8 fsid[BTRFS_FSID_SIZE];
 	u64 block_count = 0;
 	u64 dev_block_count = 0;
 	u64 blocks[7];
@@ -1258,7 +1262,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VMK", long_options,
+		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:U:r:VMK", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1288,6 +1292,9 @@ int main(int ac, char **av)
 			case 's':
 				sectorsize = parse_size(optarg);
 				break;
+			case 'U':
+				fsid_str = optarg;
+				break;
 			case 'b':
 				block_count = parse_size(optarg);
 				if (block_count <= 1024*1024*1024) {
@@ -1375,13 +1382,22 @@ int main(int ac, char **av)
 		}
 	}
 
+	if(fsid_str) {
+		if(uuid_parse(fsid_str, fsid) == -1) {
+			fprintf(stderr, "failed to parse UUID: %s\n", fsid_str);
+			exit(1);
+		}
+	}
+	else
+		uuid_generate(fsid);
+
 	blocks[0] = BTRFS_SUPER_INFO_OFFSET;
 	for (i = 1; i < 7; i++) {
 		blocks[i] = BTRFS_SUPER_INFO_OFFSET + 1024 * 1024 +
 			leafsize * i;
 	}
 
-	ret = make_btrfs(fd, file, label, blocks, dev_block_count,
+	ret = make_btrfs(fd, file, label, fsid, blocks, dev_block_count,
 			 nodesize, leafsize,
 			 sectorsize, stripesize);
 	if (ret) {
diff --git a/utils.c b/utils.c
index 205e667..1ef6174 100644
--- a/utils.c
+++ b/utils.c
@@ -74,8 +74,8 @@ static u64 reference_root_table[] = {
 };
 
 int make_btrfs(int fd, const char *device, const char *label,
-	       u64 blocks[7], u64 num_bytes, u32 nodesize,
-	       u32 leafsize, u32 sectorsize, u32 stripesize)
+	       u8 fsid[BTRFS_FSID_SIZE], u64 blocks[7], u64 num_bytes,
+	       u32 nodesize, u32 leafsize, u32 sectorsize, u32 stripesize)
 {
 	struct btrfs_super_block super;
 	struct extent_buffer *buf;
@@ -103,7 +103,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	memset(&super, 0, sizeof(super));
 
 	num_bytes = (num_bytes / sectorsize) * sectorsize;
-	uuid_generate(super.fsid);
+	memcpy(super.fsid, fsid, BTRFS_FSID_SIZE);
 	uuid_generate(super.dev_item.uuid);
 	uuid_generate(chunk_tree_uuid);
 
diff --git a/utils.h b/utils.h
index 3a0368b..c201a14 100644
--- a/utils.h
+++ b/utils.h
@@ -22,8 +22,8 @@
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
 int make_btrfs(int fd, const char *device, const char *label,
-	       u64 blocks[6], u64 num_bytes, u32 nodesize,
-	       u32 leafsize, u32 sectorsize, u32 stripesize);
+	       u8 fsid[BTRFS_FSID_SIZE], u64 blocks[6], u64 num_bytes,
+	       u32 nodesize, u32 leafsize, u32 sectorsize, u32 stripesize);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-- 
1.8.0.3

