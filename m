Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53760 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbcERWpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 18:45:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b3AD7-0002Qb-N1
	for linux-btrfs@vger.kernel.org; Thu, 19 May 2016 00:45:01 +0200
Received: from 145.132.48.198 ([145.132.48.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 00:45:01 +0200
Received: from ftoth by 145.132.48.198 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 00:45:01 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@exalondelft.nl>
Subject: Re: Hot data tracking / hybrid storage
Date: Wed, 18 May 2016 22:44:55 +0000 (UTC)
Message-ID: <nhir96$8n4$1@ger.gmane.org>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
	<20160516010524.7e208f96@jupiter.sol.kaishome.de>
	<nhedk2$dpq$1@ger.gmane.org>
	<0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
	<20160517203335.5ff99a05@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op Tue, 17 May 2016 20:33:35 +0200, schreef Kai Krakow:

> Am Tue, 17 May 2016 07:32:11 -0400 schrieb "Austin S. Hemmelgarn"
> <ahferroin7@gmail.com>:
> 
>> On 2016-05-17 02:27, Ferry Toth wrote:
>> > Op Mon, 16 May 2016 01:05:24 +0200, schreef Kai Krakow:
>> >  
>> >> Am Sun, 15 May 2016 21:11:11 +0000 (UTC)
>> >> schrieb Duncan <1i5t5.duncan@cox.net>:
>> >>  
>>  [...]
>> > <snip>
>> >>
>> >> You can go there with only one additional HDD as temporary storage.
>> >> Just connect it, format as bcache, then do a "btrfs dev replace".
>> >> Now wipe that "free" HDD (use wipefs), format as bcache,
>> >> then... well, you get the point. At the last step, remove the
>> >> remaining HDD. Now add your SSDs, format as caching device, and
>> >> attach each individual HDD backing bcache to each SSD caching
>> >> bcache.
>> >>
>> >> Devices don't need to be formatted and created at the same time. I'd
>> >> also recommend to add all SSDs only in the last step to not wear
>> >> them early with writes during device replacement.
>> >>
>> >> If you want, you can add one additional step to get the temporary
>> >> hard disk back. But why not simply replace the oldest hard disk with
>> >> the newest. Take a look at smartctl to see which is the best
>> >> candidate.
>> >>
>> >> I went a similar route but without one extra HDD. I had three HDDs
>> >> in mraid1/draid0 and enough spare space. I just removed one HDD,
>> >> prepared it for bcache, then added it back and removed the next.
>> >>  
>> > That's what I mean, a lot of work. And it's still a cache, with
>> > unnecessary copying from the ssd to the hdd.
>> On the other hand, it's actually possible to do this all online with
>> BTRFS because of the reshaping and device replacement tools.
>> 
>> In fact, I've done even more complex reprovisioning online before (for
>> example, my home server system has 2 SSD's and 4 HDD's, running BTRFS
>> on top of LVM, I've at least twice completely recreated the LVM layer
>> online without any data loss and minimal performance degradation).
>> >
>> > And what happens when either a hdd or ssd starts failing?
>> I have absolutely no idea how bcache handles this, but I doubt it's any
>> better than BTRFS.
> 
> Bcache should in theory fall back to write-through as soon as an error
> counter exceeds a threshold. This is adjustable with sysfs
> io_error_halftime and io_error_limit. Tho I never tried what actually
> happens when either the HDD (in bcache writeback-mode) or the SSD fails.
> Actually, btrfs should be able to handle this (tho, according to list
> reports, it doesn't handle errors very well at this point).
> 
> BTW: Unnecessary copying from SSD to HDD doesn't take place in bcache
> default mode: It only copies from HDD to SSD in writeback mode (data is
> written to the cache first, then persisted to HDD in the background).
> You can also use "write through" (data is written to SSD and persisted
> to HDD at the same time, reporting persistence to the application only
> when both copies were written) and "write around" mode (data is written
> to HDD only, and only reads are written to the SSD cache device).
> 
> If you want bcache behave as a huge IO scheduler for writes, use
> writeback mode. If you have write-intensive applications, you may want
> to choose write-around to not wear out the SSDs early. If you want
> writes to be cached for later reads, you can choose write-through mode.
> The latter two modes will ensure written data is always persisted to HDD
> with the same guaranties you had without bcache. The last mode is
> default and should not change behavior of btrfs if the HDD fails, and if
> the SSD fails bcache would simply turn off and fall back to HDD.
> 

Hello Kai,

Yeah, lots of modes. So that means, none works well for all cases?

Our server has lots of old files, on smb (various size), imap (10000's 
small, 1000's large), postgresql server, virtualbox images (large), 50 or 
so snapshots and running synaptics for system upgrades is painfully slow. 

We are expecting slowness to be caused by fsyncs which appear to be much 
worse on a raid10 with snapshots. Presumably the whole thing would be 
fast enough with ssd's but that would be not very cost efficient.

All the overhead of the cache layer could be avoided if btrfs would just 
prefer to write small, hot, files to the ssd in the first place and clean 
up while balancing. A combination of 2 ssd's and 4 hdd's would be very 
nice (the mobo has 6 x sata, which is pretty common)

Moreover increasing the ssd's size in the future would then be just as 
simple as replacing a disk by a larger one.

I think many would sign up for such a low maintenance, efficient setup 
that doesn't require a PhD in IT to think out and configure.

Even at home, I would just throw in a low cost ssd next to the hdd if it 
was as simple as device add. But I wouldn't want to store my photo/video 
collection on just ssd, too expensive.

> Regards,
> Kai
> 
> Replies to list-only preferred.


