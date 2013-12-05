Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52923 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3LEK1j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Dec 2013 05:27:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VoW9h-0003gB-8s
	for linux-btrfs@vger.kernel.org; Thu, 05 Dec 2013 11:27:37 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2013 11:27:37 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2013 11:27:37 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-cleaner leaves CPU pinned to 100%
Date: Thu, 5 Dec 2013 10:27:14 +0000 (UTC)
Message-ID: <pan$f2236$913cfbec$e1280556$6e940b4f@cox.net>
References: <CALnfhZDKEs7LeTrHAk3oecJ2oOqo=VJzQqoeEy3qNB92s2CC7A@mail.gmail.com>
	<loom.20131204T162331-814@post.gmane.org> <20131204174909.GA6675@fb.com>
	<CALnfhZAEg1EgtDmZ6Qka=Ka-oaUmg++3mN3M=qOf5BHtEXXPpA@mail.gmail.com>
	<CALnfhZDW4w4kuLPf1pYEMkW-d_aV+o7tHawbrNi+3JX7jeqzFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam G posted on Wed, 04 Dec 2013 19:19:15 -0500 as excerpted:

> I recreated the problem by booting with autodefrag enabled and loading a
> large VirtualBox image of Windows 8.1. The CPU is pinned to 100%
> even after closing the VirtualBox software.

Virtual images!

That's your problem!  Any large and frequently internally written files 
(as opposed to appended such as logs or write-once files such as most 
media files), including both large databases and virtual machine images, 
are going to be an issue on any COW (copy-on-write) filesystem such as 
btrfs, since they'll very quickly become very heavily fragmented due to 
the constant internal writes creating fragments.

And virtual machine images are a classic example, often being several 
gigs (if not tens of gigs) in size, with frequent writes to data in the 
center of the image.

As a consequence, it's strongly recommended that VM images are set NOCOW, 
so writes will happen in-place, instead of fragmenting the image.  
Without that... well, the poor defragmenter was working overtime to try 
and fix the fragments, and all those fragments were certainly dragging 
down your VM performance as well.

For curiosity sake, you might try running filefrag on that image and see 
just how fragmented it was.

As for setting NOCOW, note that the attribute must be set before the file 
has any data in it.  There are two common ways to do that.  The easy way 
is to create a directory for your VM images and set the attribute on it, 
then copy the vm images into it.  An alternative is to touch the 
individual file to create it at zero size, set the attribute, then copy 
the data into it from the existing file.

After doing that with all your VM images and deleting the old/fragmented 
copies, the pegged cpu defrag thread issue should disappear or at least 
dramatically reduce, and you may well notice a performance boost in your 
VMs as well. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

