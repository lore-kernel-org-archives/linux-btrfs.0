Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:49658 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3GDJtY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 05:49:24 -0400
Received: by mail-we0-f176.google.com with SMTP id t56so939250wes.35
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 02:49:23 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 4/5] Btrfs-progs: return error on write failure in make_btrfs()
Date: Thu,  4 Jul 2013 10:48:39 +0100
Message-Id: <1372931320-8340-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372931320-8340-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
 <1372931320-8340-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of aborting with a BUG_ON() statement, return a
negated errno code. Also updated mkfs and convert tools
to print a nicer error message when make_btrfs() returns
an error.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 btrfs-convert.c |    3 ++-
 mkfs.c          |    2 +-
 utils.c         |   36 ++++++++++++++++++++++++++++--------
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 399856f..0e66eb9 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2323,7 +2323,8 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 			 blocks, total_bytes, blocksize, blocksize,
 			 blocksize, blocksize);
 	if (ret) {
-		fprintf(stderr, "unable to create initial ctree\n");
+		fprintf(stderr, "unable to create initial ctree: %s\n",
+			strerror(-ret));
 		goto fail;
 	}
 	/* create a system chunk that maps the whole device */
diff --git a/mkfs.c b/mkfs.c
index 7ff60e5..348bcaa 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1446,7 +1446,7 @@ int main(int ac, char **av)
 			 nodesize, leafsize,
 			 sectorsize, stripesize);
 	if (ret) {
-		fprintf(stderr, "error during mkfs %d\n", ret);
+		fprintf(stderr, "error during mkfs: %s\n", strerror(-ret));
 		exit(1);
 	}
 
diff --git a/utils.c b/utils.c
index 702a0b1..f43816b 100644
--- a/utils.c
+++ b/utils.c
@@ -215,7 +215,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[1]);
-	BUG_ON(ret != leafsize);
+	if (ret < 0)
+		return -errno;
+	else if (ret != leafsize)
+		return -EIO;
 
 	/* create the items for the extent tree */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -262,7 +265,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[2]);
-	BUG_ON(ret != leafsize);
+	if (ret < 0)
+		return -errno;
+	else if (ret != leafsize)
+		return -EIO;
 
 	/* create the chunk tree */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -346,7 +352,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[3]);
-	BUG_ON(ret != leafsize);
+	if (ret < 0)
+		return -errno;
+	else if (ret != leafsize)
+		return -EIO;
 
 	/* create the device tree */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -382,7 +391,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
-	BUG_ON(ret != leafsize);
+	if (ret < 0)
+		return -errno;
+	else if (ret != leafsize)
+		return -EIO;
 
 	/* create the FS root */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -392,7 +404,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[5]);
-	BUG_ON(ret != leafsize);
+	if (ret < 0)
+		return -errno;
+	else if (ret != leafsize)
+		return -EIO;
 
 	/* finally create the csum root */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -402,7 +417,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[6]);
-	BUG_ON(ret != leafsize);
+	if (ret < 0)
+		return -errno;
+	else if (ret != leafsize)
+		return -EIO;
 
 	/* and write out the super block */
 	BUG_ON(sizeof(super) > sectorsize);
@@ -411,8 +429,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	buf->len = sectorsize;
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
-	BUG_ON(ret != sectorsize);
-
+	if (ret < 0)
+		return -errno;
+	else if (ret != leafsize)
+		return -EIO;
 
 	free(buf);
 	return 0;
-- 
1.7.9.5

