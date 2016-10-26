Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:42022 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754604AbcJZWke (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 18:40:34 -0400
Date: Wed, 26 Oct 2016 18:40:25 -0400
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
Message-ID: <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 03:21:53PM -0700, Linus Torvalds wrote:

 > Could you try the attached patch? It adds a couple of sanity tests:
 > 
 >  - a number of tests to verify that 'rq->queuelist' isn't already on
 > some queue when it is added to a queue
 > 
 >  - one test to verify that rq->mq_ctx is the same ctx that we have locked.
 > 
 > I may be completely full of shit, and this patch may be pure garbage
 > or "obviously will never trigger", but humor me.
 
I gave it a shot too for shits & giggles.
This falls out during boot.

[    9.244030] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[    9.271391] ------------[ cut here ]------------
[    9.278420] WARNING: CPU: 0 PID: 1 at block/blk-mq.c:1181 blk_sq_make_request+0x465/0x4a0
[    9.285613] CPU: 0 PID: 1 Comm: init Not tainted 4.9.0-rc2-think+ #4
[    9.300106]  ffffc90000013848
[    9.307353]  ffffffff8130d27c
[    9.307420]  0000000000000000
[    9.307456]  0000000000000000
[    9.307494]  ffffc90000013888
[    9.314780]  ffffffff81077a41
[    9.314847]  0000049d00013898
[    9.314884]  0000000000000001
[    9.314922]  0000000000000002
[    9.322213]  ffffe8ffffc06600
[    9.322280]  ffffe8ffff606600
[    9.322317]  ffff8805015c2e80
[    9.322355] Call Trace:
[    9.329689]  [<ffffffff8130d27c>] dump_stack+0x4f/0x73
[    9.337208]  [<ffffffff81077a41>] __warn+0xc1/0xe0
[    9.344730]  [<ffffffff81077b18>] warn_slowpath_null+0x18/0x20
[    9.352282]  [<ffffffff812f7975>] blk_sq_make_request+0x465/0x4a0
[    9.359816]  [<ffffffff812eb44a>] ? generic_make_request+0xca/0x210
[    9.367367]  [<ffffffff812eb457>] generic_make_request+0xd7/0x210
[    9.374931]  [<ffffffff812eb5f9>] submit_bio+0x69/0x120
[    9.382488]  [<ffffffff812004ef>] ? submit_bh_wbc+0x16f/0x1e0
[    9.390083]  [<ffffffff812004ef>] submit_bh_wbc+0x16f/0x1e0
[    9.397673]  [<ffffffff81200bfe>] submit_bh+0xe/0x10
[    9.405205]  [<ffffffff81255eac>] __ext4_get_inode_loc+0x1ac/0x3d0
[    9.412795]  [<ffffffff81258f4b>] ext4_iget+0x6b/0xb70
[    9.420366]  [<ffffffff811d6018>] ? lookup_slow+0xf8/0x1f0
[    9.427947]  [<ffffffff81259a7a>] ext4_iget_normal+0x2a/0x30
[    9.435541]  [<ffffffff81264734>] ext4_lookup+0x114/0x230

