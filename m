Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33855 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaAVQS4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 11:18:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W60Vy-0004VO-IV
	for linux-btrfs@vger.kernel.org; Wed, 22 Jan 2014 17:18:54 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 17:18:54 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 17:18:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: failed to read the system array on sdX
Date: Wed, 22 Jan 2014 16:18:31 +0000 (UTC)
Message-ID: <pan$1d6c4$b8303dbf$82032e51$ec0030c7@cox.net>
References: <CAD_cGvFie41PxiJqa1tL04vZYNsfk8fCHrf4=znXO2Ds=sF8Vw@mail.gmail.com>
	<CAD_cGvHMX0=EaThq3u_ZOGGcXgi0hmmW-_zUVf5WK5dEzPg2vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans-Kristian Bakke posted on Tue, 21 Jan 2014 23:09:58 +0100 as
excerpted:

> 2. There is no uninstall target in the btrfs-tools Makefile. How am I
> supposed to uninstall btrfs-progs if wanting to go back to older
> versions (or newer)?

As I run gentoo not debian, I won't try to answer the other.  However I 
can answer this, to /some/ extent anyway.

a) (probably not all that interesting to you) On gentoo there's a live-
git ebuild available.  The PM will track the files it installs just as it 
would for any other package.  (A fake-install to a temp location is done 
first and the files that appear there are automatically registered for 
tracking and later uninstall.  Then the fake install is copied to the 
live filesystem.)  If your distro has something similar...

b) As is often the case with in-development "leaf" packages that are 
mostly executables and documentation (that is, no libraries/headers/etc 
that other packages will need), a standard recommendation is to use the 
files directly from the build dir, without actually installing.

So you'd build btrfs, and any time you wanted to use it you'd simply cd 
to its build dir and do ./btrfs (or other command).  Then you'd simply 
delete the build dir to uninstall.

Of course you could manually copy individual files out of the build dir, 
say to your initr* build, if desired, and track the ones you did just as 
manually.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

