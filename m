Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47296 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754824AbeBOHyG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 02:54:06 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1emEKC-0001Gg-Ej
        for linux-btrfs@vger.kernel.org; Thu, 15 Feb 2018 08:51:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
Date: Thu, 15 Feb 2018 07:50:49 +0000 (UTC)
Message-ID: <pan$af153$d8c6ba64$e3a02424$f79c8bd5@cox.net>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
        <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
        <f77a1a28c2cbf08efd24577088a29de0@virtall.com>
        <58ea1e02-6f38-97f7-34aa-e993a1aa261b@gmx.com>
        <57960c49a431cdfdb4c659d0a9b40856@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Thu, 15 Feb 2018 16:02:59 +0900 as excerpted:

>> Not sure if the removal of 80G has anything to do with this, but this
>> seems that your metadata (along with data) is quite scattered.
>> 
>> It's really recommended to keep some unallocated device space, and one
>> of the method to do that is to use balance to free such scattered space
>> from data/metadata usage.
>> 
>> And that's why balance routine is recommened for btrfs.
> 
> The balance might work on that server - it's less than 0.5 TB SSD disks.
> 
> However, on multi-terabyte servers with terabytes of data on HDD disks,
> running balance is not realistic. We have some servers where balance was
> taking 2 months or so, and was not even 50% done. And the IO load the
> balance was adding was slowing the things down a lot.

Try a filtered balance.  Something along the lines of:

btrfs balance start -dusage=10 <filesystem-path>

The -dusage number, a limit on the chunk usage percentage, can start 
small, even 0, and be increased as necessary, until btrfs fi usage 
reports data size (currently 411 GiB) closer to data usage (currently 
246.14 GiB), with the freed space returning to unallocated.

I'd shoot for reducing data size to under 300 GiB, thus returning over 
100 GiB to unallocated, while hopefully not requiring too high a -dusage 
percentage and thus too long a balance time.  You could get it down under 
250 gig size, but that would likely take a lot of rewriting for little 
additional gain, since with it under 300 gig size you should already have 
over 100 gig unallocated.

Balance time should be quite short for low percentages, with a big 
payback if there's quite a few chunks with little usage, because at 10%, 
the filesystem can get rid of 10 chunks while only rewriting the 
equivalent of a single full chunk.

Obviously as the chunk usage percentage goes up, the payback goes down, 
so at 50%, it can only clear two chunks while writing one, and at 66%, it 
has to write two chunks worth to clear three.  Above that (tho I tend to 
round up to 70% here) is seldom worth it until the filesystem gets quite 
full and you're really fighting to keep a few gigs of unallocated space.  
(As Qu indicated, you always want at least a gig of unallocated space, on 
at least two devices if you're doing raid1.)

If you really wanted you could do the same with -musage for metadata, 
except that's not so bad, only 9 gig size, 3 gig used.  But you could 
free 5 gigs or so, if desired.


That's assuming there's no problem.  I see a followup indicating you're 
seeing problems in dmesg with a balance, however, and will let others 
deal with that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

