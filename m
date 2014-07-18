Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35155 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbaGRKB4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 06:01:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X84zB-0006dF-Pr
	for linux-btrfs@vger.kernel.org; Fri, 18 Jul 2014 12:01:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 12:01:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 12:01:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unmountable btrfs filesystem - 'unable to find logical' / 'no
 mapping'
Date: Fri, 18 Jul 2014 10:01:42 +0000 (UTC)
Message-ID: <pan$8a4a4$d7f675d5$9433bb47$a7453cfe@cox.net>
References: <CABibBbuGtAC7Rpptdd_wF7m87MSqg8zUEHvWSFsfk3KH+w2Jmg@mail.gmail.com>
	<pan$1a915$ec9d1e93$7b7c14f1$dea1f150@cox.net>
	<loom.20140718T004316-587@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Clay posted on Thu, 17 Jul 2014 23:09:08 +0000 as excerpted:

> I'm not fully sure about the btrfs restore -x behaviour either.
> Ownership of the restored files is still  incorrect, but maybe it
> affects r/w/x permissions, which look fairly sensible for the small set
> of files  I've looked at so far...

Thanks and good to read that you eventually able to successfully restore 
most of the files too.  A wakeup call indeed!  I've always stressed 
backups with btrfs and did have them, so wouldn't have been too bad off 
if I had to revert to them.  I'd simply let them get inconveniently 
outdated, and between that and the chance it gave me to actually get real 
experience with btrfs restore, I decided to try it first.

But your reply reminded me...

Something think I forgot to mention is that btrfs restore didn't restore 
symlinks, at all, not as symlinks and not as copies of the files they 
pointed at.  It was as if the symlinks simply didn't exist on the source 
filesystem I was restoring from, so I'm guessing the implementation 
simply overlooked symlinks as something it needed to deal with.

Meanwhile, on ownership/permissions I think btrfs restore must simply 
find the data and write it out as the user (presumably root) it is run 
as, using the existing umask, just as a normal user file write would do 
by default.  So if your root and user umasks are identical (presumably 
0022), you probably won't notice the permissions difference.  My root 
umask is 0022 while my user umask is 0027, so I noticed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

