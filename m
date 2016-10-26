Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35058 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932584AbcJZWvE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 18:51:04 -0400
MIME-Version: 1.0
In-Reply-To: <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
References: <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
 <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk> <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk> <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com> <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com> <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2016 15:51:01 -0700
Message-ID: <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 3:40 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
>
> I gave it a shot too for shits & giggles.
> This falls out during boot.
>
> [    9.278420] WARNING: CPU: 0 PID: 1 at block/blk-mq.c:1181 blk_sq_make_request+0x465/0x4a0

Hmm. That's the

    WARN_ON_ONCE(rq->mq_ctx != ctx);

that I added to blk_mq_merge_queue_io(), and I really think that
warning is valid, and the fact that it triggers shows that something
is wrong with locking.

We just did a

                spin_lock(&ctx->lock);

and that lock is *supposed* to protect the __blk_mq_insert_request(),
but that uses rq->mq_ctx.

So if rq->mq_ctx != ctx, then we're locking the wrong context.

Jens - please explain to me why I'm wrong.

Or maybe I actually might have found the problem? In which case please
send me a patch that fixes it ;)

Dave: it might be a good idea to split that "WARN_ON_ONCE()" in
blk_mq_merge_queue_io() into two, since right now it can trigger both
for the

                blk_mq_bio_to_request(rq, bio);

path _and_ for the

                if (!blk_mq_attempt_merge(q, ctx, bio)) {
                        blk_mq_bio_to_request(rq, bio);
                        goto insert_rq;

path. If you split it into two: one before that "insert_rq:" label,
and one before the "goto insert_rq" thing, then we could see if it is
just one of the blk_mq_merge_queue_io() cases (or both) that is
broken..

                  Linus
