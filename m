Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54995 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaLBIVL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 03:21:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xvihp-0004a4-ET
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 09:21:09 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 09:21:09 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 09:21:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS equivalent for tune2fs?
Date: Tue, 2 Dec 2014 08:20:55 +0000 (UTC)
Message-ID: <pan$630e$cc82698$5b1e5632$d2123a7b@cox.net>
References: <CAE8gLhnq_HjcB=Teis751eXD1FKEVTgfbY-2yDCB77-7oz5Yaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MegaBrutal posted on Tue, 02 Dec 2014 06:54:47 +0100 as excerpted:

> Hi all,
> 
> I know there is a btrfstune, but it doesn't provide all the
> functionality I'm thinking of.
> 
> For ext2/3/4 file systems I can get a bunch of useful data with "tune2fs
> -l". How can I retrieve the same type of information about a BTRFS file
> system? (E.g., last mount time, last checked time, blocks reserved for
> superuser*, etc.)
> 
> * Anyway, does BTRFS even have an option to reserve X% for the
> superuser?

btrfs-show-super, btrfs filesystem show, and btrfs filesystem df, show 
various btrfs-specifics of the filesystem.  Last check time doesn't 
really apply, as the kernel automatically does a lot of checks 
dynamically at mount and btrfs check isn't designed to be run routinely, 
only to repair a broken filesystem when mounting with the recovery 
option, etc, fails.

As for reserving a percentage for superuser, btrfs doesn't do that 
directly.  There is the GlobalReserve space (as shown by btrfs fi df) for 
use by the filesystem itself.  Other than that, btrfs quotas could I 
think be (ab)used to reserve superuser space, but they're definitely 
optional, and I always recommend not using them if you can avoid it due 
to the additional complexity/overhead/bugs they add.

There's also btrfs property get/set/list, for some of what tune2fs would 
do plus a lot more btrfs specific stuff and not just on the filesystem 
but on devices, subvolumes and individual files too, but while the 
property infrastructure and some basics are there, I think there's more 
planned that has yet to be implemented.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

