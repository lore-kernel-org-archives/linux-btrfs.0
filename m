Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58485 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbcCMRMm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 13:12:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1af9ZI-0001xd-0l
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 18:12:40 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 18:12:40 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 18:12:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Date: Sun, 13 Mar 2016 17:12:35 +0000 (UTC)
Message-ID: <pan$9abbc$75454df4$bbede296$bf2d7878@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Haber posted on Sun, 13 Mar 2016 12:58:10 +0100 as excerpted:

> I see the same metadata spread as with the old filesystem in btrfs fi
> df,
> totl at 23 and used at 2.38 GiB. What I find strange is that this
> filesystem has Data, System and Metadata in "single" profile, is this
> the new default for a 200 GiB file system?

Single is default for data.  Metadata (and system) will normally default 
to dup on a single device, raid1 on multi-device, EXCEPT on detected 
SSDs, where it defaults to single as well, because the firmware on some 
ssds will dedup it in any case.  If you know your ssd isn't one of the 
deduping ones (as I do, here), you can of course overrule that by 
specifying modes at mkfs.btrfs time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

