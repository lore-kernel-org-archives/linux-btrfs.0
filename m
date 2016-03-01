Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43190 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbcCAVoa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 16:44:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aas5k-0001gK-JL
	for linux-btrfs@vger.kernel.org; Tue, 01 Mar 2016 22:44:28 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 22:44:28 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 22:44:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid5
Date: Tue, 1 Mar 2016 21:44:21 +0000 (UTC)
Message-ID: <pan$d7909$c07dac53$17a8f04a$fdf6e07b@cox.net>
References: <CAAcrkYL_=8Ru+_Aum_ZR14AD-D44Dki7Qr9pyAzezWMMZJ8A2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Smith posted on Tue, 01 Mar 2016 15:24:04 +0100 as excerpted:

> what is the status of  btrfs raid5 in kernel 4.4? Thank you

That is a very good question. =:^)

The answer, to the best I can give it, is, btrfs raid56 mode has no known 
outstanding bugs specific to it at this time (unless a dev knows of any, 
but I've not seen any confirmed on-list), and hasn't had any, at least 
nothing major, since early in the 4.1 cycle, so 4.2 thru 4.4 should be 
clean of /known/ raid56 bugs.

However, there was (at least) /one/ report of a problem on raid56, that 
to my knowledge hasn't been traced, so it's unknown if it would have 
happened on say raid1 or raid10, as opposed to the raid5/6 it did happen 
on, or not.  Of course with raid56 mode still being relatively new, 
that's one suspect, but we simply don't know at this point, and I've seen 
nothing further on that thread in say 10 days or so, so I'm not sure we 
ever will.

So the best recommendation I can give is that raid56 mode is definitely 
coming along, but depending on how cautious you are, may or may not yet 
be considered quite as stable as the rest of btrfs in general.

If your use-case calls for raid5 or raid6 and provided you have backups 
in place if you value the data (a caveat which still applies to btrfs in 
general even more than it does to fully stable and mature filesystems, as 
in general it's "stabilizing, but not yet fully stable and mature", and 
here, even incrementally more to raid56 mode), raid56 mode is what I'd 
call the barely acceptable tolerably stable range, but I'd still be much 
more comfortable with, and recommend, waiting another couple of kernel 
cycles just to be sure if you don't have an /immediate/ need, or 
alternatively, using say raid10 mode.

Again, that's assuming backups and that you're prepared to use them if 
necessary, if you care about the data, but again, that still applies to 
btrfs in general, and indeed, to a slightly lessor extent to /any/ data 
on /any/ filesystem.  Because as the sysadmin's rule of backups states 
(in simple form), you either have at least one level of backup, or by 
your (in)actions, you are literally defining that data as worth less than 
the time and resources necessary to do that backup.  Which means if you 
lose the data and don't have it backed up elsewhere to restore it from, 
you can still be happy, as obviously you considered the time and 
resources necessary to do that backup as of more worth than the data, so 
even if you lose the data, you saved what was obviously more important to 
you, the time and resources you otherwise would have put into ensuring 
that you had a backup, if the data was worth it.

So take heed and don't decide only AFTER you've lost it, that the data 
was actually worth more than the time and resources you DIDN'T spend on 
backing it up.  And while that definitely applies a bit more to btrfs in 
its current "stabilizing but not yet fully stable and mature" state than 
it does to fully stable and mature filesystems, it applies well enough to 
all of them, that figuring out the data was worth more than you thought 
is /always/ an experience you'd rather avoid, /regardless/ of the 
filesystem and hardware that data is on. =:^)

And with it either backed up or of only trivial value regardless, you 
don't have anything to lose, and even if raid56 mode /doesn't/ prove so 
stable for you after all, you can still rest easy knowing you aren't 
going to lose anything of value. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

