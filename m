Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37354 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758200AbcK3RQm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 12:16:42 -0500
Date: Wed, 30 Nov 2016 09:16:36 -0800
From: Marc MERLIN <marc@merlins.org>
To: Eric Wheeler <bcache@lists.ewheeler.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20161130171636.fpsx6rgknbbbsbks@merlins.org>
References: <20161118164643.g7ttuzgsj74d6fbz@merlins.org>
 <20161118184915.j6dlazbgminxnxzx@merlins.org>
 <b6c3daab-d990-e873-4d0f-0f0afe2259b1@coly.li>
 <alpine.LRH.2.11.1611291255350.1914@mail.ewheeler.net>
 <20161130164646.d6ejlv72hzellddd@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161130164646.d6ejlv72hzellddd@merlins.org>
Subject: Re: 4.8.8, bcache deadlock and hard lockup
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2016 at 08:46:46AM -0800, Marc MERLIN wrote:
> +btrfs mailing list, see below why
> 
> On Tue, Nov 29, 2016 at 12:59:44PM -0800, Eric Wheeler wrote:
> > On Mon, 27 Nov 2016, Coly Li wrote:
> > > 
> > > Yes, too many work queues... I guess the locking might be caused by some
> > > very obscure reference of closure code. I cannot have any clue if I
> > > cannot find a stable procedure to reproduce this issue.
> > > 
> > > Hmm, if there is a tool to clone all the meta data of the back end cache
> > > and whole cached device, there might be a method to replay the oops much
> > > easier.
> > > 
> > > Eric, do you have any hint ?
> > 
> > Note that the backing device doesn't have any metadata, just a superblock. 
> > You can easily dd that off onto some other volume without transferring the 
> > data. By default, data starts at 8k, or whatever you used in `make-bcache 
> > -w`.
> 
> Ok, Linus helped me find a workaround for this problem:
> https://lkml.org/lkml/2016/11/29/667
> namely:
>    echo 2 > /proc/sys/vm/dirty_ratio
>    echo 1 > /proc/sys/vm/dirty_background_ratio
> (it's a 24GB system, so the defaults of 20 and 10 were creating too many
> requests in th buffers)
> 
> Note that this is only a workaround, not a fix.

Actually, I'm even more worried about the general bcache situation when
caching is enabled. In the message above, Linus wrote:

"One situation where I've seen something like this happen is

 (a) lots and lots of dirty data queued up
 (b) horribly slow storage
 (c) filesystem that ends up serializing on writeback under certain
circumstances

The usual case for (b) in the modern world is big SSD's that have bad
worst-case behavior (ie they may do gbps speeds when doing well, and
then they come to a screeching halt when their buffers fill up and
they have to do rewrites, and their gbps throughput drops to mbps or
lower).

Generally you only find that kind of really nasty SSD in the USB stick
world these days."

Well, come to think of it, this is _exactly_ what bcache will create, by
design. It'll swallow up a lot of IO cached to the SSD, until the SSD
buffers fill up and then things will hang while bcache struggles to
write it all to slower spinning rust storage.

Looks to me like bcache and dirty_ratio need to be synced somehow, or
things will fall over reliably.

What do you think?

Thanks,
Marc


> When I did this and re tried my big copy again, I still got 100+ kernel
> work queues, but apparently the underlying swraid5 was able to unblock
> and satisfy the write requests before too many accumulated and crashed
> the kernel.
> 
> I'm not a kernel coder, but seems to me that bcache needs a way to
> throttle incoming requests if there are too many so that it does not end
> up in a state where things blow up due to too many piled up requests.
> 
> You should be able to reproduce this by taking 5 spinning rust drives,
> put raid5 on top, dmcrypt, bcache and hopefully any filesystem (although
> I used btrfs) and send lots of requests.
> Actually to be honest, the problems have mostly been happening when I do
> btrfs scrub and btrfs send/receive which both generate I/O from within
> the kernel instead of user space.
> So here, btrfs may be a contributor to the problem too, but while btrfs
> still trashes my system if I remove the caching device on bcache (and
> with the default dirty ratio values), it doesn't crash the kernel.
> 
> I'll start another separate thread with the btrfs folks on how much
> pressure is put on the system, but on your side it would be good to help
> ensure that bcache doesn't crash the system altogether if too many
> requests are allowed to pile up.
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
