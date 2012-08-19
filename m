Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58446 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2HSGnb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 02:43:31 -0400
Date: Sat, 18 Aug 2012 23:43:25 -0700
From: Marc MERLIN <marc@merlins.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: james northrup <northrup.james@gmail.com>,
        Norbert Scheibner <scno@gmx.net>,
        =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>,
        Hubert Kario <hka@qbs.com.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: cross-subvolume cp --reflink
Message-ID: <20120819064325.GB3305@merlins.org>
References: <20120401152749.61790@gmx.net> <CALJXSJpjOX3t6Xa=gFF2p13eSb+SJfRc_pc0d5ScShnK-5BwkQ@mail.gmail.com> <2272893.XFoXOC5Zif@bursa22> <op.wdjl3kx0r07q8e@tron.scheibner.rb> <CAPkEcwjF6pvqySbKGX6tJXb_4k=Z2BLg4OahuH=r6dsSF5ynDg@mail.gmail.com> <20120817052011.GA28121@merlins.org> <CAKcLGm93KY705k4xxkc=4Ob0Gw_sR2BuoxKw0hAt0n1GGxv2Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm93KY705k4xxkc=4Ob0Gw_sR2BuoxKw0hAt0n1GGxv2Zw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 19, 2012 at 12:08:01AM -0500, Mitch Harder wrote:
> On Fri, Aug 17, 2012 at 12:20 AM, Marc MERLIN <marc@merlins.org> wrote:
> > On Thu, Aug 16, 2012 at 09:20:00PM -0700, james northrup wrote:
> >> dunno if this thread is dead, but im inclined to patch in cp --reflink
> >> to "fdupes" prog.  It  currently does provide a poor-man's dedupe via
> >> md5sum and hardlink, or delete.
> >>
> >> all the better if the distro-kernels can backport cross-snapshot
> >> reflinks sooner than later.
> >
> > So, I'd love for cp --reflink to bring back a deleted VM (huge file) from a
> > snapshot back to trunk without duplicating it.
> > But how would fdupes help? I can't hardlink between two snapshots, can I?
> >
> > gandalfthegreat:/mnt/btrfs_pool1# ln usr_weekly_20120812_00\:02\:01/svn-commit.tmp  usr/test
> > ln: failed to create hard link `usr/test' => `usr_weekly_20120812_00:02:01/svn-commit.tmp': Invalid cross-device link
> >
> > So, is there anything user space can do without kernel support?
> >
> 
> A cross-subvolume copy patch has made it into 3.6_rc
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=362a20c5e27614739c4
> 
> This patch will allow cp --reflink across subvolumes, as long as the
> copy does not cross mount points.

I missed that, that's great news, thanks to all those involved in getting
this in.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
