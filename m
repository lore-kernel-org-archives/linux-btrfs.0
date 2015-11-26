Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36443 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbbKZQww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 11:52:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a1zmp-0005kq-Os
	for linux-btrfs@vger.kernel.org; Thu, 26 Nov 2015 17:52:47 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 17:52:47 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 17:52:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Thu, 26 Nov 2015 16:52:41 +0000 (UTC)
Message-ID: <pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mitchell Fossen posted on Wed, 25 Nov 2015 15:49:58 -0600 as excerpted:

> Also, is there a recommendation for relatime vs noatime mount options? I
> don't believe anything that runs on the server needs to use file access
> times, so if it can help with performance/disk usage I'm fine with
> setting it to noatime.

FWIW I finally got tired enough of always setting noatime (for over a 
decade, since kernel 2.4 and my standardizing to then reiserfs) that I 
finally found the spot in the kernel where the relatime default is set, 
and patched it to be noatime by default.  My kernel scripts apply that on 
top of my git kernel pulls, now.

For people doing snapshotting in particular, atime updates can be a big 
part of the differences between snapshots, so it's particularly important 
to set noatime if you're snapshotting.

If you're not doing snapshots, it's somewhat less important, but IIRC it 
was still someone more of a performance issue than with ext*, tho I don't 
remember the details but I'd guess it's to do with COWing the metadata 
triggering metadata fragmentation.

Bottom line, use noatime unless you have something that needs atime.  
It's not going to hurt for sure, and should improve performance at least 
somewhat even on ext*.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

