Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50037 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbbL2C2c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 21:28:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDk1W-0006kC-4B
	for linux-btrfs@vger.kernel.org; Tue, 29 Dec 2015 03:28:30 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 03:28:30 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 03:28:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: should btrfsck fix a bad superblock?
Date: Tue, 29 Dec 2015 02:28:19 +0000 (UTC)
Message-ID: <pan$5afbb$4270f15d$d1ce1c42$cc039fab@cox.net>
References: <CAJCQCtT78=kqXZVDAV-x0C1NW=7okBBM_+vM3+HAc5BtUArsiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 28 Dec 2015 17:10:14 -0700 as excerpted:

> Hi,
> 
> I (intentionally) used wipefs -a on a device with a btrfs. As expected
> btrfs check doesn't recognize the device as having a btrfs volume
> anymore.
> 
> Slightly surprising that it doesn't mention other intact supers are
> found.
> 
> Most surprising that options -s1 --repair doesn't fix it.
> 
> I thought maybe it's intentional, only with explicitly bad magic, and
> I'd get different results if it were zero'd. So I zero'd it and I get
> the same results. s0 superblock isn't repaired with --repair.
> 
> Bug?
> 
> Of course I can fix it with echo+dd.

Btrfs check's -s option simply lets you use a different superblock.  I 
don't believe check is designed to actually fix superblocks, tho I guess 
with --repair it fixes certain bad fields in them.

What you want to actually recover bad superblocks from good copies is 
btrfs rescue super-recover.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

