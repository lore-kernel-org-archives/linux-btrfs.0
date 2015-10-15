Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44453 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbbJOCKY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 22:10:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZmXzp-0001LN-IW
	for linux-btrfs@vger.kernel.org; Thu, 15 Oct 2015 04:10:21 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 04:10:21 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 04:10:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs says no errors, but booting gives lots of errors
Date: Thu, 15 Oct 2015 02:10:15 +0000 (UTC)
Message-ID: <pan$76e30$947a020c$72d4d9dd$c47081a8@cox.net>
References: <8042.1444481164@ccs.covici.com>
	<56191CC2.9000505@googlemail.com> <11640.1444488108@ccs.covici.com>
	<561932EF.2090005@bouton.name> <5619385C.7040103@googlemail.com>
	<16953.1444496102@ccs.covici.com> <56198B7B.90806@bouton.name>
	<27402.1444518173@ccs.covici.com> <27611.1444518496@ccs.covici.com>
	<pan$d2df6$3d7eab24$5c921ac6$dfe0f628@cox.net>
	<7505.1444566567@ccs.covici.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

covici posted on Sun, 11 Oct 2015 08:29:27 -0400 as excerpted:

> Thanks, in the ext4 world, I have lvm and lots of things using separate
> lvm's.  I don't want to go back to partitions, if btrfs is that fragile,
> maybe I should waita while yet.  Or, I could use lvm and put btrfs on
> top of that, but it seems strange to me.

Taking the larger picture perspective, I'd suggest that while btrfs 
arguably isn't "that fragile" if you're willing to work with it, it most 
definitely is of a status I characterize as "stabilizing, but not yet 
fully stable or mature", and as such, isn't likely to be the best choice 
for people who just want "sufficiently stable that I don't have to mess 
with it or worry about it", particularly if they're also the type that 
prefer to run "enterprise stable" or "debian stable" grade distros, which 
are, to put it mildly, not known for the up-to-dateness of the versions 
of various packages they ship.  If that's a description of your comfort 
zone, then there's a basic incompatibility between your comfort zone and 
btrfs' current state, and btrfs probably isn't the right choice for you 
at this point.

In which case, ext3/4, reiserfs (my old favorite, which I had very good 
experience with even with not so reliable hardware), xfs, or possibly zfs 
if you need the features and are willing to put the money into the 
hardware it requires for stability, are more mature and arguably 
appropriate choices.

I had in mind to say something about the big-picture like that in an 
earlier reply, but forgot...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

