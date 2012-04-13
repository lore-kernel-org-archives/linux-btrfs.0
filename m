From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Wiki update request: source repo page Was: [PATCH] Btrfs: use
 i_version instead of our own sequence
Date: Fri, 13 Apr 2012 21:55:20 +0000 (UTC)
Message-ID: <pan.2012.04.13.21.55.20@cox.net>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
	<CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
	<20120412133107.GC1924@localhost.localdomain>
	<pan.2012.04.12.21.41.17@cox.net> <20120412215546.GB4856@carfax.org.uk>
	<pan.2012.04.12.22.56.00@cox.net> <20120413131632.GG4856@carfax.org.uk>
	<pan.2012.04.13.18.48.48@cox.net>
	<CAE5mzvhym10Y9-Z8zLKrQYhvBR6FhUHigk-xs_OWNiQJWFG4PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

cwillu posted on Fri, 13 Apr 2012 14:03:38 -0600 as excerpted:

> The fact is that you _don't_ know that your device names aren't going to
> change one day, any more than a generation of developers who only worked
> with ext3 knew that "fsync is expensive and all you really need is the
> atomic guarantee of mv".

What I /do/ know is that such changes will be due to either (1) kernel 
upgrades or (2) hardware changes (planned upgrades or unpredicted 
failure).  Both factors can be mitigated with redundant layers of 
fallback and dynamic reconfiguration.

Regardless of what brings those device names, a fallback to an earlier 
kernel, or a different device, or a bit of manual grub commandline new 
device location detection and according alteration of the grub-passed 
kernel command line so I can boot and make the necessary permanent config 
changes, is all it'll take to change that.

And as an admin working with stuff directly within my reach to fix when 
necessary, unlike that generation of developers on ext3 with expensive 
fsync, once it's out of my reach to directly manipulate for a fix, it's 
no longer something I need to worry about.

Granted, btrfs and distro devs have to worry about products out of their 
direct reach to fix, but that doesn't mean they have to take the tools 
away (or even simply hide them) from those that can and do put them to 
use.

> Everyone needs to start somewhere, but it's not unreasonable to expect
> an admin to understand how their distro does things, and where to find
> answers when they don't know, and to verify that their knowledge is
> correct.  The middle of a disaster recovery should not be the first time
> you've tried a recovery.

Agreed.  That's why a prudent admin continually scans the radar for 
incoming, as well as having tested fallbacks for the unexpected.

Either that, or as I was at one point, they don't have the knowledge or 
experience yet, but are willing to risk loss of data and a new install, 
in ordered to get that knowledge and experience.  I remember being in 
that group myself, and to a certain extent, I'm still a part of it.  
After all, that level of risk and the knowledge and experienced gained 
from it is part of the pull of pre-releases, live-git kernels, and 
experimental filesystems, in the first place.

But that doesn't mean I don't try to control that risk by building on 
knowledge and experience I already have to limit the risk stack at other 
levels.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

