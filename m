Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48120 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbcCVStP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 14:49:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aiRMZ-0001iC-Oa
	for linux-btrfs@vger.kernel.org; Tue, 22 Mar 2016 19:49:07 +0100
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 19:49:07 +0100
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 19:49:07 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
Date: Tue, 22 Mar 2016 19:48:54 +0100
Message-ID: <20160322194854.161e9c4c@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 22 Mar 2016 16:47:10 +0800
schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:

> Hi,
> 
> Kai Krakow wrote on 2016/03/22 09:03 +0100:
> > Hello!
> >
> > Since one of the last kernel updates (I don't know which exactly),
> > I'm experiencing csum errors within VDI files when running
> > VirtualBox. A side effect of this is, as soon as dmesg shows these
> > errors, commands like "du" and "df" hang until reboot.
> >
> > I've now restored the file from backup but it happens over and over
> > again.
> >
> > On another machine I'm also seeing errors with big files in the
> > following scenario (apparently an older kernel, 4.1.x I afair):
> >
> > # ntfsclone --save /dev/md126p2 -o rescue.ntfs.img
> >                     ^ big NTFS partition   ^ file on btrfs
> >
> > results in a write error and the file system goes read-only.  
> 
> When it goes RO, it must have some warning in kernel log.
> Would you please paste the kernel log?

Apparently, that system does not boot now due to errors in bcache
b-tree. That being that, it may well be some bcache error and not
btrfs' fault. Apparently I couldn't catch the output, I've been in a
hurry. It said "write error" and had some backtrace. I will come to
this back later.

Let's go to the system I currently care about (that one with the
always breaking VDI file):

> > Both systems have in common they are using btrfs on bcache with
> > compress=lzo,autodefrag,nossd,discard (mraid=1,draid=0 and
> > mraid=1,draid=single).
> >
> > The system mentioned first is running Kernel 4.5.0 with Gentoo
> > patch-set. I upgraded from the last 4.4.x kernel when I first
> > experienced this problem. The first time the problem resulted in a
> > duplicate extent which btrfsck wasn't able to fix, that's when I
> > first restored from backup. But now I'm getting csum errors in this
> > file over a over again, plus when rsync has run for backup, the
> > system no longer responds to "du" and "df" commands - it just hangs.
> >
> > Known problem? Does it help if I send debug info? If so, please
> > instruct.
> >  
> Does btrfs check report anything wrong?

After the error occured?

Yes, some text about the extent being compressed and btrfs repair
doesn't currently handle that case (I tried --repair as I'm having a
backup). I simply decided not to investigate that further at that point
but delete and restore the affected file from backup. However, this is
the message from dmesg (tho, I didn't catch the backtrace):

btrfs_run_delayed_refs:2927: errno=-17 Object already exists

After this, the system went RO and I had to reboot. I ran btrfs check
and it told about a duplicate extent. I identified the file (using
btrfs inspect and the inode number) being the VDI file, and restored it.
Afterwards, I upgraded from latest 4.4 to 4.5. Currently, I'm now
watching closer since this incident, and the file becomes damaged
without any message in the kernel log when doing some more than usual
IO in VirtualBox. When my backup script then runs over the file, I get
errors about missing csums - the block is not readable. I now ran
ddrescue, and replaced the file to get a current and slightly damaged
VDI image back (my backup uses time rotation, so no problem). But
running chkdsk in VirtualBox damages the VDI again.

Regarding the other error on the other machine, I'm not completely
convinced bcache ain't involved in this problem.

As soon as I "produced" csum errors again, I'll run btrfs check. Or
should I do it now without forcing the csum error to occur?


-- 
Regards,
Kai

Replies to list-only preferred.

