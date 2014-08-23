Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35552 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaHWMcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 08:32:55 -0400
Date: Sat, 23 Aug 2014 05:32:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: Naohiro Aota <nao.aota@gmail.com>, Chris Mason <clm@fb.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted in
 various ways
Message-ID: <20140823123249.GJ3875@merlins.org>
References: <20140822155040.GU3875@merlins.org>
 <pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
 <20140822184919.GE3875@merlins.org>
 <pan$644c4$e5e83b2d$34cd9e4d$75795b7@cox.net>
 <20140823031055.GH3875@merlins.org>
 <CAEe67=9gN2F58C2MJO0Ag-P7cRAux8+gcov0k5J2PwtNmi=MBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEe67=9gN2F58C2MJO0Ag-P7cRAux8+gcov0k5J2PwtNmi=MBg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 23, 2014 at 02:45:25PM +0900, Naohiro Aota wrote:
> On Sat, Aug 23, 2014 at 12:10 PM, Marc MERLIN <marc@merlins.org> wrote:
> > On Sat, Aug 23, 2014 at 02:52:16AM +0000, Duncan wrote:
> >> > For mysql, I got:
> >> > InnoDB: Page directory corruption:
> >> > infimum not pointed to 140708 11:53:58
> >> > InnoDB: Page dump in ascii and hex (16384 bytes):
> >> > len 16384; hex 00000000(16KB of 0's).
> >>
> >> Is that on ssd or spinning rust, and if ssd, do you run with trim/discard
> >> and/or have you filled the device yet if not (since mkfs.btrfs trims the
> >> device as part of the process)?  I'm wondering if that's 4 4 KiB btrfs
> >> data blocks of trimmed and unwritten SSD?
> >
> > It's on SSD, I do have trim/discard, I never filled the device.
> >
> > But I could totally remove trim and see what happens. I'll do that.
> 
> I'm experiencing the same google-chrome profile corruption on my HDD too.
> It almost always happen to me when the power got lost or kernel get panic.

Thanks for that data point, so that rules out discard and SSDs.

Given that, it sounds like btrfs may still have a bug where everything
does not get to disk in the right order before the system stops.

Now, it is possible that google-chrome has a bug where it doesn't fsync
or end up in consistent points. It's also possible btrfs is just not
able to get all that fsync data to disk before the system crashes, and
the inconsistent state is not its fault.
But I'm a bit perplexed by the 16KB of 0's that ended up in the middle
of my mysql database.

What's interesting though is that Chris told me he never go the profile
issue with google-chrome, but he also said his laptop almost never
crashes, so they're most likely related.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
