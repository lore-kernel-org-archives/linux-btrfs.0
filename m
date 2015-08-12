Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42130 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbbHLE65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 00:58:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZPO7r-0007p6-8v
	for linux-btrfs@vger.kernel.org; Wed, 12 Aug 2015 06:58:55 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 06:58:55 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 06:58:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scaling to 100k+ snapshots/subvolumes
Date: Wed, 12 Aug 2015 04:58:49 +0000 (UTC)
Message-ID: <pan$b52f9$559a3177$6de43ad3$9e149b65@cox.net>
References: <CAMUoZtY7Or1+4-XmxWQjrmkAk-x62e13XMoTbWApRAn_zhd2DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tristan Zajonc posted on Tue, 11 Aug 2015 11:33:45 -0700 as excerpted:

> In an early thread Duncan mentioned that btrfs does not scale well in
> the number of subvolumes (including snapshots).  He recommended keeping
> the total number under 1000.  I just wanted to understand this
> limitation further.  Is this something that has been resolved or will be
> resolved in the future or is it something inherent to the design of
> btrfs?

It is not resolved yet, but it's definitely on the radar.  I don't 
personally understand the details well enough to know if the problem is 
inherent to btrfs, or if some optimized rewrite down the road is likely 
to at least yield linear scaling.

On the practical side, one related thing I do know is that this is the 
reason snapshot-aware-defrag was disabled a few kernel cycles after being 
introduced -- it simply didn't scale, and the thought was, better a 
defrag that at least worked for the snapshot you pointed it at, even at 
the cost of increasing usage due to COW if other snapshots pointed at the 
same file extents, than a defrag that basically didn't work at all.

But the intent remains to at least get scaling working well enough to 
have snapshot-aware-defrag again.  So when snapshot-aware-defrag is 
enabled again, that's your clue that things should be scaling at least 
/reasonably/ well, and it's time to reexamine the situation.  Until then, 
I'd not recommend trying it.

> We have an application that could easily generate 100k-1M snapshots and
> 10s of thousands of subvolumes.  We use snapshots to track very
> fine-grained filesystem histories and subvolumes to enforce quotas
> across a large number of distinct projects.

Btrfs quotas... have been another sticky wicket on btrfs, both as earlier 
the code was simply broken (tho AFAIK that's fixed in general, now), and 
because due to the way it works, quota tracking multiplies the scaling 
issues several fold (certainly in the original code form).  AFAIK they've 
actually done at least two partial rewrites, so are on the third quota 
code version now.  The third-try quota code is fresh enough I don't think 
people know yet how well it's going to perform in deployment.

As a result of that quota code history, my recommendation has been that 
unless you're deliberately testing it, if you don't need quotas, keep it 
turned off on btrfs and avoid the issues it has been known, at least 
historically, to trigger.  As btrfs quota code is demonstrably not yet 
stable and reliable enough to use, if you *do* actually depend on quotas, 
you should definitely be on some other filesystem where the quota code is 
well tested and known to be dependable, as that simply doesn't describe 
btrfs quota code at this point.

But there's actually some pretty big effort going into the quota code at 
the moment, this the fact that we're on the third version now, and 
they're definitely planning on it actually working, or they'd not be 
sinking the effort into it that they are.

And as I said, the quota code was multiplying the scaling issues several 
fold, so getting quotas actually working well is a big part of getting 
the scaling issues fixed as well.

But beyond that; in particular, whether it's ever likely to work at the 
scales you mention above, is something you'd have to ask the devs, as I'm 
just a list regular and btrfs-using admin, with a use-case that doesn't 
directly involve either quotas or subvolumes/snapshotting to any great 
degree.  So while I can point to the current situation and the current 
trend and work areas, I have effectively no idea if scaling to the 
numbers you mention above is even technically possible, or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

