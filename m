Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:40526 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759174Ab2IKTgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 15:36:46 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id s4UYgCiJoGZ2Fnxb (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 13:36:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: create a pinned em when writing to a prealloc range in DIO
Date: Tue, 11 Sep 2012 15:42:11 -0400
Message-ID: <1347392531-10863-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wade Cline reported a problem where he was getting garbage and warnings when
writing to a preallocated range via O_DIRECT.  This is because we weren't
creating our normal pinned extent_map for the range we were writing to,
which was causing all sorts of issues.  This patch fixes the problem and
makes his testcase much happier.  Thanks,

Reported-by: Wade Cline <clinew@linux.vnet.ibm.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e7107bd..ccc3310 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6513,6 +6513,48 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 	return ret;
 }
 
+static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
+					   u64 len, u64 orig_start,
+					   u64 block_start, u64 block_len,
+					   int type)
+{
+	struct extent_map_tree *em_tree;
+	struct extent_map *em;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	em_tree = &BTRFS_I(inode)->extent_tree;
+	em = alloc_extent_map();
+	if (!em)
+		return ERR_PTR(-ENOMEM);
+
+	em->start = start;
+	em->orig_start = orig_start;
+	em->len = len;
+	em->block_len = block_len;
+	em->block_start = block_start;
+	em->bdev = root->fs_info->fs_devices->latest_bdev;
+	set_bit(EXTENT_FLAG_PINNED, &em->flags);
+	if (type == BTRFS_ORDERED_PREALLOC)
+		set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
+
+	do {
+		btrfs_drop_extent_cache(inode, em->start,
+				em->start + em->len - 1, 0);
+		write_lock(&em_tree->lock);
+		ret = add_extent_mapping(em_tree, em);
+		write_unlock(&em_tree->lock);
+	} while (ret == -EEXIST);
+
+	if (ret) {
+		free_extent_map(em);
+		return ERR_PTR(ret);
+	}
+
+	return em;
+}
+
+
 static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -6627,6 +6669,19 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 			goto must_cow;
 
 		if (can_nocow_odirect(trans, inode, start, len) == 1) {
+			u64 orig_start = em->start;
+
+			if (type == BTRFS_ORDERED_PREALLOC) {
+				free_extent_map(em);
+				em = create_pinned_em(inode, start, len,
+						       orig_start,
+						       block_start, len, type);
+				if (IS_ERR(em)) {
+					btrfs_end_transaction(trans, root);
+					goto unlock_err;
+				}
+			}
+
 			ret = btrfs_add_ordered_extent_dio(inode, start,
 					   block_start, len, len, type);
 			btrfs_end_transaction(trans, root);
-- 
1.7.7.6

