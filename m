Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:53490 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755525AbcJTXDv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 19:03:51 -0400
Date: Thu, 20 Oct 2016 19:03:41 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk>
 <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 20, 2016 at 04:01:12PM -0700, Andy Lutomirski wrote:
 > On Thu, Oct 20, 2016 at 3:50 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
 > > On Tue, Oct 18, 2016 at 06:05:57PM -0700, Andy Lutomirski wrote:
 > >
 > >  > One possible debugging approach would be to change:
 > >  >
 > >  > #define NR_CACHED_STACKS 2
 > >  >
 > >  > to
 > >  >
 > >  > #define NR_CACHED_STACKS 0
 > >  >
 > >  > in kernel/fork.c and to set CONFIG_DEBUG_PAGEALLOC=y.  The latter will
 > >  > force an immediate TLB flush after vfree.
 > >
 > > I can give that idea some runtime, but it sounds like this a case where
 > > we're trying to prove a negative, and that'll just run and run ? In which case I
 > > might do this when I'm travelling on Sunday.
 > 
 > The idea is that the stack will be free and unmapped immediately upon
 > process exit if configured like this so that bogus stack accesses (by
 > the CPU, not DMA) would OOPS immediately.

oh, misparsed. ok, I can definitely get behind that idea then.
I'll do that next.

	Dave
