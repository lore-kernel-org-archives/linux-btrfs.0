Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47277 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbcEMGLl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 02:11:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b16K0-0007iK-TI
	for linux-btrfs@vger.kernel.org; Fri, 13 May 2016 08:11:37 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 08:11:36 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 08:11:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Amount of scrubbed data goes from 15.90GiB to 26.66GiB after
 defragment -r -v -clzo on a fs always mounted with compress=lzo
Date: Fri, 13 May 2016 06:11:27 +0000 (UTC)
Message-ID: <pan$106d2$20dff0d0$cff8ba20$86e58020@cox.net>
References: <264486fb-94ce-4040-a436-e9db5de9a203@linuxsystems.it>
	<pan$331b6$43ad41cc$c9aa5858$e14154bc@cox.net>
	<60018ed4-023e-4ca6-8f74-e19b8849de65@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niccolò Belli posted on Thu, 12 May 2016 15:56:20 +0200 as excerpted:

> Thanks for the detailed explanation, hopefully in the future someone
> will be able to make defrag snapshot/reflink aware in a scalable manner.

It's still planned, AFAIK, but one of the scaling issues in particular, 
quotas, have turned out to be a particularly challenging thing to even 
actually get working correctly.  They've rewritten the quota code twice 
(so they're on their third attempted solution), and it's still broken in 
certain corner-cases ATM, to the point that while they're still actually 
trying to get the existing third try to work in the tough corner-cases as 
well, they're already talking about an eventual third rewrite (4th 
attempt, having scrapped three) once they actually have the corner-cases 
working, to try to bring better performance once they know the tough 
corner-cases and can actually design a solution with both them and 
performance in mind from the beginning.

So in practice an actually scalable snapshot-aware defrag is likely to be 
years out, as it's going to need actually working and scalable quota 
code, and even then, that's only part of the full scalable snapshot/
reflink-aware defrag solution.

The good news is that while there's still work to be done, progress has 
been healthy in other areas, so once the quota code both actually works 
and is scalable, the other aspects should hopefully fall into place 
relatively fast, as they've already been maturing on their own, 
separately.

> I will not use use defrag anymore, but what do you suggest me to do to
> reclaim the lost space? Get rid of my current snapshots or maybe simply
> running bedup?

Neither snapshots nor dedup are one of my direct use-cases so my 
practical knowledge there is limited, but removing the snapshots should 
indeed clear the space (but you'll likely have to remove all of them 
covering a specific subvolume in ordered to free the space) as in doing 
so you'll be removing all references locking the old extents in place.  
If you already have them backed up (using send/receive, for instance) 
elsewhere or don't actually need them, however, it's a viable alternative.

In theory the various btrfs dedup solutions out there should work as 
well, while letting you keep the snapshots (at least to the extent 
they're either writable snapshots so can be reflink modified, or a single 
read-only snapshot that the others including the freshly defragged 
working copy can be reflinked to), since that's their mechanism of 
operation -- finding identical block sequences and reflinking them so 
there's only one actual copy on the filesystem, with the rest being 
reflinks to it -- so in effect it should undo the reflink-breaking you 
did with the defrag.  *But*, without any personal experience with them, I 
have no idea either how effective they are in practice in a situation 
like this, or how practical vs. convoluted the commandlines are going to 
be to actually accomplish your goal.  Best-case, it's a simple and fast 
command to run and it not only undoes the defrag reflink breakage, but 
actually finds enough duplication in the dataset to reduce usage even 
further than before, worst-case it's multiple complex commands that take 
a week or longer to run and don't actually help much.

So in practice, you have a choice between EITHER deleting all the 
snapshots and along with them everything locking down the old extents, 
thus leaving you with only the new, fresh copy (which by itself should be 
smaller than before), but at the expense of losing your snapshots, OR the 
at least from my knowledge relative unknown of the various btrfs dedup 
solutions, which in theory should work well, but in practice... I simply 
don't know.

AND of course you have the option of basically doing nothing, leaving 
things as they are.  However, given the context of this thread, it seems 
you don't consider that a viable longer term option as apparently you 
were trying to clear space, not use MORE of it, and presumably you 
actually need that space for something else, and that precludes just 
letting things be, unless of course you can afford to simply buy your way 
out of the problem with more storage devices.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

