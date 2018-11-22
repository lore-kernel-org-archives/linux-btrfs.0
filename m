Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6694C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81BCD20672
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:17:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81BCD20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438119AbeKWC5F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 21:57:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:57950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730352AbeKWC5F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 21:57:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 89569AD17
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 16:17:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EF49EDA829; Thu, 22 Nov 2018 17:16:46 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: remove redundant csum buffer in btrfs_io_bio
Date:   Thu, 22 Nov 2018 17:16:46 +0100
Message-Id: <8eeb7eb407bf3d0d8defffd5564b45da1eb3da07.1542902890.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542902890.git.dsterba@suse.com>
References: <cover.1542902890.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The io_bio tracks checksums and has an inline buffer or an allocated
one. And there's a third member that points to the right one, but we
don't need to use an extra pointer for that. Let btrfs_io_bio::csum
point to the right buffer and check that the inline buffer is not
accidentally freed.

This shrinks struct btrfs_io_bio by 8 bytes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/file-item.c | 12 +++++++-----
 fs/btrfs/volumes.h   |  1 -
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ba74827beb32..1f2d0a6ab634 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -144,7 +144,10 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 
 static void btrfs_io_bio_endio_readpage(struct btrfs_io_bio *bio, int err)
 {
-	kfree(bio->csum_allocated);
+	if (bio->csum != bio->csum_inline) {
+		kfree(bio->csum);
+		bio->csum = NULL;
+	}
 }
 
 static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
@@ -175,13 +178,12 @@ static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio
 	nblocks = bio->bi_iter.bi_size >> inode->i_sb->s_blocksize_bits;
 	if (!dst) {
 		if (nblocks * csum_size > BTRFS_BIO_INLINE_CSUM_SIZE) {
-			btrfs_bio->csum_allocated = kmalloc_array(nblocks,
-					csum_size, GFP_NOFS);
-			if (!btrfs_bio->csum_allocated) {
+			btrfs_bio->csum = kmalloc_array(nblocks, csum_size,
+							GFP_NOFS);
+			if (!btrfs_bio->csum) {
 				btrfs_free_path(path);
 				return BLK_STS_RESOURCE;
 			}
-			btrfs_bio->csum = btrfs_bio->csum_allocated;
 			btrfs_bio->end_io = btrfs_io_bio_endio_readpage;
 		} else {
 			btrfs_bio->csum = btrfs_bio->csum_inline;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1d936ce282c3..9a764f2d462e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -274,7 +274,6 @@ struct btrfs_io_bio {
 	u64 logical;
 	u8 *csum;
 	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
-	u8 *csum_allocated;
 	btrfs_io_bio_end_io_t *end_io;
 	struct bvec_iter iter;
 	/*
-- 
2.19.1

