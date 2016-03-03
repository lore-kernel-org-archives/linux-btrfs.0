Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52198 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbcCCERL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Mar 2016 23:17:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abKhJ-0005hN-9D
	for linux-btrfs@vger.kernel.org; Thu, 03 Mar 2016 05:17:09 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 05:17:09 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 05:17:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid5
Date: Thu, 3 Mar 2016 04:16:59 +0000 (UTC)
Message-ID: <pan$428f7$ac0ca994$7fa9e21d$b3ab1072@cox.net>
References: <CAAcrkYL_=8Ru+_Aum_ZR14AD-D44Dki7Qr9pyAzezWMMZJ8A2w@mail.gmail.com>
	<pan$d7909$c07dac53$17a8f04a$fdf6e07b@cox.net>
	<56D6EDF5.2010408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 02 Mar 2016 08:43:17 -0500 as
excerpted:

> On 2016-03-01 16:44, Duncan wrote:
>> John Smith posted on Tue, 01 Mar 2016 15:24:04 +0100 as excerpted:
>>
>>> what is the status of  btrfs raid5 in kernel 4.4? Thank you
>>
>> That is a very good question. =:^)
>>
>> The answer, to the best I can give it, is, btrfs raid56 mode has no
>> known outstanding bugs specific to it at this time (unless a dev knows
>> of any,
>> but I've not seen any confirmed on-list), and hasn't had any, at least
>> nothing major, since early in the 4.1 cycle, so 4.2 thru 4.4 should be
>> clean of /known/ raid56 bugs.
> That really depends on what you consider to be a bug...
> 
> For example, for most production usage, the insanely long
> rebuild/rebalance times that people are seeing with BTRFS raid56 (on the
> order of multiple days per terabyte of data to be rebuilt, compared to a
> couple of hours for a rebuild on the same hardware using MDRAID or LVM)

Very good point.  I wasn't considering that a bug as it's not a direct 
dataloss danger (only the indirect danger of another device dying during 
the extremely long rebuilds), but you're correct, in practice it's a 
potentially blocker level bug.

But from what I've seen, it isn't affecting everyone, which is of course 
part of the problem from a developer POV, since that makes it harder to 
replicate and trace down.  And it's equally a problem from a user POV, as 
until it's fixed, even if your testing demonstrates that it's not 
affecting you ATM, until we actually pin down what's triggering it, 
there's no way of knowing whether or when it /might/ trigger, which means 
even if it's not affecting you in testing, you gotta assume it's going to 
affect you if you end up trying to do data recovery.

So agreed, tho the effect is pretty much the same as my preferred 
recommendation in any case, effectively, hold off another couple kernel 
cycles and ask again.  I simply wasn't thinking of this specific bug at 
the time and thus couldn't specifically mention it as a concrete reason.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

