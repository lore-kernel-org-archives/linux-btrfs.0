From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs RAID with enterprise SATA or SAS drives
Date: Fri, 11 May 2012 02:18:24 +0000 (UTC)
Message-ID: <pan.2012.05.11.02.18.22@cox.net>
References: <4FAAE94D.4010103@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Pocock posted on Wed, 09 May 2012 22:01:49 +0000 as excerpted:

> There is various information about
> - enterprise-class drives (either SAS or just enterprise SATA)
> - the SCSI/SAS protocols themselves vs SATA having more advanced
> features (e.g. for dealing with error conditions)
> than the average block device

This isn't a direct answer to that, but expressing a bit of concern over 
the implications of your question, that you're planning on using btrfs in 
an enterprise class installation.

While various Enterprise Linux distributions do now officially "support" 
btrfs, it's worth checking out exactly what that means in practice.

Meanwhile, in mainline Linux kernel terms, btrfs remains very much an 
experimental filesystem, as expressed by the kernel config option that 
turns btrfs on.  It's still under very intensive development, with an 
error-fixing btrfsck only recently available and still coming with its 
own "may make the problems worse instead of fixing them" warning.  
Testers willing to risk the chance of data loss implied by that 
"experimental filesystem" label should be running the latest stable 
kernel at the oldest, and preferably the rcs by rc5 or so, as new kernels 
continue to fix problems in older btrfs code as well as introduce new 
features and if you're running an older kernel, that means you're running 
a kernel with known problems that are fixed in the latest kernel.

Experimental also has implications in terms of backups.  A good sysadmin 
always has backups, but normally, the working copy can be considered the 
primary copy, and there's backups of that.  On an experimental filesystem 
under as intense continued development as btrfs, by contrast, it's best 
to consider your btrfs copy an extra "throwaway" copy only intended for 
testing.  You still have your primary copy, along with all the usual 
backups, on something less experimental, since you never know when/where/
how your btrfs testing will screw up its copy.

That's not normally the kind of filesystem "enterprise class" users are 
looking for, unless of course they're doing longer term testing, with an 
intent to actually deploy perhaps a year out, if the testing proves it 
robust enough by then.

And while it's still experimental ATM, btrfs /is/ fast improving.  It 
/does/ now have a working fsck, even if it still comes with warnings, 
and  reasonable feature-set build-out should be within a few more kernels 
(raid5/6 mode is roadmapped for 3.5, and n-way-mirroring raid1/10 are 
roadmapped after that, current "raid1" mode is only 2-way mirroring, 
regardless of the number of drives).  After that, the focus should turn 
toward full stabilization.  So while btrfs is currently intended for 
testers only, by around the end of the year or early next, it will likely 
be reasonably stable and ready for at least the more adventurous 
conventional users.  Still, enterprise class users tend to be a 
conservative bunch, and I'd be surprised if they really consider btrfs 
ready before mid-year next year, at the earliest.

So if you're looking to test btrfs on enterprise-class hardware, great!  
But do be aware of what you're getting into.  If you have an enterprise 
distro which supports it too, even greater, but know what that actually 
means.  Does it mean they support the same level of 9s uptime on it as 
they normally do, or just that they're ready to accept payment to try and 
recover things if something goes wrong?

If that hasn't scared you off, and you've not read the wiki yet, that's 
probably the next thing you should look at, as it answers a lot of 
questions you may have, as well as some you wouldn't think to ask.  Being 
a wiki, of course, your own contributions are welcome.  In particular, 
you may well be able to cover some of the enterprise class viewpoint 
questions your asking based on your own testing, once you get to that 
point.

https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

