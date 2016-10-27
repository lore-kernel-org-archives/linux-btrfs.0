Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933736AbcJ0GeD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 02:34:03 -0400
Date: Wed, 26 Oct 2016 23:33:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161027063356.GA547@infradead.org>
References: <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
 <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Dave, can you hit the warnings with this? Totally untested...

Can we just kill off the unhelpful blk_map_ctx structure, e.g.:


diff --git a/block/blk-mq.c b/block/blk-mq.c
index ddc2eed..d74a74a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1190,21 +1190,15 @@ static inline bool blk_mq_merge_queue_io(struct blk_mq_hw_ctx *hctx,
 	}
 }
 
-struct blk_map_ctx {
-	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *ctx;
-};
-
 static struct request *blk_mq_map_request(struct request_queue *q,
 					  struct bio *bio,
-					  struct blk_map_ctx *data)
+					  struct blk_mq_alloc_data *data)
 {
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx;
 	struct request *rq;
 	int op = bio_data_dir(bio);
 	int op_flags = 0;
-	struct blk_mq_alloc_data alloc_data;
 
 	blk_queue_enter_live(q);
 	ctx = blk_mq_get_ctx(q);
@@ -1214,12 +1208,10 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 		op_flags |= REQ_SYNC;
 
 	trace_block_getrq(q, bio, op);
-	blk_mq_set_alloc_data(&alloc_data, q, 0, ctx, hctx);
-	rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);
+	blk_mq_set_alloc_data(data, q, 0, ctx, hctx);
+	rq = __blk_mq_alloc_request(data, op, op_flags);
 
-	hctx->queued++;
-	data->hctx = hctx;
-	data->ctx = ctx;
+	data->hctx->queued++;
 	return rq;
 }
 
@@ -1267,7 +1259,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = rw_is_sync(bio_op(bio), bio->bi_opf);
 	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
-	struct blk_map_ctx data;
+	struct blk_mq_alloc_data data;
 	struct request *rq;
 	unsigned int request_count = 0;
 	struct blk_plug *plug;
@@ -1363,7 +1355,7 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
-	struct blk_map_ctx data;
+	struct blk_mq_alloc_data data;
 	struct request *rq;
 	blk_qc_t cookie;
 
