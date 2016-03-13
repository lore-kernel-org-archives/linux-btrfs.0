Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35866 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148AbcCMDzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 22:55:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aex7T-0007uj-0U
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 04:55:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 04:55:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 04:55:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: parent transid verify failed on snapshot deletion
Date: Sun, 13 Mar 2016 03:54:45 +0000 (UTC)
Message-ID: <pan$c954b$14267bd6$8ef1d5a7$ce601fa2@cox.net>
References: <20160312204847.2092f3f3@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sat, 12 Mar 2016 20:48:47 +0500 as excerpted:

> I wonder what's the best way to proceed here. Maybe try btrfs-zero-log?
> But the difference between transid numbers of 6 thousands is concerning.

btrfs-zero-log is a very specific tool designed to fix a very specific 
problem, and transid differences >1 are not it.

I read your followup, posting btrfs check output and wondering about 
enabling --repair, as well.

As long as you have a backup, shouldn't be a problem, even if it does 
cause further damage (which it doesn't appear like it will in your case).

If you don't have a backup it shouldn't be a problem either, since the 
very fact that you don't have a backup, indicates by your actions that 
you consider the data at risk as of less value than the time, effort and 
resources necessary to have that backup in the first place.   As such, 
even if you lose the data, you saved what was obviously more important 
than that data to you, the time, effort and resources that you would have 
otherwise put into making and testing that backup, so you're still coming 
out ahead. =:^)

Which means the only case not clearly covered is that of data worth 
having backed up, which you do, but the backup is somewhat stale, and as 
long as the risk was theoretical, you didn't consider the chance of 
something happening to the data updated since the backup worth more than 
the cost of updating that backup.  But now that the theoretical chance 
has become reality, while loss of that incremental data isn't earth 
shattering in its consequences, you'd prefer not to lose it if you can 
save it without too much trouble.  That's quite understandable, and is 
the exact position I've been in myself a couple times.

In both my cases where I did end up actually giving up on repair and 
eventually blowing away the filesystem, btrfs restore (before that blow-
away) was able to get me back the incremental changes since my last 
proper backup.  If it hadn't worked I'd have certainly lost some work and 
been less than absolutely happy, but as I _did_ have backups (which by 
the fact that I had them indicated I actually valued the data at risk at 
something above trivial), they were simply somewhat stale, it wouldn't 
have been the end of the world.


Of course in your case you _can_ mount, if only in read-only mode.  So 
take the opportunity you've been handed and update your backups (and of 
course backups that haven't been verified readable/restorable aren't yet 
completed backups, as a would-be backup isn't complete and can't really 
be considered a backup yet, until that verification is done), just in 
case, and then even in the worst-case scenario, btrfs check --repair 
can't do more than inconvenience you a bit if it makes the problem worse 
instead of fixing it, since you have current backups and will only need 
to blow away the filesystem and recreate it fresh, in ordered to restore 
them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

