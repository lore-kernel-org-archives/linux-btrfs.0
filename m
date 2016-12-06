Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33682 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754107AbcLFQxN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Dec 2016 11:53:13 -0500
MIME-Version: 1.0
In-Reply-To: <20161206081659.GV3092@twins.programming.kicks-ass.net>
References: <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk> <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
 <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
 <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
 <CA+55aFxeWe2VQaW30qGR0syiZ75jSwFwg3Ac+wS20KDtf5UKNw@mail.gmail.com>
 <CAOMGZ=Eb8mw6CfGaruM-tRir7pWn78vLTaCqp1pGPqkagfzPPA@mail.gmail.com>
 <CA+55aFzEG-6pkJXy4itiXsHPu_VV5q2vd6zJLq6vmi=AzdnaUw@mail.gmail.com>
 <CA+55aFwC3nfmum6oPoBRU325CKjK-g3MuqW+bhq3+9DnE_4fgw@mail.gmail.com> <20161206081659.GV3092@twins.programming.kicks-ass.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2016 08:33:41 -0800
Message-ID: <CA+55aFzw1_N29mSttZ-TKn7S0-MKbvAfBr4PH+_KBMYr2Uoj+Q@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 6, 2016 at 12:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> Of course, I'm really hoping that this shmem.c use is the _only_ such
>> case.  But I doubt it.
>
> $ git grep DECLARE_WAIT_QUEUE_HEAD_ONSTACK | wc -l
> 28

Hmm. Most of them seem to be ok, because they use "wait_event()",
which will always remove itself from the wait-queue. And they do it
from the place that allocates the wait-queue.

IOW, the mm/shmem.c case really was fairly special, because it just
did "prepare_to_wait()", and then did a finish_wait() - and not in the
thread that allocated it on the stack.

So it's really that "some _other_ thread allocated the waitqueue on
the stack, and now we're doing a wait on it" that is bad.

So the normal pattern seems to be:

 - allocate wq on the stack
 - pass it on to a waker
 - wait for it

and that's ok, because as part of "wait for it" we will also be
cleaning things up.

The reason mm/shmem.c was buggy was that it did

 - allocate wq on the stack
 - pass it on to somebody else to wait for
 - wake it up

and *that* is buggy, because it's the waiter, not the waker, that
normally cleans things up.

Is there some good way to find this kind of pattern automatically, I wonder....

                     Linus
