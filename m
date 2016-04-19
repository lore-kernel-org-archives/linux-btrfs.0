Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35555 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbcDSH6Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 03:58:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1asQY1-0006Nj-Aj
	for linux-btrfs@vger.kernel.org; Tue, 19 Apr 2016 09:58:13 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 09:58:13 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 09:58:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel crash if both devices in raid1 are failing
Date: Tue, 19 Apr 2016 07:58:07 +0000 (UTC)
Message-ID: <pan$4b158$295907b$46fdde88$24c8df73@cox.net>
References: <570FFDFE.3050305@gmail.com>
	<CAJCQCtSDUVDVZ=JfkhOhwn-OTM3iA=cNXc9w=zLcsEatA4xU5Q@mail.gmail.com>
	<5715C604.2070200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dmitry Katsubo posted on Tue, 19 Apr 2016 07:45:40 +0200 as excerpted:

> Actually btrfs restore has recovered many files, however I was not able
> to run in fully unattended mode as it complains about "looping a lot".
> Does it mean that files are corrupted / not correctly restored?

As long as you tell it to keep going each time, the loop complaints 
shouldn't be an issue.  The problem is that the loop counter is measuring 
loops on a particular directory, because that's what it has available to 
measure.  But if you had a whole bunch of files in that dir, it's /going/ 
to loop a lot, to restore all of them.

I have one cache directory with over 200K files in it.  They're all text 
messages from various technical lists and newsgroups (like this list, 
which I view as a newsgroup using gmane.org's list2news service) so 
they're quite small, about 5 KiB on average by my quick calculation, but 
that's still a LOT of files for a single dir, even if they're only using 
just over a GiB of space.

I ended up doing a btrfs restore on that filesystem (/home), because 
while I had a backup, restore was getting more recent copies of stuff 
back, and that dir looped a *LOT* the first time it happened, now several 
years ago, before they actually added the always option.

The second time it happened, about a year ago, restore worked much 
better, and I was able to use the always option.  But AFAIK, always only 
applies to that dir.  If you have multiple dirs with the problem, you'll 
still get asked for the next one.  But it did vastly improve the 
situation for me, giving me only a handful of prompts instead of the very 
many I had before the option was there.

(The main problem triggering the need to run restore for me, turned out 
to be hardware.  I've had no issues since I replaced that failing ssd, 
and with a bit of luck, won't be running restore again for a few years, 
now.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

