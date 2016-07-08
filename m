Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55669 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbcGHBZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 21:25:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bLKXK-0004ty-EP
	for linux-btrfs@vger.kernel.org; Fri, 08 Jul 2016 03:24:58 +0200
Received: from ip-64-134-228-164.public.wayport.net ([64.134.228.164])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 03:24:58 +0200
Received: from 1i5t5.duncan by ip-64-134-228-164.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 03:24:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid1 has failing disks, but smart is clear
Date: Fri, 8 Jul 2016 01:24:51 +0000 (UTC)
Message-ID: <pan$90586$9ef8a2d7$381c8c69$44837006@cox.net>
References: <577D82AE.3040005@gmail.com>
	<03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com>
	<577DF95E.7080100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Corey Coughlin posted on Wed, 06 Jul 2016 23:40:30 -0700 as excerpted:

> Well yeah, if I was mounting all the disks to different mount points, I
> would definitely use UUIDs to get them mounted.  But I haven't seen any
> way to set up a "mkfs.btrfs" command to use UUID or anything else for
> individual drives.  Am I missing something?  I've been doing a lot of
> googling.

FWIW, you can use the /dev/disk/by-*/* symlinks (as normally setup by 
udev) to reference various devices.

Of course because the identifiers behind by-uuid and by-label are per-
filesystem, those will normally only identify the one device of a multi-
device filesystem, but the by-id links ID on device serials and partition 
number, and if you are using GPT partitioning, you have by-partuuid and 
(if you set them when setting up the partitions) by-partlabel as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

