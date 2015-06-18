Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46744 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbbFREc0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 00:32:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z5RV1-0000Gj-6W
	for linux-btrfs@vger.kernel.org; Thu, 18 Jun 2015 06:32:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 06:32:23 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 06:32:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS: read error corrected: ino 1 off 226840576 (dev
 /dev/mapper/dshelf1 sector 459432)
Date: Thu, 18 Jun 2015 04:32:17 +0000 (UTC)
Message-ID: <pan$e509f$9bb669c$8cfbb039$6d6b7135@cox.net>
References: <CAJCQCtRwy_beFwAH8=WV0VpVW3295rB4UY6WQ0ZJf+bXynuXnw@mail.gmail.com>
	<20150617161936.GK16468@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Wed, 17 Jun 2015 09:19:36 -0700 as excerpted:

> On Wed, Jun 17, 2015 at 01:51:26PM +0000, Duncan wrote:
>> > Also, if my actual data got corrupted, am I correct that btrfs will
>> > detect the checksum failure and give me a different error message of
>> > a read error that cannot be corrected?
>> > 
>> > I'll do a scrub later, for now I have to wait 20 hours for the raid
>> > rebuild first.
>> 
>> Yes again.
>  
> Great, thanks for confirming.
> Makes me happy to know that checksums and metadata DUP are helping me
> out here.  With ext4 I'd have been worse off for sure.
> 
>> One thing I'd strongly recommend.  Once the rebuild is complete and you
>> do the scrub, there may well be both read/corrected errors, and
>> unverified errors.  AFAIK, the unverified errors are a result of bad
>> metadata blocks, so missing checksums for what they covered.  So once
>> you
> 
> I'm slightly confused here. If I have metadata DUP and checksums, how
> can metadata blocks be unverified?
> Data blocks being unverified, I understand, it would mean the data or
> checksum is bad, but I expect that's a different error message I haven't
> seen yet.

Backing up a bit to better explain what I'm seeing here...

What I'm getting here, when the sectors go unreadable on the (slowly) 
failing SSD, is actually a SATA level timeout, which btrfs (correctly) 
interprets as a read error.  But it wouldn't really matter whether it was 
a read error or a corruption error, btrfs would respond the same -- 
because both data and metadata are btrfs raid1 here, it would fetch and 
verify the other copy of the block from the raid1 mirror device, and 
assuming it verified (which it should since the other device is still in 
great condition, zero relocations), rewrite it over the one it couldn't 
read.

Back on the failing device, the rewrite triggers a sector relocation, and 
assuming it doesn't fall in the bad area too, that block is now clean.  
(If it does fall in the defective area, I simply have to repeat the scrub 
another time or two, until there are no more errors.)


But, and this is what I was trying to explain earlier but skipped a step 
I figured was more obvious than it apparently was, btrfs works with 
trees, including a metadata tree.  So each block of metadata that has 
checksums covering actual data, is in turn itself checksummed by a 
metadata block one step closer to the metadata root block, multiple 
levels deep.

I should mention here that this is my non-coder understanding.  If a dev 
says it works differently...

It's these multiple metadata levels and the chained checksums for them, 
that I was referencing.  Suppose it's a metadata block that fails, not a 
data block.  That metadata block will be checksummed, and will in turn 
contain checksums for other blocks, which might be either data blocks, or 
other metadata blocks, a level closer to the data (and further from the 
root) than the failed block.

Because the metadata block was failed (either checksum failure or read 
error, shouldn't matter at this point), whatever checksums it contained, 
whether for data, or for other metadata blocks, will be unverified.  If 
the affected metadata block is close to the root of the tree, the effect 
could in theory domino thru to several further levels.

These checksum unverified blocks (because the block containing the 
checksums failed) will show up as unverified errors, and whatever that 
checksum was supposed to cover, whether other metadata blocks or data 
blocks, won't be checked in that scrub round, because the level above it 
can't be verified.

Given a checksum-verified raid1 copy on the mirror device, the original 
failed block will be rewritten.  But if it's metadata, whatever checksums 
it in turn contained will still not be verified in that scrub round.  
Again, these show up as unverified errors.

By running scrub repeatedly, however, now that the first error has been 
fixed by the rewrite from the good copy, the checksums it contained can 
now in turn be checked.  If they all verify, great.  If not, another 
rewrite will be triggered, fixing them, but if if those checksums were in 
turn for other metadata blocks, now /those/ will need checked and will 
show up as unverified.

So depending on what the bad metadata block was located on in the 
metadata tree, a second, third, possibly even fourth, scrub may be 
needed, in ordered to correct all the errors at all levels of the 
metadata tree, thereby fixing in turn each level of unverified errors 
exposed as the level above it (closer to root) was fixed.


Of course, if your scrub listed all corrected (metadata since it's raid1 
in your case) or uncorrectable (data since it's single in your case, or 
metadata with both copies bad) errors, no unverified errors, then at 
least in theory, a second scrub shouldn't find any further errors to 
correct.  Only if you see unverified errors should it be necessary to 
repeat the scrub, but then you might need to repeat it several times as 
each run will expose another level to checksum verification that was 
previously unverified.

Of course, an extra scrub run shouldn't hurt anything in any case.  It'll 
just have nothing it can fix, and will only cost time.  (Tho on multi-TB 
spinning rust that time could be significant!)


Hopefully it makes more sense now, given that I've included the critical 
information about multi-level metadata trees that I had skipped as 
obvious, the first time.  Again, this is my understanding as a btrfs 
using admin and list regular, not a coder.  If a dev says the code 
doesn't work that way, he's most likely correct.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

