Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48137 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641AbaDMUqq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 16:46:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WZRIa-00033l-Ur
	for linux-btrfs@vger.kernel.org; Sun, 13 Apr 2014 22:46:44 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Apr 2014 22:46:44 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Apr 2014 22:46:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Rebalance makes BTRFS 10x slower
Date: Sun, 13 Apr 2014 20:46:32 +0000 (UTC)
Message-ID: <pan$78e51$a2348240$c61eed49$b68b7430@cox.net>
References: <4392627.HWimVooIO4@tethys> <7616233.4PhybLsPIr@merkaba>
	<CAFvQSYT=1z4iENu8xLnBLvVTqUzYfZazY1acnFvUEz_FO-Gf4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clemens Eisserer posted on Sun, 13 Apr 2014 10:16:22 -0400 as excerpted:

>> I also found this to be the case as I rebalanced the root filesystem of
>> my Debian installation on this ThinkPad T520 on an Intel SSD 320.
> 
> Same here, I ran balance on kernel-3.12 some time ago and after
> balancing performance dropped noticeable and stayed there.
> When booting natively I can see the HDD activity led lid for 10+ seconds
> (Samsung 830 SSD), working with the same system in virtualbox using
> direct device access is a real pain.
> 
> Non of the measures I took (re-balance, fstrim, defraging all files on
> the volume, ...) had mentionable impact.

This one is a real mystery to me, and only recently came up on my radar 
as an issue people are seeing.  It'd be interesting to get to the bottom 
of it as it's possible it has other bug and correctness implications as 
well.

I've seen nothing like it here, but then my btrfs are all relatively 
small (under 50 gig each), and I don't tend to do much snapshotting or 
subvolumes, which might make a difference.  Additionally, I don't have a 
lot of large "internal write" files such as databases and the like (not 
even the systemd journal file issue that some have reported, as while I 
recently switched to systemd, I deliberately chose to configure it to do 
tmpfs logs only to avoid that problem entirely, with all longer term 
logging going thru syslog-ng, which has more conventional append-only log 
files).

But as I said, I'd sure like to get to the bottom of this one, since I do 
believe it has other potential implications in terms of bugs, etc.  In 
theory, a balance should either not affect performance or should improve 
it, so getting to the bottom of why it's having such a bad performance 
impact for many really is something that needs to be done.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

