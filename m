Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42405 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab3KEIbX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 03:31:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vdc2f-0001Vy-3W
	for linux-btrfs@vger.kernel.org; Tue, 05 Nov 2013 09:31:17 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 09:31:17 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 09:31:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: OOPS on 3.11.6
Date: Tue, 5 Nov 2013 08:30:56 +0000 (UTC)
Message-ID: <pan$50204$5f68936b$4c0c043d$30f95d76@cox.net>
References: <CALCETrX9M2SFAFHB9AaAm+X-a=XfqJ9ivjy7neoQgHF9UH_dBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andy Lutomirski posted on Mon, 04 Nov 2013 15:11:44 -0800 as excerpted:

> (This is Fedora's kernel 3.11.6-200.fc19.x86_64)
> 
> I have a file on my btrfs filesystem.  Reading it results in:
> 
> [  170.261789] general protection fault: 0000 [#1] SMP

I had a similar case recently (running 3.12-rc5+ at the time, I believe).

Unfortunately sometimes my storage takes longer to stabilize after resume 
from suspend-to-ram than the kernel is willing to wait (and again 
unfortunately I know of no knob for that, I already have "wait forever" 
set for boot, but the kernel apparently doesn't use the same knob for 
resume), and occasionally one of the devices drops out of my btrfs raid1 
configuration, with the resulting kernel and btrfs mayhem.

Root is never remounted read-write by default, only for system updates, 
so it remains consistent.  But my (separate btrfs) log and home 
partitions cannot be remounted read-only for the suspend due to files 
being in-use, so they remain read-write mounted thru the suspend, and 
when the device drops they go inconsistent.

Fortunately, most of the time a scrub after reboot seems to fix things up 
just fine, but the last time it happened, two files, my user's 
~/.bash_history and ~/.xsession_errors files, were apparently corrupted 
beyond what scrub could fix.  Despite scrub saying it fixed everything 
(and a rescrub resulting in no errors) any attempt to read those files 
resulted in a a hung task, which one of them being ./bash_history 
naturally meant I couldn't login at the console, and after fixing that, I 
still couldn't startx due to the ~/.xsession_errors problem.

I tried various ways (cat, etc) to read the files to see what the problem 
was, but that had the same result, so ultimately I simply blew them away 
with an rm, and let bash and X recreate them.

I've toyed with the idea of bind-mounting a couple of tmpfs files over 
the two (as I already do with $TMPDIR and $KDETMP except they're not 
bindmounts, just pointed at the appropriate tmpfs), since they're 
basically cached history/errors in any case and losing them isn't a big 
deal, but what if a more critical file happened to be being written when 
I suspended?  I suppose I could work thru my routinely open-write files 
one at a time, bindmounting tmpfs, until I could pre-suspend read-only 
mount /home in the routine case, and refuse to suspend if I couldn't read-
only mount, but that is beyond the ability of most users and /shouldn't/ 
be necessary.

What really bothers me that scrub supposedly fixed all the errors, yet 
these files were still corrupt to the point that even a cat of the 
affected file would hang the system -- so obviously the filesystem wasn't 
in a consistent state despite scrub's claims.  What would it take for 
btrfs in raid1 mode to atomically update one copy at a time, so a scrub 
would consistently recreate either the pre-write or the post-write copy, 
and the file would never be corrupted by a crash at the wrong moment 
beyond what scrub could recover to either one or the other, 
consistently?  Isn't atomic COW supposed to already do just that?

But with a read-only mounted root, at least I should always have full 
recovery tools available to me. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

