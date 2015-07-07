Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40163 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbbGGArv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jul 2015 20:47:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZCH37-0001GK-UX
	for linux-btrfs@vger.kernel.org; Tue, 07 Jul 2015 02:47:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 02:47:49 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 02:47:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange corruptions found during btrfs check
Date: Tue, 7 Jul 2015 00:47:44 +0000 (UTC)
Message-ID: <pan$a2365$d81c3521$a3dbaee4$237d0b1c@cox.net>
References: <1435853528.6153.3.camel@scientia.net>
	<1436208023.7124.6.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 06 Jul 2015 20:40:23 +0200 as
excerpted:

> After removing some of the snapshots that were received, the errors at
> btrfs check went away.
> 
> Is there some list of features in btrfs which are considered stable?
> Cause I though send/receive and the subvolumes would be, but apparently
> this doesn't seem to be the case :-/

[List-regular non-developer but btrfs using admin answer.]

I know of no such list, per se.  There are, however, features that are 
known to be still being very actively worked on, either because they are 
very new to nominal code-completion (raid56 mode), or because they are 
simply complicated problems, possibly having to be redone with a new 
approach as the devs learned more about the the issues with the existing 
approach.

This list would include:

raid56 mode (new)

quotas (on I think their second partial rewrite, third approach, now)

send/receive (there's simply very many very complex corner-cases to find 
and deal with)


Subvolumes/snapshots should however be reasonably stable, since their 
basis is pretty close to that of btrfs itself, b-trees and COW, and the 
hooks for managing them (the GUI) have been established for some time.  
The problems involving subvolumes/snapshots aren't so much in that 
subsystem, but in whatever other subsystems are involved as well.  The 
interaction between quotas and subvolumes has been a problem point, for 
instance, and snapshot-aware-defrag continues to be disabled ATM as it 
simply didn't scale due to problems in other areas (quotas being one of 
them).  The interaction between send/receive and subvolumes/snapshots is 
also a problem, but again, not so much on the subvolume/snapshot side, as 
on the send/receive side.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

