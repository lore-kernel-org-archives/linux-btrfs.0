Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45722 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbaJWItX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 04:49:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XhE5C-0005pI-4L
	for linux-btrfs@vger.kernel.org; Thu, 23 Oct 2014 10:49:22 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 10:49:22 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 10:49:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: device balance times
Date: Thu, 23 Oct 2014 08:49:11 +0000 (UTC)
Message-ID: <pan$dd83c$71fcc8de$b8588506$48afd8db@cox.net>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
	<5446BEC0.8070009@siedziba.pl>
	<02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
	<5447A5CF.9060405@siedziba.pl> <5447E273.3030901@shiftmail.org>
	<4720D6B0-A157-4B68-8472-85176B9949A8@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Thu, 23 Oct 2014 18:39:52 +1100 as excerpted:

> Also a device replace operation requires that the replacement be the
> same size (or maybe larger). While a remove and replace allows the
> replacement to be merely large enough to contain all the data. Given the
> size variation in what might be called the same size disk by
> manufcturers this isn't uncommon - unless you just get a replacement of
> the next size up (which is a good option too).

Good argument for using user-configured partitions, even if you just use 
one covering most of the physical device, instead of manufacturer's 
rather arbitrarily convenience-chosen raw physical device sizes.

In such a scenario if you deliberately undersize that single partition by 
a few gigs, you can be reasonably sure that any physical device of the 
same claimed size as the original physical device can handle it.

Plus that reserves room for GPT and dedicated EFI and/or reserved-BIOS 
partitions too, since the BIOS partition might be a couple MiB and the 
EFI partition a couple hundred MiB, well under a gig combined.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

