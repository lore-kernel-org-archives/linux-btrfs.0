Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:42324 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932549AbcJZXBW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 19:01:22 -0400
Date: Wed, 26 Oct 2016 19:01:13 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161026230113.jjyadei4ipwixgvg@codemonkey.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 03:51:01PM -0700, Linus Torvalds wrote:
 > Dave: it might be a good idea to split that "WARN_ON_ONCE()" in
 > blk_mq_merge_queue_io() into two, since right now it can trigger both
 > for the
 > 
 >                 blk_mq_bio_to_request(rq, bio);
 > 
 > path _and_ for the
 > 
 >                 if (!blk_mq_attempt_merge(q, ctx, bio)) {
 >                         blk_mq_bio_to_request(rq, bio);
 >                         goto insert_rq;
 > 
 > path. If you split it into two: one before that "insert_rq:" label,
 > and one before the "goto insert_rq" thing, then we could see if it is
 > just one of the blk_mq_merge_queue_io() cases (or both) that is
 > broken..

It's the latter of the two.

[   12.302392] WARNING: CPU: 3 PID: 272 at block/blk-mq.c:1191
blk_sq_make_request+0x320/0x4d0

	Dave


