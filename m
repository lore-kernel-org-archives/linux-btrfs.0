Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43483 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbbLXAjG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 19:39:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBtvr-00007e-Eu
	for linux-btrfs@vger.kernel.org; Thu, 24 Dec 2015 01:39:03 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 01:39:03 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 01:39:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid 5/6 Stability
Date: Thu, 24 Dec 2015 00:38:57 +0000 (UTC)
Message-ID: <pan$3b05a$667561e3$4f808486$449baaf4@cox.net>
References: <E1aBsGQ-0007zz-4V@rmm6prod02.runbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

jwalmer posted on Wed, 23 Dec 2015 17:52:10 -0500 as excerpted:

> Just an avid follower of the project checking in. It has been about nine
> months since the initial Raid 5/6 features were released in 3.19 and
> they are still listed as incomplete/experimental on the Wiki.
> 
> Admittedly, I don't understand how such a large and distributed project
> prioritizes features for development, but I haven't been able to find a
> clear roadmap anywhere.
> 
> I'm wondering if anyone here is able to give me some insight about when
> the Raid 5/6 feature will next be updated, or even when they are
> scheduled to lose their incomplete/experimental designation.

Addressing the wiki side first, then the question you're probably more 
interested in. =:^)

FWIW, the wiki gets updated... when a volunteer (which could be you =:^) 
updates it.  It often has quite current information... somewhere on the 
wiki, but often not all mentions of a feature get updated at the same 
time, and some may lag behind.

That said, while btrfs raid56 is no longer experimental, I'd not call it 
entirely stable, even to the point of the rest of btrfs (which is 
stabilizing but not fully stable or mature yet), just yet.

I've personally long stated that raid56 feature stability, to the point 
of the rest of btrfs anyway, can be expected roughly a year after nominal 
feature completion, with an additional requirement of at least two kernel 
cycles without major bugs in the feature.  At five kernel releases a year 
that would put it more or less at 4.4, which is soon to be released and 
quite good timing, as 4.4 is an LTS release, and indeed, the last major 
raid56 bug was fixed early in the 4.2 cycle (well before 4.2 release), so 
4.4 meets the requirement in that regard as well. =:^)

Now I'm just an active list regular and btrfs user, not a dev, but I 
began making that recommendation/prediction before 3.19's release, when 
it was clear 3.19 would bring nominal raid56 code completion, and in the 
immediately following releases as well, when people were (I thought) 
jumping the gun, and indeed, getting their data eaten by remaining 
critical bugs, and nobody has argued it otherwise in the intervening 
time, so I'd suggest it's a reasonably solid recommendation. 

So 4.4 is what I'd consider the magical raid56-stability release, and I'd 
actually expect the wiki to be updated shortly thereafter, tho 4.4 is 
close enough now, and there have been no major raid56 bugs reported in 
the 4.3 and 4.4 cycles, that arguably the wiki's raid56 status could be 
updated now to reflect that.

(Personally, I'm more a newsgroups and mailing lists guy, and while I 
read web/wiki resources and will in fact often quote them, I tend to 
treat them as read-only and very seldom personally edit them, leaving 
that to others, who occasionally even quote my list posts more or less 
verbatim when they update the wiki.  So again, you're invited to do so if 
that's your thing, but it's nothing I'm likely to do personally.  And 
FWIW, there are a few folks that watch wiki updates and revert spam and 
anything crazy, so as long as the edits are honestly trying to make 
things better, any help you can be in editing the wiki is highly 
appreciated, and you don't have to worry too much about any mistakes you 
inadvertently make, as others will be along to fix them. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

