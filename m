From: Peter Stuge <peter@stuge.se>
Subject: Re: BTRFS fsck tool
Date: Tue, 8 Mar 2011 07:52:55 +0100
Message-ID: <20110308065255.24100.qmail@stuge.se>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <4D7591CC.6060301@shiftmail.org> <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Spelic <spelic@shiftmail.org>, linux-btrfs@vger.kernel.org
To: Alexey A Nikitin <moonwalker@syrius.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Alexey A Nikitin wrote:
> I went experimenting with btrfs RAID0 on my USB setup .. because
> I'm a reckless experimenter when it doesn't involve production
> systems.

I encountered the same broken root node issue. (see thread resize ate
my root node) and I'd like to understand it better. Hopefully there
will come something out of this. I'm surprised that my resize broke
the filesystem for mounting, when it looked good right after the
resize.

When I looked through the archive and found your thread I started
thinking, and I am not absolutely sure if there was some disk
activity when I cut power to my system, but I believe there was not.
(I ran reboot, but soft poweroff doesn't work with recent kernels. At
the Rebooting system message I switched hard power off.)


//Peter
