Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40001 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbbHQXGI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 19:06:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZRTTi-0001hC-0n
	for linux-btrfs@vger.kernel.org; Tue, 18 Aug 2015 01:06:06 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 01:06:06 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 01:06:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: The performance is not as expected when used several disks on
 raid0.
Date: Mon, 17 Aug 2015 23:06:00 +0000 (UTC)
Message-ID: <pan$9af23$4fb7d57c$d76038f$6f4281af@cox.net>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
	<CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
	<55CE4682.3080106@gmail.com>
	<CAJCQCtTTgiuNA7+bqd31CG1OHeDiZ=TwQEnVbUF2jNU7qBRRnA@mail.gmail.com>
	<55CE4866.6060207@gmail.com> <pan$82931$bcf5ef1b$88d8d18$c8aa5770@cox.net>
	<55D1C7A5.7050204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Mon, 17 Aug 2015 07:38:13 -0400 as
excerpted:

> I've also found that BTRFS raid5/6 on top of MD RAID0 mitigates (to a
> certain extent that is) the performance penalty of doing raid5/6 if you
> aren't on ridiculously fast storage, probably not something that should
> be used in production yet, but it's how I've got the near-line backups
> setup on my home server system.

As should be clear from my previous posts on the subject, I'm 
conservative enough not to be comfortable with the btrfs raid56 
implementation yet.  My recommendation has been, and remains, unless 
you're deliberately testing it in ordered to help find/report/workout 
bugs, give it a year after the nominally full implementation (3.19, so 
until 4.4), before expecting it to be reasonably as stable as the rest of 
btrfs (which itself isn't fully stable yet).

But the almost-released 4.2 does seem to be past the initial nominally 
btrfs raid56 full-code bugs, and I'd call an intermediate level backup, 
with working copies in front and itself backed up in back, a reasonable 
first working (as opposed to testing) deployment.

And yes, btrfs raid5/6 over mdraid0  would have the same general 
complementary nature as btrfs raid1/10 over mdraid0.

> It may also be worth pointing out that
> BTRFS raid6 lets you use 4 disks minimum, as opposed to most other raid6
> implementations that (unnecessarily, as a 4 disk RAID6 is not a
> degenerate form) require 5.

4-device raid6, btrfs and mdraid both allow that, good point.  But of 
course mdraid6 doesn't have the data integrity, only rebuild-parity.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

