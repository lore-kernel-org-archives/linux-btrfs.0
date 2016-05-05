Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45998 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbcEEGfr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 May 2016 02:35:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ayCsy-0005qe-Ho
	for linux-btrfs@vger.kernel.org; Thu, 05 May 2016 08:35:44 +0200
Received: from ip5f5ae06c.dynamic.kabel-deutschland.de ([95.90.224.108])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 May 2016 08:35:44 +0200
Received: from hurikhan77 by ip5f5ae06c.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 May 2016 08:35:44 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Thu, 5 May 2016 08:35:37 +0200
Message-ID: <20160505083537.0811b46f@jupiter.sol.kaishome.de>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<CAD=QJKiQb0Ryedw+52pfZ-Tp0W9O0jPqxgGqxhY7b=U+2eP3wg@mail.gmail.com>
	<20160503084814.3e355f56@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 3 May 2016 08:48:14 +0200
schrieb Kai Krakow <hurikhan77@gmail.com>:

> Am Sun, 1 May 2016 20:39:31 -0400
> schrieb Nicholas D Steeves <nsteeves@gmail.com>:
> 
> > On 1 May 2016 at 03:00, Kai Krakow <hurikhan77@gmail.com> wrote:  
> > > Hello!
> > >
> > > I'm not sure what triggeres this, neither if it is btrfs specific.
> > > The filesystems have been recreated from scratch. Mainly during my
> > > rsync backup (from btrfs to btrfs), but not necessarily limited to
> > > rsync usage, my system experiences uninterruptable freezes of
> > > commands like "df", "du", "btrfs fs sync", and probably more.    
> > 
> > Out of curiosity, does this occur if you don't create or delete
> > snapshots, or if your backup script doesn't create or delete
> > snapshots?  And when it occurs, are you able to go to another
> > terminal and run a command that you don't use often, that
> > definitely had to be read from disk, but that doesn't query any
> > filesystem properties (eg: whois)?  
> 
> I only create snapshots in the destination device, not on the source.
> I could try disabling the snapshotting and see if it changes things.
> 
> It seems from my observation, that only programs querying disk free or
> disk usage status hang, especially all of the btrfs subcommands doing
> it hang, in addition to traditional programs like du and df. I think
> also "btrfs sub delete" and friends hang. So your guess may very well
> go into the right direction. Let me try. Coming back later...

With the snapshot and sync related bits disabled in my script, I no
longer experience freezing df/du/... commands.


-- 
Regards,
Kai

Replies to list-only preferred.

