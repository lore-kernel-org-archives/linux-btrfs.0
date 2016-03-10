Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([125.16.236.5]:57916 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbcCJInh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 03:43:37 -0500
Received: from localhost
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Thu, 10 Mar 2016 14:13:34 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2A8h9T619005730
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 14:13:09 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2A8hNBH030529
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 14:13:23 +0530
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: chandan@linux.vnet.ibm.com, Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2] btrfs-progs: Replace hardcoded PAGE_CACHE_SIZE with sectorsize.
Date: Thu, 10 Mar 2016 16:43:20 +0800
Message-Id: <1457599400-10549-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

PAGE_CACHE_SIZE is hardcoded to 4K in cmds-restore.c. Correct
value should be sector size. Fix this through replacing
hardcoded 4K to sectorsize.

Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 cmds-restore.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 161fd91..0e06a67 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -56,7 +56,6 @@ static int get_xattrs = 0;
 static int dry_run = 0;
 
 #define LZO_LEN 4
-#define PAGE_CACHE_SIZE 4096
 #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
 
 static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
@@ -93,8 +92,8 @@ static inline size_t read_compress_length(unsigned char *buf)
 	return le32_to_cpu(dlen);
 }
 
-static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
-			  u64 *decompress_len)
+static int decompress_lzo(struct btrfs_root *root, unsigned char *inbuf,
+			char *outbuf, u64 compress_len, u64 *decompress_len)
 {
 	size_t new_len;
 	size_t in_len;
@@ -126,8 +125,7 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 
 		inbuf += LZO_LEN;
 		tot_in += LZO_LEN;
-
-		new_len = lzo1x_worst_compress(PAGE_CACHE_SIZE);
+		new_len = lzo1x_worst_compress(root->sectorsize);
 		ret = lzo1x_decompress_safe((const unsigned char *)inbuf, in_len,
 					    (unsigned char *)outbuf,
 					    (void *)&new_len, NULL);
@@ -144,8 +142,8 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 		 * If the 4 byte header does not fit to the rest of the page we
 		 * have to move to the next one, unless we read some garbage
 		 */
-		mod_page = tot_in % PAGE_CACHE_SIZE;
-		rem_page = PAGE_CACHE_SIZE - mod_page;
+		mod_page = tot_in % root->sectorsize;
+		rem_page = root->sectorsize - mod_page;
 		if (rem_page < LZO_LEN) {
 			inbuf += rem_page;
 			tot_in += rem_page;
@@ -157,16 +155,16 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 	return 0;
 }
 
-static int decompress(char *inbuf, char *outbuf, u64 compress_len,
-		      u64 *decompress_len, int compress)
+static int decompress(struct btrfs_root *root, char *inbuf, char *outbuf,
+			u64 compress_len, u64 *decompress_len, int compress)
 {
 	switch (compress) {
 	case BTRFS_COMPRESS_ZLIB:
 		return decompress_zlib(inbuf, outbuf, compress_len,
 				       *decompress_len);
 	case BTRFS_COMPRESS_LZO:
-		return decompress_lzo((unsigned char *)inbuf, outbuf, compress_len,
-				      decompress_len);
+		return decompress_lzo(root, (unsigned char *)inbuf, outbuf,
+					compress_len, decompress_len);
 	default:
 		break;
 	}
@@ -234,7 +232,8 @@ again:
 	return 0;
 }
 
-static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
+static int copy_one_inline(struct btrfs_root *root, int fd,
+				struct btrfs_path *path, u64 pos)
 {
 	struct extent_buffer *leaf = path->nodes[0];
 	struct btrfs_file_extent_item *fi;
@@ -273,7 +272,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 		return -ENOMEM;
 	}
 
-	ret = decompress(buf, outbuf, len, &ram_size, compress);
+	ret = decompress(root, buf, outbuf, len, &ram_size, compress);
 	if (ret) {
 		free(outbuf);
 		return ret;
@@ -401,7 +400,7 @@ again:
 		goto out;
 	}
 
-	ret = decompress(inbuf, outbuf, disk_size, &ram_size, compress);
+	ret = decompress(root, inbuf, outbuf, disk_size, &ram_size, compress);
 	if (ret) {
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      bytenr, length);
@@ -738,7 +737,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC)
 			goto next;
 		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-			ret = copy_one_inline(fd, path, found_key.offset);
+			ret = copy_one_inline(root, fd, path, found_key.offset);
 			if (ret)
 				goto out;
 		} else if (extent_type == BTRFS_FILE_EXTENT_REG) {
-- 
1.9.1

