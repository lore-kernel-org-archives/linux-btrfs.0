Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60912 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbbLAPPM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 10:15:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a3mdv-0004Ys-UE
	for linux-btrfs@vger.kernel.org; Tue, 01 Dec 2015 16:14:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 16:14:54 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 16:14:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: utils version and convert crash
Date: Tue, 1 Dec 2015 15:14:49 +0000 (UTC)
Message-ID: <pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Tue, 01 Dec 2015 23:38:52 +1100 as excerpted:

> One of the first things I checked was that I was using an up to date
> btrfs util and it keeps reporting that I'm using version 4.0 (btrfs
> --version). This is after confirming that my git clone is up to date,
> the last commit to my master is talking about v4.3.1 and the version.sh
> tells me it is 4.3.1 as well. Why the different reported versions?

The gentoo btrfs-progs live-git version had a similar problem a month or 
two ago.  Turns out the main repo had changed policy.  As explained on 
the wiki, the master branch updates to latest release (so is basically no 
different than building from the latest release tarball), and the devel 
branch (which gentoo had been following) was no longer updated.  The devel 
branch on github (kdave) and repo.or.cz, however, should be current.

So if you're running into the same problem gentoo's live-git build did, 
it's likely because you're building the devel branch cloned from 
kernel.org, which is no longer updated.  Either switch to the github or 
repo.or.cz mirrors where devel is updated, or switch back to master 
branch if you prefer to stick with released versions but still want to 
fetch from git for bisect flexibility, etc, instead of sticking with the 
release tarballs.

Here's the gentoo bug I filed:

https://bugs.gentoo.org/show_bug.cgi?id=562636

... and the btrfs wiki page describing policy and listing the repos
(referenced in the bug as well):

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories


The other possibility is that you're running a stale binary, either a 
stale distro package binary, or a stale self-built, as there's currently 
posted patch saying the default-install switched to /usr/ with the switch 
to autotools, and switches it back to the traditional self-build default-
install to /usr/local/. 

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

