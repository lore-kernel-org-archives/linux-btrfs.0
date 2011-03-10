From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS fsck tool
Date: Thu, 10 Mar 2011 08:58:44 -0500
Message-ID: <1299765503-sup-219@think>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <4D7591CC.6060301@shiftmail.org> <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com> <20110308065255.24100.qmail@stuge.se> <1299762048-sup-3940@think> <20110310132937.11456.qmail@stuge.se>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Peter Stuge <peter@stuge.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110310132937.11456.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Peter Stuge's message of 2011-03-10 08:29:37 -0500:
> Chris Mason wrote:
> > Cutting the power isn't problem unless you're using something
> > where cache flushes are not supported.
> 
> Nod. I've had very abrupt system outage before, without problems.
> 
> > Which kernel were you on?
> 
> 2.6.38-rc6 + wireless-testing.git
> 
> > Was btrfs directly accessing the disks or were things like LVM in use?
> 
> Directly.
> 
> > I think with the resize something else went wrong.
> 
> I don't know where to look exactly. Any hint on which data structures
> to focus on are welcome.

I moved my questions back to the resize thread ;)

-chris
