Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3CNO7j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 10:59:39 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2EExchH030665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 14:59:38 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2EExbkv015273
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 14:59:37 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2EExbbX011175
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 09:59:37 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup unused arguments of btrfs_csum_data
Date: Thu, 14 Mar 2013 22:57:45 +0800
Message-Id: <1363273065-15563-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Argument 'root' is no more used in btrfs_csum_data().

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/compression.c      |    3 +--
 fs/btrfs/disk-io.c          |    6 +++---
 fs/btrfs/disk-io.h          |    2 +-
 fs/btrfs/file-item.c        |    3 +--
 fs/btrfs/free-space-cache.c |    4 ++--
 fs/btrfs/inode.c            |    5 ++---
 fs/btrfs/scrub.c            |   13 +++++--------
 7 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 15b9408..b9c5650 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -106,7 +106,6 @@ static int check_compressed_csum(struct inode *inode,
 				 u64 disk_start)
 {
 	int ret;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page *page;
 	unsigned long i;
 	char *kaddr;
@@ -121,7 +120,7 @@ static int check_compressed_csum(struct inode *inode,
 		csum = ~(u32)0;
 
 		kaddr = kmap_atomic(page);
-		csum = btrfs_csum_data(root, kaddr, csum, PAGE_CACHE_SIZE);
+		csum = btrfs_csum_data(kaddr, csum, PAGE_CACHE_SIZE);
 		btrfs_csum_final(csum, (char *)&csum);
 		kunmap_atomic(kaddr);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7d84651..b107028 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -238,7 +238,7 @@ out:
 	return em;
 }
 
-u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
+u32 btrfs_csum_data(char *data, u32 seed, size_t len)
 {
 	return crc32c(seed, data, len);
 }
@@ -274,7 +274,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		if (err)
 			return 1;
 		cur_len = min(len, map_len - (offset - map_start));
-		crc = btrfs_csum_data(root, kaddr + offset - map_start,
+		crc = btrfs_csum_data(kaddr + offset - map_start,
 				      crc, cur_len);
 		len -= cur_len;
 		offset += cur_len;
@@ -2913,7 +2913,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			btrfs_set_super_bytenr(sb, bytenr);
 
 			crc = ~(u32)0;
-			crc = btrfs_csum_data(NULL, (char *)sb +
+			crc = btrfs_csum_data((char *)sb +
 					      BTRFS_CSUM_SIZE, crc,
 					      BTRFS_SUPER_INFO_SIZE -
 					      BTRFS_CSUM_SIZE);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 034d7dc..e0deb27 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -77,7 +77,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
-u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
+u32 btrfs_csum_data(char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			int metadata);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ec16020..9c9dd40 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -482,8 +482,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 
 		data = kmap_atomic(bvec->bv_page);
 		sector_sum->sum = ~(u32)0;
-		sector_sum->sum = btrfs_csum_data(root,
-						  data + bvec->bv_offset,
+		sector_sum->sum = btrfs_csum_data(data + bvec->bv_offset,
 						  sector_sum->sum,
 						  bvec->bv_len);
 		kunmap_atomic(data);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1f84fc0..26ad3e7 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -431,7 +431,7 @@ static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-	crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + offset, crc,
+	crc = btrfs_csum_data(io_ctl->orig + offset, crc,
 			      PAGE_CACHE_SIZE - offset);
 	btrfs_csum_final(crc, (char *)&crc);
 	io_ctl_unmap_page(io_ctl);
@@ -461,7 +461,7 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 	kunmap(io_ctl->pages[0]);
 
 	io_ctl_map_page(io_ctl, 0);
-	crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + offset, crc,
+	crc = btrfs_csum_data(io_ctl->orig + offset, crc,
 			      PAGE_CACHE_SIZE - offset);
 	btrfs_csum_final(crc, (char *)&crc);
 	if (val != crc) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 13ab4de..a687a2b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2800,7 +2800,7 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	if (ret)
 		goto zeroit;
 
-	csum = btrfs_csum_data(root, kaddr + offset, csum,  end - start + 1);
+	csum = btrfs_csum_data(kaddr + offset, csum,  end - start + 1);
 	btrfs_csum_final(csum, (char *)&csum);
 	if (csum != private)
 		goto zeroit;
@@ -6902,7 +6902,6 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	struct inode *inode = dip->inode;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 start;
 
 	start = dip->logical_offset;
@@ -6919,7 +6918,7 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 				goto failed;
 			local_irq_save(flags);
 			kaddr = kmap_atomic(page);
-			csum = btrfs_csum_data(root, kaddr + bvec->bv_offset,
+			csum = btrfs_csum_data(kaddr + bvec->bv_offset,
 					       csum, bvec->bv_len);
 			btrfs_csum_final(csum, (char *)&csum);
 			kunmap_atomic(kaddr);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 53c3501..509c168 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1335,7 +1335,6 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 	int page_num;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 	u32 crc = ~(u32)0;
-	struct btrfs_root *root = fs_info->extent_root;
 	void *mapped_buffer;
 
 	WARN_ON(!sblock->pagev[0]->page);
@@ -1364,12 +1363,11 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 
 	for (page_num = 0;;) {
 		if (page_num == 0 && is_metadata)
-			crc = btrfs_csum_data(root,
+			crc = btrfs_csum_data(
 				((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE,
 				crc, PAGE_SIZE - BTRFS_CSUM_SIZE);
 		else
-			crc = btrfs_csum_data(root, mapped_buffer, crc,
-					      PAGE_SIZE);
+			crc = btrfs_csum_data(mapped_buffer, crc, PAGE_SIZE);
 
 		kunmap_atomic(mapped_buffer);
 		page_num++;
@@ -1656,7 +1654,6 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	void *buffer;
 	u32 crc = ~(u32)0;
 	int fail = 0;
-	struct btrfs_root *root = sctx->dev_root;
 	u64 len;
 	int index;
 
@@ -1673,7 +1670,7 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	for (;;) {
 		u64 l = min_t(u64, len, PAGE_SIZE);
 
-		crc = btrfs_csum_data(root, buffer, crc, l);
+		crc = btrfs_csum_data(buffer, crc, l);
 		kunmap_atomic(buffer);
 		len -= l;
 		if (len == 0)
@@ -1743,7 +1740,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	for (;;) {
 		u64 l = min_t(u64, len, mapped_size);
 
-		crc = btrfs_csum_data(root, p, crc, l);
+		crc = btrfs_csum_data(p, crc, l);
 		kunmap_atomic(mapped_buffer);
 		len -= l;
 		if (len == 0)
@@ -1804,7 +1801,7 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	for (;;) {
 		u64 l = min_t(u64, len, mapped_size);
 
-		crc = btrfs_csum_data(root, p, crc, l);
+		crc = btrfs_csum_data(p, crc, l);
 		kunmap_atomic(mapped_buffer);
 		len -= l;
 		if (len == 0)
-- 
1.7.7.6

