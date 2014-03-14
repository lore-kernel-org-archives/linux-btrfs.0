Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50770 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaCNEyv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 00:54:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOK8w-0001y2-JU
	for linux-btrfs@vger.kernel.org; Fri, 14 Mar 2014 05:54:50 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 05:54:50 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 05:54:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.14.0-rc3: btrfs send/receive blocks btrfs IO on other devices
 (near deadlocks)
Date: Fri, 14 Mar 2014 04:54:25 +0000 (UTC)
Message-ID: <pan$6f587$1aabe17f$e8f110d4$4b096c0c@cox.net>
References: <20140312151808.GE16865@merlins.org>
	<20140314014813.GP18959@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Thu, 13 Mar 2014 18:48:13 -0700 as excerpted:

> Are others seeing some btrfs operations on filesystem/diskA
> hang/deadlock other btrfs operations on filesystem/diskB ?

Well, if the filesystem in filesystem/diskA and filesystem/diskB is the 
same (multi-device) filesystem, as the above definitely implies...  Tho 
based on the context I don't believe that's what you actually meant.

Meanwhile, send/receive is intensely focused in bug-finding/fixing mode 
ATM.  The basic concept is there, but to this point it has definitely 
been more development/testing-reliability (as befitted btrfs overall 
state, with the eat-your-babies kconfig option warning only recently 
toned down to what I'd call semi-stable) than enterprise-reliability.  
Hopefully by the time they're done with all this bug-stomping it'll be 
rather closer to the latter.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

