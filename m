Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49878 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbcCFGMO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Mar 2016 01:12:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1acRvI-0005pc-98
	for linux-btrfs@vger.kernel.org; Sun, 06 Mar 2016 07:12:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 07:12:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 07:12:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: balance hangs and starts again on reboot
Date: Sun, 6 Mar 2016 06:12:04 +0000 (UTC)
Message-ID: <pan$44b2d$92437ced$cc156215$bd43ad44@cox.net>
References: <20160304173125.GA1902@torres.zugschlus.de>
	<56D9CF63.3060603@googlemail.com>
	<20160305141707.GC1902@torres.zugschlus.de>
	<56DAFD91.2090805@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Sat, 05 Mar 2016 16:38:57 +0100 as excerpted:

> On 03/05/16 15:17, Marc Haber wrote:
>>> Then try to balance in small increments.
>> 
>> -dusage=5 and incrementing? Or what do you mean with "in small
>> increments"?
> 
> Exactly, yes. Sorry for not being more clear.
> 
> FWIW I've been balancing a lot recently (both for stress testing and
> cleaning up a few filesystems) and have never run into this particular
> stall, but only ever do filtered balances. Also I wouldn't be surprised
> at all if this is yet another problem where md does something in a way
> that btrfs doesn' expect, and things go wrong.

What I thought you meant was the drange= or vrange= filters, changing the 
range to eventually cover the entire filesystem.

That should work too, tho I've never actually used it myself and I 
suspect I'd have to play around with the ranges a bit to figure out what 
numbers I should actually be supplying, as the filter descriptions in the 
manpage are somewhat vague on this point.

(Anyone who knows where to actually find those numbers to plug in and/or 
has useful examples, feel free to consider this an invitation to 
elucidate. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

