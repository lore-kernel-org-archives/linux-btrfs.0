Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45101 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbbEFKOf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 06:14:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YpwLZ-0006wX-7J
	for linux-btrfs@vger.kernel.org; Wed, 06 May 2015 12:14:33 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 12:14:33 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 12:14:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: check metadata redundancy
Date: Wed, 6 May 2015 10:14:22 +0000 (UTC)
Message-ID: <pan$4d8bd$69a541b1$1eeb8716$dbf90143@cox.net>
References: <mi2sgj$urs$1@ger.gmane.org>
	<20150505145432.GG5099@twin.jikos.cz> <mibc2f$a9$1@ger.gmane.org>
	<B7F2379062E32745A8651FBDB20F645954A286B3@Server.waterlogic.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Paul Jones posted on Wed, 06 May 2015 03:40:12 +0000 as excerpted:

> I would appreciate being able to use the DUP profile for data on a
> single disk - at the moment I just resort to partitioning the disk in
> two and creating a raid1. Usecase is portable disk backups

Rabbit-trailing a bit from the original discussion to address this 
point...

First of all, DUP data has been on the wishlist for some users for some 
time, generally for those who wish to capitalize on btrfs data 
checksumming and validation and actually be able to correct and scrub 
invalid data when using btrfs on a single device, which would seem to be 
what your use-case is about, at its root.

Meanwhile, second, good news!  There is actually one way to achieve DUP 
data on a single device, without resorting to partitioning a single 
device to create a raid1 on it:

When doing the mkfs.btrfs, set the -M/--mixed chunk mode option.  

Mixed-chunk mode (aka mixed-block-group aka mixed-bg) is used by default 
on btrfs under 1 GiB, and there have been discussions about upping that 
to say 16 GiB or so, but the reason it isn't the default on normal larger 
btrfs is because (as the mkfs.btrfs manpage states) mixed-chunk mode 
incurs a performance penalty on larger btrfs.

But partitioning up a single physical device to make it two logical 
devices, just to be able to setup raid1 data, surely incurs a larger 
penalty, at least on spinning rust, where the single set of write heads 
will have to seek back and forth between partitions.  And obviously, if 
people are going to that extreme (and you and others have demonstrated 
that they are and do!), they're willing to pay the relatively smaller 
mixed-bg penalty.

Since mixed-bg mode mixes data and metadata in the same block-groups 
(chunks), DUP mode was made an option there (and I think the default, tho 
I always set it specifically for both data and metadata, setting just one 
in the case of mixed-bg is an error), in ordered to maintain metadata DUP 
protection.  But since as the name suggests they're mixed-bgs, that also 
has the effect of setting data DUP mode! =:^)

When asked specifically about this, Chris Mason confirmed that wasn't 
intentional, simply an implementation accident, with the purpose of mixed-
bg mode being, as the manpage and sub-1-GiB-default suggests, to allow 
more efficient usage of space on small btrfs, which was really needed as 
pre-mixed-bg, chunk allocation on small devices /was/ really inefficient, 
and mixed-bg really did solve that problem.  However, accident or not, 
it's not something that can really be dropped now, and I've seen 
absolutely no suggestions to do so.

So mixed-bg does seem to be the workaround for lack of DUP mode data, and 
even with its inefficiencies compared to separate data/metadata, compared 
to "virtual" raid1 on a single partitioned physical device, it should be 
/quite/ efficient indeed, at least on spinning rust.

Which just leaves some loose ends to tie up...

* I don't know that anyone has benchmarked, or even made claims based on 
logic, of performance on single SSD, partitioned raid1 mode against mixed-
bg dup mode.

* If the concern is failing media itself, again on spinning rust (ssd 
firmwares do weird things with consecutive sector addresses anyway), 
raid1 mode should still be slightly more reliable, simply because the two 
copies are going to be in partitions on opposite ends of the disc.  Mixed-
bg mode will tend to allocate chunks closer to each other, such that at 
least in theory, it's more likely that a flaky media section will damage 
both copies.

* Many people would still like to have true DUP data chunks as an option, 
and personally, I think it'll likely eventually happen, because I think 
the reason people want that option is valid and it shouldn't be hard to 
implement -- I think mostly just letting that be a data option too, tho 
there's likely a few corner-case races that might expose that have been 
hidden so far as it's not an option.  However, I also believe that as a 
practical matter, the existence of the mixed-bg workaround has more or 
less silenced the requests, and there have been bigger fish (well, bugs, 
and features like raid56 mode, not fish) to fry, so it hasn't been the 
issue that it would have been otherwise, and that has probably delayed 
the lifting of the DUP mode data restriction in the more general case.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

