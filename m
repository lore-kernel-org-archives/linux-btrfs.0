Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35048 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbcBIQrG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 11:47:06 -0500
Date: Tue, 9 Feb 2016 08:46:37 -0800
From: Marc MERLIN <marc@merlins.org>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to
 one cpu core?
Message-ID: <20160209164637.GL13969@merlins.org>
References: <56A73460.7080100@netcologne.de>
 <CAJCQCtTdDyv0PkkuHGrEpEnk5yzM1Fx1C0VUT8r7OAfU6i8Dfw@mail.gmail.com>
 <56A7CF97.6030408@gmail.com>
 <CAJCQCtTMEHcc1CnuHqS=g23tsirQv3S9cmDcHaK0WXyQrRds1w@mail.gmail.com>
 <56A88452.6020306@netcologne.de>
 <56A8F18E.3070400@gmail.com>
 <CAJCQCtT9NZdaJ8MKHQw-1ARi7PkLeq_p9dtdZaPYdLt8EpTcbA@mail.gmail.com>
 <56AF676B.2070902@netcologne.de>
 <CAJCQCtS1gX4jbnpjmgnGn2WE5TTfHnSfeyQioDwRL4vgZrXMhA@mail.gmail.com>
 <56B9EE1E.2040000@netcologne.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56B9EE1E.2040000@netcologne.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 09, 2016 at 02:48:14PM +0100, Christian Rohmann wrote:
> 
> 
> On 02/01/2016 09:52 PM, Chris Murphy wrote:
> >> Would some sort of stracing or profiling of the process help to narrow
> >> > down where the time is currently spent and why the balancing is only
> >> > running single-threaded?
> > This can't be straced. Someone a lot more knowledgeable than I am
> > might figure out where all the waits are with just a sysrq + t, if it
> > is a hold up in say parity computations. Otherwise perf which is a
> > rabbit hole but perf top is kinda cool to watch. That might give you
> > an idea where most of the cpu cycles are going if you can isolate the
> > workload to just the balance. Otherwise you may end up with noisy
> > data.
> 
> My balance run is now working away since 19th of January:
>  "885 out of about 3492 chunks balanced (996 considered),  75% left"
> 
> So this will take several more WEEKS to finish. Is there really nothing
> anyone here wants me to do or analyze to help finding the root cause of
> this? I mean with this kind of performance there is no way a RAID6 can
> be used in production. Not because the code is not stable or
> functioning, but because regular maintenance like replacing a drive or
> growing an array takes WEEKS in which another maintenance procedure
> could be necessary or, much worse, another drive might have failed.
> 
> What I'm saying is: Such a slow RAID6 balance renders the redundancy
> unusable because drives might fail quicker than the potential rebuild
> (read "balance").

I agree, this is bad.
For what it's worth, one of my own filesystems (target for backups, many
many files) has apparently become slow enough that it half hangs my
system when I'm using it.
I've just unmounted it to make sure my overall system performance comes
back, and I may have to delete and recreate it.

Sadly, this also means that btrfs still seems to get itself in corner
cases that are causing performance issues.
I'm not saying that you did hit this problem, but it is possible.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
