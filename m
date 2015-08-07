Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57549 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbbHGLOB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Aug 2015 07:14:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZNfb4-0002M4-Nn
	for linux-btrfs@vger.kernel.org; Fri, 07 Aug 2015 13:13:58 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 13:13:58 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 13:13:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid1 metadata, single data
Date: Fri, 7 Aug 2015 11:13:53 +0000 (UTC)
Message-ID: <pan$ab556$31334246$50071ab6$5c19a1f7@cox.net>
References: <55C47136.2080402@render-wahnsinn.de>
	<201508071918.02231.russell@coker.com.au> <1520215.AbHMhTRmNr@hoefnix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sjoerd posted on Fri, 07 Aug 2015 11:47:57 +0200 as excerpted:

> While we're at it: any idea why the default for SSD's is single for meta
> data as described on the wiki?
> (https://btrfs.wiki.kernel.org/index.php/
Using_Btrfs_with_Multiple_Devices#Filesystem_creation)
> 
> I was looking for an answer why my SSD just had single metadata, while I
> expected it to be DUP and stumbled on this wiki article. Can't find a
> reason for why a SSD would be different?

I've seen two variant answers given, both having to do with the FTL in 
the SSDs, but both not particularly satisfying to me.

The first applies to only some SSDs, in particular, those with dedup 
features, like those with sandstorm (?? from memory, sand-something 
anyway) firmware.  These will detect the duplicated metadata and dedup 
it, so there will still be only one copy.  In this case, writing the 
disappearing dup is only wasting cpu and device cycles and bandwidth, so 
yes, for these devices single is appropriate, but since only a fraction 
of SSDs are affected, I personally still don't see that justifying 
changing the default for all SSDs.

The second variant suggests that since the two copies will be updated so 
close to each other in time, even non-deduping FTLs will very likely map 
both of them to the same erase block, moving them together for wear-
leveling, etc.  As such, they will very likely be located close to each 
other on the physical media, and chip damage or block wear-out that 
affects one will very likely affect the other as well, so even where it's 
not deduped into a single copy by #1, there's likely very little if any 
advantage in having that second copy on ssd, since both copies are likely 
going to be corrupted together in any case, and it's /both/ extra cpu and 
device cycles and bandwidth, /and/ extra write cycles on write-cycle-
limited media.

This variant seems to me to be more credible, but even then, I'm not sure 
it's justification for changing the default.  If a user wants to spare 
his SSD the trouble, it's easy enough to change the default.  Otherwise, 
it seems to me the otherwise dup default should remain as it is, both 
because in some cases it might still provide useful redundancy, and 
because having an exception like that is a pain when it comes to 
documentation and explanation.  And that pain has a cost as well...


But... most of my btrfs are dual-device raid1 both data/metadata anyway, 
with the exception of /boot, which I specifically setup dup, despite it 
being on ssd (with a backup /boot on the other device, complete with its 
own backup gpt-bios partition and grub setup as well, so each device can 
be selected in the BIOS and booted independently, regardless of whether 
the other device is there or not).  Being /boot it's small, so mixed-bg, 
meaning data/metadata are both dup, which halves my effective storage 
capacity, but I'd still rather dup than single.

And I'd really recommend dual device raid1 both data/metadata, for the 
reasons I explained in my earlier response to this thread -- in addition 
to the additional physical device redundancy of raid1, btrfs data 
integrity means raid1 gives you a second copy of everything, so if btrfs 
detects a bad copy, it actually has a second, hopefully good, copy to 
overwrite the bad copy with.  Without that second copy, it'll just error 
out when you try to access the blocks of the file that checksum-fail.  
With it, you'll get the good copy instead, and btrfs can overwrite the 
bad one too. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

