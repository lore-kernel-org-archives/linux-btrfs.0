Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48762 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbeINMie (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 08:38:34 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7792AE1D
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 07:25:22 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: convert: Output meaningful error messages for create_image()
Date: Fri, 14 Sep 2018 15:25:05 +0800
Message-Id: <20180914072505.15916-3-wqu@suse.com>
In-Reply-To: <20180914072505.15916-1-wqu@suse.com>
References: <20180914072505.15916-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When convert failed, the error messsage would look like:

  create btrfs filesystem:
      blocksize: 4096
      nodesize:  16384
      features:  extref, skinny-metadata (default)
  creating ext2 image file
  ERROR: failed to create ext2_saved/image: -1
  WARNING: an error occurred during conversion, filesystem is partially
  created but not finalized and not mountable

We can only know something wrong happened during "ext2_saved/image" file
creation, but unable to know what exactly went wrong.

This patch will add the following error messages for create_image() and
its callee:

1) Sanity test error
2) Csum calculation error
3) Free ino number allocation error
4) Inode creation error
5) Inode mode change error
6) Inode link error

With all these error messages, we should be pretty easy to locate the
error without extra debugging.

Reported-by: Serhat Sevki Dincer <jfcgauss@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/main.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 3736a14955d1..f100699b652c 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -290,10 +290,16 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	if (disk_bytenr) {
 		/* Check if the range is in a data block group */
 		bg_cache = btrfs_lookup_block_group(root->fs_info, bytenr);
-		if (!bg_cache)
+		if (!bg_cache) {
+			error("missing data block for bytenr %llu", bytenr);
 			return -ENOENT;
-		if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_DATA))
+		}
+		if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_DATA)) {
+			error(
+	"data bytenr %llu is covered by non-data block group %llu flags 0x%llu",
+			      bytenr, bg_cache->key.objectid, bg_cache->flags);
 			return -EINVAL;
+		}
 
 		/* The extent should never cross block group boundary */
 		len = min_t(u64, len, bg_cache->key.objectid +
@@ -310,8 +316,13 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		return ret;
 
-	if (datacsum)
+	if (datacsum) {
 		ret = csum_disk_extent(trans, root, bytenr, len);
+		if (ret < 0)
+			error(
+		"failed to calculate csum for bytenr %llu len %llu, %s\n",
+			      bytenr, len, strerror(-ret));
+	}
 	*ret_len = len;
 	return ret;
 }
@@ -759,18 +770,30 @@ static int create_image(struct btrfs_root *root,
 
 	ret = btrfs_find_free_objectid(trans, root, BTRFS_FIRST_FREE_OBJECTID,
 				       &ino);
-	if (ret < 0)
+	if (ret < 0) {
+		error("failed to find free objectid for root %llu, %s",
+			root->root_key.objectid, strerror(-ret));
 		goto out;
+	}
 	ret = btrfs_new_inode(trans, root, ino, 0400 | S_IFREG);
-	if (ret < 0)
+	if (ret < 0) {
+		error("failed to create new inode for root %llu, %s",
+			root->root_key.objectid, strerror(-ret));
 		goto out;
+	}
 	ret = btrfs_change_inode_flags(trans, root, ino, flags);
-	if (ret < 0)
+	if (ret < 0) {
+		error("failed to change inode flag for ino %llu root %llu, %s",
+			ino, root->root_key.objectid, strerror(-ret));
 		goto out;
+	}
 	ret = btrfs_add_link(trans, root, ino, BTRFS_FIRST_FREE_OBJECTID, name,
 			     strlen(name), BTRFS_FT_REG_FILE, NULL, 1, 0);
-	if (ret < 0)
+	if (ret < 0) {
+		error("failed to link ino %llu to '/%s' in root %llu, %s",
+			ino, name, root->root_key.objectid, strerror(-ret));
 		goto out;
+	}
 
 	key.objectid = ino;
 	key.type = BTRFS_INODE_ITEM_KEY;
-- 
2.19.0
