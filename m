Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51134 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2GRSNT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 14:13:19 -0400
Date: Wed, 18 Jul 2012 11:13:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        mbroz@redhat.com, Calvin Walton <calvin.walton@kepstin.ca>,
        Martin Steigerwald <Martin@lichtvoll.de>
Cc: jeff@deserettechnology.com
Subject: Re: brtfs on top of dmcrypt with SSD -> Trim or no Trim
Message-ID: <20120718181316.GD16899@merlins.org>
References: <20120202124241.GW16796@shiny> <20120202152722.GI12429@merlins.org> <20120130003754.GD4380@merlins.org> <20120201175624.GE16796@shiny> <20120202032345.GB31903@merlins.org> <20120212223242.GA31989@merlins.org> <20120130003754.GD4380@merlins.org> <20120201175624.GE16796@shiny> <20120202032345.GB31903@merlins.org> <20120130003754.GD4380@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120218160702.GB32373@merlins.org> <20120215165540.GC4763@merlins.org> <20120213001400.GD31989@merlins.org> <20120212223242.GA31989@merlins.org> <20120202032345.GB31903@merlins.org> <20120130003754.GD4380@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sat, Feb 18, 2012 at 08:07:02AM -0800, Marc MERLIN wrote:
> On Sat, Feb 18, 2012 at 01:39:24PM +0100, Martin Steigerwald wrote:
> > To Milan Broz: Well now I noticed that you linked to your own blog entry. 
> 
> He did not, I'm the one who did.
> I asked a bunch of questions since the online docs didn't address them for
> me. Some of you answered those for me, I asked access to the wiki and I
> updated the wiki to have the information you gave me.
> 
> While I have no inherent bias one way or another, obviously I did put some
> of your opinions on the wiki :)
> 
> > Please do not take my below statements personally - I might have written 
> > them a bit harshly. Actually I do not really know whether your statement 
> > that TRIM is overrated is correct, but before believing that TRIM does not 
> > give much advantage, I would like to see at least some evidence of any 
> > sort, cause for me my explaination below that it should make a difference 
> > at least seems logical to me.
> 
> That sounds like a reasonable request to me.
> 
> In the meantime I changed the page to 
> 'Does Btrfs support TRIM/discard?
> 
> "-o discard" is supported, but can have some negative consequences on
> performance on some SSDs or at least whether it adds worthwhile performance
> is up for debate depending on who you ask, and makes undeletion/recovery
> near impossible while being a security problem if you use dm-crypt
> underneath (see
> http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html ), therefore
> it is not enabled by default. You are welcome to run your own benchmarks and
> post them here, with the caveat that they'll be very SSD firmware specific.'
> 
> I'll leave further edits to others ;)

TL;DR:
I'm going to change the FAQ to say people should use TRIM with dmcrypt
because not doing so definitely causes some lesser SSDs to suck, or 
possibly even fail and lose our data.


Longer version:
Ok, so several months later I can report back with useful info.

Not using TRIM on my Crucial RealSSD C300 256GB is most likely what caused
its garbage collection algorithm to fail (killing the drive and all its
data), and it was also causing BRTFS to hang badly when I was getting
within 10GB of the drive getting full.

I reported some problems I had with btrfs being very slow and hanging when I
only had 10GB free, and I'm now convinced that it was the SSD that was at
fault.

On the Crucial RealSSD C300 256GB, and from talking to their tech support
and other folks who happened to have gotten that 'drive' at work and also
got weird unexplained failures, I'm convinced that even its latest 007
firmware (the firmware it shipped with would just hang the system for a few
seconds every so often so I did upgrade to 007 early on), the drive does
very poorly without TRIM when it's getting close to full.
In my case, I hit a bug that is likely firmware and caused the drive to die
(not show up on the bus anymore). I went through special reset, power on but
don't talk to it procedures that eventually brought the drive back after 4
hours of trying, except the drive is now 'blank', all the partitions and
data are gone as far as the controller is concerned.
(yes, I had backups, thanks for asking :) ).

>From talking to their techs and other folks, it seems clear that TRIM is
greatly encouraged, and I'm pretty sure that had I used TRIM, I would not
have hit the problems that caused my drive to fail and suck so much when it
was getting full.

Now, I still think that the Crucial RealSSD C300 256GB has poor firmware
compared to some of its competition and there is no excuse for it just dying 
like that, but I'm going to change the FAQ to recommend that people do use
TRIM if they can, even if they use dm-crypt (assuming their kernel is at
least 3.2.0).

Any objections and/or comments?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
