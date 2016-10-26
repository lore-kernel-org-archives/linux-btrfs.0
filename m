Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:32813 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755280AbcJZWHN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 18:07:13 -0400
MIME-Version: 1.0
In-Reply-To: <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
References: <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk> <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk> <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk> <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk> <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk> <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2016 15:07:10 -0700
Message-ID: <CA+55aFxkhMnyh+L78f4Hkq6hnDaSv7X-_gADFd5vDQjKZnruLw@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Chris Mason <clm@fb.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 1:00 PM, Chris Mason <clm@fb.com> wrote:
>
> Today I turned off every CONFIG_DEBUG_* except for list debugging, and
> ran dbench 2048:
>
> [ 2759.118711] WARNING: CPU: 2 PID: 31039 at lib/list_debug.c:33 __list_add+0xbe/0xd0
> [ 2759.119652] list_add corruption. prev->next should be next (ffffe8ffffc80308), but was ffffc90000ccfb88. (prev=ffff880128522380).
> [ 2759.121039] Modules linked in: crc32c_intel i2c_piix4 aesni_intel aes_x86_64 virtio_net glue_helper i2c_core lrw floppy gf128mul serio_raw pcspkr button ablk_helper cryptd sch_fq_codel autofs4 virtio_blk
> [ 2759.124369] CPU: 2 PID: 31039 Comm: dbench Not tainted 4.9.0-rc1-15246-g4ce9206-dirty #317
> [ 2759.125077] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.0-1.fc24 04/01/2014
> [ 2759.125077]  ffffc9000f6fb868 ffffffff814fe4ff ffffffff8151cb5e ffffc9000f6fb8c8
> [ 2759.125077]  ffffc9000f6fb8c8 0000000000000000 ffffc9000f6fb8b8 ffffffff81064bbf
> [ 2759.127444]  ffff880128523680 0000002139968000 ffff880138b7a4a0 ffff880128523540
> [ 2759.127444] Call Trace:
> [ 2759.127444]  [<ffffffff814fe4ff>] dump_stack+0x53/0x74
> [ 2759.127444]  [<ffffffff8151cb5e>] ? __list_add+0xbe/0xd0
> [ 2759.127444]  [<ffffffff81064bbf>] __warn+0xff/0x120
> [ 2759.127444]  [<ffffffff81064c99>] warn_slowpath_fmt+0x49/0x50
> [ 2759.127444]  [<ffffffff8151cb5e>] __list_add+0xbe/0xd0
> [ 2759.127444]  [<ffffffff814df338>] blk_sq_make_request+0x388/0x580

Ok, that's definitely the same one that Dave started out seeing.

The fact that it is that reliable - two different machines, two very
different loads (dbench looks nothing like trinity) really makes me
think that maybe the problem really is in the block plugging after
all.

It very much does not smell like random stack corruption. It's simply
not random enough.

And I just noticed something: I originally thought that this is the
"list_add_tail()" to the plug - which is the only "list_add()" variant
in that function.

But that never made sense, because the whole "but was" isn't a stack
address, and "next" in "list_add_tail()" is basically fixed, and would
have to be the stack.

But I now notice that there's actually another "list_add()" variant
there, and it's the one from __blk_mq_insert_request() that gets
inlined into blk_mq_insert_request(), which then gets inlined into
blk_mq_make_request().

And that actually makes some sense just looking at the offsets too:

     blk_sq_make_request+0x388/0x580

so it's somewhat at the end of blk_sq_make_request(). So it's not unlikely.

And there it makes perfect sense that the "next should be" value is
*not* on the stack.

Chris, if you built with debug info, you can try

    ./scripts/faddr2line /boot/vmlinux blk_sq_make_request+0x388

to get what line that blk_sq_make_request+0x388 address actually is. I
think it's the

                list_add_tail(&rq->queuelist, &ctx->rq_list);

in __blk_mq_insert_req_list() (when it's inlined from
blk_sq_make_request(), "at_head" will be false.

So it smells like "&ctx->rq_list" might be corrupt.

And that actually seems much more likely than the "plug" list, because
while the plug is entirely thread-local (and thus shouldn't have any
races), the ctx->rq_list very much is not.

Jens?

For example, should we have a

    BUG_ON(ctx != rq->mq_ctx);

in blk_mq_merge_queue_io()? Because it locks ctx->lock, but then
__blk_mq_insert_request() will insert things onto the queues of
rq->mq_ctx.

blk_mq_insert_requests() has similar issues, but there has that BUG_ON().

The locking there really is *very* messy. All the lockers do

        spin_lock(&ctx->lock);
        ...
        spin_unlock(&ctx->lock);

but then __blk_mq_insert_request() and __blk_mq_insert_req_list don't
act on "ctx", but on "ctx = rq->mq_ctx", so if you ever get those
wrong, you're completely dead.

Now, I'm not seeing why they'd be wrong, and why they'd be associated
with the VMAP_STACK thing, but it could just be an unlucky timing
thing.

           Linus
