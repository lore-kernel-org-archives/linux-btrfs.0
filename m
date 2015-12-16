Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35895 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbbLPXkD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 18:40:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9Lfs-0002Gu-0B
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 00:40:00 +0100
Received: from ip5f5ae08a.dynamic.kabel-deutschland.de ([95.90.224.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 00:39:59 +0100
Received: from hurikhan77 by ip5f5ae08a.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 00:39:59 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Thu, 17 Dec 2015 00:39:53 +0100
Message-ID: <20151217003953.68948d04@jupiter.sol.kaishome.de>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com>
	<1448497439.28195.33.camel@scientia.net>
	<20151126003342.GA24333@carfax.org.uk>
	<1449639781.7835.3.camel@scientia.net>
	<pan$ab79a$6d00d5c9$95504338$ca8d2761@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 9 Dec 2015 13:36:01 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> >> > 4) Duncan mentioned that defrag (and I guess that's also for
> >> > auto- defrag) isn't ref-link aware...
> >> > Isn't that somehow a complete showstopper?  
> 
> >> It is, but the one attempt at dealing with it caused massive data
> >> corruption, and it was turned off again.  
> 
> IIRC, it wasn't data corruption so much, as massive scaling issues,
> to the point where defrag was entirely useless, as it could take a
> week or more for just one file.
> 
> So the decision was made that a non-reflink-aware defrag that
> actually worked in something like reasonable time even if it did
> break reflinks and thus increase space usage, was of more use than a
> defrag that basically didn't work at all, because it effectively took
> an eternity. After all, you can always decide not to run it if you're
> worried about the space effects it's going to have, but if it's going
> to take a week or more for just one file, you effectively don't have
> the choice to run it at all.
> 
> > So... does this mean that it's still planned to be implemented some
> > day or has it been given up forever?  
> 
> AFAIK it's still on the list.  And the scaling issues are better, but
> one big thing holding it up now is quota management.  Quotas never
> have worked correctly, but they were a big part (close to half, IIRC)
> of the original snapshot-aware-defrag scaling issues, and thus must
> be reliably working and in a generally stable state before a
> snapshot-aware-defrag can be coded to work with them.  And without
> that, it's only half a solution that would have to be redone when
> quotes stabilized anyway, so really, quota code /must/ be stabilized
> to the point that it's not a moving target, before reimplementing
> snapshot-aware-defrag makes any sense at all.
> 
> But even at that point, while snapshot-aware-defrag is still on the
> list, I'm not sure if it's ever going to be actually viable.  It may
> be that the scaling issues are just too big, and it simply can't be
> made to work both correctly and in anything approaching practical
> time.  Time will tell, of course, but until then...

I'd like to throw in an idea... Couldn't auto-defrag just be made "sort
of reflink-aware" in a very simple fashion: Just let it ignore extents
that are shared?

That way you can still enjoy it benefits in a mixed-mode scenario where
you are working with snapshots partly but other subvolumes are never
taken snapshots of.

Comments?

-- 


