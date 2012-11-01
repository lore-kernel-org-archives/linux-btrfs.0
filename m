Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52167 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab2KASqK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 14:46:10 -0400
Date: Thu, 1 Nov 2012 14:46:07 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ablock84@googlemail.com" <ablock84@googlemail.com>,
        "sensille@gmx.net" <sensille@gmx.net>
Subject: Re: [PATCH 0/2] Btrfs-progs: urgent fixes for btrfs send
Message-ID: <20121101184607.GD21281@shiny>
References: <1351782086-23435-1-git-send-email-list.btrfs@jan-o-sch.net>
 <20121101150710.GA21281@shiny>
 <509299C9.7050509@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <509299C9.7050509@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 01, 2012 at 09:48:25AM -0600, Jan Schmidt wrote:
> On Thu, November 01, 2012 at 16:07 (+0100), Chris Mason wrote:
> > On Thu, Nov 01, 2012 at 09:01:24AM -0600, Jan Schmidt wrote:
> >> Hi everybody,
> >>
> >> We made a bad mistake with "btrfs send" command line arguments and we'd
> >> better fix it before it's being widely used (read: *now*).
> > 
> > Ok, I do agree that -i was confusing.  I didn't end up using it in my
> > backup scripts here.
> 
> Good we agree here :-)
> 
> > How about:
> > 
> > Make -p and -i mean the same thing.  Add -r for what -i should have
> > done.  
> > 
> > This has the advantage of not breaking the people that did get working
> > btrfs send setups ;)
> 
> I'd carefully argue that we're still in the position to break things, because
> the 3.7 kernel isn't released and you cannot use "btrfs send" without it. The
> number of users should be really small.
> 
> I prefer having a clean and painful cut over suffering from bad decisions
> forever. That may not be the most popular opinion in the world. In the end, I
> could live with -p and -i doing the same thing.

But we have a working -p, I'm not sure why we'd rename it to -i?  I'm
even fine with just flat out removing -i.  This is mostly because
--parent makes a lot of sense to me, but I'm more than open to other
ideas.

-chris

