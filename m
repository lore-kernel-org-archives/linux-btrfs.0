Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50673 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbcFIOx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 10:53:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bB1KM-0000Y8-JY
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 16:52:58 +0200
Received: from ip-64-134-228-1.public.wayport.net ([64.134.228.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 16:52:58 +0200
Received: from 1i5t5.duncan by ip-64-134-228-1.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 16:52:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: WARNING: at
 =?us-ascii?Q?=2Fhome=2Fkernel=2FCOD=2Flinux=2Ffs=2Fbtrfs=2Finode=2E?=
 =?us-ascii?Q?c=3A9261?= btrfs_destroy_inode+0x247/0x2c0 [btrfs]
Date: Thu, 9 Jun 2016 14:52:00 +0000 (UTC)
Message-ID: <pan$282ab$fbadc095$ca288943$dfa7a0b@cox.net>
References: <CAO8gOzMt2Wgb2jZ-eq-an-RqHPgssMgZ+O1jOxmZ4GPc-MdDYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fugou Nashi posted on Sun, 05 Jun 2016 10:12:31 +0900 as excerpted:

> Hi,
> 
> Do I need to worry about this?
> 
> Thanks.
> 
> Linux nakku 4.6.0-040600-generic #201605151930 SMP Sun May 15 23:32:59
> UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

There's a patch for it that didn't quite make 4.6.0, but is in 4.7-rc1 
and should appear in later 4.6.x stable releases (tho I don't track 
stable myself so couldn't tell you if it's there yet or not).

In general, some people were reporting many of these warnings during the 
4.6 rcs with no visible damage or further problems, so it doesn't tend to 
be anything but the irritation of the warnings in practice, tho under the 
right conditions, in theory, it could be a bigger issue.  But I know of 
no one who actually experienced a problem beyond the warn noise.

So in practice it's a get the patch as soon as you can thing, but not 
something to be hugely worried about in the mean time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

