From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS fsck tool
Date: Thu, 10 Mar 2011 08:02:41 -0500
Message-ID: <1299762048-sup-3940@think>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <4D7591CC.6060301@shiftmail.org> <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com> <20110308065255.24100.qmail@stuge.se>
Content-Type: text/plain; charset=UTF-8
Cc: Alexey A Nikitin <moonwalker@syrius.us>,
	Spelic <spelic@shiftmail.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Peter Stuge <peter@stuge.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110308065255.24100.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Peter Stuge's message of 2011-03-08 01:52:55 -0500:
> Hi,
> 
> Alexey A Nikitin wrote:
> > I went experimenting with btrfs RAID0 on my USB setup .. because
> > I'm a reckless experimenter when it doesn't involve production
> > systems.
> 
> I encountered the same broken root node issue. (see thread resize ate
> my root node) and I'd like to understand it better. Hopefully there
> will come something out of this. I'm surprised that my resize broke
> the filesystem for mounting, when it looked good right after the
> resize.
> 
> When I looked through the archive and found your thread I started
> thinking, and I am not absolutely sure if there was some disk
> activity when I cut power to my system, but I believe there was not.
> (I ran reboot, but soft poweroff doesn't work with recent kernels. At
> the Rebooting system message I switched hard power off.)

Cutting the power isn't problem unless you're using something
where cache flushes are not supported.

Which kernel were you on?  Was btrfs directly accessing the disks or
were things like LVM in use?

Recent kernels (.37 and higher) have improved support for barriers in
LVM and friends, but btrfs directly using the disks should have been
safe for a long time.

I think with the resize something else went wrong.

-chris
