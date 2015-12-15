Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35268 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbbLOCIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 21:08:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a8f2e-0008Ku-Gq
	for linux-btrfs@vger.kernel.org; Tue, 15 Dec 2015 03:08:40 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 03:08:40 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 03:08:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Tue, 15 Dec 2015 02:08:34 +0000 (UTC)
Message-ID: <pan$f0d9c$6c421fa5$20426420$296fb4ac@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
	<pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
	<1448562347.8809.16.camel@scientia.net>
	<pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
	<1448582805.11377.9.camel@scientia.net>
	<pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
	<1448683025.6837.4.camel@scientia.net>
	<pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
	<1449958538.15961.3.camel@scientia.net> <566ED124.30803@gmail.com>
	<1450121957.6629.41.camel@scientia.net> <566F261F.4040705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 14 Dec 2015 15:27:11 -0500 as
excerpted:

> FWIW, both Duncan and I have our own copy of the sources patched to
> default to noatime, and I know a number of embedded Linux developers who
> do likewise, and I've even heard talk in the past of some distributions
> possibly using such patches themselves (although it always ends up not
> happening, because of Mutt).

And FWIW, while I was reasonably conservative with my original patch and 
simply defaulted to noatime, turning it off if any of the atime-enabling 
options were found, I'm beginning to think I might as well simply hard-
code noatime, removing the conditions.  This is due to initr* behavior 
that ends up not disabling atime for early, mostly virtual/memory-based 
filesystems like procfs, sysfs, devfs, tmp-on-tmpfs, etc, but could 
extend to initial initr* mount of the root filesystem as well, if I 
decide to make it rw on the kernel commandline or some such.

Of course atime on a memory-based-fs isn't normally a huge problem since 
its all memory-based anyway, and it would enable stuff like atime based 
tmpwatch since I do a tmpfs based tmp, so I've not worried about it 
much.  But at the same time, I'm now assuming noatime on my systems, and 
anything that breaks that assumption could trigger hard to trace down 
bugs, and hardcoding the noatime assumption would bring a consistency 
that I don't have ATM.

If/when I change my patch in that regard, I may look into adding other 
conditional options, perhaps defaulting to autodefrag if it's btrfs, for 
instance, if my limited sysadmin-not-developer-level patching/coding 
skills allow it.  I'd have to see...  But I'd certainly start with making 
autodefrag a default, not hard-coded, if I did patch in autodefrag, 
because while I don't have large VM images and the like, where autodefrag 
can be a performance bottleneck, to worry about now, I'd like to keep 
that option available for me in the future, and would thus make 
autodefrag the default, not hard-coded.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

