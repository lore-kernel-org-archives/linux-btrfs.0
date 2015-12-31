Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60733 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbbLaNK7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 08:10:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aEd0K-0007aV-2A
	for linux-btrfs@vger.kernel.org; Thu, 31 Dec 2015 14:10:56 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 14:10:56 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 14:10:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: quota rescan hangs
Date: Thu, 31 Dec 2015 13:10:49 +0000 (UTC)
Message-ID: <pan$11229$bfbe83b3$4e7e69d1$13a0ab64@cox.net>
References: <785a5727b63b495cabeed26742515a9f@nex-exchng-01-v.bcn.nexica.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Xavier Romero posted on Thu, 31 Dec 2015 10:09:22 +0000 as excerpted:

> Using BTRFS on CentOS 7, I get the filesystem hung by running btrfs
> quota rescan  /mnt/btrfs/
> 
> After that I could not access to the filesystem anymore until system
> restart.

> Additional Info:
> 
> [root@nex-dstrg-ctrl-1 ~]# modinfo btrfs
> filename: 
> /lib/modules/3.10.0-327.3.1.el7.x86_64/kernel/fs/btrfs/btrfs.ko

> btrfs-progs v3.19.1

> I'm just starting with BTRFS so I could be doing something wrong! Any
> ideas?

[OK, the below lays it on kinda thick.  I'm not saying your choice of 
centos /or/ of btrfs is bad, only that if your interest is in something 
so old and stal^hble as centos with its 3.10 kernel, then you really 
should reconsider whether btrfs is an appropriate choice for you, because 
it seems to be a seriously bad mismatch.  The answer to your actual 
question is below that discussion.]

First thing wrong, here's a quote from the Stability Status section right 
on the front page of the btrfs wiki:

https://btrfs.wiki.kernel.org/index.php/Main_Page

>>>>>

The Btrfs code base is under heavy development. Every effort is being 
made to keep it stable and fast. Due to the fast development speed, the 
state of development of the filesystem improves noticeably with every new 
Linux version, so it's recommended to run the most modern kernel possible.

<<<<<

And here's what the getting started page says:

https://btrfs.wiki.kernel.org/index.php/Getting_started

>>>>>

btrfs is a fast-moving target. There are typically a great many bug fixes 
and enhancements between one kernel release and the next. Therefore:
If you have btrfs filesystems, run the latest kernel.

If you are running a kernel two or more versions behind the latest one 
available from kernel.org, the first thing you will be asked to when you 
report a problem is to upgrade to the latest kernel. Some distributions 
keep backports of recent kernels to earlier releases -- see the page 
below for details.

Having the latest user-space tools are also useful, as they contain 
additional features and tools which may be of use in debugging or 
recovering your filesystem if something goes wrong. 

<<<<<

Centos, running kernel 3.10, is anything *BUT* "the latest kernel".  With 
five release cycles a year, 4.0 being 10 release cycles beyond 3.10, and 
4.4 very near release, 3.10 is now nearing three years old!

Further, btrfs didn't even have the experimental sticker peeled off until 
IIRC 3.12 or so, so that btrfs 3.10 isn't just nearly three years 
outdated, it's also still experimental!

OK, so we know that the enterprise distros support btrfs and backport 
stuff, but only they know what they backported, while we're focused on 
the mainline kernel here on this list.  So while the upstream btrfs and 
list recommendation is keep current, you're running what for all we know 
is a three year old experimental btrfs, with who knows what backports?  
If you want support for that, you really should be asking the distro that 
says they support it, not the upstream that says it's now ancient history 
from when the filesystem was still experimental.

Meanwhile, from here, running the still under heavy development 
"stabilizing but not yet entirely stable or mature" btrfs, on an 
enterprise distro that runs years old versions... seems there's some sort 
of bad-match incompatibility there.  If your emphasis is that old and 
stable, you really should reconsider whether the still under heavy 
development btrfs is an appropriate choice for you, or if a filesystem 
more suitably stable is more in keeping with your stability needs.  One 
or the other would seem to be the wrong choice, as they're at rather 
opposite ends of the spectrum and don't work well together.



OK, on to the specific question.  Tho the devs have been and are working 
very hard on quotas, to date (4.3 release kernel) they've never worked 
entirely correctly or reliably in btrfs, and my recommendation has always 
been, if you're not working with the devs on the latest version to help 
test, find and fix problems, which if you are, thanks, then you either 
need quota functionality or you don't.  Since quotas have never worked 
reliably in btrfs, if you need that functionality, you really need to be 
on a filesystem where it's much more stable and reliable than that 
function has been on btrfs.  OTOH, if you don't need quota functionality, 
then I strongly recommend turning it off and leaving it off until at 
least two kernel cycles have gone by with it working with no stability-
level issues.

Tho I'm not a dev, only a btrfs user and list regular, and my own use-
case doesn't need quotas, so given their problems I've kept them off, and 
I'm not actually sure what the 4.4 status is.  However, even if there's 
no known problems with btrf quotas in 4.4, given the history, as I said 
above, I strongly recommend not enabling them until at least two complete 
kernel cycles have completed with no quota issues, which would mean even 
if 4.4 and 4.5 are clear, I'd not actually trust the feature until 4.6 
time.  At that point, since 4.4 is to be an LTS kernel, you could 
potentially enable them on 4.4 as an LTS kernel, as well as 4.6.  But 
that of course is assuming there's no known or new quota issues in 4.4 or 
4.5, and we don't know that yet, so it could be well beyond 4.6 before 
they're actually stable enough to depend on.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

