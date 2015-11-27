Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:47254 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbK0KaN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 05:30:13 -0500
Subject: Re: implications of mixed mode
To: Duncan <1i5t5.duncan@cox.net>
References: <56579BD1.4030401@lukas-pirl.de>
 <pan$d7271$6dfb6246$70339bd2$f62a4d8@cox.net>
From: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <565830AD.3000805@lukas-pirl.de>
Date: Fri, 27 Nov 2015 23:30:05 +1300
MIME-Version: 1.0
In-Reply-To: <pan$d7271$6dfb6246$70339bd2$f62a4d8@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/27/2015 04:11 PM, Duncan wrote as excerpted:
> My big hesitancy would be over that fact that very few will run or test 
> mixed-mode at TB scale filesystem level, and where they do, it's likely 
> to be in ordered to work around the current (but set to soon be 
> eliminated) metadata-only (no data) dup mode limit on single-device, 
> since in that regard mixed-mode is treated as metadata and dup mode is 
> allowed.
> 
> So you're relatively more likely to run into rarely seen scaling issues 
> and perhaps bugs that nobody else has ever run into as (relatively) 
> nobody else runs mixed-mode on multi-terabyte-scale btrfs.  If you want 
> to be the guinea pig and make it easier for others to try later on, after 
> you've flushed out the worst bugs, that's definitely one way to do it.
> =:^]

I see. This somehow aligns with Qu's answer.

> It's worth noting that rsync... seems to stress btrfs more than pretty 
> much any other common single application.  It's extremely heavy access 
> pattern just seems to trigger bugs that nothing else does, and while they 
> do tend to get fixed, it really does seem to push btrfs to the limits, 
> and there have been a /lot/ of rsync triggered btrfs bugs reported over 
> the years.

Well, IMHO btrfs /has/ to deal with rsync workloads if it wants to be
an alternative for larger storages but that is another story.
I do run btrfs (non-mixed) with rsync workloads for quite a while now
and it is doing well (except for the deadlock that has been around a
while ago). Maybe my network is just slow enough to not trigger any
unfixed weird issues with the intense access patterns of rsync.
Anyways, thanks for the hint!

> Between the stresses of rsyncing half a TiB daily and the relatively 
> untested quantity that is mixed-mode btrfs at multi-terabyte scales on 
> multi-devices, there's a reasonably high chance that you /will/ be 
> working with the devs on various bugs for awhile.  If you're willing to 
> do it, great, somebody putting the filesystem thru those kinds of mixed-
> mode paces at that scale is just the sort of thing we need to get 
> coverage on that particular not yet well tested corner case, but don't 
> expect it to be particularly stable for a couple kernel cycles anyway, 
> and after that, you'll still be running a particularly rare corner-case 
> that's likely to put new code thru its paces as well, so just be aware of 
> the relatively stony path you're signing up to navigate, should you 
> choose to go that route.

Makes perfect sense. I think I sadly do not have the resources to be
that guinea pig…

> Meanwhile, assuming you're /not/ deliberately setting out to test a 
> rarely tested corner-case with stress tests known to rather too 
> frequently get the best of btrfs...
> 
> Why are you considering mixed-mode here?  At that size the ENOSPC hassles 
> of unmixed-mode btrfs on say single-digit GiB and below really should be 
> dwarfed into insignificance, particularly since btrfs since 3.17 or so 
> deletes empty chunks instead of letting them build up to the point where 
> they're a problem, so what possible reason, other than simply to test it 
> and cover that corner-case, could justify mixed-mode at that sort of 
> scale?
> 
> Unless of course, given that you didn't mention number of devices or 
> individual device size, only the 8 TB total, you have in mind a raid of 
> something like 1000 8-GB USB sticks, or the like, in which case mixed-
> mode on the individual sticks might make some sense (well, to the extent 
> that a 1000-device raid of /anything/ makes sense! =:^), given their 8-GB 
> each size.

That is not the case. I just came to the consideration because I
wondered why mixed-mode is not generally preferred when data and
metadata have the same replication level.

Thanks Duncan!

Lukas
