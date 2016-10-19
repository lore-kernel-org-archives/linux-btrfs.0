Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34015 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757146AbcJSRoB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 13:44:01 -0400
MIME-Version: 1.0
In-Reply-To: <9ba0cd0b-33f6-2156-aaf2-ad9ed9a00115@pmhahn.de>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk> <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com> <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com> <9ba0cd0b-33f6-2156-aaf2-ad9ed9a00115@pmhahn.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Oct 2016 10:43:59 -0700
Message-ID: <CA+55aFx1W2d4TJN5_D-v_3-hVKKqSyrweqk+eigvNtr_hJe_9A@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Philipp Hahn <pmhahn@pmhahn.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Cc: Chris Mason <clm@fb.com>, Jens Axboe <axboe@fb.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 19, 2016 at 10:09 AM, Philipp Hahn <pmhahn@pmhahn.de> wrote:
>
> Nearly a month ago I reported also a "list_add corruption", but with 4.1.6:
> <http://marc.info/?l=linux-kernel&m=147508265316854&w=2>
>
> That server rungs Samba4, which also is a heavy user of xattr.

That one looks very different. In fact, the list that got corrupted
for you has since been changed to a hlist (which is *similar* to our
doubly-linked list, but has a smaller head and does not allow adding
to the end of the list).

Also, the "should be" and "was" values are very close, and switched:

should be ffffffff81ab3ca8, but was ffffffff81ab3cc8
should be ffffffff81ab3cc8, but was ffffffff81ab3ca8

so it actually looks like it was the same data structure. In
particular, it looks like enqueue_timer() ended up racing on adding an
entry to one index in the "base->vectors[]" array, while hitting an
entry that was pointing to another index near-by.

So I don't think it's related. Yours looks like some subtle timer base
race. It smells like a locking problem with timers. I'm not seeing
what it might be, but it *might* have been fixed by doing the
TIMER_MIGRATING bit right in add_timer_on() (commit 22b886dd1018).

Adding some timer people just in case, but I don't think your 4.1
report is related.

                Linus
