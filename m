Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39226 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbcBNRbE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 12:31:04 -0500
Date: Sun, 14 Feb 2016 09:30:41 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>, Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is there now a way to migrate FS without losing shared COW blocks between subvolumes?
Message-ID: <20160214173041.GE4115@merlins.org>
References: <20160213032846.GB6717@merlins.org> <CAJCQCtSW-JkH52E3fSx-wd6hUBmVZw0UxMwDbZQiBwaz3Oppig@mail.gmail.com> <20160213032846.GB6717@merlins.org> <pan$d18dd$d9074a4a$a174d451$aaf0a831@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSW-JkH52E3fSx-wd6hUBmVZw0UxMwDbZQiBwaz3Oppig@mail.gmail.com> <pan$d18dd$d9074a4a$a174d451$aaf0a831@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 13, 2016 at 12:28:13PM +0000, Duncan wrote:
> Marc MERLIN posted on Fri, 12 Feb 2016 19:28:46 -0800 as excerpted:
> 
> > btrfs send lets you keep COW blocks within a subvolume.
> > But if I have lots of backups where subvolumes have shared data, and I
> > need to migrate this to a new filesystem, is there a decent way?
> > 
> > I know I can btrfs device add new drive as raid1, but I'm trying to
> > migrate off an old filesystem that likely wasn't created well. Is there
> > a way to do that?
> > I guess ideally I'd need btrfs send on a volume level, not subvolume
> > level.
> 
> Unless I'm mistaken, what you're looking for is btrfs send -c.  You're 
> still sending a subvolume, but the -c says to consider the supplied clone-
> src parameter for just that, cloned, aka shared, sources, and unlike
> -p parent, multiple such -c cloned-src options are allowed, so...

I had forgotten about that option, thanks for reminding me.

On Sat, Feb 13, 2016 at 11:25:16AM -0700, Chris Murphy wrote:
> On Fri, Feb 12, 2016 at 8:28 PM, Marc MERLIN <marc@merlins.org> wrote:
> > btrfs send lets you keep COW blocks within a subvolume.
> > But if I have lots of backups where subvolumes have shared data, and I need
> > to migrate this to a new filesystem, is there a decent way?
> >
> > I know I can btrfs device add new drive as raid1, but I'm trying to migrate
> > off an old filesystem that likely wasn't created well. Is there a way to do
> > that?
> > I guess ideally I'd need btrfs send on a volume level, not subvolume level.
> 
> btrfs send -e should accept a long list of subvolumes, or if you have
> good bashfoo maybe you can have bash hand over the list in the proper
> subvolume order. This effectively acts like a recursive send. The
> problem is that right now it's not working. Even if I use fully
> qualified paths, starting with the top level volume (id5) being
> mounted, it doesn't work. But that's the only way I know of to do what
> you want. Otherwise it's with -p and it's pretty tedious to do
> manually but again, good bashfoo and you can probably automate a loop.
> Send SV1 manually, then -p SV1 SV2 then -p SV2 SV3 then -p SV3 SV4,
> and so on. I'm pretty sure -e does that for you but I haven't been
> able to test it because I can't get it to work.

Yeah, indeed that's the only way I know and the one I was trying to avoid, both
because I may not remember all the subvolumes that are related, and because
it does not take into account me using cp --reflink=always between
subvolumes that are otherwise totally separate for most other files.

I realize it's probably not top of the list, but at this point it would be
good to have a way to copy an entire btrfs filesystem to another device
without playing device add/remove tricks which won't let you use a new/fresh
filesystem, or easily migrate off a somewhat damaged filesystem that maybe
you mounted with -o recovery,ro

Is there a TODO/Wishlist somewhere this could/should be added to?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
