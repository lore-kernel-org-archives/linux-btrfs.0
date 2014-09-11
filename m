Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33776 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaIKGzz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 02:55:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XRyIE-0006dx-0B
	for linux-btrfs@vger.kernel.org; Thu, 11 Sep 2014 08:55:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 08:55:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 08:55:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it necessary to balance a btrfs raid1 array?
Date: Thu, 11 Sep 2014 06:55:18 +0000 (UTC)
Message-ID: <pan$a192b$da065674$ab069abf$c7aef1f5@cox.net>
References: <541043B8.7010601@barrowhillfarm.org.uk>
	<54109BCD.5000106@inwind.it>
	<20140910193212.GA2549@wheatley.student.rit.edu>
	<5410D0A8.6040204@inwind.it>
	<20140911012516.GA3367@wheatley.student.rit.edu>
	<20140911035119.GA10787@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Wed, 10 Sep 2014 23:51:19 -0400 as excerpted:

> Spinning disks stop being able to position their heads properly around
> -10C or so, a fact that will be familiar to anyone who's tried to use a
> laptop outside in winter.

Depends on where that winter is.  Here in Phoenix, snow makes news (and 
whatever you do, don't ask Phoenicians to drive in it, they're bad enough 
in rain!) and with the exception of outlying areas, there's now seldom 
even frost in the morning.  -10C or so?  YIKES!

So using a laptop outside in winter here isn't likely to trigger the 
behavior in question.

OTOH, I've personally had the opposite issue, go away for some hours in 
the summer with the computer left running, AC fails when it's already 45C 
in the shade outside, come back to a house baking at 55-60C inside, a 
computer still on but of course crashed, and head-crashed disk that 
likely reached well over 70C...

Still, once I shut down and cooled everything down, the system but for 
the disk was fine, and the disk was fine too, outside the zones where the 
heads happened to be at the time.  I had (unmounted at the time) backup 
partitions on the same disk that I was able to boot and run from for 
several months, until I was able to buy and install a replacement.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

