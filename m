Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45406 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaLPVke (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 16:40:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y0zr5-00081B-Qr
	for linux-btrfs@vger.kernel.org; Tue, 16 Dec 2014 22:40:31 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 22:40:31 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 22:40:31 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 6/7] Print the summary
Date: Tue, 16 Dec 2014 21:40:20 +0000 (UTC)
Message-ID: <pan$19bf5$401c56ea$62691b03$1c476b4d@cox.net>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
	<1418673780-22000-7-git-send-email-kreijack@inwind.it>
	<pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
	<548FAB3A.7060009@pobox.com> <20141216090540.GK1442@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 16 Dec 2014 09:05:40 +0000 as excerpted:

> On Mon, Dec 15, 2014 at 07:47:06PM -0800, Robert White wrote:
>> On 12/15/2014 05:58 PM, Duncan wrote:
>> >* Please s/disk/device/, here and possibly elsewhere.  I know I'm not
>> >the only one who is trying to make the switch in my own usage, as it
>> >looks a bit foolish (and/or marks the user as an old fogey who's
>> >likely to start lecturing about how a GiB isn't "small", as I'm known
>> >to do at times! =:^) already, as it's only going to be more so over
>> >time.
>> 
>> I am actually not fond of "disk" nor "device" as both carry potentially
>> false information.
>> 
>> I prefer "slice", not that I am totally happy with that word either.
>> But by the time you get through loopback devices, memory map devices,
>> the "device files" that represent parts of "partitioned" devices,
>> logical "volumes", and god only knows what future "thingies" we will
>> end up dealing with... I like the terms that remove false hints.
> 
> All this agreed, but "slice" will be largely viewed as a neologism
> by anyone who hasn't used (IIRC) BSD or Solaris. On the other hand, for
> all their other flaws, "device" is much better than "disk" here, as you
> could he talking about a partition, a flash memory card (which many
> people don't view as "disks"), or a network block device. You could
> refer to a "block device" to clarify, because that's really what we're
> talking about here, but it could get a bit cumbersome.

Agreed.  I've only seen "slice" in the bsd context and don't even know 
how the word is used, only that it's something from BSD land that I've 
seen in the context of partitions.

Device seems much more natural at least on Linux, and if btrfs is 
eventually used elsewhere where concepts and/or terminology is different, 
that'll be something they'll deal with in the btrfs context much as I'd 
expect to have to deal with a number of context-specific terms and 
meanings were I to run zfs on Linux[1].

>> In linux we (currently, and for the foreseeable future) use the device
>> files and so conflate "device" with all the above.
>> 
>> But if the code base and format were to spread to another platform...
>> 
>> And besides, using device carries its own lingual hazzards.

That "device" is such a flexible term at least on Linux, where devices 
can be and often are nested and/or virtual as well as physical, is 
actually its big advantage here, IMO.  And FWIW, the only difference I 
saw between slice and device in your example is exactly as discussed, 
they seemed to be used in almost exactly the same way, only "device" is a 
term native to linux, while slice sounds like we're trying to borrow bsd 
terminology and make them fit on linux, for no good reason given that 
"device" is a linux-native term that appears to work just as well in the 
context in which it is used.

---
[1] Zfs on linux: Not an option here for licensing reasons and because it 
appears Oracle has absolutely no interest in clearing up the problem, but 
that's certainly the most comparable thing to btrfs at this point, with 
the biggest technical difference being its relative maturity, tho from 
what I have read there's a big practical difference in hardware 
requirements (much higher memory requirements and ECC RAM very strongly 
recommended) as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

