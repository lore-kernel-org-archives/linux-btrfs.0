Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37427 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaATQNq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 11:13:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W5HTp-0002UT-QX
	for linux-btrfs@vger.kernel.org; Mon, 20 Jan 2014 17:13:41 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 17:13:41 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 17:13:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs and ECC RAM
Date: Mon, 20 Jan 2014 16:13:18 +0000 (UTC)
Message-ID: <pan$36f1b$8300c6a3$5960d52c$7e050399@cox.net>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
	<CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com>
	<52DC9453.4000705@gmail.com>
	<96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ian Hinder posted on Mon, 20 Jan 2014 15:57:42 +0100 as excerpted:

> In hxxp://forums.freenas.org/threads/ecc-vs-non-ecc-ram-and-zfs.15449,
> they talk about reconstructing corrupted data from parity information:
> 
>> Ok, no problem. ZFS will check against its parity. Oops, the parity
>> failed since we have a new corrupted bit. Remember, the checksum data
>> was calculated after the corruption from the first memory error
>> occurred. So now the parity data is used to "repair" the bad data. So
>> the data is "fixed" in RAM.
> 
> i.e. that there is parity information stored with every piece of data,
> and ZFS will "correct" errors automatically from the parity information.
> I start to suspect that there is confusion here between checksumming
> for data integrity and parity information.  If this is really how ZFS
> works, then if memory corruption interferes with this process, then I
> can see how a scrub could be devastating.  I don't know if ZFS really
> works like this.  It sounds very odd to do this without an additional
> checksum check.

Good point on the difference between parity and checksumming.

I've absolutely no confirmation of this, but privately I've begun to 
wonder if this difference has anything at all to do with the delay in 
getting "complete" raid5/6 support in btrfs, including scrub; if once 
they actually started working with it, they realized that the traditional 
parity solution of raid5/6 didn't end up working out so well with 
checksumming, such that in an ungraceful shutdown/crash situation, if the 
crash happened at just the wrong point, if the parity and checksumming 
would actually fight each other, such that restoring one (presumably 
parity, since it'd be the lower level, closer to the metal) triggered a 
failure of the other (presumably the checksumming, existing above the 
parity).

That could trigger all sorts of issues that I suppose to be solvable in 
theory, but said theory is well beyond me, and could well invite complex 
coding issues that are incredibly difficult to resolve in a satisfactory 
way, thus the hiccup in getting /complete/ btrfs raid5/6 support, even 
when the basic parity calculation and write-out as been in-kernel for 
several kernel cycles already, and was available as patches from well 
before that.

If that's correct (and again, I've absolutely nothing but the delay and 
personal intuition to back it up, and the delay in itself means little, 
as it seems most btrfs features have taken longer to complete than 
originally planned, such that btrfs as a whole is now years behind the 
originally it turned out wildly optimistic plan, meaning it's simply 
personal intuition, and as I'm not a dev that should mean approximately 
nothing to anyone else, so take it for what it's worth...), then 
ultimately we may end up with btrfs raid5/6 modes that end up being 
declared usable, but that come with lower integrity and checksumming 
guarantees (particularly across device failure and replace) than those 
that normally apply to btrfs in other configurations.  At least for the 
btrfs initially considered stable.  Perhaps down the road a few years a 
more advanced btrfs raid5/6 implementation, with better integrity/
checksumming guarantees, would become available.

Perhaps zfs has a similar parity mode, as opposed to real checksumming, 
but has real checksumming in other modes?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

