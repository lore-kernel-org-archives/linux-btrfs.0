Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:39304 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936334AbcJUUCy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 16:02:54 -0400
Date: Fri, 21 Oct 2016 16:02:45 -0400
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
Message-ID: <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
References: <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 20, 2016 at 04:23:32PM -0700, Andy Lutomirski wrote:
 > On Thu, Oct 20, 2016 at 4:03 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
 > > On Thu, Oct 20, 2016 at 04:01:12PM -0700, Andy Lutomirski wrote:
 > >  > On Thu, Oct 20, 2016 at 3:50 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
 > >  > > On Tue, Oct 18, 2016 at 06:05:57PM -0700, Andy Lutomirski wrote:
 > >  > >
 > >  > >  > One possible debugging approach would be to change:
 > >  > >  >
 > >  > >  > #define NR_CACHED_STACKS 2
 > >  > >  >
 > >  > >  > to
 > >  > >  >
 > >  > >  > #define NR_CACHED_STACKS 0
 > >  > >  >
 > >  > >  > in kernel/fork.c and to set CONFIG_DEBUG_PAGEALLOC=y.  The latter will
 > >  > >  > force an immediate TLB flush after vfree.
 > >  > >
 > >  > > I can give that idea some runtime, but it sounds like this a case where
 > >  > > we're trying to prove a negative, and that'll just run and run ? In which case I
 > >  > > might do this when I'm travelling on Sunday.
 > >  >
 > >  > The idea is that the stack will be free and unmapped immediately upon
 > >  > process exit if configured like this so that bogus stack accesses (by
 > >  > the CPU, not DMA) would OOPS immediately.
 > >
 > > oh, misparsed. ok, I can definitely get behind that idea then.
 > > I'll do that next.
 > >
 > 
 > It could be worth trying this, too:
 > 
 > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=174531fef4e8
 > 
 > It occurred to me that the current code is a little bit fragile.

It's been nearly 24hrs with the above changes, and it's been pretty much
silent the whole time.

The only thing of note over that time period has been a btrfs lockdep
warning that's been around for a while, and occasional btrfs checksum
failures, which I've been seeing for a while, but seem to have gotten
worse since 4.8.

I'm pretty confident in the disk being ok in this machine, so I think
the checksum warnings are bogus.  Chris suggested they may be the result
of memory corruption, but there's little else going on.


BTRFS warning (device sda3): csum failed ino 130654 off 0 csum 2566472073 expected csum 3008371513
BTRFS warning (device sda3): csum failed ino 131057 off 4096 csum 3563910319 expected csum 738595262
BTRFS warning (device sda3): csum failed ino 131176 off 4096 csum 1344477721 expected csum 441864825
BTRFS warning (device sda3): csum failed ino 131241 off 245760 csum 3576232181 expected csum 2566472073
BTRFS warning (device sda3): csum failed ino 131429 off 0 csum 1494450239 expected csum 2646577722
BTRFS warning (device sda3): csum failed ino 131471 off 0 csum 3949539320 expected csum 3828807800
BTRFS warning (device sda3): csum failed ino 131471 off 4096 csum 3475108475 expected csum 2566472073
BTRFS warning (device sda3): csum failed ino 131471 off 958464 csum 142982740 expected csum 2566472073
BTRFS warning (device sda3): csum failed ino 131471 off 0 csum 3949539320 expected csum 3828807800
BTRFS warning (device sda3): csum failed ino 131532 off 270336 csum 3138898528 expected csum 2566472073
BTRFS warning (device sda3): csum failed ino 131532 off 1249280 csum 2169165042 expected csum 2566472073
BTRFS warning (device sda3): csum failed ino 131649 off 16384 csum 2914965650 expected csum 1425742005


A curious thing: the expected csum 2566472073 turns up a number of times for different inodes, and gets
differing actual csums each time.  I suppose this could be something like a block of all zeros in multiple files,
but it struck me as surprising.

btrfs people: is there an easy way to map those inodes to a filename ? I'm betting those are the
test files that trinity generates. If so, it might point to a race somewhere.

	Dave

