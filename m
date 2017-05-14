Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34177 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754259AbdENVXH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 17:23:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dA0ye-0003Lx-C3
        for linux-btrfs@vger.kernel.org; Sun, 14 May 2017 23:22:56 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
Date: Sun, 14 May 2017 23:22:51 +0200
Message-ID: <20170514232251.74f35f3e@jupiter.sol.kaishome.de>
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
        <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
        <20170514201508.bd3dshfymqt4swpb@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 14 May 2017 13:15:09 -0700
schrieb Marc MERLIN <marc@merlins.org>:

> On Sun, May 14, 2017 at 09:13:35PM +0200, Hans van Kranenburg wrote:
> > On 05/13/2017 10:54 PM, Marc MERLIN wrote:  
> > > Kernel 4.11, btrfs-progs v4.7.3
> > > 
> > > I run scrub and balance every night, been doing this for 1.5
> > > years on this filesystem.  
> > 
> > What are the exact commands you run every day?  
>  
> http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html
> (at the bottom)
> every night:
> 1) scrub
> 2) balance -musage=0
> 3) balance -musage=20
> 4) balance -dusage=0
> 5) balance -dusage=20
> 
> > > How did I get into such a misbalanced state when I balance every
> > > night?  
> > 
> > I don't know, since I don't know what you do exactly. :)  
>  
> Now you do :)
> 
> > > My filesystem is not full, I can write just fine, but I sure
> > > cannot rebalance now.  
> > 
> > Yes, because you have quite some allocated but unused space. If
> > btrfs cannot just allocate more chunks, it starts trying a bit
> > harder to reuse all the empty spots in the already existing
> > chunks.  
> 
> Ok. shouldn't balance fix problems just like this?
> I have 60GB-ish free, or in this case that's also >25%, that's a lot
> 
> Speaking of unallocated, I have more now:
>     Device unallocated:		 993.00MiB
> 
> This kind of just magically fixed itself during snapshot rotation and
> deletion I think.
> Sure enough, balance works again, but this feels pretty fragile.
> Looking again:
>     Device size:		 228.67GiB
>     Device allocated:		 227.70GiB
>     Device unallocated:		 993.00MiB
>     Free (estimated):		  58.53GiB	(min: 58.53GiB)
> 
> You're saying that I need unallocated space for new chunks to be
> created, which is required by balance.
> Should btrfs not take care of keeping some space for me?
> Shoudln't a nigthly balance, which I'm already doing, help even more
> with this?
> 
> > > Besides adding another device to add space, is there a way around
> > > this and more generally not getting into that state anymore
> > > considering that I already rebalance every night?  
> > 
> > Add monitoring and alerting on the amount of unallocated space.
> > 
> > FWIW, this is what I use for that purpose:
> > 
> > https://packages.debian.org/sid/munin-plugins-btrfs
> > https://packages.debian.org/sid/monitoring-plugins-btrfs
> > 
> > And, of course the btrfs-heatmap program keeps being a fun tool to
> > create visual timelapses of your filesystem, so you can learn how
> > your usage pattern is resulting in allocation of space by btrfs,
> > and so that you can visually see what the effect of your btrfs
> > balance attempts is:  
> 
> That's interesting, but ultimately, users shoudln't have to
> micromanage their filesystem to that level, even btrfs.
> 
> a) What is wrong in my nightly script that I should fix/improve?

You may want to try
https://www.spinics.net/lists/linux-btrfs/msg52076.html

> b) How do I recover from my current state?

That script may work it's way through.

-- 
Regards,
Kai

Replies to list-only preferred.

