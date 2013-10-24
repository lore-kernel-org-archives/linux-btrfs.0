Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55830 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab3JXSFa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 14:05:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VZPHl-0007GF-3r
	for linux-btrfs@vger.kernel.org; Thu, 24 Oct 2013 20:05:29 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 20:05:29 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 20:05:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why cannot I move a read-only snapshot around?
Date: Thu, 24 Oct 2013 18:05:07 +0000 (UTC)
Message-ID: <pan$85344$b336f5bf$ca444091$a3ef1e0c@cox.net>
References: <20131024152955.GA6110@kipc2.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Karl Kiniger posted on Thu, 24 Oct 2013 17:29:56 +0200 as excerpted:

> Dear list, (newbie alert)
> 
> After sucessfully sending and receiving a dozen of  related snapshots I
> want to move them all to the readonly folder but I cannot:

I see you mention fedora 19 in a followup, but for those not on fedora, 
that's not much help figuring out which kernel you're running.  It's 
likely that the following is your problem, tho there's not enough 
information in your post to be sure.

There was a recent regression with nested subvolumes that may be what 
you're running into.  Kernel 3.11 was affected as well as early 3.12-rcs 
and I believe 3.10 also but I'm not sure how far back, except that 
someone mentioned trying an old kernel (3.8 or 3.6-ish) and moving 
subvolumes into subvolumes worked there (tho doing anything involving 
writing into read-only snapshots shouldn't work, by design, but that 
doesn't appear to be what you're doing, you're just trying to move read-
only snapshots to a different location on a read/write base or parent 
subvolume, this post assuming it's a parent subvolume, thus triggering 
the nested subvolumes bug).

A fix is available but I'm not sure whether it got into 3.12 (which is 
just about to be released) or will now have to wait for 3.13.  So either 
try latest 3.12 git and see if its there, or find and cherry-pick the 
patch, applying it against 3.11 or 3.12.  (Given that btrfs is still an 
experimental filesystem with fixes applied every kernel, while reverting 
to an old enough kernel should unregress this particular problem, I can't 
recommend it except possibly for testing against data you don't care 
about, since by doing so you're exposing yourself to other known and now 
fixed bugs.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

