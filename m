Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48291 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbbK0Dis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 22:38:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a29rv-0006YF-05
	for linux-btrfs@vger.kernel.org; Fri, 27 Nov 2015 04:38:43 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 04:38:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 04:38:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Fri, 27 Nov 2015 03:38:39 +0000 (UTC)
Message-ID: <pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
	<pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
	<1448562347.8809.16.camel@scientia.net>
	<pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
	<1448582805.11377.9.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Fri, 27 Nov 2015 01:06:45 +0100 as
excerpted:

> And additionally, allow people to mount subvols with different
> noatime/relatime/atime settings (unless that's already working)... that
> way, they could enable it for things where they want/need it,... and
> disable it where not.

AFAIK, per-subvolume *atime mounts should already be working.  The *atime 
mount options are filesystem-generic (aka Linux vfs level), and while I 
my own use-case doesn't involve subvolumes, the wiki says they should be 
working (wrapped link I'm not bothering to jump thru the hoops to 
properly unwrap):

https://btrfs.wiki.kernel.org/index.php/FAQ
#Can_I_mount_subvolumes_with_different_mount_options.3F

So while personally untested, per-subvolume *atime mount options /should/ 
"just work".

Meanwhile, I've simply grown to hate atime as an inefficient and mostly 
useless drain on resources, so I pretty much just noatime everything, the 
reason I decided to bother patching my kernel to make that the default, 
instead of having yet another option I use everywhere anyway, clogging up 
the options field in my fstab.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

