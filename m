From: Peter Stuge <peter@stuge.se>
Subject: Re: BTRFS fsck tool
Date: Thu, 10 Mar 2011 14:29:37 +0100
Message-ID: <20110310132937.11456.qmail@stuge.se>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <4D7591CC.6060301@shiftmail.org> <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com> <20110308065255.24100.qmail@stuge.se> <1299762048-sup-3940@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299762048-sup-3940@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Cutting the power isn't problem unless you're using something
> where cache flushes are not supported.

Nod. I've had very abrupt system outage before, without problems.


> Which kernel were you on?

2.6.38-rc6 + wireless-testing.git


> Was btrfs directly accessing the disks or were things like LVM in use?

Directly.


> I think with the resize something else went wrong.

I don't know where to look exactly. Any hint on which data structures
to focus on are welcome.


//Peter
