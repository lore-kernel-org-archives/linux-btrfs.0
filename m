Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43279 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbaDKAfz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 20:35:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WYPRh-0003R2-QS
	for linux-btrfs@vger.kernel.org; Fri, 11 Apr 2014 02:35:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 02:35:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 02:35:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Fri, 11 Apr 2014 00:35:38 +0000 (UTC)
Message-ID: <pan$4fcd0$87fc5afe$80e50794$911d5718@cox.net>
References: <4783411.VVGoQz5kVU@fuchsia> <3414746.Gera7uWrI1@fuchsia>
	<CAPpBBdNo0ar8+2Kt9O_mNyQsmmOvFNfVJ=a_EA1HW=TnS4uTXQ@mail.gmail.com>
	<1924982.LHpDrRg8EQ@fuchsia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Schuerig posted on Thu, 10 Apr 2014 18:24:00 +0200 as excerpted:

> I *think* send/receive with clone sources might be the key to a
> solution. I'm still hoping that someone with a far better understanding
> of btrfs than me gives it a try first...

Well, there's both that (which I don't know enough about to discuss in 
any intelligent way at all), and the fact that at least until very (very) 
recently (like recent enough I'm not sure it'll all be in 2.15 yet), 
btrfs send/receive still had some serious corner-case bugs, such that to 
my knowledge if it worked without error it was reliable, there were 
numbers of cases (like where it was originally subdir /a/b/, and then 
switched to /b/a, reversing the nesting) where it would spit out errors, 
leaving the receive in a half-received state.

So it worked for some people but not others, and for some it would work 
for awhile, then would start erroring out, whenever they hit whatever 
corner-case.

Regulars on this list will have seen all the recent work going into send/
receive bug tracing and fixing, however, which will of course ultimately 
make it far more reliable than it had been.  Surely it's already far more 
reliable, as a fair number of those corner cases have now been found and 
dealt with.

But what I do NOT know yet, is where in the process we are, in terms of 
/reliable/ send/receive.  Relatively, we're certainly closer than we 
were, but did that move use from say 80% to 90% reliable, or from 80% to 
97 or 98% reliable (which is about where I'd put general btrfs at this 
point), or from 90% to 98-ish% reliable, or... ?  

Without that knowledge, even if you did know the specific CL options you 
needed, I'd still consider it very much a "great if it works, but don't 
count on it until you actually see it complete without errors, and even 
then, be aware that the next time you try it could error out, because 
it's still very much in bug-fixing-phase" solution.

Meanwhile, the ddrescue solution is mature technology, proven to work 
with many different types of filesystems over many years, now, so that's 
the basket I'd be putting my resource eggs into at this point. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

