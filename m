From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: btrfs lockup after mounting for a second time on 2.6.26
Date: Wed, 18 Feb 2009 15:51:30 -0500
Message-ID: <20090218205130.GA10422@tux64-01>
References: <4993C23C.8000108@cs.drexel.edu> <1234450272.8300.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Trager <lt73@cs.drexel.edu>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234450272.8300.2.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

I took your suggestions from the phone conference today and tired them
out on my system.

It seems that even though 2.6.26 can not mount a btrfs partition a
second time 2.6.27 has no problem doing this. I created the the btrfs
parition on 2.6.26, copied data to it on 2.6.26, I tried to mount the
btrfs for a second time on 2.6.26 and I experienced the bug. I then
tried mounting the btrfs parition on 2.6.27 and it worked fine.

When I run vmstat it seems no data is comming from the btrfs partition
on 2.6.26. While I get some burts of data every few seconds it doesn't
seem I am getting anything from btrfs.

Lee

P.S Thanks for helping me get this working and answering my questions!

On Thu, Feb 12, 2009 at 09:51:12AM -0500, Chris Mason wrote:
> On Thu, 2009-02-12 at 01:31 -0500, Lee Trager wrote:
> > While running a few tests with the btrfs sources pulled from
> > btrfs-unstable patched with my patch to compile under 2.6.26 I
> > encountered a very weird problem. Everything works fine the first time I
> > mount the file system (either actual disk or loop back). When I
> > unmounted the file system and mounted it again(I'm not doing mount -o
> > remount ...) btrfs is completely unusable. When I tried to view some of
> > the data which I previously put on the btrfs partition by doing a simple
> > ls /mnt/btrfs in bash nothing happens. ls shows nothing, just hangs, and
> > I am unable to kill ls. The same thing happens when I try to copy a file
> > from my ext3 partition onto the btrfs partition after mounting it for a
> > second time. The rest of the system is completely usable and the only
> > things that are effects are applications which are trying to read/write
> > from the btrfs file system. There are no kernel opps or any other errors
> > messages in any of my logs. This happens if I have compression on or
> > not. I'd be happy to fix this issue but I don't have a clue about where
> > to start looking for what is wrong.
> > 
> > Could someone please help me?
> 
> Thanks for working on this.  The first step is to figure out what ls is
> doing, and my guess is trying to read block groups.  Do a sysrq-w while
> it is hung and send the results along.
> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
