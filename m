Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45596 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbcCRX64 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 19:58:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ah4I9-0005Q0-8v
	for linux-btrfs@vger.kernel.org; Sat, 19 Mar 2016 00:58:53 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 00:58:53 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 00:58:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Snapshots slowing system
Date: Fri, 18 Mar 2016 23:58:47 +0000 (UTC)
Message-ID: <pan$9214$e77e0ea$9e58bc49$a0b72fea@cox.net>
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
	<pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
	<56E88CB2.6020300@petezilla.co.uk> <56E945E9.1050005@gmail.com>
	<56EB1CC7.2000602@petezilla.co.uk>
	<pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net>
	<56EBE8B5.4090705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Fri, 18 Mar 2016 07:38:29 -0400 as
excerpted:

>>> 188 Command_Timeout         0x0032   100   099   000    Old_age  
>>> Always
>>>        -       8590065669
>>
>> Again, a non-zero raw value indicating command timeouts, probably due
>> to those bad seeks.  It'll have to retry those commands, and that'll
>> definitely mean slowdowns.
>>
>> Tho there's no threshold, but 99 worst-value cooked isn't horrible.
>>
>> FWIW, on my spinning rust device this value actually shows a worst of
>> 001, here (100 current cooked value, tho), with a threshold of zero,
>> however.  But as I've experienced no problems with it I'd guess that's
>> an aberration.  I haven't the foggiest why/how/when it got that 001
>> worst.

> Such an occurrence is actually not unusual when you have particularly
> bad sectors on a 'desktop' rated HDD, as they will keep retrying for an
> insanely long time to read the bad sector before giving up.

Which is why it's mystifying to me how it could be reporting a worst-
value 1, when the device seems to be working just fine, and I don't 
recall even one event of waiting "an insanely long time", or even 
anything out of the ordinary, for anything on that device, ever.

Tho I suppose it's within reason that whatever it was froze up the system 
bad enough that I rebooted, and I attributed the one-off to something 
else.  But with no other attributes indicating issues, I remain clueless 
as to what might have happened and why that 1-worst, particularly so 
given the 0 threshold for that attribute and that it's an old-age 
indicator rather than a fail indicator, but the device is neither that 
old, nor as I said, in any other way indicating anything close to what 
that 1-worst value for just that single attribute implies.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

