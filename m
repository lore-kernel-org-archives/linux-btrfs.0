Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E467AC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 10:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B197420820
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 10:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B197420820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390592AbeKVVhq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 16:37:46 -0500
Received: from verein.lst.de ([213.95.11.211]:57683 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732079AbeKVVhp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 16:37:45 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 0F65C68BC7; Thu, 22 Nov 2018 11:58:50 +0100 (CET)
Date:   Thu, 22 Nov 2018 11:58:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
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
Subject: Re: [PATCH V11 07/19] fs/buffer.c: use bvec iterator to truncate
 the bio
Message-ID: <20181122105849.GA30066@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-8-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121032327.8434-8-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Btw, given that this is the last user of bvec_last_segment after my
other patches I think we should kill bvec_last_segment and do something
like this here:


diff --git a/fs/buffer.c b/fs/buffer.c
index fa37ad52e962..af5e135d2b83 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2981,6 +2981,14 @@ static void end_bio_bh_io_sync(struct bio *bio)
 	bio_put(bio);
 }
 
+static void zero_trailing_sectors(struct bio_vec *bvec, unsigned bytes)
+{
+	unsigned last_page = (bvec->bv_offset + bvec->bv_len - 1) >> PAGE_SHIFT;
+
+	zero_user(nth_page(bvec->bv_page, last_page),
+		  bvec->bv_offset % PAGE_SIZE + bvec->bv_len, bytes);
+}
+
 /*
  * This allows us to do IO even on the odd last sectors
  * of a device, even if the block size is some multiple
@@ -3031,13 +3039,8 @@ void guard_bio_eod(int op, struct bio *bio)
 	bvec->bv_len -= truncated_bytes;
 
 	/* ..and clear the end of the buffer for reads */
-	if (op == REQ_OP_READ) {
-		struct bio_vec bv;
-
-		bvec_last_segment(bvec, &bv);
-		zero_user(bv.bv_page, bv.bv_offset + bv.bv_len,
-				truncated_bytes);
-	}
+	if (op == REQ_OP_READ)
+		zero_trailing_sectors(bvec, truncated_bytes);
 }
 
 static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
