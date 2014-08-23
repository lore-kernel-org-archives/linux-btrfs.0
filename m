Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39350 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbaHWCwo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 22:52:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XL1RU-00038r-VB
	for linux-btrfs@vger.kernel.org; Sat, 23 Aug 2014 04:52:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 04:52:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 04:52:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted
 in various ways
Date: Sat, 23 Aug 2014 02:52:16 +0000 (UTC)
Message-ID: <pan$644c4$e5e83b2d$34cd9e4d$75795b7@cox.net>
References: <20140822155040.GU3875@merlins.org>
	<pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
	<20140822184919.GE3875@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 22 Aug 2014 11:49:19 -0700 as excerpted:

> On Fri, Aug 22, 2014 at 06:17:38PM +0000, Duncan wrote:
>> Marc MERLIN posted on Fri, 22 Aug 2014 08:50:40 -0700 as excerpted:
>> 
>> > Fairly often (over 20 times for me so far with various kernel
>> > versions), when I reboot after a crash, my google-chrome profile
>> > is damaged in one of 2 ways:
>> > 1) open tabs don't reopen
>> > 2) google-chrome says that my profile is corrupted.
>> > 
>> > In both cases rsyncing ~/.config/google-chrome from the last hourly
>> > snapshot has fixed the problem every time.
>> 
>> I've had a similar issue with firefox, tho I've narrowed it down to a
> 
> Ok, so so far we've had:
> 1) gogole-chrome 2) firefox 3) mysql
> 
> and 3 different people reporting this at least.
> 
> Google-chrome is complicated because it has many state files and I
> haven't narrowed down which one got corrupted.
> In your firefox example, did you find what corruption you got in that
> file, or was it just truncated?

Unfortunately I can't say for sure.  I only notice it when I launch 
firefox the next time and it comes up skinless, with intro dialogs from a 
some of the extensions (which are still loaded from other files, just not 
configured).  By that time it has rewritten the file in question, *MUCH* 
smaller than my fully configured version, apparently rewriting the firefox 
defaults and possibly some extension defaults, but without any of the 
custom configuration.

I don't know if the file disappears entirely (missing directory entry), 
or whether it gets truncated to zero-size, or whether it's there but 
corrupted, but whatever the case, firefox obviously decides it can' work 
with it and restores the settings in that file to default (not restoring 
from the last backup it made tho I can do that manually, but to defaults 
for that file).

And firefox has already overwritten it with the defaults version by the 
time I notice it after launching firefox and seeing the defaults.

BTW, I just looked at my profile and it's for sure prefs.js, with 
firefox's automated backups being prefs-1.js, prefs-2.js ... prefs-7.js, 
the latter being the latest.  An educated guess is that firefox makes a 
new numbered backup every time it upgrades, which would mean those are 
the backups going back seven versions before current (v31).  Or maybe 
only when it changes something big and thus those seven backups go back 
to v4 or whatever.

> For mysql, I got:
> InnoDB: Page directory corruption: 
> infimum not pointed to 140708 11:53:58
> InnoDB: Page dump in ascii and hex (16384 bytes):
> len 16384; hex 00000000(16KB of 0's).

Is that on ssd or spinning rust, and if ssd, do you run with trim/discard 
and/or have you filled the device yet if not (since mkfs.btrfs trims the 
device as part of the process)?  I'm wondering if that's 4 4 KiB btrfs 
data blocks of trimmed and unwritten SSD?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

