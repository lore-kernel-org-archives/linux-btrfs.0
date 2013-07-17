Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37151 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab3GQXiy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 19:38:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UzbJ6-0007jF-H7
	for linux-btrfs@vger.kernel.org; Thu, 18 Jul 2013 01:38:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 01:38:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 01:38:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: bug: corrupt filesystem, cannot delete tmp files created just
 before crash.
Date: Wed, 17 Jul 2013 23:38:32 +0000 (UTC)
Message-ID: <pan$8addd$a853ed60$657c1f02$89661ea8@cox.net>
References: <CAPs0Bij+BQZArDJuXmKF0S25=wGgdMq6otXmrLJtQYRoMAjQFw@mail.gmail.
	com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sandy McArthur posted on Wed, 17 Jul 2013 10:06:05 -0400 as excerpted:

> have a btrfs filesystem that is corrupt so that I cannot remove a few
> files. Attempting to delete these temp files from before a crash leaves
> the filesystem read-only and sends a trace to the syslog. Assistance
> correcting this issue is most appreciated.
> 
> I have two disks /dev/sd{b,c}1 to make up this filesystem.
> I've updated to the latest btrfs-tools and kernel packages available.
> The crash happened with kernel 3.8.13-gentoo.
> 
> # btrfs version Btrfs v0.20-rc1
> # [uname -r] 3.10.1-gentoo

Hi fellow gentooer. =:^)  I'm just a user too so won't attempt a 
technical answer.  However...

I see you've tried the latest packages for both kernel and btrfs-tools.  
That's good as otherwise that's one of the the first suggestion you'd 
get.  However you don't mention the btrfs wiki, nor do you mention trying 
what it suggests in such cases, so I'll assume you're not familiar with 
it.  (Additionally, being a wiki and btrfs still being under development, 
it's worth checking back every couple months or so, and possibly using 
the wiki history function to see what has changed on your pages of 
interest since your last visit.)

Main page (for bookmarking):

https://btrfs.wiki.kernel.org/index.php/Main_Page

Of course right at the top there it mentions (in bold) that btrfs is 
under heavy development and to run the latest, which you're basically 
doing, altho you apparently haven't tried the latest kernel rc or the 
btrfs-tools git build (which being a gentooer, I know are available, but 
masked by default).  If the following suggestion doesn't help, you might 
try them, as fixes really are going in all the time.

Meanwhile, I recommend reading up on the documentation section of the 
wiki.  In particular, altho with the corruption it may not help in your 
case, pay attention to the no-space sections of the FAQ and Problem FAQ 
pages.  Even more in particular, when there's space problems it 
recommends attempting to clobber/truncate a file in place, the idea being 
to free up space without having to allocate additional metadata space to 
do it.  Again, with corruption it may not help, but it's worth a try.

echo > /path/to/file

Of course, even more with a development filesystem than ordinarily, you 
should have good backups, so you shouldn't need to worry too much about 
finding clobber candidates since you can recover most files from backup 
in any case.

If the echo/clobber doesn't work, try again after mounting with the 
nodatacow option.  But read the wiki for the details.

There's also mount options such as recovery (and skip-balance if you have 
an aborted balance it'd otherwise be trying to restart), that you can 
try.  Of course if you have the space to do so, it might be worth dd-ing 
the filesystem elsewhere as a backup image, in case you screw things up 
worse while experimenting.

Meanwhile, based on my interested-admin most definitely NOT kernel-dev 
technical level following of this list at least, there /have/ been recent 
no-space, extents maintenance and other cleanups in the really-latest 
code (3.11-rc1+ kernel and live-git btrfs-tools, and there may be further 
patches posted to the list that haven't actually been committed yet), 
that may well help in your case.  I'm not technically qualified to match 
backtraces against commits/patches and identify a solid match, but it's 
definitely worth a try.

Finally, as background once you're out of the tight spot, since you're 
running a multi-device filesystem, you're likely to find the discussion 
of that on the multiple devices, sysadmin guide, and use cases pages 
useful.  FWIW, here I'm running most of my btrfs filesystems in dual-
device raid1 (both data/metadata) mode, to take advantage of the 
checksumming and extra copy to lookup in case of checksum error, that 
btrfs offers, in addition to the device-loss scenario that raid1 helps 
protect against.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

