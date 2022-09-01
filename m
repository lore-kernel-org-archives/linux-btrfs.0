Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CC7ECAAD3
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Sep 2022 07:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiIAHoK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 03:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbiIAHnM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2022 03:43:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58B81257FC;
        Thu,  1 Sep 2022 00:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=k/bCRqhIEe5EhCH7REQnZWBBj0b2P9XHUMRdc2s+emM=; b=RJro6QENp+ATJxjQYZBSEm2m6k
        H9IF1Owaw6OuVJZmyYl3RtIdOuu2muedMSl8OC099YK+EJXkDH4LLua9j0GUjK2GT/MnHuHhDAnR0
        /S+Cycno1M4TpgpltNq/mTv4wZL6pM07ekiX4mGanWFKT+pL/IBuD5BF3e85X4dKxa0srgrx5iBxb
        1N7F3srEeW3h/BNPVF5HxYXvdHFfW7rCZcK4r+GgtiegnakSgWRYTG3Qh8qnvwIc/7CZ8BRB2nSOY
        aI18DV5QFCYLsIgHKBH15smQTpjvVwIxDxLUnZs83iLdOunBGc0aRUKAZ6FH0cRPmhnBFP4GDpSrc
        PUsdyPXQ==;
Received: from 213-225-1-14.nat.highway.a1.net ([213.225.1.14] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTeqv-00ANj6-36; Thu, 01 Sep 2022 07:43:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 11/17] btrfs: remove stripe boundary calculation for encoded I/O
Date:   Thu,  1 Sep 2022 10:42:10 +0300
Message-Id: <20220901074216.1849941-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901074216.1849941-1-hch@lst.de>
References: <20220901074216.1849941-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

Stop looking at the stripe boundary in
btrfs_encoded_read_regular_fill_pages() now that that btrfs_submit_bio
can split bios.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 833ea647f7887..399381a4f8e69 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10025,7 +10025,6 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 					  u64 file_offset, u64 disk_bytenr,
 					  u64 disk_io_size, struct page **pages)
 {
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_encoded_read_private priv = {
 		.inode = inode,
 		.file_offset = file_offset,
@@ -10033,33 +10032,15 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 	};
 	unsigned long i = 0;
 	u64 cur = 0;
-	int ret;
 
 	init_waitqueue_head(&priv.wait);
 	/*
-	 * Submit bios for the extent, splitting due to bio or stripe limits as
-	 * necessary.
+	 * Submit bios for the extent, splitting due to bio limits as necessary.
 	 */
 	while (cur < disk_io_size) {
-		struct extent_map *em;
-		struct btrfs_io_geometry geom;
 		struct bio *bio = NULL;
-		u64 remaining;
+		u64 remaining = disk_io_size - cur;
 
-		em = btrfs_get_chunk_map(fs_info, disk_bytenr + cur,
-					 disk_io_size - cur);
-		if (IS_ERR(em)) {
-			ret = PTR_ERR(em);
-		} else {
-			ret = btrfs_get_io_geometry(fs_info, em, BTRFS_MAP_READ,
-						    disk_bytenr + cur, &geom);
-			free_extent_map(em);
-		}
-		if (ret) {
-			WRITE_ONCE(priv.status, errno_to_blk_status(ret));
-			break;
-		}
-		remaining = min(geom.len, disk_io_size - cur);
 		while (bio || remaining) {
 			size_t bytes = min_t(u64, remaining, PAGE_SIZE);
 
-- 
2.30.2

