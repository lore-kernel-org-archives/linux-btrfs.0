Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53728 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758617AbbJ3JdN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 05:33:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zs63a-0005TK-Ie
	for linux-btrfs@vger.kernel.org; Fri, 30 Oct 2015 10:33:10 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 10:33:10 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 10:33:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: random i/o error without error in dmesg
Date: Fri, 30 Oct 2015 09:32:59 +0000 (UTC)
Message-ID: <pan$a8f03$738e56c1$efb50882$54e11ccd@cox.net>
References: <562E0D31.2080003@dblaci.hu> <1844690.p2LsPbdn9l@thetick>
	<pan$31224$86839f8e$da37e2a5$124e475b@cox.net>
	<2085133.yRiO7H1dHn@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Thu, 29 Oct 2015 22:10:24 +0100 as excerpted:

>>Meanwhile, as explained in the systemd docs (specifically the systemd
>>for administrators series, IIRC), systemd dropping back to the initr* is
>>actually its way of automatically doing effectively the same thing we
>>were using lib_users and all those restarts to do, getting rid of all
>>possible still running on root executables, including systemd itself, by
>>reexecing systemd itself back in the initr*, as a way to help eliminate
>>*everything* running on root, so it can not only be remounted read-only,
>>but actually unmounted the same as any other filesystem, as userspace is
>>now actually running from the initr* once again.  That's a far *FAR*
>>safer reboot after upgrade than traditional sysvinit solutions were able
>>to do. =:^)
> 
> Yeah, the ability to do that is a nice plus of using an initramfs.
> Although I've never been clear on why it's *safer*.  Is it because the
> remount might fail?  Or are there other reasons, too?

While I don't claim anything but informed admin level authority on the 
problem...

It's first worth noting that the problem a return to initramfs helps 
solve is in practice reasonably rare and obscure, since if it weren't, 
people would have been experiencing it in serious numbers on sysvinit-
based systems all along, and something would have been done to solve it 
long before systemd came along.  So it's a relatively narrow issue that 
in practice can only affect a few users, a relatively small portion of 
the time.

>From my read of the systemd docs, it's more pointing out a theoretical 
issue than a practical one, pointing out that systemd is in fact a more 
theoretically correct solution to the (implicitly mostly theoretical) 
problem.

In that context, I believe the (mostly theoretical) point is as much that 
we were treating / (and perhaps another mount or two) special, remounting 
it read-only instead of unmounting it because in practice there wasn't 
any other choice, and that now that systemd offers the choice, it can in 
fact be treated just like any other filesystem, fully unmounting it 
before shutdown.

Since exceptions to rules are nice places for bugs to hide, in theory at 
least (the remount-ro root being such a universal exception that in 
practice it's a rule of its own, and bugs couldn't long hide in that 
exception /because/ of its universalness), being able to treat / like any 
other filesystem and unmount it is a "purer and more correct" solution.

IOW, it's a nice counter to the "systemd isn't unixy enough" point, as 
here, it's more "unixy" than sysvinit ever was.

That said, I expect that over the years there have been plenty of 
otherwise nice implementations of various useful things that ran into a 
shutdown/reboot-time problem due to root's remount-ro exception, that 
either limited them to non-root-filesystem deployment or sent them back 
for a workaround, if not causing them to rejected outright as unworkable, 
that in this new return-to-initr*-and-unmount-root environment will see 
faster deployment without the workarounds that heretofore were required.  
Of course that'll end up being a limitation on deployment on non-initr* 
direct-to-root boot sequences, but in this primarily prebuild binary 
distro with prebuild by-necessity-modular-kernel-and-initr* environment, 
that's unlikely to slow down wide deployment by much, and anyone wanting 
to do direct-to-root boots and/or non-systemd-based deployments will just 
have to find their own workarounds, which may ultimately be incorporated 
into upstream, or not, depending on upstream's whims.

Which, bringing it all back to the btrfs list title topic, is already 
where multi-device btrfs as / filesystem is in terms of initr*, since 
that's basically broken without an initr* to assemble it.  And of course 
the same thing goes for / on LVM, since it too requires userspace to 
activate, which means initr* if / is on it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

