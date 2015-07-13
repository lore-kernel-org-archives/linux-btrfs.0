Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55575 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbbGMAns (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jul 2015 20:43:48 -0400
Date: Sun, 12 Jul 2015 17:42:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: Axel Burri <axel@tty0.ch>
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Anyone tried out btrbk yet?
Message-ID: <20150713004249.GP5274@merlins.org>
References: <11148188.L9vtSMaNHV@merkaba>
 <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150712035523.GI5274@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 11, 2015 at 08:55:23PM -0700, Marc MERLIN wrote:
> On Fri, Jul 10, 2015 at 12:46:24PM +0200, Axel Burri wrote:
> > On 2015-07-09 14:26, Martin Steigerwald wrote:
> > 
> > > Well I may try it for one of my BTRFS volumes in addition to the rsync 
> > > backup for now. I would like to give all options on command line, but well, 
> > > maybe it can completely replace my current script if I put everything in its 
> > > configuration.
> > 
> > One reason why btrbk exists is that I wanted to have all my backups
> > configured in a config file. I use btrbk to backup several hosts to
> > several backup locations (around 20 subvolumes), which made setting
> > everything up with command-line options very cumbersome.
> > 
> > For simpler setups you might be better off with command-line based tools
> > (e.g. Marcs "btrfs-subvolume-backup", which I like for it's smallness).
> 
> I just had another look at btrbk, and it's obviously a lot more
> featureful. It's almost 10 times bigger in lines of code than
> btrfs-subvolume-backup :)
> 
> Anyway, to others, if you're happy using a tool that just does that you
> need without having to dig into it and without you caring how btrfs
> send/receive, works, btrbk looks like the better choice.
> 
> If you'd like something short-ish to look at and see how it works and/or
> want something simple in shell you can modify quickly, btrfs-subvolume-backup
> might be better for you.

Actually there is one thing my backup script doesn't do and it looks
like btrbk doesn't do either.
When I travel I'm often on crappy hotel wireless and my incremental
backups never succeed, and they just get bigger every day, so succeed
even less next time.
At the same time, I have an issue with btrfs where my backup server
cause a backup over ssh on a local network to take 12H or more when the
data to transfer isn't that much.
>From what I can tell it's a problem where btrfs receive just pauses for
one second or more, and kills the TCP flow.
TCP restarts slowly and ramps up just to be stopped again. As a result,
it takes forever to finish.

Since I don't know if this btrfs stall problem will get looked into or
fixed anytime soon, it would be great for the incremental backup to go
to a local spool directory, and then for the backup script to just copy
it with rsync until it makes it to the other side. Only then is btrfs
receive run with that file, and then the next incremental backup is
tried.

But this is a fair amount of logic to get this right, and I just haven't
taken the time to write it.

Would it be helpful to others, or am I the only one with this problem?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
