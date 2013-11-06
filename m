Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56122 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/16] btrfs-progs: fix leak of "buf" in make_btrfs() error paths
Date: Wed,  6 Nov 2013 17:15:45 -0600
Message-Id: <1383779755-18228-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If any pwrite failed we leaked the allocated "buf" on
return from the function.  "goto out" takes care of
those paths.

Resolves-Coverity-CID: 1125938
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |   62 ++++++++++++++++++++++++++++++++------------------------------
 1 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/utils.c b/utils.c
index c784345..d8ce153 100644
--- a/utils.c
+++ b/utils.c
@@ -210,10 +210,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[1]);
-	if (ret < 0)
-		return -errno;
-	else if (ret != leafsize)
-		return -EIO;
+	if (ret != leafsize) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
 
 	/* create the items for the extent tree */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -269,10 +269,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[2]);
-	if (ret < 0)
-		return -errno;
-	else if (ret != leafsize)
-		return -EIO;
+	if (ret != leafsize) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
 
 	/* create the chunk tree */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -356,10 +356,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[3]);
-	if (ret < 0)
-		return -errno;
-	else if (ret != leafsize)
-		return -EIO;
+	if (ret != leafsize) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
 
 	/* create the device tree */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -395,10 +395,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
-	if (ret < 0)
-		return -errno;
-	else if (ret != leafsize)
-		return -EIO;
+	if (ret != leafsize) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
 
 	/* create the FS root */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -408,11 +408,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[5]);
-	if (ret < 0)
-		return -errno;
-	else if (ret != leafsize)
-		return -EIO;
-
+	if (ret != leafsize) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
 	/* finally create the csum root */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
 		leafsize-sizeof(struct btrfs_header));
@@ -421,10 +420,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[6]);
-	if (ret < 0)
-		return -errno;
-	else if (ret != leafsize)
-		return -EIO;
+	if (ret != leafsize) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
 
 	/* and write out the super block */
 	BUG_ON(sizeof(super) > sectorsize);
@@ -433,13 +432,16 @@ int make_btrfs(int fd, const char *device, const char *label,
 	buf->len = sectorsize;
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
-	if (ret < 0)
-		return -errno;
-	else if (ret != sectorsize)
-		return -EIO;
+	if (ret != sectorsize) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
+
+	ret = 0;
 
+out:
 	free(buf);
-	return 0;
+	return ret;
 }
 
 u64 btrfs_device_size(int fd, struct stat *st)
-- 
1.7.1

