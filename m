Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64F7C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7710D20865
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7710D20865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbeKZNKk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 08:10:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbeKZNKi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 08:10:38 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06E193084035;
        Mon, 26 Nov 2018 02:18:03 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 077FA6A6B4;
        Mon, 26 Nov 2018 02:17:55 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH V12 02/20] btrfs: look at bi_size for repair decisions
Date:   Mon, 26 Nov 2018 10:17:02 +0800
Message-Id: <20181126021720.19471-3-ming.lei@redhat.com>
In-Reply-To: <20181126021720.19471-1-ming.lei@redhat.com>
References: <20181126021720.19471-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 26 Nov 2018 02:18:03 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

bio_readpage_error currently uses bi_vcnt to decide if it is worth
retrying an I/O.  But the vector count is mostly an implementation
artifact - it really should figure out if there is more than a
single sector worth retrying.  Use bi_size for that and shift by
PAGE_SHIFT.  This really should be blocks/sectors, but given that
btrfs doesn't support a sector size different from the PAGE_SIZE
using the page size keeps the changes to a minimum.

Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/extent_io.c | 2 +-
 include/linux/bio.h  | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 15fd46582bb2..40751e86a2a9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2368,7 +2368,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	int read_mode = 0;
 	blk_status_t status;
 	int ret;
-	unsigned failed_bio_pages = bio_pages_all(failed_bio);
+	unsigned failed_bio_pages = failed_bio->bi_iter.bi_size >> PAGE_SHIFT;
 
 	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 056fb627edb3..6f6bc331a5d1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -263,12 +263,6 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
 		bv->bv_len = iter.bi_bvec_done;
 }
 
-static inline unsigned bio_pages_all(struct bio *bio)
-{
-	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-	return bio->bi_vcnt;
-}
-
 static inline struct bio_vec *bio_first_bvec_all(struct bio *bio)
 {
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-- 
2.9.5

