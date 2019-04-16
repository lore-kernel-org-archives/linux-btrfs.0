Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152C7C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8509206B6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbfDPQmS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:42:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:36224 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729237AbfDPQmS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:42:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00FF1B05E;
        Tue, 16 Apr 2019 16:42:17 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 05/18] btrfs: return whether extent is nocow or not
Date:   Tue, 16 Apr 2019 11:41:41 -0500
Message-Id: <20190416164154.30390-6-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We require this to make sure we return type IOMAP_DAX_COW in
iomap structure, in the later patches.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/inode.c | 9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b7bbe5130a3b..050f30165531 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3278,7 +3278,7 @@ struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 int btrfs_get_extent_map_write(struct extent_map **map, struct buffer_head *bh,
-		struct inode *inode, u64 start, u64 len);
+		struct inode *inode, u64 start, u64 len, bool *nocow);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 				    struct page *page, size_t pg_offset,
 				    u64 start, u64 end, int create);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 80184d0c3b52..06764d89490f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7499,12 +7499,15 @@ static int btrfs_get_blocks_direct_read(struct extent_map *em,
 int btrfs_get_extent_map_write(struct extent_map **map,
 		struct buffer_head *bh,
 		struct inode *inode,
-		u64 start, u64 len)
+		u64 start, u64 len, bool *nocow)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em = *map;
 	int ret = 0;
 
+	if (nocow)
+		*nocow = false;
+
 	/*
 	 * We don't allocate a new extent in the following cases
 	 *
@@ -7553,6 +7556,8 @@ int btrfs_get_extent_map_write(struct extent_map **map,
 			 */
 			btrfs_free_reserved_data_space_noquota(inode, start,
 							       len);
+			if (nocow)
+				*nocow = true;
 			/* skip COW */
 			goto out;
 		}
@@ -7579,7 +7584,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	struct extent_map *em;
 
 	ret = btrfs_get_extent_map_write(map, bh_result, inode,
-			start, len);
+			start, len, NULL);
 	if (ret < 0)
 		return ret;
 	em = *map;
-- 
2.16.4

