Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41403 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaKXFX0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 00:23:26 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id sAO5NPnk011689
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:23:25 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sAO5NO4r013537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:23:24 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id sAO5NNdU005062
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:23:23 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH] Btrfs-progs: support sha256 checksum algorithm
Date: Mon, 24 Nov 2014 13:23:06 +0800
Message-Id: <1416806586-18050-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the progs side patch to support sha256.

Sha256 can be seleted on mkfs stage, "mkfs.btrfs -C 256 /device"

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 Makefile           |   6 +-
 btrfs-convert.c    |  24 +++--
 btrfs-find-root.c  |   6 +-
 btrfs-image.c      |  35 ++++---
 btrfs-show-super.c |   9 +-
 chunk-recover.c    |  22 ++--
 cmds-check.c       |  17 ++--
 ctree.h            |   4 +-
 disk-io.c          |  32 ++----
 file-item.c        |  13 +--
 free-space-cache.c |   9 +-
 hash.c             |  32 ++++++
 hash.h             |   3 +
 kerncompat.h       |  14 +++
 mkfs.c             |  20 +++-
 sha256.c           | 290 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 sha256.h           |  42 ++++++++
 super-recover.c    |  11 +-
 utils.c            |  30 ++++--
 utils.h            |   3 +-
 20 files changed, 514 insertions(+), 108 deletions(-)
 create mode 100644 hash.c
 create mode 100644 sha256.c
 create mode 100644 sha256.h

diff --git a/Makefile b/Makefile
index 4cae30c..4b1cf1c 100644
--- a/Makefile
+++ b/Makefile
@@ -17,10 +17,10 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
-		   uuid-tree.o utils-lib.o rbtree-utils.o
+		   uuid-tree.o utils-lib.o rbtree-utils.o sha256.o hash.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
-	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
-	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
+	       crc32c.h sha256.h hash.h list.h kerncompat.h radix-tree.h \
+	       extent-cache.h extent_io.h ioctl.h ctree.h btrfsck.h version.h
 TESTS = fsck-tests.sh convert-tests.sh
 
 INSTALL = install
diff --git a/btrfs-convert.c b/btrfs-convert.c
index a544fc6..fba72b8 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -36,7 +36,7 @@
 #include "disk-io.h"
 #include "volumes.h"
 #include "transaction.h"
-#include "crc32c.h"
+#include "hash.h"
 #include "utils.h"
 #include <ext2fs/ext2_fs.h>
 #include <ext2fs/ext2fs.h>
@@ -2197,7 +2197,7 @@ err:
 }
 
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
-	       int copylabel, const char *fslabel)
+	       int copylabel, const char *fslabel, int csum_size)
 {
 	int i, ret;
 	int fd = -1;
@@ -2241,7 +2241,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
 			 NULL, blocks, total_bytes, blocksize, blocksize,
-			 blocksize, blocksize, 0);
+			 blocksize, blocksize, 0, csum_size);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree: %s\n",
 			strerror(-ret));
@@ -2696,13 +2696,14 @@ fail:
 
 static void print_usage(void)
 {
-	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] [-l label] [-L] device\n");
+	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] [-l label] [-L] [-C csum_size] device\n");
 	printf("\t-d           disable data checksum\n");
 	printf("\t-i           ignore xattrs and ACLs\n");
 	printf("\t-n           disable packing of small files\n");
 	printf("\t-r           roll back to ext2fs\n");
 	printf("\t-l LABEL     set filesystem label\n");
 	printf("\t-L           use label from converted fs\n");
+	printf("\t-C           specify the filesystem checksum size, only 32 and 256 are supported\n");
 }
 
 int main(int argc, char *argv[])
@@ -2716,9 +2717,10 @@ int main(int argc, char *argv[])
 	int usage_error = 0;
 	char *file;
 	char *fslabel = NULL;
+	int csum_size = BTRFS_CRC32_SIZE;
 
 	while(1) {
-		int c = getopt(argc, argv, "dinrl:L");
+		int c = getopt(argc, argv, "dinrl:LC:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -2747,6 +2749,16 @@ int main(int argc, char *argv[])
 			case 'L':
 				copylabel = 1;
 				break;
+			case 'C':
+				csum_size = parse_size(optarg);
+
+				if (csum_size != (BTRFS_CRC32_SIZE << 3) &&
+				    csum_size != (BTRFS_SHA256_SIZE << 3)) {
+					print_usage();
+					return 1;
+				}
+				csum_size = csum_size >> 3;
+				break;
 			default:
 				print_usage();
 				return 1;
@@ -2784,7 +2796,7 @@ int main(int argc, char *argv[])
 	if (rollback) {
 		ret = do_rollback(file);
 	} else {
-		ret = do_convert(file, datacsum, packing, noxattr, copylabel, fslabel);
+		ret = do_convert(file, datacsum, packing, noxattr, copylabel, fslabel, csum_size);
 	}
 	if (ret)
 		return 1;
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 6fa61cc..9f7ec84 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -33,7 +33,7 @@
 #include "version.h"
 #include "volumes.h"
 #include "utils.h"
-#include "crc32c.h"
+#include "hash.h"
 
 static u16 csum_size = 0;
 static u64 search_objectid = BTRFS_ROOT_TREE_OBJECTID;
@@ -49,7 +49,6 @@ static void usage(void)
 static int csum_block(void *buf, u32 len)
 {
 	char *result;
-	u32 crc = ~(u32)0;
 	int ret = 0;
 
 	result = malloc(csum_size * sizeof(char));
@@ -59,8 +58,7 @@ static int csum_block(void *buf, u32 len)
 	}
 
 	len -= BTRFS_CSUM_SIZE;
-	crc = crc32c(crc, buf + BTRFS_CSUM_SIZE, len);
-	btrfs_csum_final(crc, result);
+	btrfs_csum(buf + BTRFS_CSUM_SIZE, len, (u8 *)result, csum_size);
 
 	if (memcmp(buf, result, csum_size))
 		ret = 1;
diff --git a/btrfs-image.c b/btrfs-image.c
index cb17f16..74e31d8 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -28,7 +28,7 @@
 #include <dirent.h>
 #include <zlib.h>
 #include "kerncompat.h"
-#include "crc32c.h"
+#include "hash.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -103,6 +103,7 @@ struct metadump_struct {
 	u64 pending_start;
 	u64 pending_size;
 
+	int csum_size;
 	int compress_level;
 	int done;
 	int data;
@@ -131,6 +132,7 @@ struct mdrestore_struct {
 	struct list_head list;
 	size_t num_items;
 	u32 leafsize;
+	u16 csum_size;
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
 	u8 fsid[BTRFS_FSID_SIZE];
@@ -149,13 +151,13 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 				   u64 search, u64 cluster_bytenr);
 static struct extent_buffer *alloc_dummy_eb(u64 bytenr, u32 size);
 
-static void csum_block(u8 *buf, size_t len)
+static void csum_block(u8 *buf, size_t len, int csum_size)
 {
-	char result[BTRFS_CRC32_SIZE];
-	u32 crc = ~(u32)0;
-	crc = crc32c(crc, buf + BTRFS_CSUM_SIZE, len - BTRFS_CSUM_SIZE);
-	btrfs_csum_final(crc, result);
-	memcpy(buf, result, BTRFS_CRC32_SIZE);
+	char result[BTRFS_CSUM_SIZE];
+
+	btrfs_csum(buf + BTRFS_CSUM_SIZE, len - BTRFS_CSUM_SIZE,
+		   (u8 *)result, csum_size);
+	memcpy(buf, result, BTRFS_CSUM_SIZE);
 }
 
 static int has_name(struct btrfs_key *key)
@@ -577,7 +579,7 @@ static void copy_buffer(struct metadump_struct *md, u8 *dst,
 			sizeof(struct btrfs_key_ptr) * nritems;
 		memset(dst + size, 0, src->len - size);
 	}
-	csum_block(dst, src->len);
+	csum_block(dst, src->len, md->csum_size);
 }
 
 static void *dump_worker(void *data)
@@ -687,6 +689,7 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 	INIT_LIST_HEAD(&md->ordered);
 	md->root = root;
 	md->out = out;
+	md->csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	md->pending_start = (u64)-1;
 	md->compress_level = compress_level;
 	md->cluster = calloc(1, BLOCK_SIZE);
@@ -1344,6 +1347,7 @@ static void update_super_old(u8 *buffer)
 	struct btrfs_disk_key *key;
 	u32 sectorsize = btrfs_super_sectorsize(super);
 	u64 flags = btrfs_super_flags(super);
+	u16 csum_size = btrfs_super_csum_size(super);
 
 	flags |= BTRFS_SUPER_FLAG_METADUMP;
 	btrfs_set_super_flags(super, flags);
@@ -1369,7 +1373,7 @@ static void update_super_old(u8 *buffer)
 	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
 	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
 	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
-	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
+	csum_block(buffer, BTRFS_SUPER_INFO_SIZE, csum_size);
 }
 
 static int update_super(u8 *buffer)
@@ -1383,6 +1387,7 @@ static int update_super(u8 *buffer)
 	u32 cur = 0;
 	u8 *ptr, *write_ptr;
 	int old_num_stripes;
+	u16 csum_size = btrfs_super_csum_size(super);
 
 	write_ptr = ptr = super->sys_chunk_array;
 	array_size = btrfs_super_sys_array_size(super);
@@ -1423,7 +1428,7 @@ static int update_super(u8 *buffer)
 	}
 
 	btrfs_set_super_sys_array_size(super, new_array_size);
-	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
+	csum_block(buffer, BTRFS_SUPER_INFO_SIZE, csum_size);
 
 	return 0;
 }
@@ -1540,7 +1545,7 @@ static int fixup_chunk_tree_block(struct mdrestore_struct *mdres,
 					    sizeof(chunk));
 		}
 		memcpy(buffer, eb->data, eb->len);
-		csum_block(buffer, eb->len);
+		csum_block(buffer, eb->len, mdres->csum_size);
 next:
 		size_left -= mdres->leafsize;
 		buffer += mdres->leafsize;
@@ -1559,6 +1564,7 @@ static void write_backup_supers(int fd, u8 *buf)
 	u64 bytenr;
 	int i;
 	int ret;
+	u16 csum_size = btrfs_super_csum_size(super);
 
 	if (fstat(fd, &st)) {
 		fprintf(stderr, "Couldn't stat restore point, won't be able "
@@ -1573,7 +1579,7 @@ static void write_backup_supers(int fd, u8 *buf)
 		if (bytenr + BTRFS_SUPER_INFO_SIZE > size)
 			break;
 		btrfs_set_super_bytenr(super, bytenr);
-		csum_block(buf, BTRFS_SUPER_INFO_SIZE);
+		csum_block(buf, BTRFS_SUPER_INFO_SIZE, csum_size);
 		ret = pwrite64(fd, buf, BTRFS_SUPER_INFO_SIZE, bytenr);
 		if (ret < BTRFS_SUPER_INFO_SIZE) {
 			if (ret < 0)
@@ -1831,6 +1837,7 @@ static int fill_mdres_info(struct mdrestore_struct *mdres,
 
 	super = (struct btrfs_super_block *)outbuf;
 	mdres->leafsize = btrfs_super_leafsize(super);
+	mdres->csum_size = btrfs_super_csum_size(super);
 	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
 	memcpy(mdres->uuid, super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
@@ -2240,6 +2247,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 	super = (struct btrfs_super_block *)buffer;
 	chunk_root_bytenr = btrfs_super_chunk_root(super);
 	mdres->leafsize = btrfs_super_leafsize(super);
+	mdres->csum_size = btrfs_super_csum_size(super);
 	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
 	memcpy(mdres->uuid, super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
@@ -2440,7 +2448,8 @@ static int update_disk_super_on_device(struct btrfs_fs_info *info,
 	btrfs_set_stack_device_sector_size(dev_item, sector_size);
 	memcpy(dev_item->uuid, dev_uuid, BTRFS_UUID_SIZE);
 	memcpy(dev_item->fsid, fs_uuid, BTRFS_UUID_SIZE);
-	csum_block((u8 *)buf, BTRFS_SUPER_INFO_SIZE);
+	csum_block((u8 *)buf, BTRFS_SUPER_INFO_SIZE,
+		   btrfs_super_csum_size(info->super_copy));
 
 	ret = pwrite64(fp, buf, BTRFS_SUPER_INFO_SIZE, BTRFS_SUPER_INFO_OFFSET);
 	if (ret != BTRFS_SUPER_INFO_SIZE) {
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 2b48f44..b3e22cc 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -35,7 +35,7 @@
 #include "list.h"
 #include "version.h"
 #include "utils.h"
-#include "crc32c.h"
+#include "hash.h"
 
 static void print_usage(void);
 static void dump_superblock(struct btrfs_super_block *sb, int full);
@@ -170,11 +170,10 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr, int full,
 static int check_csum_sblock(void *sb, int csum_size)
 {
 	char result[BTRFS_CSUM_SIZE];
-	u32 crc = ~(u32)0;
 
-	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE,
-				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-	btrfs_csum_final(crc, result);
+	btrfs_csum((char *)sb + BTRFS_CSUM_SIZE,
+		   BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE,
+		   (u8 *)result, csum_size);
 
 	return !memcmp(sb, &result, csum_size);
 }
diff --git a/chunk-recover.c b/chunk-recover.c
index 6f43066..7e491f2 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -36,7 +36,7 @@
 #include "disk-io.h"
 #include "volumes.h"
 #include "transaction.h"
-#include "crc32c.h"
+#include "hash.h"
 #include "utils.h"
 #include "version.h"
 #include "btrfsck.h"
@@ -1647,7 +1647,7 @@ static int next_csum(struct btrfs_root *root,
 		     struct btrfs_path *path,
 		     int *slot,
 		     u64 *csum_offset,
-		     u32 *tree_csum,
+		     u8 *tree_csum,
 		     u64 end,
 		     struct btrfs_key *key)
 {
@@ -1711,11 +1711,13 @@ static u64 calc_data_offset(struct btrfs_key *key,
 	return dev_offset + data_offset;
 }
 
-static int check_one_csum(int fd, u64 start, u32 len, u32 tree_csum)
+static int check_one_csum(struct btrfs_root *root, int fd, u64 start, u32 len,
+			  u8 *tree_csum)
 {
 	char *data;
 	int ret = 0;
-	u32 csum_result = ~(u32)0;
+	u8 csum_result[BTRFS_CSUM_SIZE];
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	data = malloc(len);
 	if (!data)
@@ -1726,9 +1728,9 @@ static int check_one_csum(int fd, u64 start, u32 len, u32 tree_csum)
 		goto out;
 	}
 	ret = 0;
-	csum_result = btrfs_csum_data(NULL, data, csum_result, len);
-	btrfs_csum_final(csum_result, (char *)&csum_result);
-	if (csum_result != tree_csum)
+
+	btrfs_csum(data, len, csum_result, csum_size);
+	if (memcmp(csum_result, tree_csum, csum_size))
 		ret = 1;
 out:
 	free(data);
@@ -1825,7 +1827,7 @@ static int rebuild_raid_data_chunk_stripes(struct recover_control *rc,
 	u64 csum_offset = 0;
 	u64 data_offset;
 	u32 blocksize = root->sectorsize;
-	u32 tree_csum;
+	u8 tree_csum[BTRFS_CSUM_SIZE];
 	int index = 0;
 	int num_unordered = 0;
 	LIST_HEAD(unordered);
@@ -1898,7 +1900,7 @@ again:
 			goto out;
 	}
 next_csum:
-	ret = next_csum(root, &leaf, &path, &slot, &csum_offset, &tree_csum,
+	ret = next_csum(root, &leaf, &path, &slot, &csum_offset, tree_csum,
 			end, &key);
 	if (ret < 0) {
 		fprintf(stderr, "Fetch csum failed\n");
@@ -1922,7 +1924,7 @@ next_csum:
 		BUG_ON(btrfs_find_device_by_devid(rc->fs_devices,
 						  devext->objectid, 1));
 
-		ret = check_one_csum(dev->fd, data_offset, blocksize,
+		ret = check_one_csum(root, dev->fd, data_offset, blocksize,
 				     tree_csum);
 		if (ret < 0)
 			goto fail_out;
diff --git a/cmds-check.c b/cmds-check.c
index 389674f..2f05cff 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -42,6 +42,7 @@
 #include "rbtree-utils.h"
 #include "backref.h"
 #include "ulist.h"
+#include "hash.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -4301,8 +4302,8 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	char *data;
 	unsigned long csum_offset;
-	u32 csum;
-	u32 csum_expected;
+	u8 csum[BTRFS_CSUM_SIZE];
+	u8 csum_expected[BTRFS_CSUM_SIZE];
 	u64 read_len;
 	u64 data_checked = 0;
 	u64 tmp;
@@ -4329,22 +4330,18 @@ again:
 		data_checked = 0;
 		/* verify every 4k data's checksum */
 		while (data_checked < read_len) {
-			csum = ~(u32)0;
 			tmp = offset + data_checked;
 
-			csum = btrfs_csum_data(NULL, (char *)data + tmp,
-					       csum, root->sectorsize);
-			btrfs_csum_final(csum, (char *)&csum);
+			btrfs_csum((char *)data + tmp, root->sectorsize, csum, csum_size);
 
 			csum_offset = leaf_offset +
 				 tmp / root->sectorsize * csum_size;
 			read_extent_buffer(eb, (char *)&csum_expected,
 					   csum_offset, csum_size);
 			/* try another mirror */
-			if (csum != csum_expected) {
-				fprintf(stderr, "mirror %d bytenr %llu csum %u expected csum %u\n",
-						mirror, bytenr + tmp,
-						csum, csum_expected);
+			if (!memcmp(csum, csum_expected, csum_size)) {
+				fprintf(stderr, "mirror %d bytenr %llu\n",
+						mirror, bytenr + tmp);
 				num_copies = btrfs_num_copies(
 						&root->fs_info->mapping_tree,
 						bytenr, num_bytes);
diff --git a/ctree.h b/ctree.h
index 89036de..af13e59 100644
--- a/ctree.h
+++ b/ctree.h
@@ -148,11 +148,13 @@ struct btrfs_free_space_ctl;
 
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
+#define BTRFS_CSUM_TYPE_SHA256	1
 
-static int btrfs_csum_sizes[] = { 4, 0 };
+static int btrfs_csum_sizes[] = { 4, 32, 0 };
 
 /* four bytes for CRC32 */
 #define BTRFS_CRC32_SIZE 4
+#define BTRFS_SHA256_SIZE 32
 #define BTRFS_EMPTY_DIR_SIZE 0
 
 #define BTRFS_FT_UNKNOWN	0
diff --git a/disk-io.c b/disk-io.c
index 03edf8e..6670dc5 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -31,7 +31,7 @@
 #include "disk-io.h"
 #include "volumes.h"
 #include "transaction.h"
-#include "crc32c.h"
+#include "hash.h"
 #include "utils.h"
 #include "print-tree.h"
 #include "rbtree-utils.h"
@@ -61,30 +61,18 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 	return ret;
 }
 
-u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
-{
-	return crc32c(seed, data, len);
-}
-
-void btrfs_csum_final(u32 crc, char *result)
-{
-	*(__le32 *)result = ~cpu_to_le32(crc);
-}
-
 static int __csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
 				  int verify, int silent)
 {
 	char *result;
 	u32 len;
-	u32 crc = ~(u32)0;
 
 	result = malloc(csum_size * sizeof(char));
 	if (!result)
 		return 1;
 
 	len = buf->len - BTRFS_CSUM_SIZE;
-	crc = crc32c(crc, buf->data + BTRFS_CSUM_SIZE, len);
-	btrfs_csum_final(crc, result);
+	btrfs_csum(buf->data + BTRFS_CSUM_SIZE, len, (u8 *)result, csum_size);
 
 	if (verify) {
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
@@ -1286,15 +1274,14 @@ static int write_dev_supers(struct btrfs_root *root,
 			    struct btrfs_device *device)
 {
 	u64 bytenr;
-	u32 crc;
 	int i, ret;
+	int csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	if (root->fs_info->super_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		btrfs_set_super_bytenr(sb, root->fs_info->super_bytenr);
-		crc = ~(u32)0;
-		crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE, crc,
-				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-		btrfs_csum_final(crc, (char *)&sb->csum[0]);
+		btrfs_csum((char *)sb + BTRFS_CSUM_SIZE,
+			   BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE,
+			   &sb->csum[0], csum_size);
 
 		/*
 		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
@@ -1314,10 +1301,9 @@ static int write_dev_supers(struct btrfs_root *root,
 
 		btrfs_set_super_bytenr(sb, bytenr);
 
-		crc = ~(u32)0;
-		crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE, crc,
-				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-		btrfs_csum_final(crc, (char *)&sb->csum[0]);
+		btrfs_csum((char *)sb + BTRFS_CSUM_SIZE,
+			   BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE,
+			   &sb->csum[0], csum_size);
 
 		/*
 		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
diff --git a/file-item.c b/file-item.c
index b46d7f1..37867ef 100644
--- a/file-item.c
+++ b/file-item.c
@@ -24,7 +24,7 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "print-tree.h"
-#include "crc32c.h"
+#include "hash.h"
 
 #define MAX_CSUM_ITEMS(r,size) ((((BTRFS_LEAF_DATA_SIZE(r) - \
 			       sizeof(struct btrfs_item) * 2) / \
@@ -180,7 +180,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	struct btrfs_csum_item *item;
 	struct extent_buffer *leaf = NULL;
 	u64 csum_offset;
-	u32 csum_result = ~(u32)0;
+	u8 csum_result[BTRFS_CSUM_SIZE];
 	u32 nritems;
 	u32 ins_size;
 	u16 csum_size =
@@ -295,14 +295,9 @@ csum:
 	item = (struct btrfs_csum_item *)((unsigned char *)item +
 					  csum_offset * csum_size);
 found:
-	csum_result = btrfs_csum_data(root, data, csum_result, len);
-	btrfs_csum_final(csum_result, (char *)&csum_result);
-	if (csum_result == 0) {
-		printk("csum result is 0 for block %llu\n",
-		       (unsigned long long)bytenr);
-	}
+	btrfs_csum(data, len, csum_result, csum_size);
 
-	write_extent_buffer(leaf, &csum_result, (unsigned long)item,
+	write_extent_buffer(leaf, csum_result, (unsigned long)item,
 			    csum_size);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 fail:
diff --git a/free-space-cache.c b/free-space-cache.c
index 220449e..617f1a0 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -22,7 +22,7 @@
 #include "transaction.h"
 #include "disk-io.h"
 #include "extent_io.h"
-#include "crc32c.h"
+#include "hash.h"
 #include "bitops.h"
 
 /*
@@ -207,8 +207,11 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 	val = *tmp;
 
 	io_ctl_map_page(io_ctl, 0);
-	crc = crc32c(crc, io_ctl->orig + offset, io_ctl->root->sectorsize - offset);
-	btrfs_csum_final(crc, (char *)&crc);
+
+	/* liubo: free space cache always uses crc32c for checksum */
+
+	btrfs_csum(io_ctl->orig + offset, io_ctl->root->sectorsize - offset,
+		   (u8 *)&crc, BTRFS_CRC32_SIZE);
 	if (val != crc) {
 		printk("btrfs: csum mismatch on free space cache\n");
 		io_ctl_unmap_page(io_ctl);
diff --git a/hash.c b/hash.c
new file mode 100644
index 0000000..3282f7b
--- /dev/null
+++ b/hash.c
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2014 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#include "hash.h"
+#include "ctree.h"
+
+void btrfs_csum(const void *buf, int len, u8 *out, int csum_size)
+{
+	if (csum_size == BTRFS_CRC32_SIZE) {
+		u32 crc = ~(u32)0;
+
+		crc = crc32c(crc, buf, len);
+		*(__le32 *)out = ~cpu_to_le32(crc);
+	} else if (csum_size == BTRFS_SHA256_SIZE) {
+		struct sha256_ctx sctx;
+
+		sha256_init(&sctx);
+		sha256_update(&sctx, buf, len);
+		sha256_final(&sctx, out);
+	}
+}
diff --git a/hash.h b/hash.h
index 804fcda..7ade73a 100644
--- a/hash.h
+++ b/hash.h
@@ -19,6 +19,9 @@
 #ifndef __HASH__
 #define __HASH__
 #include "crc32c.h"
+#include "sha256.h"
+
+void btrfs_csum(const void *buf, int len, u8 *out, int csum_size);
 
 static inline u64 btrfs_name_hash(const char *name, int len)
 {
diff --git a/kerncompat.h b/kerncompat.h
index 8afadc8..d6aacf3 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -322,6 +322,13 @@ typedef u64 __bitwise __be64;
 #define le32_to_cpu(x) ((__force u32)(__le32)(bswap_32(x)))
 #define cpu_to_le16(x) ((__force __le16)(u16)(bswap_16(x)))
 #define le16_to_cpu(x) ((__force u16)(__le16)(bswap_16(x)))
+/* be{16,32,64} */
+#define cpu_to_be64(x) ((__force __be64)(u64)(x))
+#define be64_to_cpu(x) ((__force u64)(__be64)(x))
+#define cpu_to_be32(x) ((__force __be32)(u32)(x))
+#define be32_to_cpu(x) ((__force u32)(__be32)(x))
+#define cpu_to_be16(x) ((__force __be16)(u16)(x))
+#define be16_to_cpu(x) ((__force u16)(__be16)(x))
 #else
 #define cpu_to_le64(x) ((__force __le64)(u64)(x))
 #define le64_to_cpu(x) ((__force u64)(__le64)(x))
@@ -329,6 +336,13 @@ typedef u64 __bitwise __be64;
 #define le32_to_cpu(x) ((__force u32)(__le32)(x))
 #define cpu_to_le16(x) ((__force __le16)(u16)(x))
 #define le16_to_cpu(x) ((__force u16)(__le16)(x))
+/* be{16,32,64} */
+#define cpu_to_be64(x) ((__force __be64)(u64)(bswap_64(x)))
+#define be64_to_cpu(x) ((__force u64)(__be64)(bswap_64(x)))
+#define cpu_to_be32(x) ((__force __be32)(u32)(bswap_32(x)))
+#define be32_to_cpu(x) ((__force u32)(__be32)(bswap_32(x)))
+#define cpu_to_be16(x) ((__force __be16)(u16)(bswap_16(x)))
+#define be16_to_cpu(x) ((__force u16)(__be16)(bswap_16(x)))
 #endif
 
 struct __una_u16 { __le16 x; } __attribute__((__packed__));
diff --git a/mkfs.c b/mkfs.c
index e10e62d..d91921c 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -277,6 +277,7 @@ static void print_usage(void)
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
+	fprintf(stderr, "\t -C --checksum-size specify the filesystem checksum size, only 32 and 256 are supported\n");
 	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
 	fprintf(stderr, "\t -f --force force overwrite of existing filesystem\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
@@ -340,6 +341,7 @@ static char *parse_label(char *input)
 static struct option long_options[] = {
 	{ "alloc-start", 1, NULL, 'A'},
 	{ "byte-count", 1, NULL, 'b' },
+	{ "checksum-size", 1, NULL, 'C' },
 	{ "force", 0, NULL, 'f' },
 	{ "leafsize", 1, NULL, 'l' },
 	{ "label", 1, NULL, 'L'},
@@ -1266,6 +1268,7 @@ int main(int ac, char **av)
 	int discard = 1;
 	int ssd = 0;
 	int force_overwrite = 0;
+	int csum_size = BTRFS_CRC32_SIZE;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
@@ -1280,7 +1283,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:U:VMK",
+		c = getopt_long(ac, av, "A:b:C:fl:n:s:m:d:L:O:r:U:VMK",
 				long_options, &option_index);
 		if (c < 0)
 			break;
@@ -1288,6 +1291,15 @@ int main(int ac, char **av)
 			case 'A':
 				alloc_start = parse_size(optarg);
 				break;
+			case 'C':
+				csum_size = parse_size(optarg);
+
+				if (csum_size != (BTRFS_CRC32_SIZE << 3) &&
+				    csum_size != (BTRFS_SHA256_SIZE << 3))
+					print_usage();
+
+				csum_size = csum_size >> 3;
+				break;
 			case 'f':
 				force_overwrite = 1;
 				break;
@@ -1566,7 +1578,7 @@ int main(int ac, char **av)
 
 	ret = make_btrfs(fd, file, label, fs_uuid, blocks, dev_block_count,
 			 nodesize, leafsize,
-			 sectorsize, stripesize, features);
+			 sectorsize, stripesize, features, csum_size);
 	if (ret) {
 		fprintf(stderr, "error during mkfs: %s\n", strerror(-ret));
 		exit(1);
@@ -1643,9 +1655,9 @@ raid_groups:
 	BUG_ON(ret);
 
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
-	    "sectorsize %u size %s\n",
+	    "sectorsize %u size %s csum_size %d\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)));
+	    pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)), csum_size << 3);
 
 	btrfs_commit_transaction(trans, root);
 
diff --git a/sha256.c b/sha256.c
new file mode 100644
index 0000000..77eb0df
--- /dev/null
+++ b/sha256.c
@@ -0,0 +1,290 @@
+/*
+ * Copied from the kernel source code, crypto/sha256_generic.c.
+ *
+ * Cryptographic API.
+ *
+ * SHA-256, as specified in
+ * http://csrc.nist.gov/groups/STM/cavp/documents/shs/sha256-384-512.pdf
+ *
+ * SHA-256 code by Jean-Luc Cooke <jlcooke@certainkey.com>.
+ *
+ * Copyright (c) Jean-Luc Cooke <jlcooke@certainkey.com>
+ * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ * SHA224 Support Copyright 2007 Intel Corporation <jonathan.lynch@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#include "kerncompat.h"
+#include "sha256.h"
+
+static inline u32 Ch(u32 x, u32 y, u32 z)
+{
+	return z ^ (x & (y ^ z));
+}
+
+static inline u32 Maj(u32 x, u32 y, u32 z)
+{
+	return (x & y) | (z & (x | y));
+}
+
+static inline uint32_t ror32(uint32_t word, unsigned int shift)
+{
+	return (word >> shift) | (word << (32 - shift));
+}
+
+#define e0(x)       (ror32(x, 2) ^ ror32(x,13) ^ ror32(x,22))
+#define e1(x)       (ror32(x, 6) ^ ror32(x,11) ^ ror32(x,25))
+#define s0(x)       (ror32(x, 7) ^ ror32(x,18) ^ (x >> 3))
+#define s1(x)       (ror32(x,17) ^ ror32(x,19) ^ (x >> 10))
+
+static inline void LOAD_OP(int I, u32 *W, const u8 *input)
+{
+	W[I] = be32_to_cpu( ((__be32*)(input))[I] );
+}
+
+static inline void BLEND_OP(int I, u32 *W)
+{
+	W[I] = s1(W[I-2]) + W[I-7] + s0(W[I-15]) + W[I-16];
+}
+
+static void sha256_transform(u32 *state, const u8 *input)
+{
+	u32 a, b, c, d, e, f, g, h, t1, t2;
+	u32 W[64];
+	int i;
+
+	/* load the input */
+	for (i = 0; i < 16; i++)
+		LOAD_OP(i, W, input);
+
+	/* now blend */
+	for (i = 16; i < 64; i++)
+		BLEND_OP(i, W);
+
+	/* load the state into our registers */
+	a=state[0];  b=state[1];  c=state[2];  d=state[3];
+	e=state[4];  f=state[5];  g=state[6];  h=state[7];
+
+	/* now iterate */
+	t1 = h + e1(e) + Ch(e,f,g) + 0x428a2f98 + W[ 0];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x71374491 + W[ 1];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0xb5c0fbcf + W[ 2];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0xe9b5dba5 + W[ 3];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x3956c25b + W[ 4];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x59f111f1 + W[ 5];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x923f82a4 + W[ 6];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0xab1c5ed5 + W[ 7];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0xd807aa98 + W[ 8];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x12835b01 + W[ 9];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x243185be + W[10];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x550c7dc3 + W[11];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x72be5d74 + W[12];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x80deb1fe + W[13];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x9bdc06a7 + W[14];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0xc19bf174 + W[15];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0xe49b69c1 + W[16];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0xefbe4786 + W[17];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x0fc19dc6 + W[18];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x240ca1cc + W[19];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x2de92c6f + W[20];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x4a7484aa + W[21];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x5cb0a9dc + W[22];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x76f988da + W[23];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0x983e5152 + W[24];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0xa831c66d + W[25];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0xb00327c8 + W[26];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0xbf597fc7 + W[27];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0xc6e00bf3 + W[28];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0xd5a79147 + W[29];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x06ca6351 + W[30];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x14292967 + W[31];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0x27b70a85 + W[32];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x2e1b2138 + W[33];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x4d2c6dfc + W[34];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x53380d13 + W[35];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x650a7354 + W[36];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x766a0abb + W[37];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x81c2c92e + W[38];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x92722c85 + W[39];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0xa2bfe8a1 + W[40];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0xa81a664b + W[41];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0xc24b8b70 + W[42];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0xc76c51a3 + W[43];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0xd192e819 + W[44];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0xd6990624 + W[45];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0xf40e3585 + W[46];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x106aa070 + W[47];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0x19a4c116 + W[48];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x1e376c08 + W[49];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x2748774c + W[50];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x34b0bcb5 + W[51];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x391c0cb3 + W[52];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x4ed8aa4a + W[53];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x5b9cca4f + W[54];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x682e6ff3 + W[55];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0x748f82ee + W[56];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x78a5636f + W[57];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x84c87814 + W[58];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x8cc70208 + W[59];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x90befffa + W[60];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0xa4506ceb + W[61];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0xbef9a3f7 + W[62];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0xc67178f2 + W[63];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	state[0] += a; state[1] += b; state[2] += c; state[3] += d;
+	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
+
+	/* clear any sensitive info... */
+	a = b = c = d = e = f = g = h = t1 = t2 = 0;
+	memset(W, 0, 64 * sizeof(u32));
+}
+
+int sha256_init(struct sha256_ctx *sctx)
+{
+	sctx->state[0] = SHA256_H0;
+	sctx->state[1] = SHA256_H1;
+	sctx->state[2] = SHA256_H2;
+	sctx->state[3] = SHA256_H3;
+	sctx->state[4] = SHA256_H4;
+	sctx->state[5] = SHA256_H5;
+	sctx->state[6] = SHA256_H6;
+	sctx->state[7] = SHA256_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+
+int sha256_update(struct sha256_ctx *sctx, const u8 *data, unsigned int len)
+{
+	unsigned int partial, done;
+	const u8 *src;
+
+	partial = sctx->count & 0x3f;
+	sctx->count += len;
+	done = 0;
+	src = data;
+
+	if ((partial + len) > 63) {
+		if (partial) {
+			done = -partial;
+			memcpy(sctx->buf + partial, data, done + 64);
+			src = sctx->buf;
+		}
+
+		do {
+			sha256_transform(sctx->state, src);
+			done += 64;
+			src = data + done;
+		} while (done + 63 < len);
+
+		partial = 0;
+	}
+	memcpy(sctx->buf + partial, src, len - done);
+
+	return 0;
+}
+
+int sha256_final(struct sha256_ctx *sctx, u8 *out)
+{
+	__be32 *dst = (__be32 *)out;
+	__be64 bits;
+	unsigned int index, pad_len;
+	int i;
+	static const u8 padding[64] = { 0x80, };
+
+	/* Save number of bits */
+	bits = cpu_to_be64(sctx->count << 3);
+
+	/* Pad out to 56 mod 64. */
+	index = sctx->count & 0x3f;
+	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
+	sha256_update(sctx, padding, pad_len);
+
+	/* Append length (before padding) */
+	sha256_update(sctx, (const u8 *)&bits, sizeof(bits));
+
+	/* Store state in digest */
+	for (i = 0; i < 8; i++)
+		dst[i] = cpu_to_be32(sctx->state[i]);
+
+	/* Zeroize sensitive information. */
+	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
diff --git a/sha256.h b/sha256.h
new file mode 100644
index 0000000..91c826d
--- /dev/null
+++ b/sha256.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2007 Red Hat.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __SHA256__
+#define __SHA256__
+
+#if BTRFS_FLAT_INCLUDES
+#include "kerncompat.h"
+#else
+#include <btrfs/kerncompat.h>
+#endif /* BTRFS_FLAT_INCLUDES */
+
+struct sha256_ctx {
+	u64 count;
+	u32 state[8];
+	u8 buf[64];
+};
+
+#define SHA256_H0       0x6a09e667UL
+#define SHA256_H1       0xbb67ae85UL
+#define SHA256_H2       0x3c6ef372UL
+#define SHA256_H3       0xa54ff53aUL
+#define SHA256_H4       0x510e527fUL
+#define SHA256_H5       0x9b05688cUL
+#define SHA256_H6       0x1f83d9abUL
+#define SHA256_H7       0x5be0cd19UL
+
+int sha256_init(struct sha256_ctx *sctx);
+int sha256_update(struct sha256_ctx *sctx, const u8 *data, unsigned int len);
+int sha256_final(struct sha256_ctx *sctx, u8 *out);
+
+#endif
diff --git a/super-recover.c b/super-recover.c
index adb2c44..7666c56 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -34,7 +34,7 @@
 #include "disk-io.h"
 #include "list.h"
 #include "utils.h"
-#include "crc32c.h"
+#include "hash.h"
 #include "volumes.h"
 #include "commands.h"
 
@@ -94,17 +94,16 @@ void free_recover_superblock(struct btrfs_recover_superblock *recover)
 static int check_super(u64 bytenr, struct btrfs_super_block *sb)
 {
 	int csum_size = btrfs_super_csum_size(sb);
-	char result[csum_size];
-	u32 crc = ~(u32)0;
+	char result[BTRFS_CSUM_SIZE];
 
 	if (btrfs_super_bytenr(sb) != bytenr)
 		return 0;
 	if (sb->magic != cpu_to_le64(BTRFS_MAGIC))
 		return 0;
 
-	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE,
-			crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-	btrfs_csum_final(crc, result);
+	btrfs_csum((char *)sb + BTRFS_CSUM_SIZE,
+		    BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE,
+		    (u8 *)result, csum_size);
 
 	return !memcmp(sb, &result, csum_size);
 }
diff --git a/utils.c b/utils.c
index 2a92416..06691b5 100644
--- a/utils.c
+++ b/utils.c
@@ -43,7 +43,7 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-#include "crc32c.h"
+#include "hash.h"
 #include "utils.h"
 #include "volumes.h"
 #include "ioctl.h"
@@ -173,7 +173,8 @@ int test_uuid_unique(char *fs_uuid)
 
 int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	       u64 blocks[7], u64 num_bytes, u32 nodesize,
-	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features)
+	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features,
+	       int csum_size_assign)
 {
 	struct btrfs_super_block super;
 	struct extent_buffer *buf = NULL;
@@ -194,9 +195,16 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	u64 ref_root;
 	u32 array_size;
 	u32 item_size;
+	int csum_size = 0;
+	int csum_type = BTRFS_CSUM_TYPE_CRC32;
 	int skinny_metadata = !!(features &
 				 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
+	if (csum_size_assign == BTRFS_CRC32_SIZE)
+		csum_type = BTRFS_CSUM_TYPE_CRC32;
+	else if (csum_size_assign == BTRFS_SHA256_SIZE)
+		csum_type = BTRFS_CSUM_TYPE_SHA256;
+
 	first_free = BTRFS_SUPER_INFO_OFFSET + sectorsize * 2 - 1;
 	first_free &= ~((u64)sectorsize - 1);
 
@@ -232,13 +240,15 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_super_leafsize(&super, leafsize);
 	btrfs_set_super_nodesize(&super, nodesize);
 	btrfs_set_super_stripesize(&super, stripesize);
-	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
+	btrfs_set_super_csum_type(&super, csum_type);
 	btrfs_set_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
 	btrfs_set_super_incompat_flags(&super, features);
 	if (label)
 		strncpy(super.label, label, BTRFS_LABEL_SIZE - 1);
 
+	csum_size = btrfs_super_csum_size(&super);
+
 	buf = malloc(sizeof(*buf) + max(sectorsize, leafsize));
 
 	/* create the tree of root objects */
@@ -321,7 +331,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	nritems++;
 
 
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, csum_size, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[1]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -380,7 +390,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_bytenr(buf, blocks[2]);
 	btrfs_set_header_owner(buf, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, csum_size, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[2]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -467,7 +477,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_bytenr(buf, blocks[3]);
 	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, csum_size, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[3]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -506,7 +516,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_bytenr(buf, blocks[4]);
 	btrfs_set_header_owner(buf, BTRFS_DEV_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, csum_size, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -519,7 +529,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_bytenr(buf, blocks[5]);
 	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, csum_size, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[5]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -531,7 +541,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_bytenr(buf, blocks[6]);
 	btrfs_set_header_owner(buf, BTRFS_CSUM_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, csum_size, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[6]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -543,7 +553,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	memset(buf->data, 0, sectorsize);
 	memcpy(buf->data, &super, sizeof(super));
 	buf->len = sectorsize;
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+	csum_tree_block_size(buf, csum_size, 0);
 	ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
 	if (ret != sectorsize) {
 		ret = (ret < 0 ? -errno : -EIO);
diff --git a/utils.h b/utils.h
index 289e86b..cc93424 100644
--- a/utils.h
+++ b/utils.h
@@ -71,7 +71,8 @@ void units_set_base(unsigned *units, unsigned base);
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       char *fs_uuid, u64 blocks[6], u64 num_bytes, u32 nodesize,
-	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features);
+	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features,
+	       int csum_size_assign);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-- 
1.8.2.1

