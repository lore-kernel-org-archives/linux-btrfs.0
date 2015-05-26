Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38909 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbbEZFid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 01:38:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yx7ZP-00005p-JO
	for linux-btrfs@vger.kernel.org; Tue, 26 May 2015 07:38:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 07:38:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 07:38:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help needed to recover a RAID5 btrfs
Date: Tue, 26 May 2015 05:38:23 +0000 (UTC)
Message-ID: <pan$3386d$35212f4$af6d06d8$b9fa55d1@cox.net>
References: <508094243.133459.1432569980190.JavaMail.open-xchange@oxbsltgw09.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Felix Koop posted on Mon, 25 May 2015 18:06:20 +0200 as excerpted:

> I have a RAID5 filesystem where one disk has crashed. Now the filesystem
> is not recognized any more. Any help available?
> 
> Here is some info:
> 
> root@server:~# uname -a Linux server 4.0.0-1-amd64 #1 SMP Debian 4.0.2-1
> (2015-05-11) x86_64 GNU/Linux
> 
> root@server:~# btrfs --version btrfs-progs v4.0

Commendations on at least running current versions.  With code as new as 
btrfs raid56 mode, that's absolutely critical, so I'm glad to see you got 
it covered! =:^)

This isn't going to help with the current problem, but it might be useful 
in general...  Note that I'm just a btrfs user/admin and list regular, 
not a dev, and that my own btrfs use-case is btrfs raid1 mode, so what I 
know about btrfs raid56 mode (covering both raid5 and raid6) is what I've 
found on the wiki and the list.  Disclaimer out of the way...

FWIW, btrfs raid56 mode was only actually theoretically complete with 
kernel 3.19, and is still very new and buggy.

If you're simply testing it, great, we need testers to help it get to 
usability. =:^)

If OTOH you're actually expecting it to work, I'd strongly recommend 
avoiding raid56 mode until it has at /least/ a /couple/ kernel cycles 
under its belt after completion... which would be 4.1 since 3.19 was code-
completion, and preferably something closer to a year, five kernel cycles 
or so, thus 4.4.

In the mean time, for multi-device btrfs modes with raid redundancy, I'd 
recommend sticking with either raid1 or raid10 modes as at this point 
they are both far more mature and tested, basically to the same level of 
maturity btrfs itself is, that being not entirely stable yet, but 
reasonably usable as long as you're following the sysadmins' backups 
rule, that in turn being, if it's not backed up you by definition don't 
care if you lose it, no matter what you claim, with the corollary being 
that a would-be backup isn't a backup, until you've tested that you can 
recover from it.

As for help with your current broken btrfs raid5, I'll refer you to 
others with actual experience with it. =:^/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

