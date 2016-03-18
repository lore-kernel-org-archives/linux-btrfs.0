Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44983 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbcCRXsB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 19:48:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ah47a-0007Hv-6H
	for linux-btrfs@vger.kernel.org; Sat, 19 Mar 2016 00:47:58 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 00:47:58 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 00:47:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs error
Date: Fri, 18 Mar 2016 23:47:52 +0000 (UTC)
Message-ID: <pan$55f1$cb4951f4$138c0630$19661418@cox.net>
References: <CABxShh-vwxqU5wq+Ouhn8H6ye=7wV4VgNx+fL2JM30H7=i0rWg@mail.gmail.com>
	<CABxShh8W8A4PjdT9uUQvmxo_N0VLMc+D-eYyJ3a0N64UoQzXjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Paul Harrison posted on Fri, 18 Mar 2016 10:25:44 +0000 as excerpted:

> Anyone? Would really appreciate a pointer or two!

I was hoping someone, presumably a dev with understanding of the code, 
would reply here, as I'm just an admin-level list regular who uses btrfs 
on my own machines and helps with the relatively simpler (non-dev) 
questions here when I can, and this one's really beyond me.

However, given no other replies, maybe extremely limited help is better 
than none.  At least you'll know the post got thru, that way, and maybe 
the limited help will be enough.

You mention SuSE Linux Enterprise 11 SP4 64-bit, but this isn't a SUSE 
list, it's a distro agnostic btrfs Linux filesystem related list, and 
that SuSE (the form I still use tho I know it's dated) information means 
little to for instance, Gentoo users such as myself.

More helpful here is information about your kernel and btrfs userspace 
versions.

In particular, because the list considers btrfs still stabilizing, not 
yet fully stable and mature, the recommendation here is to run much more 
current code than enterprise distros in particular tend to run.

For the kernel, two tracks are recognized as supported, upstream (Linus/
mainline) current releases, and mainline LTS track.  For current track, 
the last two kernels are typically considered supported, so with 4.5 just 
out, 4.4 and 4.5, with 4.3 users expected to be upgrading by now.

For kernel LTS series track, 4.4 is the most recent LTS, with 4.1 before 
that, and 3.18 previous to that.  Until 4.4, the recommendation was again 
to keep to the latest two LTS kernel series, but as btrfs has matured and 
because 3.18 actually turned out to be reasonably stable btrfs-wise, 
we're still supporting it to some degree now as well, tho upgrade to at 
least 4.1 is still recommended.

For userspace, in normal runtime conditions, most userspace commands 
simply call the appropriate kernel code to do the real work, so userspace 
version doesn't tend to be as critical, as long as it doesn't get so old 
that it's difficult to map its commands and output to more current 
versions.  However, once things go wrong, the userspace version becomes 
far more critical as it's userspace code that helps you repair or restore 
files from the broken filesystem, and only newer versions have the latest 
bug fixes, etc, and thus are best equipped to help you repair or recover 
files from the damaged filesystem.  Userspace releases version releases 
are synced to the kernel cycle and developed in the same current bug 
context as the kernel series of the same major.minor number.

As a result, a reasonable rule of thumb is to run at least a userspace of 
a version similar to that of your kernel, tho newer is fine as well.  As 
long as you're following kernel version recommendations, that will ensure 
that your userspace doesn't get /too/ old.

Of course we do recognize that various distros, including enterprise 
distros that prefer ancient code, offer support for btrfs.  However, we 
don't track what patches they may or may not have backported to their 
nominally ancient kernel numbers on this list, as the list is in general 
focused on the mainline kernel.  As a result, we're not in a very good 
position to support those older versions, tho we do the best we can.  
What that means in practice is that if you choose to use that sort of 
distro support, you really should be getting your support from them, as 
they know what they've backported and what they've not and are better 
equipped to provide that support.  As I said, we still do the best we 
can, but often, that's asking you to upgrade to a more current kernel and/
or userspace and try again, reporting the results there if you still have 
problems.

So you didn't report the version numbers we'd need for this list, but 
given the enterprise distro you did report running, there's a good chance 
that your kernel and/or userspace is older than what the list can provide 
best support for, so your first step would be to either upgrade to a 
supported version as described above and try there, reporting appropriate 
version numbers if the problem still exists, or ask your distro for the 
support it offers on btrfs on older code, if indeed it does offer that 
support.

As I said, only extremely limited and general help, not specific to your 
problem at all, but it's the best I can do, in the absence of replies 
from others.  Hope it's at least of some help.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

