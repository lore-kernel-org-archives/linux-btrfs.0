Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43098 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbaKSGWW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 01:22:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xqyei-0000aH-BA
	for linux-btrfs@vger.kernel.org; Wed, 19 Nov 2014 07:22:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 07:22:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 07:22:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [btrfs-progs] cmds-restore.c:182:20: warning: array subscript
 is above array bounds [-Warray-bounds]
Date: Wed, 19 Nov 2014 06:22:08 +0000 (UTC)
Message-ID: <pan$7c0d5$a0ea0afe$8ce3c1bf$723e34af@cox.net>
References: <pan$7e207$ad1fefbf$2a4c2d19$75d64f5f@cox.net>
	<20141118172323.GB7166@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Tue, 18 Nov 2014 18:23:23 +0100 as excerpted:

> On Sun, Nov 09, 2014 at 03:54:56AM +0000, Duncan wrote:
>> A bit more context:
>> 
>> cmds-restore.c: In function 'next_leaf':
>> cmds-restore.c:182:20: warning: array subscript is above array bounds
>> [-Warray-bounds]
>>   slot = path->slots[level] + 1;
>>                     ^
> 
> Thanks. We've seen that before and were not able to find why the
> compiler thinks it could overflow, see the dicussion here:
> 
> http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34338.html
> 
> I'll probably merge Christian's patch so the warning goes away.

Thanks.  I don't claim to be a coder but I surely can't see where/how the 
code as written could go out of array bounds either.

The bit the worries me is that -Warray-bounds says it warns where 
subscripts are *ALWAYS* out of bounds.  Couple that with the 
"unintuitive" optimizations that I've seen gcc reported as doing from 
time to time, and admittedly not understanding all the implications 
involved, and "optimized to always out of bounds" seems uncomfortably 
within the realm of possibility, given the warning.

The next step if I were to go from there would be to CC or file a bug 
with the gentoo QA team, who after all consider this gcc warning serious 
enough to point it out in (colored!) QA warnings before a package is 
installed.  As such, perhaps they know enough about gcc optimizations 
specific to this warning to explain what gcc's actually warning about 
here, since "upstream" can't see a problem and neither can I.  I just 
gotta decide whether it's worth bothering them with or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

