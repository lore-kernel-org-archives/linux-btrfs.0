Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaENPfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 11:35:02 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4EFZ2hp016325
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 11:35:02 -0400
Message-ID: <53738D29.7020405@redhat.com>
Date: Wed, 14 May 2014 10:35:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: jshubin@redhat.com
Subject: [PATCH V2] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com>
In-Reply-To: <5372C457.3000706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow the specification of the filesystem UUID at mkfs time.

Non-unique unique IDs are rejected.

(Implemented only for mkfs.btrfs, not btrfs-convert).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: reject non-unique unique IDs.

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a8b2c51..d62d4f8 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2240,7 +2240,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 		goto fail;
 	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
-			 blocks, total_bytes, blocksize, blocksize,
+			 NULL, blocks, total_bytes, blocksize, blocksize,
 			 blocksize, blocksize, 0);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree: %s\n",
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index bef509d..4450d03 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -16,6 +16,7 @@ mkfs.btrfs \- create a btrfs filesystem
 [ \fB\-r\fP\fI rootdir\fP ]
 [ \fB\-K\fP ]
 [ \fB\-O\fP\fI feature1,feature2,...\fP ]
+[ \fB\-U\fP\fI uuid\fP ]
 [ \fB\-h\fP ]
 [ \fB\-V\fP ]
 \fI device\fP [ \fIdevice ...\fP ]
@@ -90,6 +91,9 @@ To see all run
 
 \fBmkfs.btrfs -O list-all\fR
 .TP
+\fB\-U\fR, \fB\-\-uuid \fR
+Create the filesystem with the specified UUID.
+.TP
 \fB\-V\fR, \fB\-\-version\fR
 Print the \fBmkfs.btrfs\fP version and exit.
 .SH UNIT
diff --git a/mkfs.c b/mkfs.c
index dbd83f5..eccb08f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -288,6 +288,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
 	fprintf(stderr, "\t -O --features comma separated list of filesystem features\n");
+	fprintf(stderr, "\t -U --uuid specify the filesystem UUID\n");
 	fprintf(stderr, "\t -V --version print the mkfs.btrfs version and exit\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
@@ -351,6 +352,7 @@ static struct option long_options[] = {
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
 	{ "features", 0, NULL, 'O' },
+	{ "uuid", 0, NULL, 'U' },
 	{ NULL, 0, NULL, 0}
 };
 
@@ -1273,11 +1275,12 @@ int main(int ac, char **av)
 	int dev_cnt = 0;
 	int saved_optind;
 	char estr[100];
+	char *fs_uuid = NULL;
 	u64 features = DEFAULT_MKFS_FEATURES;
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:VMK",
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:U:VMK",
 				long_options, &option_index);
 		if (c < 0)
 			break;
@@ -1346,6 +1349,9 @@ int main(int ac, char **av)
 				source_dir = optarg;
 				source_dir_set = 1;
 				break;
+			case 'U':
+				fs_uuid = optarg;
+				break;
 			case 'K':
 				discard = 0;
 				break;
@@ -1514,7 +1520,7 @@ int main(int ac, char **av)
 
 	process_fs_features(features);
 
-	ret = make_btrfs(fd, file, label, blocks, dev_block_count,
+	ret = make_btrfs(fd, file, label, fs_uuid, blocks, dev_block_count,
 			 nodesize, leafsize,
 			 sectorsize, stripesize, features);
 	if (ret) {
diff --git a/utils.c b/utils.c
index 3e9c527..48c9bb0 100644
--- a/utils.c
+++ b/utils.c
@@ -93,12 +93,41 @@ static u64 reference_root_table[] = {
 	[6] =	BTRFS_CSUM_TREE_OBJECTID,
 };
 
-int make_btrfs(int fd, const char *device, const char *label,
+int test_uuid_unique(char *fs_uuid)
+{
+	int unique = 1;
+	blkid_dev_iterate iter = NULL;
+	blkid_dev dev = NULL;
+	blkid_cache cache = NULL;
+
+	if (blkid_get_cache(&cache, 0) < 0) {
+		printf("ERROR: lblkid cache get failed\n");
+		return 1;
+	}
+	blkid_probe_all(cache);
+	iter = blkid_dev_iterate_begin(cache);
+	blkid_dev_set_search(iter, "UUID", fs_uuid);
+
+	while (blkid_dev_next(iter, &dev) == 0) {
+		dev = blkid_verify(cache, dev);
+		if (dev) {
+			unique = 0;
+			break;
+		}
+	}
+
+	blkid_dev_iterate_end(iter);
+	blkid_put_cache(cache);
+
+	return unique;
+}
+
+int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	       u64 blocks[7], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features)
 {
 	struct btrfs_super_block super;
-	struct extent_buffer *buf;
+	struct extent_buffer *buf = NULL;
 	struct btrfs_root_item root_item;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_extent_item *extent_item;
@@ -125,7 +154,19 @@ int make_btrfs(int fd, const char *device, const char *label,
 	memset(&super, 0, sizeof(super));
 
 	num_bytes = (num_bytes / sectorsize) * sectorsize;
-	uuid_generate(super.fsid);
+	if (fs_uuid) {
+		if (uuid_parse(fs_uuid, super.fsid) != 0) {
+			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
+			ret = -EINVAL;
+			goto out;
+		}
+		if (!test_uuid_unique(fs_uuid)) {
+			fprintf(stderr, "non-unique UUID: %s\n", fs_uuid);
+			ret = -EBUSY;
+			goto out;
+		}
+	} else
+		uuid_generate(super.fsid);
 	uuid_generate(super.dev_item.uuid);
 	uuid_generate(chunk_tree_uuid);
 

diff --git a/utils.h b/utils.h
index 3c62066..054cbb6 100644
--- a/utils.h
+++ b/utils.h
@@ -40,7 +40,7 @@
 #define BTRFS_UUID_UNPARSED_SIZE	37
 
 int make_btrfs(int fd, const char *device, const char *label,
-	       u64 blocks[6], u64 num_bytes, u32 nodesize,
+	       char *fs_uuid, u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);


