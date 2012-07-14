Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40612 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab2GNBBU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jul 2012 21:01:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SpqjU-0001AV-SJ
	for linux-btrfs@vger.kernel.org; Sat, 14 Jul 2012 03:01:17 +0200
Received: from 174-126-51-102.cpe.cableone.net ([174.126.51.102])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jul 2012 03:01:16 +0200
Received: from DaninFuchs by 174-126-51-102.cpe.cableone.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jul 2012 03:01:16 +0200
To: linux-btrfs@vger.kernel.org
From: Skylar Burtenshaw <DaninFuchs@Gmail.com>
Subject: Re: Can't mount, power failure - recoverable?
Date: Sat, 14 Jul 2012 01:01:04 +0000 (UTC)
Message-ID: <loom.20120714T025232-591@post.gmane.org>
References: <loom.20120317T051243-551@post.gmane.org> <201207131423.54019.Martin@lichtvoll.de> <20120713122839.GJ28701@carfax.org.uk> (sfid-20120713_143222_885648_8598A33F) <201207131638.34771.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald <Martin <at> lichtvoll.de> writes:

> > > Since I didn´t found any explicit mention on it:
> > > Did you try btrfs-zero-log on the partition prior to mounting it?


I had tried that previously, yes. Approximately the date of my first post.
Unless something significant has changed in that tool, it seems to not be
the answer in this case.


> > > All of my BTRFS will not mount after sudden write interruption cases
> > > have been solved by it. Except one with a BTRFS RAID 0 with lots of
> > > 2 TB drives at a time where I didn´t know about btrfs-zero-log.
> > > Maybe it would have helped there, too.

Actually, I have about two dozen drives ranging from 250gb to 2tb, but I
don't think size plays much in this one - I'm obviously just guessing here,
though.

> Yes.
> 
> But why would it write some stuff then on mounting?
> 
> Could it be that it tries to update some of its caches (inode or space)? 
> But then that also does not seem to be in the trace.

I agree with you. I noticed it was trying to write, myself. I have no idea
what it was doing when the power dropped, I wasn't even present, so I can't
even say if it was doing some massive database culling or just idling.

I noticed there've been some recent (since I last looked at least) updates
including fsck and such, however I haven't run anything git-based since the
last time I pulled the btrfs tools, and I had to dig for ages to find info
on how to get the RECENT stuff from the CORRECT source. I can find a dozen
Google results that seem relevant, but can someone give me a definitive 
answer on which tree to pull down (and how) to test the new tools on my mess?

On a related note, if the new tools don't work I'm thinking it's time to bag
it, UNLESS one of the BTRFS devs is curious about my problem and wants to
inspect something to try to figure out the cause. My fear is that with 23
disks and the obscure nature of the issue, it wouldn't be worth the time
it would take to learn what happened. Basically; unless a dev says "let us
look at it first" the chances are it'll be wiped before Monday.

