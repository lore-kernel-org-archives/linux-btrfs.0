Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38533 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaFEVQN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 17:16:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wsf19-0002zC-Ld
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 23:16:11 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 23:16:11 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 23:16:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using BTRFS on SSD now ?
Date: Thu, 5 Jun 2014 21:15:59 +0000 (UTC)
Message-ID: <pan$314b2$693d11b8$ba4ce49f$15236427@cox.net>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org>
	<FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 05 Jun 2014 12:13:37 -0600 as excerpted:

>> auto-defrag: not really (read the archives)
> 
> Definitely there are some issues, it's probably why its not yet default.
> So I'd either not use it, or use it with the point of testing it to make
> it better.

Usage-pattern is the big one with autodefrag.  I'm personally an 
autodefrag user and booster, but my use-case has few if any of the big 
red-flag file-access-pattern cases, and several where there's reasonable 
benefit.

Autodefrag's target: Small (up to a few hundred MiB, safely under a gig 
and preferably under half a gig) internal-rewrite-pattern files typically 
found on desktop/laptop purpose systems.  Typical example: Firefox and 
thunderbird sqlite database files.  Also: Multi-file simultaneous write, 
since this write pattern can trigger fragmentation as well, that 
autodefrag's background rewrite strategy should counter/fix.

Autodefrag sees writes that update these files and on copy-on-write (COW) 
filesystems such as btrfs trigger fragmentation, and queues the affected 
files for background sequential rewrite and defrag.  On this type of file 
this strategy works very well, neutralizing the fragmentation that would 
otherwise plague these files on btrfs, without huge ware or performance 
issues.

Autodefrag's bane: Large (gig-plus) internal-rewrite-pattern files, 
traditionally less often found on desktop/laptop systems altho they are 
becoming more common.  Typical examples: VM-images and database files 
over a gig in size.

It can be noted that these types of files are a challenge for any COW-
based filesystem, btrfs being no exception.  Like me, you may have few to 
none of these, but if you do, I strongly recommend reading up on the NOCOW 
file attribute and related strategies, as it's very likely the single 
most common performance issue seen with btrfs, autodefrag or not and ssd 
or not.  See the "Very slow filesystem" thread posted by Igor M (igork20 
at gmail) yesterday.

Autodefrag neutral: Sequentially-written files in general and append-only 
files such as the typical logfile, particularly when only one file is 
being written at once.

Autodefrag strategy hint:  If you choose to use this mount option, it's 
best to use it from THE FIRST TIME file data is written to the 
filesystem.  Unfortunately, as of a year or so ago at least, various 
distro installers did NOT use this flag by default when installing on 
btrfs, resulting in a lot of out-of-the-box installation fragmentation on 
btrfs.  Turning it on only after installation thus resulted in a 
performance drag for several days, until autodefrag caught up with the 
backlog.  So if installing to btrfs, verify that this flag is turned on 
by the installer for the install itself, if necessary using the custom 
option at this step to turn it on at initial mount, before all those 
files are copied over by the installer.

As an installation-time-autodefrag alternative, run btrfs filesystem 
defrag -r (recursive) on the filesystem after installation, before you 
start using it much and definitely before the first btrfs snapshot (or 
delete that snapshot first, do the defrag, then create a new snapshot).  
That will take care of all the fragmentation at once, and by doing it 
without snapshots taken, you avoid data duplication due to defrag being 
temporarily snapshot-aware disabled, until they fix the scaling issues 
that snapshot-awareness was triggering.

Unless you have autodefrag-bane files to worry about (and if you do, I 
strongly recommend that you do your research on that and special-case 
them with NOCOW and etc), even on ssd, autodefrag should be a small bonus 
due to saved IOPS, tho not to the extent it would be on spinning rust due 
to ssd's zero-seek-time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

