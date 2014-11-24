Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41388 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaKXFXY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 00:23:24 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id sAO5NMpO011660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:23:23 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sAO5NLbU025144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:23:22 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sAO5NLcs029177
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:23:21 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 24 Nov 2014 13:23:05 +0800
Message-Id: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This brings a strong-but-slow checksum algorithm, sha256.

Actually btrfs used sha256 at the early time, but then moved to crc32c for
performance purposes.

As crc32c is sort of weak due to its hash collision issue, we need a stronger
algorithm as an alternative.

Users can choose sha256 from mkfs.btrfs via

$ mkfs.btrfs -C 256 /device

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/Kconfig            |   1 +
 fs/btrfs/check-integrity.c  |  13 ++++--
 fs/btrfs/compression.c      |  30 ++++++-------
 fs/btrfs/ctree.h            |   8 +++-
 fs/btrfs/disk-io.c          | 106 ++++++++++++++++++++++++--------------------
 fs/btrfs/disk-io.h          |   2 -
 fs/btrfs/file-item.c        |  25 +++++------
 fs/btrfs/free-space-cache.c |   8 ++--
 fs/btrfs/hash.c             |  47 ++++++++++++++++++++
 fs/btrfs/hash.h             |   9 +++-
 fs/btrfs/inode.c            |  21 +++++----
 fs/btrfs/ordered-data.c     |  10 +++--
 fs/btrfs/ordered-data.h     |   9 ++--
 fs/btrfs/scrub.c            |  67 +++++++++++++++++++++-------
 14 files changed, 237 insertions(+), 119 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index a66768e..0a4f9e7 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -2,6 +2,7 @@ config BTRFS_FS
 	tristate "Btrfs filesystem support"
 	select CRYPTO
 	select CRYPTO_CRC32C
+	select CRYPTO_SHA256
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	select LZO_COMPRESS
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index cb7f3fe..98e1037 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1808,8 +1808,11 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 {
 	struct btrfs_header *h;
 	u8 csum[BTRFS_CSUM_SIZE];
-	u32 crc = ~(u32)0;
 	unsigned int i;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(state->root->fs_info->csum_tfm)];
+	} desc;
 
 	if (num_pages * PAGE_CACHE_SIZE < state->metablock_size)
 		return 1; /* not metadata */
@@ -1819,14 +1822,18 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 	if (memcmp(h->fsid, state->root->fs_info->fsid, BTRFS_UUID_SIZE))
 		return 1;
 
+	desc.shash.tfm = state->root->fs_info->csum_tfm;
+	desc.shash.flags = 0;
+	crypto_shash_init(&desc.shash);
+
 	for (i = 0; i < num_pages; i++) {
 		u8 *data = i ? datav[i] : (datav[i] + BTRFS_CSUM_SIZE);
 		size_t sublen = i ? PAGE_CACHE_SIZE :
 				    (PAGE_CACHE_SIZE - BTRFS_CSUM_SIZE);
 
-		crc = btrfs_crc32c(crc, data, sublen);
+		crypto_shash_update(&desc.shash, data, sublen);
 	}
-	btrfs_csum_final(crc, csum);
+	crypto_shash_final(&desc.shash, csum);
 	if (memcmp(csum, h->csum, state->csum_size))
 		return 1;
 
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d3220d3..d10883f 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -78,7 +78,7 @@ struct compressed_bio {
 	 * the start of a variable length array of checksums only
 	 * used by reads
 	 */
-	u32 sums;
+	u8 sums[];
 };
 
 static int btrfs_decompress_biovec(int type, struct page **pages_in,
@@ -111,31 +111,29 @@ static int check_compressed_csum(struct inode *inode,
 	struct page *page;
 	unsigned long i;
 	char *kaddr;
-	u32 csum;
-	u32 *cb_sum = &cb->sums;
+	u8 csum[BTRFS_CSUM_SIZE];
+	u8 *cb_sum = cb->sums;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		return 0;
 
 	for (i = 0; i < cb->nr_pages; i++) {
 		page = cb->compressed_pages[i];
-		csum = ~(u32)0;
 
 		kaddr = kmap_atomic(page);
-		csum = btrfs_csum_data(kaddr, csum, PAGE_CACHE_SIZE);
-		btrfs_csum_final(csum, (char *)&csum);
+		btrfs_csum(fs_info, kaddr, PAGE_CACHE_SIZE, csum);
 		kunmap_atomic(kaddr);
 
-		if (csum != *cb_sum) {
+		if (memcmp(csum, cb_sum, csum_size)) {
 			btrfs_info(BTRFS_I(inode)->root->fs_info,
-			   "csum failed ino %llu extent %llu csum %u wanted %u mirror %d",
-			   btrfs_ino(inode), disk_start, csum, *cb_sum,
-			   cb->mirror_num);
+			   "csum failed ino %llu extent %llu mirror %d",
+			   btrfs_ino(inode), disk_start, cb->mirror_num);
 			ret = -EIO;
 			goto fail;
 		}
-		cb_sum++;
-
+		cb_sum += csum_size;
 	}
 	ret = 0;
 fail:
@@ -578,7 +576,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	struct extent_map *em;
 	int ret = -ENOMEM;
 	int faili = 0;
-	u32 *sums;
+	u8 *sums;
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	tree = &BTRFS_I(inode)->io_tree;
 	em_tree = &BTRFS_I(inode)->extent_tree;
@@ -601,7 +600,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	cb->errors = 0;
 	cb->inode = inode;
 	cb->mirror_num = mirror_num;
-	sums = &cb->sums;
+	sums = cb->sums;
 
 	cb->start = em->orig_start;
 	em_len = em->len;
@@ -686,7 +685,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 							comp_bio, sums);
 				BUG_ON(ret); /* -ENOMEM */
 			}
-			sums += DIV_ROUND_UP(comp_bio->bi_iter.bi_size,
+			sums += csum_size *
+				DIV_ROUND_UP(comp_bio->bi_iter.bi_size,
 					     root->sectorsize);
 
 			ret = btrfs_map_bio(root, READ, comp_bio,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fe69edd..93b8a1c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -38,6 +38,7 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
+#include "hash.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -173,8 +174,9 @@ struct btrfs_ordered_sum;
 
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
+#define BTRFS_CSUM_TYPE_SHA256	1
 
-static int btrfs_csum_sizes[] = { 4, 0 };
+static int btrfs_csum_sizes[] = { 4, 32, 0 };
 
 /* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
@@ -1729,6 +1731,8 @@ struct btrfs_fs_info {
 
 	/* For btrfs to record security options */
 	struct security_mnt_opts security_opts;
+
+	struct crypto_shash *csum_tfm;
 };
 
 struct btrfs_subvolume_writers {
@@ -3728,7 +3732,7 @@ struct btrfs_dio_private;
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, u64 bytenr, u64 len);
 int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
-			  struct bio *bio, u32 *dst);
+			  struct bio *bio, u8 *dst);
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
 			      struct bio *bio, u64 logical_offset);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1bf9f89..4ba28e6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -260,16 +260,6 @@ out:
 	return em;
 }
 
-u32 btrfs_csum_data(char *data, u32 seed, size_t len)
-{
-	return btrfs_crc32c(seed, data, len);
-}
-
-void btrfs_csum_final(u32 crc, char *result)
-{
-	put_unaligned_le32(~crc, result);
-}
-
 /*
  * compute the csum for a btree block, and either verify it or write it
  * into the csum field of the block.
@@ -286,8 +276,16 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 	unsigned long map_start;
 	unsigned long map_len;
 	int err;
-	u32 crc = ~(u32)0;
 	unsigned long inline_result;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(root->fs_info->csum_tfm)];
+	} desc;
+
+	desc.shash.tfm = root->fs_info->csum_tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
 
 	len = buf->len - offset;
 	while (len > 0) {
@@ -296,8 +294,9 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		if (err)
 			return 1;
 		cur_len = min(len, map_len - (offset - map_start));
-		crc = btrfs_csum_data(kaddr + offset - map_start,
-				      crc, cur_len);
+		crypto_shash_update(&desc.shash, kaddr + offset - map_start,
+				    cur_len);
+
 		len -= cur_len;
 		offset += cur_len;
 	}
@@ -309,7 +308,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		result = (char *)&inline_result;
 	}
 
-	btrfs_csum_final(crc, result);
+	crypto_shash_final(&desc.shash, result);
 
 	if (verify) {
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
@@ -319,10 +318,10 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 
 			read_extent_buffer(buf, &val, 0, csum_size);
 			printk_ratelimited(KERN_INFO
-				"BTRFS: %s checksum verify failed on %llu wanted %X found %X "
+				"BTRFS: %s checksum verify failed on %llu wanted  found  "
 				"level %d\n",
 				root->fs_info->sb->s_id, buf->start,
-				val, found, btrfs_header_level(buf));
+				btrfs_header_level(buf));
 			if (result != (char *)&inline_result)
 				kfree(result);
 			return 1;
@@ -394,41 +393,45 @@ out:
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
  */
-static int btrfs_check_super_csum(char *raw_disk_sb)
+static int btrfs_check_super_csum(struct btrfs_fs_info *info, char *raw_disk_sb)
 {
 	struct btrfs_super_block *disk_sb =
 		(struct btrfs_super_block *)raw_disk_sb;
 	u16 csum_type = btrfs_super_csum_type(disk_sb);
+	const int csum_size = btrfs_super_csum_size(disk_sb);
+	char result[csum_size];
 	int ret = 0;
 
-	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
-		u32 crc = ~(u32)0;
-		const int csum_size = sizeof(crc);
-		char result[csum_size];
+	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
+		pr_err("BTRFS: unsupported checksum algorithm %u\n",
+				csum_type);
+		return 1;
+	}
 
-		/*
-		 * The super_block structure does not span the whole
-		 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
-		 * is filled with zeros and is included in the checkum.
-		 */
-		crc = btrfs_csum_data(raw_disk_sb + BTRFS_CSUM_SIZE,
-				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-		btrfs_csum_final(crc, result);
+	btrfs_csum(info, raw_disk_sb + BTRFS_CSUM_SIZE,
+		   BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE, result);
 
-		if (memcmp(raw_disk_sb, result, csum_size))
-			ret = 1;
+	if (memcmp(raw_disk_sb, result, csum_size))
+		ret = 1;
 
-		if (ret && btrfs_super_generation(disk_sb) < 10) {
-			printk(KERN_WARNING
-				"BTRFS: super block crcs don't match, older mkfs detected\n");
-			ret = 0;
-		}
+	if (ret && btrfs_super_generation(disk_sb) < 10) {
+		pr_warn("BTRFS: super block crcs don't match, older mkfs detected\n");
+		ret = 0;
 	}
 
-	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
-		printk(KERN_ERR "BTRFS: unsupported checksum algorithm %u\n",
+	if (!ret) {
+		switch (csum_type) {
+		case 0:
+			btrfs_info(info, "crc32c is the checksum algorithm.");
+			break;
+		case 1:
+			btrfs_info(info, "sha256 is the checksum algorithm.");
+			break;
+		default:
+			WARN(1, "Btrfs: unsupported checksum algorithm %u.\n",
 				csum_type);
-		ret = 1;
+			break;
+		}
 	}
 
 	return ret;
@@ -2404,11 +2407,22 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	{
+		u16 csum_type = btrfs_super_csum_type(
+					(struct btrfs_super_block *)bh->b_data);
+
+		if (btrfs_csum_init(fs_info, csum_type)) {
+			err = -EINVAL;
+			pr_err("BTRFS: csum init error\n");
+			goto fail_alloc;
+		}
+	}
+
 	/*
 	 * We want to check superblock checksum, the type is stored inside.
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
-	if (btrfs_check_super_csum(bh->b_data)) {
+	if (btrfs_check_super_csum(fs_info, bh->b_data)) {
 		printk(KERN_ERR "BTRFS: superblock checksum mismatch\n");
 		err = -EINVAL;
 		goto fail_alloc;
@@ -3010,6 +3024,7 @@ fail_tree_roots:
 fail_sb_buffer:
 	btrfs_stop_all_workers(fs_info);
 fail_alloc:
+	btrfs_csum_exit(fs_info);
 fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
@@ -3130,7 +3145,6 @@ static int write_dev_supers(struct btrfs_device *device,
 	int i;
 	int ret;
 	int errors = 0;
-	u32 crc;
 	u64 bytenr;
 
 	if (max_mirrors == 0)
@@ -3162,12 +3176,10 @@ static int write_dev_supers(struct btrfs_device *device,
 		} else {
 			btrfs_set_super_bytenr(sb, bytenr);
 
-			crc = ~(u32)0;
-			crc = btrfs_csum_data((char *)sb +
-					      BTRFS_CSUM_SIZE, crc,
-					      BTRFS_SUPER_INFO_SIZE -
-					      BTRFS_CSUM_SIZE);
-			btrfs_csum_final(crc, sb->csum);
+			btrfs_csum(device->dev_root->fs_info,
+				     (char *)sb + BTRFS_CSUM_SIZE,
+				     BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE,
+				     sb->csum);
 
 			/*
 			 * one reference for us, and we leave it for the
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 4146518..e8bbb96 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -116,8 +116,6 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
-u32 btrfs_csum_data(char *data, u32 seed, size_t len);
-void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			enum btrfs_wq_endio_type metadata);
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 84a2d18..d777c50 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -33,9 +33,9 @@
 #define MAX_CSUM_ITEMS(r, size) (min_t(u32, __MAX_CSUM_ITEMS(r, size), \
 				       PAGE_CACHE_SIZE))
 
-#define MAX_ORDERED_SUM_BYTES(r) ((PAGE_SIZE - \
+#define MAX_ORDERED_SUM_BYTES(r, size) ((PAGE_SIZE - \
 				   sizeof(struct btrfs_ordered_sum)) / \
-				   sizeof(u32) * (r)->sectorsize)
+				   sizeof(u8) * size * (r)->sectorsize)
 
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
@@ -160,7 +160,7 @@ static void btrfs_io_bio_endio_readpage(struct btrfs_io_bio *bio, int err)
 
 static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
-				   u64 logical_offset, u32 *dst, int dio)
+				   u64 logical_offset, u8 *dst, int dio)
 {
 	struct bio_vec *bvec = bio->bi_io_vec;
 	struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
@@ -224,7 +224,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 		if (!dio)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
-					       (u32 *)csum, nblocks);
+					       csum, nblocks);
 		if (count)
 			goto found;
 
@@ -293,7 +293,7 @@ found:
 }
 
 int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
-			  struct bio *bio, u32 *dst)
+			  struct bio *bio, u8 *dst)
 {
 	return __btrfs_lookup_bio_sums(root, inode, bio, 0, dst, 0);
 }
@@ -384,7 +384,7 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 				      struct btrfs_csum_item);
 		while (start < csum_end) {
 			size = min_t(size_t, csum_end - start,
-				     MAX_ORDERED_SUM_BYTES(root));
+				     MAX_ORDERED_SUM_BYTES(root, csum_size));
 			sums = kzalloc(btrfs_ordered_sum_size(root, size),
 				       GFP_NOFS);
 			if (!sums) {
@@ -435,6 +435,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	unsigned long total_bytes = 0;
 	unsigned long this_sum_bytes = 0;
 	u64 offset;
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	WARN_ON(bio->bi_vcnt <= 0);
 	sums = kzalloc(btrfs_ordered_sum_size(root, bio->bi_iter.bi_size),
@@ -481,16 +482,12 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		}
 
 		data = kmap_atomic(bvec->bv_page);
-		sums->sums[index] = ~(u32)0;
-		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
-						    sums->sums[index],
-						    bvec->bv_len);
+		btrfs_csum(root->fs_info, data + bvec->bv_offset,
+			   bvec->bv_len, sums->sums + index);
 		kunmap_atomic(data);
-		btrfs_csum_final(sums->sums[index],
-				 (char *)(sums->sums + index));
 
 		bio_index++;
-		index++;
+		index += csum_size;
 		total_bytes += bvec->bv_len;
 		this_sum_bytes += bvec->bv_len;
 		offset += bvec->bv_len;
@@ -858,9 +855,9 @@ found:
 	write_extent_buffer(leaf, sums->sums + index, (unsigned long)item,
 			    ins_size);
 
+	index += ins_size;
 	ins_size /= csum_size;
 	total_bytes += ins_size * root->sectorsize;
-	index += ins_size;
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	if (total_bytes < sums->len) {
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3384819..8a6ad56 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -442,9 +442,9 @@ static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-	crc = btrfs_csum_data(io_ctl->orig + offset, crc,
+	crc = btrfs_crc32c(crc, io_ctl->orig + offset,
 			      PAGE_CACHE_SIZE - offset);
-	btrfs_csum_final(crc, (char *)&crc);
+	btrfs_crc32c_final(crc, (char *)&crc);
 	io_ctl_unmap_page(io_ctl);
 	tmp = kmap(io_ctl->pages[0]);
 	tmp += index;
@@ -472,9 +472,9 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 	kunmap(io_ctl->pages[0]);
 
 	io_ctl_map_page(io_ctl, 0);
-	crc = btrfs_csum_data(io_ctl->orig + offset, crc,
+	crc = btrfs_crc32c(crc, io_ctl->orig + offset,
 			      PAGE_CACHE_SIZE - offset);
-	btrfs_csum_final(crc, (char *)&crc);
+	btrfs_crc32c_final(crc, (char *)&crc);
 	if (val != crc) {
 		printk_ratelimited(KERN_ERR "BTRFS: csum mismatch on free "
 				   "space cache\n");
diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
index aae520b..12e8d01 100644
--- a/fs/btrfs/hash.c
+++ b/fs/btrfs/hash.c
@@ -13,6 +13,7 @@
 
 #include <crypto/hash.h>
 #include <linux/err.h>
+#include <asm/unaligned.h>
 #include "hash.h"
 
 static struct crypto_shash *tfm;
@@ -29,6 +30,7 @@ void btrfs_hash_exit(void)
 	crypto_free_shash(tfm);
 }
 
+/* btrfs_name_hash() still needs this. */
 u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
 {
 	SHASH_DESC_ON_STACK(shash, tfm);
@@ -44,3 +46,48 @@ u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
 
 	return *ctx;
 }
+
+void btrfs_crc32c_final(u32 crc, char *result)
+{
+	put_unaligned_le32(~crc, result);
+}
+
+int btrfs_csum_init(struct btrfs_fs_info *info, u16 csum_type)
+{
+	struct crypto_shash *tfm = NULL;
+
+	if (csum_type == BTRFS_CSUM_TYPE_CRC32)
+		tfm = crypto_alloc_shash("crc32c", 0, 0);
+	else if (csum_type == BTRFS_CSUM_TYPE_SHA256)
+		tfm = crypto_alloc_shash("sha256", 0, 0);
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	info->csum_tfm = tfm;
+	return 0;
+}
+
+void btrfs_csum_exit(struct btrfs_fs_info *info)
+{
+	if (info->csum_tfm)
+		crypto_free_shash(info->csum_tfm);
+}
+
+int btrfs_csum(struct btrfs_fs_info *info, const void *address,
+	       unsigned int length, u8 *out)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(info->csum_tfm)];
+	} desc;
+	int err;
+
+	desc.shash.tfm = info->csum_tfm;
+	desc.shash.flags = 0;
+
+	err = crypto_shash_digest(&desc.shash, address, length, out);
+
+	ASSERT(!err);
+	return err;
+}
diff --git a/fs/btrfs/hash.h b/fs/btrfs/hash.h
index 118a231..cfa896f 100644
--- a/fs/btrfs/hash.h
+++ b/fs/btrfs/hash.h
@@ -19,11 +19,14 @@
 #ifndef __HASH__
 #define __HASH__
 
-int __init btrfs_hash_init(void);
+#include <crypto/hash.h>
+#include "ctree.h"
 
+int __init btrfs_hash_init(void);
 void btrfs_hash_exit(void);
 
 u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length);
+void btrfs_crc32c_final(u32 crc, char *result);
 
 static inline u64 btrfs_name_hash(const char *name, int len)
 {
@@ -39,4 +42,8 @@ static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name,
 	return (u64) btrfs_crc32c(parent_objectid, name, len);
 }
 
+int btrfs_csum_init(struct btrfs_fs_info *fs_info, u16 csum_type);
+void btrfs_csum_exit(struct btrfs_fs_info *fs_info);
+int btrfs_csum(struct btrfs_fs_info *info, const void *address,
+		 unsigned int length, u8 *out);
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d23362f..15fa0a8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2909,17 +2909,18 @@ static int __readpage_endio_check(struct inode *inode,
 				  int pgoff, u64 start, size_t len)
 {
 	char *kaddr;
-	u32 csum_expected;
-	u32 csum = ~(u32)0;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u8 *csum_expected;
+	u8 csum[BTRFS_CSUM_SIZE];
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
-	csum_expected = *(((u32 *)io_bio->csum) + icsum);
+	csum_expected = ((u8 *)io_bio->csum) + icsum * csum_size;
 
 	kaddr = kmap_atomic(page);
-	csum = btrfs_csum_data(kaddr + pgoff, csum,  len);
-	btrfs_csum_final(csum, (char *)&csum);
-	if (csum != csum_expected)
+	btrfs_csum(root->fs_info, kaddr + pgoff, len, csum);
+	if (memcmp(csum, csum_expected, csum_size))
 		goto zeroit;
 
 	kunmap_atomic(kaddr);
@@ -2927,13 +2928,17 @@ static int __readpage_endio_check(struct inode *inode,
 zeroit:
 	if (__ratelimit(&_rs))
 		btrfs_info(BTRFS_I(inode)->root->fs_info,
-			   "csum failed ino %llu off %llu csum %u expected csum %u",
-			   btrfs_ino(inode), start, csum, csum_expected);
+			   "csum failed ino %llu off %llu",
+			   btrfs_ino(inode), start);
 	memset(kaddr + pgoff, 1, len);
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr);
+
+/*
+ * Liubo: Not sure why this could happen.
 	if (csum_expected == 0)
 		return 0;
+*/
 	return -EIO;
 }
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ac734ec..d361091 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -996,7 +996,7 @@ out:
  * be reclaimed before their checksum is actually put into the btree
  */
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
-			   u32 *sum, int len)
+			   u8 *sum, int len)
 {
 	struct btrfs_ordered_sum *ordered_sum;
 	struct btrfs_ordered_extent *ordered;
@@ -1005,6 +1005,8 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 	unsigned long i;
 	u32 sectorsize = BTRFS_I(inode)->root->sectorsize;
 	int index = 0;
+	u16 csum_size = btrfs_super_csum_size(
+				BTRFS_I(inode)->root->fs_info->super_copy);
 
 	ordered = btrfs_lookup_ordered_extent(inode, offset);
 	if (!ordered)
@@ -1019,10 +1021,10 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 			num_sectors = ordered_sum->len >>
 				      inode->i_sb->s_blocksize_bits;
 			num_sectors = min_t(int, len - index, num_sectors - i);
-			memcpy(sum + index, ordered_sum->sums + i,
-			       num_sectors);
+			memcpy(sum + index, ordered_sum->sums + i * csum_size,
+			       num_sectors * csum_size);
 
-			index += (int)num_sectors;
+			index += (int)num_sectors * csum_size;
 			if (index == len)
 				goto out;
 			disk_bytenr += num_sectors * sectorsize;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index d81a274..2df227c 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -36,7 +36,7 @@ struct btrfs_ordered_sum {
 	int len;
 	struct list_head list;
 	/* last field is a variable length array of csums */
-	u32 sums[];
+	u8 sums[];
 };
 
 /*
@@ -145,7 +145,10 @@ static inline int btrfs_ordered_sum_size(struct btrfs_root *root,
 					 unsigned long bytes)
 {
 	int num_sectors = (int)DIV_ROUND_UP(bytes, root->sectorsize);
-	return sizeof(struct btrfs_ordered_sum) + num_sectors * sizeof(u32);
+	int csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+
+	return sizeof(struct btrfs_ordered_sum) +
+	       num_sectors * sizeof(u8) * csum_size;
 }
 
 static inline void
@@ -189,7 +192,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
-			   u32 *sum, int len);
+			   u8 *sum, int len);
 int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr);
 void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr);
 void btrfs_get_logged_extents(struct inode *inode,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index efa0831..a7d58c9 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1364,8 +1364,16 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 {
 	int page_num;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
-	u32 crc = ~(u32)0;
 	void *mapped_buffer;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(fs_info->csum_tfm)];
+	} desc;
+
+	desc.shash.tfm = fs_info->csum_tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
 
 	WARN_ON(!sblock->pagev[0]->page);
 	if (is_metadata) {
@@ -1393,11 +1401,12 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 
 	for (page_num = 0;;) {
 		if (page_num == 0 && is_metadata)
-			crc = btrfs_csum_data(
-				((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE,
-				crc, PAGE_SIZE - BTRFS_CSUM_SIZE);
+			crypto_shash_update(&desc.shash,
+				 ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE,
+				 PAGE_SIZE - BTRFS_CSUM_SIZE);
 		else
-			crc = btrfs_csum_data(mapped_buffer, crc, PAGE_SIZE);
+			crypto_shash_update(&desc.shash, mapped_buffer,
+					    PAGE_SIZE);
 
 		kunmap_atomic(mapped_buffer);
 		page_num++;
@@ -1408,7 +1417,7 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		mapped_buffer = kmap_atomic(sblock->pagev[page_num]->page);
 	}
 
-	btrfs_csum_final(crc, calculated_csum);
+	crypto_shash_final(&desc.shash, calculated_csum);
 	if (memcmp(calculated_csum, csum, csum_size))
 		sblock->checksum_error = 1;
 }
@@ -1669,14 +1678,23 @@ static int scrub_checksum(struct scrub_block *sblock)
 static int scrub_checksum_data(struct scrub_block *sblock)
 {
 	struct scrub_ctx *sctx = sblock->sctx;
+	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
 	u8 csum[BTRFS_CSUM_SIZE];
 	u8 *on_disk_csum;
 	struct page *page;
 	void *buffer;
-	u32 crc = ~(u32)0;
 	int fail = 0;
 	u64 len;
 	int index;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(fs_info->csum_tfm)];
+	} desc;
+
+	desc.shash.tfm = fs_info->csum_tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
 
 	BUG_ON(sblock->page_count < 1);
 	if (!sblock->pagev[0]->have_csum)
@@ -1691,7 +1709,7 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	for (;;) {
 		u64 l = min_t(u64, len, PAGE_SIZE);
 
-		crc = btrfs_csum_data(buffer, crc, l);
+		crypto_shash_update(&desc.shash, buffer, l);
 		kunmap_atomic(buffer);
 		len -= l;
 		if (len == 0)
@@ -1703,7 +1721,7 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 		buffer = kmap_atomic(page);
 	}
 
-	btrfs_csum_final(crc, csum);
+	crypto_shash_final(&desc.shash, csum);
 	if (memcmp(csum, on_disk_csum, sctx->csum_size))
 		fail = 1;
 
@@ -1722,11 +1740,19 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	void *mapped_buffer;
 	u64 mapped_size;
 	void *p;
-	u32 crc = ~(u32)0;
 	int fail = 0;
 	int crc_fail = 0;
 	u64 len;
 	int index;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(fs_info->csum_tfm)];
+	} desc;
+
+	desc.shash.tfm = fs_info->csum_tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
 
 	BUG_ON(sblock->page_count < 1);
 	page = sblock->pagev[0]->page;
@@ -1760,7 +1786,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	for (;;) {
 		u64 l = min_t(u64, len, mapped_size);
 
-		crc = btrfs_csum_data(p, crc, l);
+		crypto_shash_update(&desc.shash, p, l);
 		kunmap_atomic(mapped_buffer);
 		len -= l;
 		if (len == 0)
@@ -1774,7 +1800,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 		p = mapped_buffer;
 	}
 
-	btrfs_csum_final(crc, calculated_csum);
+	crypto_shash_final(&desc.shash, calculated_csum);
 	if (memcmp(calculated_csum, on_disk_csum, sctx->csum_size))
 		++crc_fail;
 
@@ -1785,17 +1811,26 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 {
 	struct btrfs_super_block *s;
 	struct scrub_ctx *sctx = sblock->sctx;
+	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 	u8 on_disk_csum[BTRFS_CSUM_SIZE];
 	struct page *page;
 	void *mapped_buffer;
 	u64 mapped_size;
 	void *p;
-	u32 crc = ~(u32)0;
 	int fail_gen = 0;
 	int fail_cor = 0;
 	u64 len;
 	int index;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(fs_info->csum_tfm)];
+	} desc;
+
+	desc.shash.tfm = fs_info->csum_tfm;
+	desc.shash.flags = 0;
+
+	crypto_shash_init(&desc.shash);
 
 	BUG_ON(sblock->page_count < 1);
 	page = sblock->pagev[0]->page;
@@ -1819,7 +1854,7 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	for (;;) {
 		u64 l = min_t(u64, len, mapped_size);
 
-		crc = btrfs_csum_data(p, crc, l);
+		crypto_shash_update(&desc.shash, p, l);
 		kunmap_atomic(mapped_buffer);
 		len -= l;
 		if (len == 0)
@@ -1833,7 +1868,7 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 		p = mapped_buffer;
 	}
 
-	btrfs_csum_final(crc, calculated_csum);
+	crypto_shash_final(&desc.shash, calculated_csum);
 	if (memcmp(calculated_csum, on_disk_csum, sctx->csum_size))
 		++fail_cor;
 
@@ -2164,7 +2199,7 @@ static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u64 len,
 
 	index = ((u32)(logical - sum->bytenr)) / sctx->sectorsize;
 	num_sectors = sum->len / sctx->sectorsize;
-	memcpy(csum, sum->sums + index, sctx->csum_size);
+	memcpy(csum, sum->sums + index * sctx->csum_size, sctx->csum_size);
 	if (index == num_sectors - 1) {
 		list_del(&sum->list);
 		kfree(sum);
-- 
1.8.1.4

