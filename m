Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53885 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbbL2EQM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 23:16:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDlhj-0008V8-0p
	for linux-btrfs@vger.kernel.org; Tue, 29 Dec 2015 05:16:11 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 05:16:11 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 05:16:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs Check - "type mismatch with chunk"
Date: Tue, 29 Dec 2015 04:16:05 +0000 (UTC)
Message-ID: <pan$6b3e3$d77dda59$7485533f$b87cbcf4@cox.net>
References: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com>
	<pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
	<1451188888.6446.18.camel@scientia.net>
	<CACRRrm-MteDcXSg10npqHLA6ZzGHfDM-ByxyvR19npaNuS3t-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zach Fuller posted on Mon, 28 Dec 2015 18:08:12 -0600 as excerpted:

> I have grabbed the "btrfs-progs-git" package from the AUR, which should
> contain the devel branch.
> $ sudo btrfs --version btrfs-progs v4.3.1-31-g0ab3d31
> 
> I ran "btrfs check --repair" again on the drive, and no "type mismatch
> with chunk" errors were returned.

So Chris A Mitterer's belief that the fix was in integration but not 
released yet seems to be correct.

[snip some output with free-space-cache errors]

> I'm not sure what the output of the above check means, but there are
> certainly less errors than before. Should I be worried about these "free
> space cache" errors?

No.  Free-space-cache errors get detected and fixed in normal use, so the 
check output for them is primarily informational.

> It seems that the newer version of "btrfs-progs" from the devel branch
> fixed the problem. The drive still mounts and functions correctly.
> Should I continue to run the devel branch, or should I switch back to
> the main branch? I would prefer to have a stable system rather than
> being on the bleeding edge.

That's an interesting question, the answer to which ultimately depends on 
your own definitions of stable as opposed to bleeding edge.  However, 
given that you're running Arch, not some mostly half-decade-old 
enterprise distro with fixes backported, I imagine your definition of 
"stable" can't be /too/ conservative.

The fact is that as widely accepted on the list, btrfs itself, while no 
longer "experimental" "eat your babies" unstable, remains "still 
stabilizING, not yet fully stable and mature."  As such, people really 
interested in "stable", as in those people mentioned above that are 
running half decade old enterprise distros with fixes backported, really 
shouldn't be running it at all.  Tho some such distros are choosing to 
support btrfs, which is their business, but then the people running those 
distros and using their btrfs should really be getting support from them, 
not from the list, since on the list we don't generally consider btrfs 
suitably stable for that, and only the distros know what they're 
backporting to their nominally really old kernel and userspace version 
numbers anyway, so the list really /can't/ properly support them.

But like I said, you're running arch, which itself indicates that you're 
not enterprise-level stal^hble conservative.  And you're running btrfs, 
which assuming you did your research before just jumping into, indicates, 
as does the fact that you actually did try the live-git integration 
version when necessary, that you /are/ willing to go live-git when 
necessary (or alternatively wait for a fix to hit mainline, as some users 
do when the btrfs they need fixed isn't critical to daily operations), 
even if you prefer not to do it longer term.

And being an informed btrfs user who knows its current status, you 
presumably also either have tested backups or are willing to declare what 
was on that btrfs lost if worse comes to worse.

With that in mind, I'd suggest that like me here on gentoo, you could run 
current btrfs release userspace and release or rc kernels, and simply be 
prepared to build a live-git version or possibly revert to an older 
version, if you run into a bug where it's necessary.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

