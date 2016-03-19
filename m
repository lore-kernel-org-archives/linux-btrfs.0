Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47960 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbcCSBPv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 21:15:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ah5Ua-0004u4-8M
	for linux-btrfs@vger.kernel.org; Sat, 19 Mar 2016 02:15:48 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 02:15:48 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 02:15:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Snapshots slowing system
Date: Sat, 19 Mar 2016 01:15:41 +0000 (UTC)
Message-ID: <pan$d2adf$2c2b9e0a$5f06f373$3ae20b04@cox.net>
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
	<pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
	<56E88CB2.6020300@petezilla.co.uk> <56E945E9.1050005@gmail.com>
	<56EB1CC7.2000602@petezilla.co.uk>
	<pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net>
	<56EC4612.4030206@petezilla.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pete posted on Fri, 18 Mar 2016 18:16:50 +0000 as excerpted:

> On 03/18/2016 09:17 AM, Duncan wrote:

>> So btrfs raid1 has data integrity and repair features that aren't
>> available on normal raid1, and thus is highly recommended.
>> 
>> But, raid1 /does/ mean two copies of both data and metadata (assuming
>> of course you make them both raid1, as I did), and if you simply don't
>> have room to do it that way, you don't have room, highly recommended
>> tho it may be.
> 
> This looks like a strong recommendation to get a second SSD for the root
> partition and go raid1.  Are SSDs more flakey that hdd or are you just a
> strong believer in the integrity of raid1?

As Austin says, I'd generally consider ssds /more/ reliable than hdds, at 
least as long as you stay away from the OCZs, etc (but then again, there 
are spinning rust brands and specific models I stay away from, as well), 
but the failure modes are a bit different so it's not always as simple as 
that.

But I played with raid1 before btrfs and find the additional data 
integrity features that btrfs raid1 brings even more compelling, so yes, 
it would indeed be fair to say that I'm a strong booster of btrfs raid1 
in particular. =:^)

The roadmapped but still to come feature I'm /really/ looking forward to, 
however, is N-way-mirroring, because btrfs raid1 is currently very 
specifically two copies, regardless of how many devices there are, and I 
would really /really/ like to have the choice of three copies, again, not 
just for device-failure protection, but because with btrfs checksumming 
and data integrity, if one copy is found to be bad for whatever reason, 
be it a crash before all copies were written, or a failing device, a 
simple bad block on an otherwise fine device, or whatever gamma ray block 
damage or the like, right now that means the other copy BETTER come out 
checksum-verified, or that data or metadata is toast, and I'd rest far 
easier if even if one failed, I knew there was still not just the one 
copy, but a second, to fall back on as well.

With N-way-mirroring, of course that could be 4 or more copies as well, 
but three is closest to my sweet spot balance between cost and extreme 
reliability, and I'd very much like to have that choice as an option.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

