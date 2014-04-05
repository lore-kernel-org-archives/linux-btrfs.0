Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45557 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbaDEKMa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Apr 2014 06:12:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WWNaO-0007YH-RT
	for linux-btrfs@vger.kernel.org; Sat, 05 Apr 2014 12:12:28 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 12:12:28 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 12:12:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sat, 5 Apr 2014 10:12:17 +0000 (UTC)
Message-ID: <pan$ca9c0$aeb7ee6f$84e2e493$5ee834ed@cox.net>
References: <2692878.dRG1K49eOP@fnix> <20140404150906.GR7442@carfax.org.uk>
	<7675297.F25Z3Ox7Yz@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Sat, 05 Apr 2014 00:35:08 +0200 as excerpted:

[Multiple machines, multiple distros, all going slow over time, the 
common thread being btrfs on all.]

> All those machines do "mainly boring office tasks", email, web surf,
> word processing, spreadsheets. No databases except for system packages
> DB and KDE "akonadi" email storage... Few compilations, if any, no heavy
> disk tasks, all mounted with noatime, space_cache, inode_cache, etc...

Some things to check:

1)  You don't mention the autodefrag mount option.  That may be part of 
the problem, but be aware that simply turning it on without doing a 
manual defrag first will likely make things even worse until it catches 
up.  A btrfs filesystem defrag -r (recursive, requires a reasonably new 
btrfs-progs) will help if this is the problem, tho on multi-terabyte 
filesystems on spinning rust it can take awhile.  When it's done, turn on 
the autodefrag.  And see point #3 below for specific defrags that might 
help, particularly if you don't want to spend the time to defrag the 
entire system.

2)  There's a reason space_cache is the default but inode_cache is not.  
Unless it's a mail server or something, inode_cache is generally not 
needed, and isn't recommended.  Additionally, I've seen comments to the 
effect that on 32-bit on large multi-terabyte filesystems its pointer can 
wrap, altho I'm not sure that's accurate or of the failure mode if it is, 
and we don't see lots of bug reports from it.  Anyway, the recommendation 
is leave it off unless you know you need it.

3)  I'm a kde-er so the akonadi mention caught my eye, that also being 
the reason I chose the paragraph above to quote.  I'm also a gentooer and 
now have semantic-desktop turned off at build time, and switched from 
kmail to claws-mail when kmail akonadified, so have neither akonadi nor 
nepomuk/baloo on my system at all, now.  (Strigi is still required at 
build time for its headers, but with no backend setup for it and 
everything else turned off, it's effectively only that, no runtime.)

Try turning off as much of semantic-desktop and akonadi as you can, and 
see if you get some speed back.  But note that akonadi in particular can 
be difficult to try to prevent autostarting.  Also, kmail and kontact 
past the kdepim 4.4 series (so kmail 2.x is affected, kmail 1.x not) 
basically won't work without akonadi running.  FWIW that's one reason I'm 
on claws-mail now, but you can first simply shut akonadi down temporarily 
and see if it helps with speed, then decide what to do about it if it 
seems to be contributing to your problem.  

While my experience with it was some versions ago now (I switched to 
claws-mail and killed kmail and akonadi in early kde 4.7), I already had 
nepomuk shut off at runtime, and I wasn't using btrfs at the time (I was 
on reiserfs), either getting rid of akonadi at runtime or purging the 
entire semantic-desktop and akonadi thing from my system, disabling them 
at build time, made a **HUGE** difference in system responsiveness!  It 
was ENTIRELY unexpected on my end (the main benefit I expected was to be 
rid of the dependencies), so while I didn't do any benchmarks, it's 
unlikely all in my head, either.

I compared it to adding a couple cores to my then 4-core (now 6-core) 
CPU, or upgrading from half a gig to four gigs of RAM, for free, or to 
the experience MS users have when they get their machine cleaned and 
suddenly realize all that malware was what was slowing the system down.  
(Did I just compare akonadi to malware... yes I did!)  The difference was 
THAT dramatic!  I'm not saying it'll be /that/ dramatic for /everyone/, 
YMMV as they say, but it's worth investigating, as even if it's not that 
dramatic for you, it might help.

Tying it all back to btrfs, if you find that turning off nepomuk/baloo 
indexing and akonadi do speed things up, consider defragging their 
databases and see if you can then run them with less slowdown.  I don't 
actually remember the size of the akonadi database, and obviously that 
was well before baloo, but before I turned off nepomuk file indexing its 
database would grow to well over two gigs here, definitely well above the 
half to one gig that's the recommended cutoff for NOCOW.  So try 
defragging it, then setting NOCOW[1], and see if that helps.  Obviously 
try the same with the akonadi database, setting nocow if it's larger than 
half a gig and simply letting autodefrag keep it clean if it's below half 
a gig.  It's possible that will get you enough performance back, and with 
the nocow and autodefrag, that it'll stay back, that you can keep running 
them and won't need to resort to the more radical switch away from kmail 
and the other kdepim applications that I did.

---
[1] The above assumes you already know the usual drill on setting 
effective nocow on btrfs.  If you don't...  It must be set before the 
file has content, and the easiest way to do that is to set it on the 
directory, before the files are created in it.

[1a] For existing files, copy/move them into the newly nocow-ed 
directory, being sure to either cross filesystems or use 
--reflink=never when copying, to avoid hard/reflinking a still possibly 
fragmented COW file, so the nocow actually takes.

[1b]  Alternatively, touch a new file to create it as zero size, set it 
nocow, then cat the content into it using redirection:

$ touch /path/to/newfile
$ chattr +C /path/to/newfile
$ cat /old/file/path/oldcopy >| /path/to/newfile

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

