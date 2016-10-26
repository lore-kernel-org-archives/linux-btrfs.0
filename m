Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36382 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932707AbcJZWyO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 18:54:14 -0400
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
 <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk>
 <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
 <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
From: Jens Axboe <axboe@fb.com>
Message-ID: <baf46ab6-6b4a-19d4-a135-d62cacf309e6@fb.com>
Date: Wed, 26 Oct 2016 16:52:55 -0600
MIME-Version: 1.0
In-Reply-To: <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2016 04:40 PM, Dave Jones wrote:
> On Wed, Oct 26, 2016 at 03:21:53PM -0700, Linus Torvalds wrote:
>
>  > Could you try the attached patch? It adds a couple of sanity tests:
>  >
>  >  - a number of tests to verify that 'rq->queuelist' isn't already on
>  > some queue when it is added to a queue
>  >
>  >  - one test to verify that rq->mq_ctx is the same ctx that we have locked.
>  >
>  > I may be completely full of shit, and this patch may be pure garbage
>  > or "obviously will never trigger", but humor me.
>
> I gave it a shot too for shits & giggles.
> This falls out during boot.
>
> [    9.244030] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
> [    9.271391] ------------[ cut here ]------------
> [    9.278420] WARNING: CPU: 0 PID: 1 at block/blk-mq.c:1181 blk_sq_make_request+0x465/0x4a0
> [    9.285613] CPU: 0 PID: 1 Comm: init Not tainted 4.9.0-rc2-think+ #4

Very odd, don't immediately see how that can happen. For testing, can
you try and add the below patch? Just curious if that fixes the list
corruption. Thing is, I don't see how ->mq_ctx and ctx are different in
this path, but I can debug that on the side.


diff --git a/block/blk-mq.c b/block/blk-mq.c
index ddc2eed64771..73b9462aa21f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1165,9 +1165,10 @@ static inline bool hctx_allow_merges(struct 
blk_mq_hw_ctx *hctx)
  }

  static inline bool blk_mq_merge_queue_io(struct blk_mq_hw_ctx *hctx,
-					 struct blk_mq_ctx *ctx,
  					 struct request *rq, struct bio *bio)
  {
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+
  	if (!hctx_allow_merges(hctx) || !bio_mergeable(bio)) {
  		blk_mq_bio_to_request(rq, bio);
  		spin_lock(&ctx->lock);
@@ -1338,7 +1339,7 @@ static blk_qc_t blk_mq_make_request(struct 
request_queue *q, struct bio *bio)
  		goto done;
  	}

-	if (!blk_mq_merge_queue_io(data.hctx, data.ctx, rq, bio)) {
+	if (!blk_mq_merge_queue_io(data.hctx, rq, bio)) {
  		/*
  		 * For a SYNC request, send it to the hardware immediately. For
  		 * an ASYNC request, just ensure that we run it later on. The
@@ -1416,7 +1417,7 @@ static blk_qc_t blk_sq_make_request(struct 
request_queue *q, struct bio *bio)
  		return cookie;
  	}

-	if (!blk_mq_merge_queue_io(data.hctx, data.ctx, rq, bio)) {
+	if (!blk_mq_merge_queue_io(data.hctx, rq, bio)) {
  		/*
  		 * For a SYNC request, send it to the hardware immediately. For
  		 * an ASYNC request, just ensure that we run it later on. The

-- 
Jens Axboe

