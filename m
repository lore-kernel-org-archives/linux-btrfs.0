Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35451 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935722AbdEWQ6x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 12:58:53 -0400
Date: Tue, 23 May 2017 09:58:47 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20170523165847.fbu45eq3w24tyh3c@merlins.org>
References: <20170501170641.GG3516@merlins.org>
 <20170501180856.GH3516@merlins.org>
 <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
 <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
 <pan$e2463$2d3d82e9$144941f3$9eeef2a4@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$e2463$2d3d82e9$144941f3$9eeef2a4@cox.net>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 05:01:02AM +0000, Duncan wrote:
> Marc MERLIN posted on Mon, 01 May 2017 20:23:46 -0700 as excerpted:
> 
> > Also, how is --mode=lowmem being useful?
> 
> FWIW, I just watched your talk that's linked from the wiki, and wondered 
> what you were doing these days as I hadn't seen any posts from you here 
> for awhile.
 
First, sorry for the late reply. Because you didn't Cc me in the answer,
it went to a different folder where I only saw your replies now.
Off topic, but basically I'm not dead or anything, I have btrfs working
well enough to not mess with it further because I have many other
hobbies :)  that is unless I put a new SAS card in my server, hit some
corruption bugs, and now I'm back spending days fixing the system.

> Well, that you're asking that question confirms you've not been following 
> the list too closely...  Of course that's understandable as people have 
> other stuff to do, but just sayin'.

That's exactly right. I'm subscribed to way too many lists on way too
many topics to be up to date with all, sadly :(

> Of course on-list I'm somewhat known for my arguments propounding the 
> notion that any filesystem that's too big to be practically maintained 
> (including time necessary to restore from backups, should that be 
> necessary for whatever reason) is... too big... and should ideally be 
> broken along logical and functional boundaries into a number of 
> individual smaller filesystems until such point as each one is found to 
> be practically maintainable within a reasonably practical time frame.  
> Don't put all the eggs in one basket, and when the bottom of one of those 
> baskets inevitably falls out, most of your eggs will be safe in other 
> baskets. =:^)
 
That's a valid point, and in my case, I can back it up/restore, it just
takes a bit of time, but most of the time is manually babysitting all
those subvolumes that I need to recreate by hand with btrfs send/restore
relationships, which all get lost during backup/restore.
This is the most painful part.
What's too big? I've only ever used a filesystem that fits on on a raid
of 4 data drives. That value has increased over time, but I don't have a
a crazy array of 20+ drives as a single filesystem, or anything.
Since drives have gotten bigger, but not that much faster, I use bcache
to make things more acceptable in speed.

> *BUT*, and here's the "go further" part, keep in mind that subvolume-read-
> only is a property, gettable and settable by btrfs property.
> 
> So you should be able to unset the read-only property of a subvolume or 
> snapshot, move it, then if desired, set it again.
> 
> Of course I wouldn't expect send -p to work with such a snapshot, but 
> send -c /might/ still work, I'm not actually sure but I'd consider it 
> worth trying.  (I'd try -p as well, but expect it to fail...)

That's an interesting point, thanks for making it.
In that case, I did have to destroy and recreate the filesystem since
btrfs check --repair was unable to fix it, but knowing how to reparent
read only subvolumes may be handy in the future, thanks.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
