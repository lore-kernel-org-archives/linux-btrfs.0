Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54888 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbbFGELt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Jun 2015 00:11:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z1Rw0-00069j-T3
	for linux-btrfs@vger.kernel.org; Sun, 07 Jun 2015 06:11:44 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2015 06:11:39 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2015 06:11:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-transaction is blocked if mounted as rw
Date: Sun, 7 Jun 2015 04:11:34 +0000 (UTC)
Message-ID: <pan$49004$d9115b64$fc1b6298$d2d18c2c@cox.net>
References: <4E041BB2-AB2D-4E50-9C2A-4C08CDC2CB6E@gabri.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gabri Mate posted on Sat, 06 Jun 2015 23:28:43 +0200 as excerpted:

> I have a 12 disk RAID10 btrfs array running on 3.18.14. The FS is 50%
> and has about 100 snapshots. The metadata size is about 450 GB. I was
> doing a metadata balance when the system crashed. After that when I try
> to mount the FS normally it crashes the host with the following error:
> 
> [  601.168088] INFO: task btrfs-transacti:4506 blocked for more than 120
> seconds.
> [  601.168154]       Not tainted 3.18.14 [...]
> 
> Mounting it as read only works fine. I have tried skip_balance without
> any success. I have also tried multiple kernel versions from 3.16 to 4.0
> but I got similar results to the above. Do you have any suggestions I
> could try to get this FS mounted as read-write?

It's possible the (up to) 30-second between-commit log got corrupted in 
the crash.  You could try btrfs-zero-log, available in newer btrfs-progs 
as btrfs rescue zero-log.  I'm no btrfs dev, just a list regular and 
admin myself, but that's what /I'd/ try next.  In theory the filesystem 
is in a known state at commits, which are 30 seconds apart (if there's 
changes to be committed) by default, and the log is only between commits, 
so you /shouldn't/ lose anything doing that.  However, given that you 
were doing a metadata balance at the time, and that it's presently 
accessible read-only, I'd backup anything of value (assuming you don't 
have a current backup already, sysadmin's backup rule of course is that 
if you don't have a backup, by definition it's not of value to you, 
so...) before I tried that, just in case.

Other than that, yeah, there's other things to try, but they get complex, 
given that it's mountable read-only, I'd simply freshen my backups and do 
a mkfs.  Of course /I'm/ running multiple sub-100-GiB btrfs here, all on 
ssd, with backups altho I can't say they're always the freshest, so 
freshening the backups, blowing up a filesystem and starting over with a 
fresh mkfs isn't the big deal here that it's going to be on a very likely 
5 TiB+ worth of data raid10 btrfs.

One thing you /can/ do, however, assuming just the filenames and 
directory layout on the filesystem isn't too sensitive, is take a btrfs-
image of the filesystem before you blow it away, in case the devs want to 
take a look.  That makes a compressed image of the metadata (only), so 
with 450 GB of metadata, expect an image file of (perhaps, I don't 
actually know how well it normally compresses) 200 GB or so.  Obviously 
that's not something you'd post to the list, but if you have a place to 
stash it that has reasonable access speeds, it is possible the devs can 
use it.

Of course the other alternative is to wait until Wednesday or so, in case 
there's someone who knows more about it than I do, that might read it and 
reply once the weekend is over.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

