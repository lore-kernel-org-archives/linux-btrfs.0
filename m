Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A53C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 114932084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 114932084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbeLEM3D (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:29:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:48484 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727679AbeLEM3D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:29:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33DD2AEB9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:29:01 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 05/10] btrfs: Carve out btrfs_get_extent_map_write() out of btrfs_get_blocks_write()
Date:   Wed,  5 Dec 2018 06:28:30 -0600
Message-Id: <20181205122835.19290-6-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This makes btrfs_get_extent_map_write() independent of Direct
I/O code.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/inode.c | 40 +++++++++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5144d28216b0..a0d296b0d826 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3169,6 +3169,8 @@ struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
 			      struct btrfs_path *path);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
+int btrfs_get_extent_map_write(struct extent_map **map, struct buffer_head *bh,
+		struct inode *inode, u64 start, u64 len);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset,
 		u64 start, u64 end, int create);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 96e9fe9e4150..4671cd9165c1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7485,11 +7485,10 @@ static int btrfs_get_blocks_direct_read(struct extent_map *em,
 	return 0;
 }
 
-static int btrfs_get_blocks_direct_write(struct extent_map **map,
-					 struct buffer_head *bh_result,
-					 struct inode *inode,
-					 struct btrfs_dio_data *dio_data,
-					 u64 start, u64 len)
+int btrfs_get_extent_map_write(struct extent_map **map,
+		struct buffer_head *bh,
+		struct inode *inode,
+		u64 start, u64 len)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em = *map;
@@ -7543,22 +7542,38 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 			 */
 			btrfs_free_reserved_data_space_noquota(inode, start,
 							       len);
-			goto skip_cow;
+			/* skip COW */
+			goto out;
 		}
 	}
 
 	/* this will cow the extent */
-	len = bh_result->b_size;
+	if (bh)
+		len = bh->b_size;
 	free_extent_map(em);
 	*map = em = btrfs_new_extent_direct(inode, start, len);
-	if (IS_ERR(em)) {
-		ret = PTR_ERR(em);
-		goto out;
-	}
+	if (IS_ERR(em))
+		return PTR_ERR(em);
+out:
+	return ret;
+}
 
+static int btrfs_get_blocks_direct_write(struct extent_map **map,
+					 struct buffer_head *bh_result,
+					 struct inode *inode,
+					 struct btrfs_dio_data *dio_data,
+					 u64 start, u64 len)
+{
+	int ret = 0;
+	struct extent_map *em;
+
+	ret = btrfs_get_extent_map_write(map, bh_result, inode,
+			start, len);
+	if (ret < 0)
+		return ret;
+	em = *map;
 	len = min(len, em->len - (start - em->start));
 
-skip_cow:
 	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
 		inode->i_blkbits;
 	bh_result->b_size = len;
@@ -7579,7 +7594,6 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	dio_data->reserve -= len;
 	dio_data->unsubmitted_oe_range_end = start + len;
 	current->journal_info = dio_data;
-out:
 	return ret;
 }
 
-- 
2.16.4

