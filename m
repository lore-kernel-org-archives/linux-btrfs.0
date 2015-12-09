Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45391 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbbLILym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 06:54:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6dKR-0005bN-5N
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 12:54:39 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 12:54:39 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 12:54:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: attacking btrfs filesystems via UUID collisions? (was:
 Subvolume UUID, data corruption?)
Date: Wed, 9 Dec 2015 11:54:30 +0000 (UTC)
Message-ID: <pan$44094$74e68a55$b1d01980$9156743e@cox.net>
References: <20151204120529.37E47D5A28@emkei.cz>
	<20151204130758.GR8775@carfax.org.uk>
	<1449286104.18841.14.camel@scientia.net>
	<pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	<1449366680.3183.37.camel@scientia.net>
	<pan$ddc43$45608356$bf638c60$d3fc60dc@cox.net>
	<1449637658.20578.23.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 09 Dec 2015 06:07:38 +0100 as
excerpted:

> Well as I've said, getting that in via USB may be only one way.
> We're already so far that GNOME&Co. automount devices when plugged...

Ugh.  ... And many know that's the sort of thing that made MS so much of 
a security headache, and want no part of it!

FWIW, of course gentoo allows far more configurability in this regard 
than many distros, but no automount here, and while I don't do gnome 
because I like my system configurable and they'd just as soon it be their 
way or the highway (echoes of proprietaryware attitude there if you ask 
me, but I'm very glad gnome's available for them to work on as otherwise 
they'd be troubling kde and etc to go the same way), I do have a much 
more limited than usual kde installed, without stuff like the device 
notifier plasmoid or underlying infrastructure like udisks, as the only 
things I want mounted are the things I've either configured to be mounted 
via fstab, or the thing's I've manually mounted.  (FWIW, the semantic-
desktop crap is opted out at build-time too, so it's not even there to 
turn off at runtime, the best most distros allow for those not interested 
in that stuff.  It meant dumping a few apps and some missing features in 
others, but I don't have indexing taking gigs of space and major IO 
bandwidth at the most inconvenient times (any time!) for nothing I'm 
going to make use of, either!)

> You said it's basically not fixable in btrfs:
> It's absolutely clear that I'm no btrfs expert (or even developer), but
> my poor man approach which I think I've written before doesn't seem so
> impossible, does it?
> 1) Don't simply "activate" btrfs devices that are found but rather:
> 2) Check if there are other devices of the same fs UUID + device ID,
> or more generally said: check if there are any collisions
> 3) If there are, and some of them are already active,
> continue to use them, don't activate the newly appeared ones
> 4) If there are, and none of them are already active, refuse to
> activate *any* of them unless the user manually instructs to do so
> via device= like options.

The underlying issue pretty much isn't fixable, but as Qu has suggested 
on that subthread, there's ameliorations that can be done, basically in 
line with your suggestions above, and you've indicated that you'd 
consider that fixed, tho neither he nor I consider it "fixed", only 
hidden to some extent.

Anyway, he's a dev and actively involved now, while I'm not a dev,
so he can take it from there. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

