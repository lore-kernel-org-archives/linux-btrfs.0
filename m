Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60213 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932334AbcJZXFl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 19:05:41 -0400
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk>
 <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
 <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <20161026230113.jjyadei4ipwixgvg@codemonkey.org.uk>
From: Jens Axboe <axboe@fb.com>
Message-ID: <9bfe5929-3e7f-0e2e-857b-0a6787289361@fb.com>
Date: Wed, 26 Oct 2016 17:05:20 -0600
MIME-Version: 1.0
In-Reply-To: <20161026230113.jjyadei4ipwixgvg@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2016 05:01 PM, Dave Jones wrote:
> On Wed, Oct 26, 2016 at 03:51:01PM -0700, Linus Torvalds wrote:
>  > Dave: it might be a good idea to split that "WARN_ON_ONCE()" in
>  > blk_mq_merge_queue_io() into two, since right now it can trigger both
>  > for the
>  >
>  >                 blk_mq_bio_to_request(rq, bio);
>  >
>  > path _and_ for the
>  >
>  >                 if (!blk_mq_attempt_merge(q, ctx, bio)) {
>  >                         blk_mq_bio_to_request(rq, bio);
>  >                         goto insert_rq;
>  >
>  > path. If you split it into two: one before that "insert_rq:" label,
>  > and one before the "goto insert_rq" thing, then we could see if it is
>  > just one of the blk_mq_merge_queue_io() cases (or both) that is
>  > broken..
>
> It's the latter of the two.
>
> [   12.302392] WARNING: CPU: 3 PID: 272 at block/blk-mq.c:1191
> blk_sq_make_request+0x320/0x4d0

I would expect that - so normal request, since we know merging is on. I
just sent out a patch, can you give that a whirl?

Keep Linus' debugging patch, and apply it on top. Below as well, for
reference.


diff --git a/block/blk-mq.c b/block/blk-mq.c
index ddc2eed64771..80a9c45a9235 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1217,9 +1217,7 @@ static struct request *blk_mq_map_request(struct 
request_queue *q,
  	blk_mq_set_alloc_data(&alloc_data, q, 0, ctx, hctx);
  	rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);

-	hctx->queued++;
-	data->hctx = hctx;
-	data->ctx = ctx;
+	data->hctx->queued++;
  	return rq;
  }


-- 
Jens Axboe

