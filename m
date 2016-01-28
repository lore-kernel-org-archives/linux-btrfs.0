Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47856 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbcA1WwG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 17:52:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aOvQ3-0008VK-JX
	for linux-btrfs@vger.kernel.org; Thu, 28 Jan 2016 23:52:03 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 23:52:03 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 23:52:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 disk upgrade method
Date: Thu, 28 Jan 2016 22:51:57 +0000 (UTC)
Message-ID: <pan$76889$d2dd6b74$a38ccc40$d082f0f6@cox.net>
References: <20160122034538.GA25196@coach.student.rit.edu>
	<pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
	<20160123214127.GA601@fox.wireless.rit.edu>
	<CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
	<20160127224549.GA4891@fox.rh.rit.edu>
	<20160127235528.GA5498@fox.rh.rit.edu> <56AA0A0A.1060807@gmail.com>
	<20160128153756.GA19617@fox.rh.rit.edu>
	<CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
	<20160128184736.GB1167@fox.rh.rit.edu>
	<CAJCQCtT3in9KS1zrQ7B7mTeAK1ODFKUBKXsR7Pz-zbgoduN0XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 28 Jan 2016 12:39:20 -0700 as excerpted:

> I've gotten tripped by this more than once myself, and have to keep
> coming back to the man page; is it max:2 or 2:max or? Actually the
> easier thing to do is skip important info and you get a mini cheat sheet
> instead of the full man page, so you can do
> 
> [chris@f23m ~]$  btrfs fi resize btrfs filesystem resize: too few
> arguments usage: btrfs filesystem resize
> [devid:][+/-]<newsize>[kKmMgGtTpPeE]|[devid:]max <path>
> 
> While you don't get the devid 1 is default clue with this, you get the
> syntax formatting.

When I first started with btrfs, I setup a helper script, that checks for 
command and subcommand and a reasonable number of parameters.  If it gets 
them, it passes everything on as-is.  If it doesn't, or if they don't 
look like commands/subcommands that btrfs will understand, it gives you 
the list of commands/subcommands for that level, or prints the --help 
output and asks for additional parameters.  Then it prints the assembled 
command for you and asks for a final OK before running it.

Later, I modified it to handle mkfs.btrfs as well, taking info from my 
fstab, etc, so I can recreate the backup filesystems and it'll set label, 
raid1, devices, btrfs feature options, etc, then again print the 
assembled btrfs.mkfs and ask for final OK before running it.

That way I don't have to keep track of all the parameter details for the 
various commands and subcommands.  If I happen to remember them I can add 
them to the initial commandline.  If not, I get prompted for them as 
appropriate. =:^)  That, or creating a bunch of separate scriptlet stubs 
or aliases that take care of most of the details (the solution I used for 
emerge, the default gentoo package manager), are the two ways I've found 
to deal with these all-in-one commands, which otherwise tend to be way 
too complex for me to work with, without constantly referencing the 
manpage as I try to enter the command.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

