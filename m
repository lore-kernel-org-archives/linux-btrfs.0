Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43123 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaEGMbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 08:31:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wi10D-0005Xp-Ok
	for linux-btrfs@vger.kernel.org; Wed, 07 May 2014 14:31:13 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 14:31:13 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 14:31:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using mount -o bind vs mount -o subvol=vol
Date: Wed, 7 May 2014 12:31:01 +0000 (UTC)
Message-ID: <pan$c0576$dfde4ffc$83a172b$f40ec159@cox.net>
References: <20140504004732.GE9061@merlins.org>
	<pan$422b5$795bfbf0$455b3e56$2333506b@cox.net>
	<20140507105551.GS10159@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Wed, 07 May 2014 03:55:51 -0700 as excerpted:

> subvolumes are also used as units of backup for btrfs send.

Hmm, yes.  Thanks.  I don't use send/receive here so forgot about that.

>> So my vote would be, for example (modified slightly for posting from my
>> own mounts):
>> 
>> mount /dev/sda5 /
>> mount /dev/sda4 /var/log
>> mount /dev/sda6 /home
> 
> On my laptop: [snip]

FWIW, those were examples.  I actually have more.

> But to each their own :)

Indeed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

