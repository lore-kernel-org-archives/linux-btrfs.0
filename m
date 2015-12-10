Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43010 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbbLJD4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 22:56:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6sLW-00025z-VT
	for linux-btrfs@vger.kernel.org; Thu, 10 Dec 2015 04:56:47 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 04:56:46 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 04:56:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: subvols and parents - how?
Date: Thu, 10 Dec 2015 03:56:41 +0000 (UTC)
Message-ID: <pan$f0e4$be60fa55$99baefcb$2044c99d@cox.net>
References: <1448340960.14125.51.camel@scientia.net>
	<pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
	<1448400350.21291.88.camel@scientia.net>
	<pan$22dc8$4457dc54$1cd0d037$c9fb9e32@cox.net>
	<1449635797.20578.0.camel@scientia.net>
	<pan$a4433$5d5ccde9$c53fc1f2$f519d361@cox.net>
	<56687B26.7070300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Wed, 09 Dec 2015 14:04:06 -0500 as
excerpted:

> Agreed.  It's not too bad fixing a Gentoo system (as long as
> /var/lib/portage/world is still correct, you can just nuke the installed
> package database and emerge world, it'll take time, but it will get your
> system in a guaranteed consistent state).

For sufficiently loose values of "consistent", yes, as I found out by 
experience.  But it can be done, and I do have the experience to prove it.

What happens in practice is that while yes, as long as @world is correct 
you can install to current and have all those files tracked again as 
appropriate, if your package installation database is missing or out of 
sync with what's actually on your filesystem(s), where the new version of 
various packages will replace older files as they come across them during 
the install process (subject to CONFIG_PROTECT of course, this part isn't 
the problem), the problem is actually where the files of the actually 
installed but untracked version differ from those of the version you're 
installing.

I think the last bug I tracked down to having a stale file from an old 
version still around, was nearly two years after the initial disaster and 
recovery.  It was some shell script (something to do with eselect IIRC) 
that had changed installed bindir location between package versions, and 
the bug was that due to path ordering, the stale version that hadn't been 
replaced by the reinstall and wasn't removed like it normally would have 
been when the old version was uninstalled, because my installed package 
database was out of sync with the backup I had used, was being executed 
as that bindir came earlier in the path, than the bindir for the updated 
version that was in the current package.

So yes it did work and I was back in business, but I was tracing bugs 
down due to stray orphan files that hadn't been cleaned up by the out of 
sync installation database package uninstall, for two years!

I wouldn't exactly call that "consistent", tho it /was/ consistent 
/enough/ to get back in business, if with lingering bugs to track down to 
still stale orphan files for years afterward.

(FWIW, that'd be less of an issue on my own installation now, even if the 
installed package database got similarly out of sync, because on my 
system I'm running a unified root/usr and bin/sbin, now, with symlinks 
/usr -> . and /sbin -> bin, so all normal executables ultimately end up 
in /bin, and all normal libraries in /lib64, with /lib -> lib64, as 
well.  No-multilib so I don't have to worry about that angle.  Portage 
handles the symlinks just fine, tho I've filed I believe three bugs in 
total due to individual ebuild scripts (1, resolved/fixed) or cmake (2, 
one resolved/obsolete as the new version works, one still open, that I'm 
having to work around) doing the wrong thing.)


> On something using dpkg or
> rpm though, it's got the potential to be almost impossible to recover
> from without a significant amount of low-level knowledge of the package
> manager's installation database.





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

