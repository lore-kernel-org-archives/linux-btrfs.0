Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56954 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbL1EfM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 23:35:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDPWX-0002c4-GX
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 05:35:09 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 05:35:09 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 05:35:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to change BTRFS filesystem UUID
Date: Mon, 28 Dec 2015 04:35:04 +0000 (UTC)
Message-ID: <pan$8c9ca$1617b07e$b95cfe66$943328ef@cox.net>
References: <567FF63E.3010106@ganomi.com>
	<20151227144535.GJ1586@carfax.org.uk> <5680034D.7030509@ganomi.com>
	<1451257299.6320.3.camel@scientia.net>
	<20151227231303.GL1586@carfax.org.uk> <56809AC4.2080209@ganomi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jiri Kanicky posted on Mon, 28 Dec 2015 13:13:24 +1100 as excerpted:

> VM with BTRFS filesystem running on XenServer. The VM disk is a VHD
> stored on NFS storage. NFS storage ran out of space, and I found the
> BTRFS in RO mode. I could not remount it as RW after increasing the
> storage space. I rebooted the VM and the VM was not able to boot
> anymore. There were many lines during boot reporting "btrfs open_ctree
> failed" and the boot ended up in dracut mode.
> 
> I booted from CD and find out that I can mount the BTRFS filesystem and
> all data are there.

You did well. =:^)

Just in case you ever get into a situation where the btrfs will /not/ 
mount, however, there's an additional tool you can try to hopefully at 
least recover the data off of it, copying it to a new (possibly non-
btrfs) location from the unmounted filesystem.

btrfs restore

In addition to the btrfs-restore manpage, there's even a wiki page on it 
that has some "extraordinary measures" you can try if restore won't work 
by itself, using btrfs-find-root to hopefully find a usable previous root 
to feed to restore's -t option.  However, once you get to this level 
you're basically trying to reconstruct at least enough of a filesystem 
from historical bits and pieces as they may still be found on the device 
to be able to restore from, and it does get quite technical, so many 
people need help, and only some end up being able to restore most or all 
of their data, as often it's simply too damaged.

So the ideal is obviously to have backups if the data is important enough 
to you that you'd be jumping thru these hoops if you had to, and once you 
have backups, then restore becomes a tool to be used to possibly get a 
newer copy than your backup had, but no big deal if it fails as you /do/ 
have backups.  And at that point, you don't need to worry too much about 
the "extraordinary measures" stuff, because if it doesn't work with 
normal measures, then you just use the backup.

What's nice about btrfs-restore is that it works in read-only mode on the 
unmounted filesystem in question and thus won't cause any more damage.  
As a result, it's a good tool to use to try to get a current backup with 
if you don't have one, before trying seriously invasive procedures that 
if they don't fix the problem, could damage the filesystem further, 
rendering it impossible to get anything useful out of it.

Anyway, just pointing out the btrfs restore tool, as it's a very useful 
tool to have in your toolbox if a btrfs won't mount.  You will want to 
use a recent version of btrfs-progs, however, as btrfs restore has 
notably improved over time, with the last fix to it in 4.2.3, an off-by-
one fix to the symlink restoration code added in 4.0.1, and 4.0 added 
metadata (time/mode/uid/gid) restoration, where before that files were 
restored with the ownership (root) and umask of the btrfs restore process 
and had to be manually corrected.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

