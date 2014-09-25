Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45014 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaIYFeT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 01:34:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XX1h3-0005HU-W5
	for linux-btrfs@vger.kernel.org; Thu, 25 Sep 2014 07:34:17 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 07:34:17 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 07:34:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount problem
Date: Thu, 25 Sep 2014 05:34:05 +0000 (UTC)
Message-ID: <pan$c2f73$56f01bfe$eb054a09$f8f997c9@cox.net>
References: <20140923120641.GA27624@galliera.it>
	<pan$b29db$c1fc8f39$f1e6e06c$d6b3042c@cox.net>
	<20140924142835.GA18272@galliera.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simone Ferretti posted on Wed, 24 Sep 2014 16:28:35 +0200 as excerpted:

> Wed, Sep 24, 2014 at 01:23:32PM +0000, Duncan wrote:
>> Simone Ferretti posted on Tue, 23 Sep 2014 14:06:41 +0200 as excerpted:
>> 
>>> we're testing BTRFS on our Debian server.  After a lot of operations
>>> simulating a RAID1 failure, every time I mount my BTRFS RAID1 volume
>>> the kernel logs these messages:
>>> 
>>> [73894.436173] BTRFS: bdev /dev/etherd/e30.20 errs:
>>> wr 33036, rd 0, flush 0, corrupt 2806, gen 0
>>> [73894.436181] BTRFS: bdev /dev/etherd/e60.28 errs:
>>> wr 244165, rd 0, flush 0, corrupt 1, gen 4
>>> 
>>> Everything seems to work nice but I'm courious to know what these
>>> messages mean (in particular what do "gen" and "corrupt" mean?).
>> 
>> Gen=generation.  The generation or transaction-ID (different names for
>> the exact same thing) is a monotonically increasing integer that gets
>> updated every time a tree update reaches all the way to the superblock.
>> In the error context, it means the superblock had one generation number
>> but N other blocks had a different (presumably older) generation
>> number.
>> 
>> Corrupt is simply the number of blocks where the calculated checksum
>> didn't match the recorded checksum, thus indicating an error.
>>
>> See btrfs device stats -z to reset the numbers to zero (after printing
>> them one last time).
> 
> 
> Thank you much for your quick and illuminating answer.
> 
> I'm wondering if you (or anyone else of course) know if there is btrfs
> documentation/papers/anything (besides wiki I did not find anything), in
> which it's possible to learn this kind of informations?

I've learned it from the list and wiki, and from general background 
experience and by reading between the lines at times.

For the monotonically increasing counts and a zero-out option case, the 
manpage and help information for btrfs device stats -z, that indicates -z 
resets counts to zero, implies that they continue to count up otherwise.  
At one point I think a dev did confirm that on-list, but it's easy enough 
to read the implication without such confirmation, particularly when it 
matches observed behavior, as it does.


The gen/trans-id thing is in fact covered in the wiki, but at least on 
the user-wiki side, I believe only in passing as it is mentioned on the 
btrfs restore page, here:

https://btrfs.wiki.kernel.org/index.php/Restore

(That is in turn linked from the problem-faq, filesystem won't mount and 
none of the above helped, is there any hope, entry, as well as from the 
built-in-tools section of the main page.)

Of course people only searching for specific things instead of doing 
general research before diving head-first into a new filesystem, thus 
reading most of at least the user section of the wiki, as I did, might 
miss it.

But while it's there, it took an actual problem and trying to actually 
use restore on my own system before the equivalence of trans-id and 
generation actually sunk in.

The corrupt thing probably came from my previous experience, working with 
mdraid and its scrub, and with ECC RAM and the related BIOS scrub 
features.  In general, any admin who has worked with (and understood) any 
sort of checksumming and error detection and correction should have a 
general idea what's going on there, at least after reading the
btrfs-scrub manpage and running it to correct errors a few times, thus 
seeing how its output matches that of the corresponding stats.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

