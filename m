Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF37C43610
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 08:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9A32077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 08:55:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F9A32077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbeKOTCM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 14:02:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728699AbeKOTCL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 14:02:11 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03E51C045109;
        Thu, 15 Nov 2018 08:55:17 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D5ED60C7E;
        Thu, 15 Nov 2018 08:55:00 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ming Lei <ming.lei@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH V10 07/19] btrfs: use bvec_last_segment to get bio's last page
Date:   Thu, 15 Nov 2018 16:52:54 +0800
Message-Id: <20181115085306.9910-8-ming.lei@redhat.com>
In-Reply-To: <20181115085306.9910-1-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 15 Nov 2018 08:55:17 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Preparing for supporting multi-page bvec.

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-erofs@lists.ozlabs.org
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org
Cc: Boaz Harrosh <ooo@electrozaur.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: cluster-devel@redhat.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/compression.c | 5 ++++-
 fs/btrfs/extent_io.c   | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2955a4ea2fa8..161e14b8b180 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -400,8 +400,11 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 static u64 bio_end_offset(struct bio *bio)
 {
 	struct bio_vec *last = bio_last_bvec_all(bio);
+	struct bio_vec bv;
 
-	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
+	bvec_last_segment(last, &bv);
+
+	return page_offset(bv.bv_page) + bv.bv_len + bv.bv_offset;
 }
 
 static noinline int add_ra_bio_pages(struct inode *inode,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d228f706ff3e..5d5965297e7e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2720,11 +2720,12 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 {
 	blk_status_t ret = 0;
 	struct bio_vec *bvec = bio_last_bvec_all(bio);
-	struct page *page = bvec->bv_page;
+	struct bio_vec bv;
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
-	start = page_offset(page) + bvec->bv_offset;
+	bvec_last_segment(bvec, &bv);
+	start = page_offset(bv.bv_page) + bv.bv_offset;
 
 	bio->bi_private = NULL;
 
-- 
2.9.5

