Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60379 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934674AbbKTDl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:41:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZzcZg-0007Mm-Gb
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 04:41:24 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 04:41:24 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 04:41:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: anything wrong with `balance -dusage -musage` together?
Date: Fri, 20 Nov 2015 03:41:17 +0000 (UTC)
Message-ID: <pan$34689$f9a98441$5a26e794$85a7efc3@cox.net>
References: <564E60FD.1010801@lukas-pirl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lukas Pirl posted on Fri, 20 Nov 2015 12:53:33 +1300 as excerpted:

> I rarely see balance used with -dusage -musage together, esp. with
> values other than zero.
> 
> The question is, is there anything wrong with running (say) `balance
> -dusage=50 -musage=30` regularly?

I see the question in general has already been answered, nothing at all 
wrong with invoking balance with both an -musage and a -dusage filter, 
it's only rare to see in examples because the examples are generally 
dealing with specific cases where one or the other, generally metadata, 
has run out, due to the other one, generally data, taking all the 
otherwise unallocated space with mostly empty allocations.  So a quick
-dusage filter to clear out the mostly empty data allocations is the most 
common example seen.

But I'd like to point out, not only is combining -dusage and -musage OK, 
but in some cases, specifically btrfs' mixed-bg mode where data and 
metadata are combined into the same blocks, it's actually _mandatory_.

Note that mkfs.btrfs defaulted to --mixed mode for small filesystems, 
under a GiB, for some time, and that while btrfs-progs 4.3 
controversially does away with that default, it's still very strongly 
recommended for filesystems under a GiB, and recommended in general by 
many list regulars to between 8 and 32 GiB (I've even seen an argument 
for making it 64 GiB), as while slightly less efficient (and doubling 
data usage in dup mode), it does eliminate the data vs metadata hassles, 
which can be far worse at smaller filesystem sizes.

And some people use --mixed at even larger sizes, hundreds of gigs to TiB 
scale, often to enable them to do single-device dup mode data for better 
reliability and to better take advantage of btrfs' data integrity 
features, since until now dup mode has been allowed for metadata only, 
and thus has been disallowed for data except with mixed-mode.  (Tho 
that's set to change as recently patches have been posted that would 
allow dup mode data as well, which when integrated, would do away with 
the biggest reason to use mixed mode at 100 gig and larger sizes.)

Anyway, with mixed mode, data and metadata are mixed in the same chunks, 
and balance will refuse to run with balance filters unless the -d and -m 
filters exactly duplicate each other.  So on such a btrfs, to do a -dusage 
balance of any percentage, -musage must be added as well, with the exact 
same percentage.

So as I said, not only is there nothing wrong with combining -dusage and -
musage, in some cases it's actually mandatory.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

