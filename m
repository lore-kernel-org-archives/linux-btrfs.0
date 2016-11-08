Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36402 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751226AbcKHPIn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Nov 2016 10:08:43 -0500
Subject: Re: btrfs btree_ctree_super fault
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161106165539.ybwm6rqvzh2k6uja@codemonkey.org.uk>
 <20161108145912.fcjvwxcpqgd7kjei@codemonkey.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <01d76d90-8d90-e09b-40a0-63488425348d@fb.com>
Date: Tue, 8 Nov 2016 10:08:04 -0500
MIME-Version: 1.0
In-Reply-To: <20161108145912.fcjvwxcpqgd7kjei@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/08/2016 09:59 AM, Dave Jones wrote:
> On Sun, Nov 06, 2016 at 11:55:39AM -0500, Dave Jones wrote:
>  > <subject changed, hopefully we're done with bio corruption for now>
>  >
>  > On Mon, Oct 31, 2016 at 01:44:55PM -0600, Chris Mason wrote:
>  >  > On Mon, Oct 31, 2016 at 12:35:16PM -0700, Linus Torvalds wrote:
>  >  > >On Mon, Oct 31, 2016 at 11:55 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>  >  > >>
>  >  > >> BUG: Bad page state in process kworker/u8:12  pfn:4e0e39
>  >  > >> page:ffffea0013838e40 count:0 mapcount:0 mapping:ffff8804a20310e0 index:0x100c
>  >  > >> flags: 0x400000000000000c(referenced|uptodate)
>  >  > >> page dumped because: non-NULL mapping
>  >  > >
>  >  > >Hmm. So this seems to be btrfs-specific, right?
>  >  > >
>  >  > >I searched for all your "non-NULL mapping" cases, and they all seem to
>  >  > >have basically the same call trace, with some work thread doing
>  >  > >writeback and going through btrfs_writepages().
>  >  > >
>  >  > >Sounds like it's a race with either fallocate hole-punching or
>  >  > >truncate. I'm not seeing it, but I suspect it's btrfs, since DaveJ
>  >  > >clearly ran other filesystems too but I am not seeing this backtrace
>  >  > >for anything else.
>  >  >
>  >  > Agreed, I think this is a separate bug, almost certainly btrfs specific.
>  >  > I'll work with Dave on a better reproducer.
>  >
>  > Still refining my 'capture ftrace when trinity detects taint' feature,
>  > but in the meantime, here's a variant I don't think we've seen before:
>
> And another new one:
>
> kernel BUG at fs/btrfs/ctree.c:3172!
> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU: 0 PID: 22702 Comm: trinity-c40 Not tainted 4.9.0-rc4-think+ #1
> task: ffff8804ffde37c0 task.stack: ffffc90002188000
> RIP: 0010:[<ffffffffa00576b9>]
>   [<ffffffffa00576b9>] btrfs_set_item_key_safe+0x179/0x190 [btrfs]
> RSP: 0000:ffffc9000218b8a8  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8804fddcf348 RCX: 0000000000001000
> RDX: 0000000000000000 RSI: ffffc9000218b9ce RDI: ffffc9000218b8c7
> RBP: ffffc9000218b908 R08: 0000000000004000 R09: ffffc9000218b8c8
> R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000218b8b6
> R13: ffffc9000218b9ce R14: 0000000000000001 R15: ffff880480684a88
> FS:  00007f7c7f998b40(0000) GS:ffff880507800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000044f15f000 CR4: 00000000001406f0
> DR0: 00007f4ce439d000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Stack:
>  ffff880501430000 d305ffffa00a2245 006c000000000002 0500000000000010
>  6c000000000002d3 0000000000001000 000000006427eebb ffff880480684a88
>  0000000000000000 ffff8804fddcf348 0000000000002000 0000000000000000
> Call Trace:
>  [<ffffffffa009cff0>] __btrfs_drop_extents+0xb00/0xe30 [btrfs]

We've been hunting this one for at least two years.  It's the white 
whale of btrfs bugs.  Josef has a semi-reliable reproducer now, but I 
think it's not the same as the pagevec based problems you reported earlier.

-chris
