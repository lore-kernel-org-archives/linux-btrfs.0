Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59275 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbaIRVZU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 17:25:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XUjCV-0006Wj-EG
	for linux-btrfs@vger.kernel.org; Thu, 18 Sep 2014 23:25:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 23:25:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 23:25:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Problem with unmountable filesystem.
Date: Thu, 18 Sep 2014 21:25:02 +0000 (UTC)
Message-ID: <pan$ad8f6$a12f1532$9aeffa42$c560f86b@cox.net>
References: <54184BD2.7000300@gmail.com>
	<2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com>
	<54196F42.4030101@gmail.com>
	<22B49628-3659-4D83-BE99-A173CAFF23F9@colorremedies.com>
	<541B1263.3090804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 18 Sep 2014 13:12:03 -0400 as
excerpted:

> Secondarily, this almost makes me want to set the ssd option on all
> BTRFS filesystems, just to get the rotating superblock updates, because
> if it weren't for that behavior, I probably wouldn't have been able to
> recovery anything in this particular case.

That's an interesting point.  All my btrfs are on ssd ATM and I'm still 
using reiserfs on the spinning rust until btrfs further stabilizes, but 
at some point I imagine I'll switch everything to btrfs, and I hadn't 
thought about this.

Tho I could do with a good explanation of how both ssd and rotational 
superblock update handling works and the differences between the two, as 
I'm not entirely clear on it myself, at this point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

