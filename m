Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37779 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932887AbcJZXil (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 19:38:41 -0400
Date: Wed, 26 Oct 2016 19:38:08 -0400
From: Chris Mason <clm@fb.com>
To: Jens Axboe <axboe@fb.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "Andy Lutomirski" <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161026233808.GC15247@clm-mbp.thefacebook.com>
References: <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <203e0319-bc9b-245c-e162-709267540d22@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 05:20:01PM -0600, Jens Axboe wrote:
>On 10/26/2016 05:08 PM, Linus Torvalds wrote:
>>On Wed, Oct 26, 2016 at 4:03 PM, Jens Axboe <axboe@fb.com> wrote:
>>>
>>>Actually, I think I see what might trigger it. You are on nvme, iirc,
>>>and that has a deep queue.
>>
>>Yes. I have long since moved on from slow disks, so all my systems are
>>not just flash, but m.2 nvme ssd's.
>>
>>So at least that could explain why Dave sees it at bootup but I don't.
>
>Yep, you'd never sleep during normal boot. The original patch had a
>problem, though... This one should be better. Too many 'data's, we'll
>still need to assign ctx/hctx, we should just use the current ones, not
>the original ones.
>
>diff --git a/block/blk-mq.c b/block/blk-mq.c
>index ddc2eed64771..e56fec187ba6 100644
>--- a/block/blk-mq.c
>+++ b/block/blk-mq.c
>@@ -1217,9 +1224,9 @@ static struct request *blk_mq_map_request(struct 
>request_queue *q,
> 	blk_mq_set_alloc_data(&alloc_data, q, 0, ctx, hctx);
> 	rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);
>
>-	hctx->queued++;
>-	data->hctx = hctx;
>-	data->ctx = ctx;
>+	data->hctx = alloc_data.hctx;
>+	data->ctx = alloc_data.ctx;
>+	data->hctx->queued++;
> 	return rq;
> }

This made it through an entire dbench 2048 run on btrfs.  My script has 
it running in a loop, but this is farther than I've gotten before.  
Looking great so far.

-chris

