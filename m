Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50363 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbdIJOyh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 10:54:37 -0400
Date: Sun, 10 Sep 2017 07:54:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: Andrei Borzenkov <arvidjaar@gmail.com>, framstag@rus.uni-stuttgart.de
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20170910145430.zzxuvaqthob4ufrs@merlins.org>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <20170909132614.GA20299@rus.uni-stuttgart.de>
 <20170909133612.7iqwr6cbjxzvfny6@merlins.org>
 <20170909134426.GB20299@rus.uni-stuttgart.de>
 <14c87878-a5a0-d7d3-4a76-c55812e751a3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <14c87878-a5a0-d7d3-4a76-c55812e751a3@gmail.com>
Subject: Re: netapp-alike snapshots?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 09, 2017 at 10:43:16PM +0300, Andrei Borzenkov wrote:
> 09.09.2017 16:44, Ulli Horlacher пишет:
> > 
> > Your tool does not create .snapshot subdirectories in EVERY directory like
> 
> Neither does NetApp. Those "directories" are magic handles that do not
> really exist.
 
Correct, thanks for saving me typing the same thing (I actually did work
at netapp many years back, so I'm familiar with how they work)

> > Netapp does.
> > Example:
> > 
> > framstag@fex:~: cd ~/Mail/.snapshot/
> > framstag@fex:~/Mail/.snapshot: l
> > lR-X - 2017-09-09 09:55 2017-09-09_0000.daily -> /local/home/.snapshot/2017-09-09_0000.daily/framstag/Mail
> 
> Apart from obvious problem with recursive directory traversal (NetApp
> .snapshot are not visible with normal directory list) those will also be
> captured in snapshots and cannot be removed. NetApp snapshots themselves
> do not expose .snapshot "directories".

Correct. Netapp knows this of course, which is why those .snapshot
directories are "magic" and hidden to ls(1), find(1) and others when
they do a readdir(3)

> > lR-X - 2017-09-09 14:00 2017-09-09_1400.hourly -> /local/home/.snapshot/2017-09-09_1400.hourly/framstag/Mail
> > lR-X - 2017-09-09 15:00 2017-09-09_1500.hourly -> /local/home/.snapshot/2017-09-09_1500.hourly/framstag/Mail
> > lR-X - 2017-09-09 15:18 2017-09-09_1518.single -> /local/home/.snapshot/2017-09-09_1518.single/framstag/Mail
> > lR-X - 2017-09-09 15:20 2017-09-09_1520.single -> /local/home/.snapshot/2017-09-09_1520.single/framstag/Mail
> > lR-X - 2017-09-09 15:22 2017-09-09_1522.single -> /local/home/.snapshot/2017-09-09_1522.single/framstag/Mail
> > 
> > My users (and I) need snapshots in this way.

You are used to them being there, I was too :)
While you could create lots of symlinks, I opted not to since it would
have littered the filesystem.
I can simply cd $(SNAPROOT)/volname_hourly/$(PWD)
and end up where I wanted to be.

I suppose you could make a snapcd shell function that does this for you.
The only issue is that volname_hourly comes before the rest of the path,
so you aren't given a list of all the snapshots available for a given
path, you have to cd into the given snapshot first, and then add the
path.
I agree it's not as nice as netapp, but honestly I don't think you can
do better with btrfs at this point.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
