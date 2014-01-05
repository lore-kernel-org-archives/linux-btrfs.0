Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46128 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaAELBu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 06:01:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzlSk-0007V2-F1
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 12:01:46 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 12:01:46 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 12:01:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sun, 5 Jan 2014 11:01:23 +0000 (UTC)
Message-ID: <pan$99ffc$18730648$ff1a175a$a2dfd435@cox.net>
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com>
	<52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com>
	<52C74415.3020407@jrs-s.net>
	<7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com>
	<pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
	<52C87BAD.4060606@jrs-s.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jim Salter posted on Sat, 04 Jan 2014 16:22:53 -0500 as excerpted:


> On 01/04/2014 01:10 AM, Duncan wrote:
>> The example given in the OP was of a 4-device raid10, already the
>> minimum number to work undegraded, with one device dropped out, to
>> below the minimum required number to mount undegraded, so of /course/
>> it wouldn't mount without that option.
> 
> The issue was not realizing that a degraded fault-tolerant array would
> refuse to mount without being passed an -o degraded option. Yes, it's on
> the wiki - but it's on the wiki under *replacing* a device, not in the
> FAQ, not in the head of the "multiple devices" section, etc; and no
> coherent message is thrown either on the console or in the kernel log
> when you do attempt to mount a degraded array without the correct
> argument.
> 
> IMO that's a bug. =)

I'd agree, usability bug, one of many smoothing out the rough "it works, 
but it's not easy to work with it" bugs.

FWIW I'm seeing progress in that area, now.  The rush of functional bugs 
and fixes for them has finally slowed down to the point where there's 
beginning to be time to focus on the usability and rough edges bugs.  I 
believe I saw a post in October or November from Chris Mason, where he 
said yes, the maturing of btrfs has been predicted before, but it really 
does seem like the functional bugs are slowing down to the point where 
the usability bugs can finally be addressed, and 2014 really does look 
like the year that btrfs will finally start shaping up into a mature 
looking and acting filesystem, including in usability, etc.

And Chris mentioned the GSoS project that worked on one angle of this 
specific issue, too.  Getting that code integrated and having btrfs 
finally be able to recognize a dropped and re-added device and 
automatically trigger a resync... that'd be a pretty sweet improvement to 
get. =:^)  While they're working on that they may well take a look at at 
least giving the admin more information on a degraded-needed mount 
failure, too, tweaking the kernel log messages, etc, and possibly taking 
a second look as to whether full refusing to mount is the best situation 
then, or not.

Actually, I wonder... what about mounting in such a situation, but read-
only and refusing to go writable unless degraded is added too?  That 
would preserve the "first, do no harm, don't make the problem worse" 
ideal, while mounting but read-only unless degraded is added with the rw, 
wouldn't be /quite/ as drastic as refusing to mount entirely, unless 
degraded is added.  I actually think that, plus some better logging 
saying hey, we don't have enough devices to write with the requested raid 
level, so remount rw,degraded, and either add another device or 
reconfigure the raid mode to something suitable for the number of devices.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

