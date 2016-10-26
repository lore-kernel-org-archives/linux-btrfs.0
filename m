Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34020 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934068AbcJZXV0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 19:21:26 -0400
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>
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
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
CC: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <203e0319-bc9b-245c-e162-709267540d22@fb.com>
Date: Wed, 26 Oct 2016 17:20:01 -0600
MIME-Version: 1.0
In-Reply-To: <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2016 05:08 PM, Linus Torvalds wrote:
> On Wed, Oct 26, 2016 at 4:03 PM, Jens Axboe <axboe@fb.com> wrote:
>>
>> Actually, I think I see what might trigger it. You are on nvme, iirc,
>> and that has a deep queue.
>
> Yes. I have long since moved on from slow disks, so all my systems are
> not just flash, but m.2 nvme ssd's.
>
> So at least that could explain why Dave sees it at bootup but I don't.

Yep, you'd never sleep during normal boot. The original patch had a
problem, though... This one should be better. Too many 'data's, we'll
still need to assign ctx/hctx, we should just use the current ones, not
the original ones.

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ddc2eed64771..e56fec187ba6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1217,9 +1224,9 @@ static struct request *blk_mq_map_request(struct 
request_queue *q,
  	blk_mq_set_alloc_data(&alloc_data, q, 0, ctx, hctx);
  	rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);

-	hctx->queued++;
-	data->hctx = hctx;
-	data->ctx = ctx;
+	data->hctx = alloc_data.hctx;
+	data->ctx = alloc_data.ctx;
+	data->hctx->queued++;
  	return rq;
  }


-- 
Jens Axboe

