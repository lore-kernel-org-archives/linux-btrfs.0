Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:43702 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbcCGIap (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 03:30:45 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acqYt-0004if-H4
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 09:30:43 +0100
Date: Mon, 7 Mar 2016 09:30:43 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160307083043.GA6939@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160305200909.GJ1902@torres.zugschlus.de>
 <pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 06, 2016 at 06:43:46AM +0000, Duncan wrote:
> Marc Haber posted on Sat, 05 Mar 2016 21:09:09 +0100 as excerpted:
> > On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> >> Something is happening with the usage of this file system that's out of
> >> the ordinary. This is the first time I've seen such a large amount of
> >> unused metadata allocation. And then for it not only fail to balance,
> >> but for the allocation amount to increase is a first.
> > 
> > It is just a root filesystem of a workstation running Debian Linux, in
> > daily use, with daily snapshots of the system, and ten-minute-increment
> > snapshots of /home, with no cleanup happening for a few months.
> > 
> >>  So understanding the usage is important to figuring out what's
> >>  happening. I'd file a bug and include as much information on how the
> >>  fs got into this state as possible. And also if possible make a
> >>  btrfs-image using the proper flags to blot out the filenames for
> >>  privacy.
> 
> Now you're homing in on what I picked up on.  There's something very 
> funky about that metadata, 100+ GiB of metadata total, only just over 2 
> GiB metadata used, and attempts to balance it don't help with the spread 
> between the two at all, only increasing the total metadata, if anything, 
> but still seem to complete without error.  There's gotta be some sort of 
> bug going on there, and I'd /bet/ it's the same one that's keeping full 
> balances from working, as well.

I don't understand a single word of this, but you seem to understand
it. Good.

> 
> OK, this question's out of left field, but it's the only thing (well, 
> /almost/ only, see below) I've seen do anything /remotely/ like that:
> 
> Was the filesystem originally created as a convert from ext*, using btrfs-
> convert?  If so, was the ext2_saved or whatever subvolume removed, and a 
> successful defrag and balance completed at that time?

I have dug aroud in my auth.logs, and thanks to my not working in a
root shell but using sudo for every single command I can say that the
filesystem was created on September 1, 2015, so it is not _this_ old,
and snapshot.debian.net tells me that Debian unstable had btrfs-tools
4.1.2 uploaded on August 31, so i guess that the filesystem was either
created by the 4.0 version we had since May 2015 or by the brand new
4.1.2.

And it was a mkfs.btrfs with no special options. I suspected this
since I would probably not have made an ext4 filesystem of 300 GB in
size. Back in the ext4 days, I usually made /, /usr, /var, /home and
/boot their own filesystems.

> Tho AFAIK there was in addition a very narrow timeframe in which a bug in 
> mkfs.btrfs would create invalid btrfs'.  That was with btrfs-progs 4.1.1, 
> released in July 2015, with an urgent bugfix release 4.1.2 in the same 
> month to fix the problem, so the timeframe was days or weeks.

Debian is chastized for their allegedly quirky release schedules even
in this thread, I usually ignore that, but this time a smile comes to
my face when I say that btrfs-progs 4.1.1 was never packaged in
Debian, hence we're clear of this bug here. We went from 4.0 straight
to 4.1.2.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
