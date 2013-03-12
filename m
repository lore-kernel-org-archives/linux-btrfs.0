Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50761 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147Ab3CLRbT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 55CC87C04E9
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:19 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id cvVNFiF6805QpHi1 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:18 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/10] btrfs-progs: add lzo compression support to restore
Date: Tue, 12 Mar 2013 13:38:14 -0400
Message-ID: <1363109897-7931-8-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <josef@redhat.com>

This patch simply adds support to decompress lzo compressed extents in restore.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 Makefile       |    2 +-
 cmds-restore.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index d102dee..50e2892 100644
--- a/Makefile
+++ b/Makefile
@@ -24,7 +24,7 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-lib_LIBS = -luuid -lblkid -lm -lz -L.
+lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
 libdir ?= $(prefix)/lib
 incdir = $(prefix)/include/btrfs
 LIBS = $(lib_LIBS) $(libs_static)
diff --git a/cmds-restore.c b/cmds-restore.c
index 365cd15..3e0ada2 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -30,6 +30,8 @@
 #include <sys/types.h>
 #include <zlib.h>
 #include <regex.h>
+#include <lzo/lzoconf.h>
+#include <lzo/lzo1x.h>
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -48,8 +50,12 @@ static int verbose = 0;
 static int ignore_errors = 0;
 static int overwrite = 0;
 
-static int decompress(char *inbuf, char *outbuf, u64 compress_len,
-		      u64 decompress_len)
+#define LZO_LEN 4
+#define PAGE_CACHE_SIZE 4096
+#define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
+
+static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
+			   u64 decompress_len)
 {
 	z_stream strm;
 	int ret;
@@ -75,6 +81,73 @@ static int decompress(char *inbuf, char *outbuf, u64 compress_len,
 	(void)inflateEnd(&strm);
 	return 0;
 }
+static inline size_t read_compress_length(unsigned char *buf)
+{
+	__le32 dlen;
+	memcpy(&dlen, buf, LZO_LEN);
+	return le32_to_cpu(dlen);
+}
+
+static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
+			  u64 *decompress_len)
+{
+	size_t new_len;
+	size_t in_len;
+	size_t out_len = 0;
+	size_t tot_len;
+	size_t tot_in;
+	int ret;
+
+	ret = lzo_init();
+	if (ret != LZO_E_OK) {
+		fprintf(stderr, "lzo init returned %d\n", ret);
+		return -1;
+	}
+
+	tot_len = read_compress_length(inbuf);
+	inbuf += LZO_LEN;
+	tot_in = LZO_LEN;
+
+	while (tot_in < tot_len) {
+		in_len = read_compress_length(inbuf);
+		inbuf += LZO_LEN;
+		tot_in += LZO_LEN;
+
+		new_len = lzo1x_worst_compress(PAGE_CACHE_SIZE);
+		ret = lzo1x_decompress_safe((const unsigned char *)inbuf, in_len,
+					    (unsigned char *)outbuf, &new_len, NULL);
+		if (ret != LZO_E_OK) {
+			fprintf(stderr, "failed to inflate: %d\n", ret);
+			return -1;
+		}
+		out_len += new_len;
+		outbuf += new_len;
+		inbuf += in_len;
+		tot_in += in_len;
+	}
+
+	*decompress_len = out_len;
+
+	return 0;
+}
+
+static int decompress(char *inbuf, char *outbuf, u64 compress_len,
+		      u64 *decompress_len, int compress)
+{
+	switch (compress) {
+	case BTRFS_COMPRESS_ZLIB:
+		return decompress_zlib(inbuf, outbuf, compress_len,
+				       *decompress_len);
+	case BTRFS_COMPRESS_LZO:
+		return decompress_lzo((unsigned char *)inbuf, outbuf, compress_len,
+				      decompress_len);
+	default:
+		break;
+	}
+
+	fprintf(stderr, "invalid compression type: %d\n", compress);
+	return -1;
+}
 
 int next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 {
@@ -134,11 +207,11 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 	struct btrfs_file_extent_item *fi;
 	char buf[4096];
 	char *outbuf;
+	u64 ram_size;
 	ssize_t done;
 	unsigned long ptr;
 	int ret;
 	int len;
-	int ram_size;
 	int compress;
 
 	fi = btrfs_item_ptr(leaf, path->slots[0],
@@ -166,7 +239,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 		return -1;
 	}
 
-	ret = decompress(buf, outbuf, len, ram_size);
+	ret = decompress(buf, outbuf, len, &ram_size, compress);
 	if (ret) {
 		free(outbuf);
 		return ret;
@@ -175,7 +248,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 	done = pwrite(fd, outbuf, ram_size, pos);
 	free(outbuf);
 	if (done < ram_size) {
-		fprintf(stderr, "Short compressed inline write, wanted %d, "
+		fprintf(stderr, "Short compressed inline write, wanted %Lu, "
 			"did %zd: %d\n", ram_size, done, errno);
 		return -1;
 	}
@@ -197,6 +270,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	u64 length;
 	u64 size_left;
 	u64 dev_bytenr;
+	u64 offset;
 	u64 count = 0;
 	int compress;
 	int ret;
@@ -208,8 +282,11 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	disk_size = btrfs_file_extent_disk_num_bytes(leaf, fi);
 	ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
+	offset = btrfs_file_extent_offset(leaf, fi);
 	size_left = disk_size;
 
+	if (offset)
+		printf("offset is %Lu\n", offset);
 	/* we found a hole */
 	if (disk_size == 0)
 		return 0;
@@ -283,7 +360,7 @@ again:
 		goto out;
 	}
 
-	ret = decompress(inbuf, outbuf, disk_size, ram_size);
+	ret = decompress(inbuf, outbuf, disk_size, &ram_size, compress);
 	if (ret) {
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      bytenr, length);
-- 
1.7.7.6

