Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51954 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaJVCZZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 22:25:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xglbz-0005iV-8X
	for linux-btrfs@vger.kernel.org; Wed, 22 Oct 2014 04:25:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 04:25:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 04:25:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: downgrade from kernel 3.17 to 3.10
Date: Wed, 22 Oct 2014 02:24:54 +0000 (UTC)
Message-ID: <pan$18b5d$12e42fd5$14087ab$8f220edb@cox.net>
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com>
	<pan$e55c6$e7985780$d6580cb2$76eb6d4@cox.net>
	<CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com>
	<AB1090E1-4EC9-4E58-BB95-3CE871018DFB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 21 Oct 2014 12:07:27 -0400 as excerpted:

> One thing I wonder, if going back to kernel 3.14 (or even 3.10), which
> btrfs-progs to use? Is it OK to use 3.17?

The goal is to have userspace entirely backward compatible (well, to the 
last incompatible device format change, anyway, which was well before 
3.0).  So barring bugs, btrfs-progs-3.17 should work just fine with 
kernel 3.14 or even 3.10.

Tho do keep in mind that -progs-3.12 was the first release using the new 
kernel-synced versioning.  Before that the newest full -progs release was 
ancient, 0.19, from years earlier, tho there was a 0.20-rc1 somewhere 
along the line.  So you really do want at least -progs-3.12 because older 
than that is ancient, and definitely the best-tested -progs-3.12 kernel 
combinations will be the 3.12 and 3.13 kernel series which ran 
concurrently (there being no -progs-3.13, so kernel 3.13 was concurrent 
to -progs-3.12).

IOW your point about staying within well-tested norms applies here as 
well.  By far the most tested code-paths will be the ones where kernel 
and -progs versions were concurrent to each other, so that's what I'd 
recommend sticking with if you want to play it safe and well tested.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

