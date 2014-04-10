Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60007 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaDJN65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 09:58:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WYFVH-00053h-Ka
	for linux-btrfs@vger.kernel.org; Thu, 10 Apr 2014 15:58:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 15:58:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 15:58:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 13:58:45 +0000 (UTC)
Message-ID: <pan$90756$dc7a7f84$91c0b585$f9cdfc6f@cox.net>
References: <4783411.VVGoQz5kVU@fuchsia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Schuerig posted on Thu, 10 Apr 2014 15:21:01 +0200 as excerpted:

> SMART indicates that my notebook disk may soon be failing (an
> unreadable/uncorrectable sector), therefore I intend to exchange it. The
> disk contains a single btrfs filesystem with several nested(!)
> subvolumes, each with several read-only snapshots in a .snapshots
> subdirectory.
> 
> As far as I can tell, btrfs currently does not offer a sensible way to
> duplicate the entire contents of the old disk onto a new one. I can use
> cp, rsync, or send/receive to copy the "main" subvolumes. But unless I'm
> missing something obvious, the snapshots are effectively lost. btrfs
> send optionally takes multiple clone sources, but I've never seen an
> example of its usage.
> 
> If that's what "experimental" means, I'm willing to accept it. However,
> I'd like to emphasize that there's still something missing. Of course,
> most of all I'd like to be proved wrong.

It's not a btrfs tool, but several of the tools you mentioned aren't, and 
you didn't mention dd (or ddrescue, if your source device starts giving 
you issues while you're cloning).  Using it you'd clone the entire raw 
device, including any not yet allocated areas, in a straight-across bit-
perfect copy.  Of course you'd need a target of either the same size or 
larger in ordered to do so...

That should give you a bit-perfect copy including the filesystem UUIDs, 
etc, which will confuse btrfs if you try to mount anything btrfs with 
both devices attached, so don't.  Do your clone, then umount and 
disconnect the old device before trying to mount the new one.


In fact, there are entire purpose-built special live-image distributions 
such as Clonezilla for managing storage devices like this.

http://clonezilla.org/

Or use a more general purpose "rescue" live-image distro such as 
SysRescue:

http://www.sysresccd.org/

Both of these tools support MS Windows systems as well.  Image-cloning is 
of course OS-agnostic -- what's on the cloned image doesn't matter, just 
whether the source device is readable and the destination writable.  And 
sysrescue is often used in the MS world to reset lost passwords and etc.  
I used to use it for that back when I still worked on friends' MS systems 
for "gratis" (well, traded for a good dinner or whatever), before I 
decided that wasn't a worthwhile use of my time, tho I'd be happy to 
teach them about Linux if they wanted, or might still do it if they paid 
me enough, but then there's other computer repair services that will do 
that if they're willing to pay.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

