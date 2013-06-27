Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44641 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3F0NvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 09:51:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UsCbV-0001LB-A2
	for linux-btrfs@vger.kernel.org; Thu, 27 Jun 2013 15:51:17 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 15:51:17 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 15:51:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: some feedbacks seen on btrfs
Date: Thu, 27 Jun 2013 13:50:59 +0000 (UTC)
Message-ID: <pan$3baf1$6d060523$a1fed5b3$72605eb8@cox.net>
References: <CADCGFBV-5OMDCD-EVtsUsKnSBOifF2+sjYHHmgR0WKOoLLsQXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roger Pack posted on Wed, 26 Jun 2013 15:04:56 -0600 as excerpted:

> First off, thanks for an awesome file system, it is working well for my
> purposes of compressing a  filesystem on a small VPS.  Woot!
> 
> I thought I'd call out a few things (in the hopes of spurring
> improvements) I'd seen about btrfs (in case they weren't common
> knowledge...):

These are common knowledge... for the folks on this list, anyway.  The 
problem tends to be distros that make the still experimental and getting 
new features btrfs an easily used option (or even default?), for people 
to use, without making the caveat about btrfs still being under heavy 
development and needing good backups equally obvious if not more so than 
the option to use btrfs in the first place.

FWIW, I tried btrfs about a year ago and it simply wasn't ready for me.  
I tried it again this year (from about a month ago on), however, and thru 
a combination of my needs changing somewhat and btrfs maturing 
dramatically in the intervening year, I've been far happier with how it's 
going now.

Generally speaking, used as a traditional-use single-device filesystem, 
btrfs is /reasonably/ stable and mature now, altho because it's still 
actively getting new features and likely will be for several more kernel 
cycles yet, it's not yet ready for the full production-ready stability 
seal and delivery just yet.

The multi-device raid1 mode (well, two-way-mirroring, it's not full N-way 
mirroring raid1, despite the name) as well as raid0 striping and raid10 
both, is in the middle, the features are there and complete, and some 
stabilizing has been done, but it's not as stable as the traditional-use 
single-device code is yet.  Still, this being my area of interest and 
usage, it's in this area that I saw the biggest changes in the last year, 
such that it's now usable for my use case, dual-device SSD in raid1 mode 
for both data and metadata -- with good backups around just in case!

Subvolumes and snapshots aren't my primary use case or focus, but I'd put 
them in the same category as raid0/1/10, middle level toward stability, 
code implemented for awhile and generally working, but not as mature or 
stable as the traditional filesystem use-case.

The brand new raid5/6 mode code was new to kernel 3.9 and isn't yet 
complete.  Certainly with 3.9, and to a lessor extent with 3.10, it's 
EXPECTED to have problems in power-drop situations, etc, as that's the 
part of the code that isn't finished yet.  (AFAIK it's basically complete 
with 3.10, but is still first-implementation code without anything beyond 
first-implementation bug testing, so don't trust 3.10 for raid5/6 mode 
either.)  By 3.12 or so, it should be starting to get there, and by 
spring of next year, I'd guess the code should be about where raid0/1/10 
code is today.

As with subvolumes and snapshots, quotas aren't my use case or focus, but 
simply knowing that they were implemented after my first trial last year, 
but before raid5/6 mode in 3.9, I'd put their maturity somewhere between 
as well, which would mean initial implementation is complete and in 
theory they're ready for use, but there's still a LOT of debugging to go 
before that can be considered stable.  Quota support should therefore be 
about where raid5/6 will be by the end of this year, or where raid0/1/10 
were near the end of last year.

N-way mirroring (aka raid1 as many people consider it) is still on the 
roadmap, as it has been, to be added after raid5/6 completion.  So maybe 
by the end of the year...  De-dup is I believe still on the roadmap as 
well.

Which means feature completion is now reasonably in sight, possibly by 
end of year, and next year should be primarily stabilization, FINALLY!  
It has been rather longer in coming than I think anyone expected, but 
given the differences I've seen over the last year, and roadmap feature 
status, next year could be the year for stabilization; the year that 
experimental label finally comes off.  Tho corporate production level 
usage tends to be rather conservative (many have only recently switched 
to ext4), so I wouldn't expect to see wide-scale deployment there until 
2015 or so.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

