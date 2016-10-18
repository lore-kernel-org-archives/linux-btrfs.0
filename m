Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50917 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934873AbcJRBIV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 21:08:21 -0400
Date: Mon, 17 Oct 2016 21:07:00 -0400
From: Chris Mason <clm@fb.com>
To: Dave Jones <davej@codemonkey.org.uk>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        "David Sterba" <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs bio linked list corruption.
Message-ID: <20161018010659.GA88177@clm-mbp.thefacebook.com>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
 <20161012134717.n74tww5eywc7dqp7@codemonkey.org.uk>
 <20161012144012.7vvfehceoykswmun@codemonkey.org.uk>
 <fb1a1c38-1ed8-e0eb-740d-c34c1d6c18f4@fb.com>
 <20161013181622.qpi5puv6ivxvslnf@codemonkey.org.uk>
 <7b476728-75f8-e3d3-1261-b9b0d598ed10@fb.com>
 <20161016004240.hpstul32lb2f3u4g@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <20161016004240.hpstul32lb2f3u4g@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 15, 2016 at 08:42:40PM -0400, Dave Jones wrote:
>On Thu, Oct 13, 2016 at 05:18:46PM -0400, Chris Mason wrote:
>
> > >  > > .. and of course the first thing that happens is a completely different
> > >  > > btrfs trace..
> > >  > >
> > >  > >
> > >  > > WARNING: CPU: 1 PID: 21706 at fs/btrfs/transaction.c:489 start_transaction+0x40a/0x440 [btrfs]
> > >  > > CPU: 1 PID: 21706 Comm: trinity-c16 Not tainted 4.8.0-think+ #14
> > >  > >  ffffc900019076a8 ffffffffb731ff3c 0000000000000000 0000000000000000
> > >  > >  ffffc900019076e8 ffffffffb707a6c1 000001e9f5806ce0 ffff8804f74c4d98
> > >  > >  0000000000000801 ffff880501cfa2a8 000000000000008a 000000000000008a
> > >  >
> > >  > This isn't even IO.  Uuughhhh.  We're going to need a fast enough test
> > >  > that we can bisect.
> > >
> > > Progress...
> > > I've found that this combination of syscalls..
> > >
> > > ./trinity -C64 -q -l off -a64 --enable-fds=testfile -c fsync -c fsetxattr -c lremovexattr -c pwritev2
> > >
> > > hits one of these two bugs in a few minutes runtime.
> > >
> > > Just the xattr syscalls + fsync isn't enough, neither is just pwrite + fsync.
> > > Mix them together though, and something goes awry.
> > >
> > Hasn't triggered here yet.  I'll leave it running though.
>
>The hits keep coming..
>
>BUG: Bad page state in process kworker/u8:12  pfn:4988fa
>page:ffffea0012623e80 count:0 mapcount:0 mapping:ffff8804450456e0 index:0x9

Hmpf, I've had this running since Friday without failing.  Can you send 
me your .config please?

-chris
