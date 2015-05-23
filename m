Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53481 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251AbbEWPCe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 May 2015 11:02:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YwAwZ-0005Fb-7H
	for linux-btrfs@vger.kernel.org; Sat, 23 May 2015 17:02:31 +0200
Received: from 93.96-242-81.adsl-dyn.isp.belgacom.be ([81.242.96.93])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2015 17:02:31 +0200
Received: from jan.voet by 93.96-242-81.adsl-dyn.isp.belgacom.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2015 17:02:31 +0200
To: linux-btrfs@vger.kernel.org
From: Jan Voet <jan.voet@gmail.com>
Subject: Re: BTRFS RAID5 filesystem corruption during balance
Date: Sat, 23 May 2015 15:02:21 +0000 (UTC)
Message-ID: <loom.20150523T165247-239@post.gmane.org>
References: <loom.20150521T231006-840@post.gmane.org> <pan$1c831$68d3ab4d$212d5e11$aaf7c2b4@cox.net> <loom.20150522T194305-796@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Voet <jan.voet <at> gmail.com> writes:

> 
> Duncan <1i5t5.duncan <at> cox.net> writes:
> 
> > FWIW, btrfs raid5 (and raid6, together called raid56 mode) is still 
> > extremely new, only normal runtime implemented as originally introduced, 
> > with complete repair from a device failure only completely implemented in 
> > kernel 3.19, and while in theory complete, that implementation is still 
> > very immature and poorly tested, and *WILL* have bugs, one of which you 
> > may very well have found.
> > 
> > For in-production use, therefore, btrfs raid56 mode, while now at least 
> > in theory complete, is really too immature at this point to recommend.  
> > I'd recommend either btrfs raid1 or raid10 modes as more stable within 
> > btrfs at this point, tho by the end of this year or early next, I predict 
> > raid56 mode to have stabilized to about that of the rest of btrfs, which 
> > is to say, not entirely stable, but heading that way.
> > 
> 

Looks like the the btrfs raid5 filesystem is back in working order.

What actually happened was that on reboot of the server, the interrupted
btrfs balance tried to resume each time, but wasn't capable of it due to an
incorrect/invalid state.  The amount of errors that were spawned by this
made it very difficult to diagnose, as the kernel log got truncated very
quickly.

Doing a 'btrfs balance cancel' immediately after the array was mounted seems
to have done the trick.  A subsequent 'btrfs check' didn't show any errors
at all and all the data seems to be there.  :-)

Kind regards,
Jan

