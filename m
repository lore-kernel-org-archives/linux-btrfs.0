Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34732 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753508AbcJSA3D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 20:29:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk> <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com> <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com> <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Oct 2016 17:28:44 -0700
Message-ID: <CA+55aFxA1QrO2sBwwtEQVp3FFgs6CGWzJg+U5kif+-msFc90uA@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2016 at 5:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Adding Andy to the cc, because this *might* be triggered by the
> vmalloc stack code itself. Maybe the re-use of stacks showing some
> problem? Maybe Chris (who can't see the problem) doesn't have
> CONFIG_VMAP_STACK enabled?

I bet it's the plug itself that is the stack address. In fact, it's
probably that mq_list head pointer

I think every single users of block plugging uses the pattern

        struct blk_plug plug;

        blk_start_plug(&plug);

and then we'll have

        INIT_LIST_HEAD(&plug->mq_list);

which initializes that mq_list head with the stack addresses pointing to itself.

So when we see something like this:

  list_add corruption. prev->next should be next (ffffe8ffff806648),
but was ffffc9000067fcd8. (prev=ffff880503878b80)

and it comes from

    list_add_tail(&rq->queuelist, &plug->mq_list);

which will expand to

    __list_add(new, head->prev, head)

which in this case *should* be:

    __list_add(&rq->queuelist, plug->mq_list.prev, &plug->mq_list);

so in fact we *should* have "next" be a stack address.

So that debug message is really really odd. I would expect that "next"
is the stack address (because we're adding to the tail of the list, so
"next" is the list head itself), but the debug message corruption
printout says that "was" is the stack address, but next isn't.

Weird.The "but was" value actually looks like the right address should
look, but the actual address (which *should* be just "&plug->mq_list"
and really should be on the stack) looks bogus.

I'm now very confused.

                  Linus
