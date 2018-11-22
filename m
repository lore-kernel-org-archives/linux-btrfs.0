Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342FEC43610
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CDF20672
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:17:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02CDF20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438122AbeKWC5I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 21:57:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:57956 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730352AbeKWC5I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 21:57:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 510FEAD17
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 16:17:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 10357DA829; Thu, 22 Nov 2018 17:16:50 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: replace btrfs_io_bio::end_io with a simple helper
Date:   Thu, 22 Nov 2018 17:16:49 +0100
Message-Id: <d714df92c07fadf07f92c10f6d629c6fdbe9d9dd.1542902890.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542902890.git.dsterba@suse.com>
References: <cover.1542902890.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The end_io callback implemented as btrfs_io_bio_endio_readpage only
calls kfree. Also the callback is set only in case the csum buffer is
allocated and not pointing to the inline buffer. We can use that
information to drop the indirection and call a helper that will free the
csums only in the right case.

This shrinks struct btrfs_io_bio by 8 bytes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c |  3 +--
 fs/btrfs/file-item.c |  9 ---------
 fs/btrfs/inode.c     |  7 ++-----
 fs/btrfs/volumes.h   | 10 ++++++++--
 4 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ea808d6cfbc..aef3c9866ff0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2623,8 +2623,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 	if (extent_len)
 		endio_readpage_release_extent(tree, extent_start, extent_len,
 					      uptodate);
-	if (io_bio->end_io)
-		io_bio->end_io(io_bio, blk_status_to_errno(bio->bi_status));
+	btrfs_io_bio_free_csum(io_bio);
 	bio_put(bio);
 }
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 1f2d0a6ab634..920bf3b4b0ef 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -142,14 +142,6 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void btrfs_io_bio_endio_readpage(struct btrfs_io_bio *bio, int err)
-{
-	if (bio->csum != bio->csum_inline) {
-		kfree(bio->csum);
-		bio->csum = NULL;
-	}
-}
-
 static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
 {
@@ -184,7 +176,6 @@ static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio
 				btrfs_free_path(path);
 				return BLK_STS_RESOURCE;
 			}
-			btrfs_bio->end_io = btrfs_io_bio_endio_readpage;
 		} else {
 			btrfs_bio->csum = btrfs_bio->csum_inline;
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 26b8bec7c2dc..6bfd37e58924 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8017,9 +8017,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
 
 	dio_bio->bi_status = err;
 	dio_end_io(dio_bio);
-
-	if (io_bio->end_io)
-		io_bio->end_io(io_bio, blk_status_to_errno(err));
+	btrfs_io_bio_free_csum(io_bio);
 	bio_put(bio);
 }
 
@@ -8372,8 +8370,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	if (!ret)
 		return;
 
-	if (io_bio->end_io)
-		io_bio->end_io(io_bio, ret);
+	btrfs_io_bio_free_csum(io_bio);
 
 free_ordered:
 	/*
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9a764f2d462e..a13045fcfc45 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -267,14 +267,12 @@ struct btrfs_fs_devices {
  * we allocate are actually btrfs_io_bios.  We'll cram as much of
  * struct btrfs_bio as we can into this over time.
  */
-typedef void (btrfs_io_bio_end_io_t) (struct btrfs_io_bio *bio, int err);
 struct btrfs_io_bio {
 	unsigned int mirror_num;
 	unsigned int stripe_index;
 	u64 logical;
 	u8 *csum;
 	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
-	btrfs_io_bio_end_io_t *end_io;
 	struct bvec_iter iter;
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
@@ -288,6 +286,14 @@ static inline struct btrfs_io_bio *btrfs_io_bio(struct bio *bio)
 	return container_of(bio, struct btrfs_io_bio, bio);
 }
 
+static inline void btrfs_io_bio_free_csum(struct btrfs_io_bio *io_bio)
+{
+	if (io_bio->csum != io_bio->csum_inline) {
+		kfree(io_bio->csum);
+		io_bio->csum = NULL;
+	}
+}
+
 struct btrfs_bio_stripe {
 	struct btrfs_device *dev;
 	u64 physical;
-- 
2.19.1

